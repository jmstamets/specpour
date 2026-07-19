// T058/T063: recipe editor — creates a recipe in the caller's personal or
// bar library. The ingredient-line picker is a flat searchable dropdown over
// curated + the caller's own personal/house-made ingredients (GET
// /ingredients and GET /ingredients?scope=personal merged), not a full
// nested class->...->product tree widget — the read endpoints already
// surface each ingredient's resolved parent name for hierarchy context, and
// a bespoke tree-navigation widget is real additional scope beyond what any
// US3 acceptance scenario exercises.
//
// Pops with the created RecipeAuthor on success, so a caller building a
// house-made ingredient's component recipe can grab its id directly.

import 'package:api_client/api_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/api/api_client_provider.dart';
import '../../core/auth/identity_auth_service.dart' show describeIdentityError;
import '../../core/l10n/gen/app_localizations.dart';
import '../../core/widgets/api_error_display.dart';
import 'venues_screen.dart';

/// Curated public ingredients plus the caller's own personal/house-made ones,
/// merged into one flat pick-list (deduplicated by id — a curated ingredient
/// never also appears as personal, but this guards the merge either way).
final ingredientPickerOptionsProvider =
    FutureProvider.autoDispose<List<IngredientSummary>>((ref) async {
      final api = ref.watch(ingredientsApiProvider);
      final curated = await api.listIngredients(limit: 100);
      final personal = await api.listIngredients(scope: 'personal', limit: 100);
      final byId = <String, IngredientSummary>{
        for (final i in curated.data!.items) i.id: i,
        for (final i in personal.data!.items) i.id: i,
      };
      final options = byId.values.toList()
        ..sort((a, b) => a.name.compareTo(b.name));
      return options;
    });

// built_value's EnumClass.valueOf(String) matches the Dart-side member name
// (lowerCamelCase — linear, stepwise, ...), NOT the @BuiltValueEnumConst
// wireName ('Linear', 'Stepwise', ... — what actually goes over the wire and
// what the C# IngredientScalingRule enum parses). Looking these up directly
// by the same key this map already uses avoids relying on valueOf at all.
const _scalingRuleValues = {
  'Linear': RecipeIngredientLineInputScalingRuleEnum.linear,
  'Stepwise': RecipeIngredientLineInputScalingRuleEnum.stepwise,
  'OmitInBatch': RecipeIngredientLineInputScalingRuleEnum.omitInBatch,
  'AddFreshAtService':
      RecipeIngredientLineInputScalingRuleEnum.addFreshAtService,
};

const _scalingRuleLabels = {
  'Linear': 'Linear',
  'Stepwise': 'Stepwise',
  'OmitInBatch': 'Omit in batch',
  'AddFreshAtService': 'Add fresh at service',
};

class RecipeEditorScreen extends ConsumerStatefulWidget {
  const RecipeEditorScreen({super.key});

  @override
  ConsumerState<RecipeEditorScreen> createState() => _RecipeEditorScreenState();
}

class _IngredientLineEntry {
  _IngredientLineEntry();

  String? ingredientId;
  final quantityController = TextEditingController();
  final unitController = TextEditingController();
  final purposeController = TextEditingController();
  String scalingRule = 'Linear';

  void dispose() {
    quantityController.dispose();
    unitController.dispose();
    purposeController.dispose();
  }
}

class _RecipeEditorScreenState extends ConsumerState<RecipeEditorScreen> {
  final _primaryNameController = TextEditingController();
  final _alternateNamesController = TextEditingController();
  final List<TextEditingController> _instructionControllers = [
    TextEditingController(),
  ];
  final List<_IngredientLineEntry> _ingredientLines = [_IngredientLineEntry()];

  String _libraryScope = 'personal';
  String? _venueId;
  String? _errorMessage;
  bool _submitting = false;

  @override
  void dispose() {
    _primaryNameController.dispose();
    _alternateNamesController.dispose();
    for (final c in _instructionControllers) {
      c.dispose();
    }
    for (final line in _ingredientLines) {
      line.dispose();
    }
    super.dispose();
  }

  Future<void> _submit() async {
    final l10n = AppLocalizations.of(context);
    final validLines = _ingredientLines
        .where((l) => l.ingredientId != null)
        .toList();

    if (_primaryNameController.text.trim().isEmpty || validLines.isEmpty) {
      setState(() => _errorMessage = l10n.recipeEditorMissingFieldsError);
      return;
    }

    setState(() {
      _submitting = true;
      _errorMessage = null;
    });

    try {
      final response = await ref
          .read(catalogApiProvider)
          .createRecipe(
            createRecipeRequest: CreateRecipeRequest((b) {
              b.primaryName = _primaryNameController.text.trim();
              b.alternateNames.addAll(
                _alternateNamesController.text
                    .split(',')
                    .map((s) => s.trim())
                    .where((s) => s.isNotEmpty),
              );
              b.libraryScope = CreateRecipeRequestLibraryScopeEnum.valueOf(
                _libraryScope,
              );
              b.venueId = _libraryScope == 'bar' ? _venueId : null;
              b.instructions.addAll(
                _instructionControllers
                    .map((c) => c.text.trim())
                    .where((s) => s.isNotEmpty),
              );
              b.ingredientLines.addAll(
                validLines.map(
                  (line) => RecipeIngredientLineInput(
                    (lb) => lb
                      ..ingredientId = line.ingredientId
                      ..quantity =
                          num.tryParse(line.quantityController.text.trim()) ?? 0
                      ..unit = line.unitController.text.trim()
                      ..purpose = line.purposeController.text.trim().isEmpty
                          ? null
                          : line.purposeController.text.trim()
                      ..scalingRule = _scalingRuleValues[line.scalingRule]!,
                  ),
                ),
              );
            }),
          );

      if (mounted) {
        context.pop(response.data);
      }
    } catch (error) {
      if (mounted) {
        setState(() => _errorMessage = describeIdentityError(error));
      }
    } finally {
      if (mounted) {
        setState(() => _submitting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final ingredientOptions = ref.watch(ingredientPickerOptionsProvider);
    final venues = ref.watch(myVenuesProvider);

    return Scaffold(
      key: const Key('recipeEditorScreen'),
      appBar: AppBar(title: Text(l10n.recipeEditorTitle)),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: ListView(
          children: [
            TextField(
              key: const Key('recipeEditorPrimaryNameField'),
              controller: _primaryNameController,
              decoration: InputDecoration(
                labelText: l10n.recipeEditorPrimaryNameLabel,
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              key: const Key('recipeEditorAlternateNamesField'),
              controller: _alternateNamesController,
              decoration: InputDecoration(
                labelText: l10n.recipeEditorAlternateNamesLabel,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              l10n.recipeEditorLibraryScopeLabel,
              style: Theme.of(context).textTheme.labelLarge,
            ),
            const SizedBox(height: 8),
            SegmentedButton<String>(
              key: const Key('recipeEditorLibraryScopeSelector'),
              segments: [
                ButtonSegment(
                  value: 'personal',
                  label: Text(l10n.recipeEditorScopePersonal),
                ),
                ButtonSegment(
                  value: 'bar',
                  label: Text(l10n.recipeEditorScopeBar),
                ),
              ],
              selected: {_libraryScope},
              onSelectionChanged: (selection) =>
                  setState(() => _libraryScope = selection.first),
            ),
            if (_libraryScope == 'bar')
              venues.when(
                loading: () => const LinearProgressIndicator(),
                error: (error, stack) => Text(describeIdentityError(error)),
                data: (items) => items.isEmpty
                    ? Text(l10n.recipeEditorNoVenuesHint)
                    : DropdownButtonFormField<String>(
                        key: const Key('recipeEditorVenueDropdown'),
                        initialValue: _venueId,
                        decoration: InputDecoration(
                          labelText: l10n.recipeEditorVenueLabel,
                        ),
                        items: [
                          for (final venue in items)
                            DropdownMenuItem(
                              value: venue.id,
                              child: Text(venue.name),
                            ),
                        ],
                        onChanged: (value) => setState(() => _venueId = value),
                      ),
              ),
            const SizedBox(height: 16),
            Text(
              l10n.recipeEditorInstructionsLabel,
              style: Theme.of(context).textTheme.labelLarge,
            ),
            for (var i = 0; i < _instructionControllers.length; i++)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: TextField(
                  key: Key('recipeEditorInstructionField-$i'),
                  controller: _instructionControllers[i],
                  decoration: InputDecoration(labelText: '${i + 1}.'),
                ),
              ),
            TextButton.icon(
              key: const Key('recipeEditorAddInstructionButton'),
              onPressed: () => setState(
                () => _instructionControllers.add(TextEditingController()),
              ),
              icon: const Icon(Icons.add),
              label: Text(l10n.recipeEditorAddInstructionButton),
            ),
            const SizedBox(height: 16),
            Text(
              l10n.recipeEditorIngredientLinesLabel,
              style: Theme.of(context).textTheme.labelLarge,
            ),
            ingredientOptions.when(
              loading: () => const LinearProgressIndicator(),
              error: (error, stack) => Text(describeIdentityError(error)),
              data: (options) => Column(
                children: [
                  for (var i = 0; i < _ingredientLines.length; i++)
                    _buildIngredientLineRow(l10n, i, options),
                ],
              ),
            ),
            TextButton.icon(
              key: const Key('recipeEditorAddIngredientLineButton'),
              onPressed: () =>
                  setState(() => _ingredientLines.add(_IngredientLineEntry())),
              icon: const Icon(Icons.add),
              label: Text(l10n.recipeEditorAddIngredientLineButton),
            ),
            if (_errorMessage case final error?) ...[
              const SizedBox(height: 16),
              ApiErrorDisplay(
                message: error,
                messageKey: const Key('recipeEditorErrorMessage'),
              ),
            ],
            const SizedBox(height: 24),
            ElevatedButton(
              key: const Key('recipeEditorSubmitButton'),
              onPressed: _submitting ? null : _submit,
              child: Text(l10n.recipeEditorSubmitButton),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIngredientLineRow(
    AppLocalizations l10n,
    int index,
    List<IngredientSummary> options,
  ) {
    final line = _ingredientLines[index];
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<String>(
                  key: Key('recipeEditorIngredientDropdown-$index'),
                  initialValue: line.ingredientId,
                  decoration: InputDecoration(
                    labelText: l10n.recipeEditorIngredientLabel,
                  ),
                  items: [
                    for (final option in options)
                      DropdownMenuItem(
                        key: Key('ingredientOption-${option.id}'),
                        value: option.id,
                        child: Text(
                          option.parentName == null
                              ? option.name
                              : '${option.name} (${option.parentName})',
                        ),
                      ),
                  ],
                  onChanged: (value) =>
                      setState(() => line.ingredientId = value),
                ),
              ),
              IconButton(
                key: Key('recipeEditorRemoveLineButton-$index'),
                tooltip: l10n.recipeEditorRemoveLineTooltip,
                icon: const Icon(Icons.remove_circle_outline),
                onPressed: _ingredientLines.length == 1
                    ? null
                    : () => setState(() {
                        _ingredientLines.removeAt(index).dispose();
                      }),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: TextField(
                  key: Key('recipeEditorQuantityField-$index'),
                  controller: line.quantityController,
                  decoration: InputDecoration(
                    labelText: l10n.recipeEditorQuantityLabel,
                  ),
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  key: Key('recipeEditorUnitField-$index'),
                  controller: line.unitController,
                  decoration: InputDecoration(
                    labelText: l10n.recipeEditorUnitLabel,
                  ),
                ),
              ),
            ],
          ),
          DropdownButtonFormField<String>(
            key: Key('recipeEditorScalingRuleDropdown-$index'),
            initialValue: line.scalingRule,
            decoration: InputDecoration(
              labelText: l10n.recipeEditorScalingRuleLabel,
            ),
            items: [
              for (final entry in _scalingRuleLabels.entries)
                DropdownMenuItem(value: entry.key, child: Text(entry.value)),
            ],
            onChanged: (value) =>
                setState(() => line.scalingRule = value ?? 'Linear'),
          ),
          TextField(
            key: Key('recipeEditorPurposeField-$index'),
            controller: line.purposeController,
            decoration: InputDecoration(
              labelText: l10n.recipeEditorPurposeLabel,
            ),
          ),
        ],
      ),
    );
  }
}
