// T059/T063: house-made ingredient editor. FR-017's own data-model wording —
// a house-made ingredient's yield/shelf-life/storage extension hangs off a
// real defining Recipe row, not an inline sub-object — so this screen picks
// (or, if none exist yet, first creates) one of the caller's own personal
// recipes as the "component recipe" before the create call.

import 'package:api_client/api_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/api/api_client_provider.dart';
import '../../core/auth/identity_auth_service.dart' show describeIdentityError;
import '../../core/l10n/gen/app_localizations.dart';
import '../../core/widgets/api_error_display.dart';
import 'library_providers.dart';

class HouseMadeIngredientEditorScreen extends ConsumerStatefulWidget {
  const HouseMadeIngredientEditorScreen({super.key});

  @override
  ConsumerState<HouseMadeIngredientEditorScreen> createState() =>
      _HouseMadeIngredientEditorScreenState();
}

class _HouseMadeIngredientEditorScreenState
    extends ConsumerState<HouseMadeIngredientEditorScreen> {
  final _nameController = TextEditingController();
  final _yieldQuantityController = TextEditingController();
  final _yieldUnitController = TextEditingController();
  final _shelfLifeDaysController = TextEditingController();
  final _storageInstructionsController = TextEditingController();
  String? _definingRecipeId;
  String? _errorMessage;
  bool _submitting = false;

  @override
  void dispose() {
    _nameController.dispose();
    _yieldQuantityController.dispose();
    _yieldUnitController.dispose();
    _shelfLifeDaysController.dispose();
    _storageInstructionsController.dispose();
    super.dispose();
  }

  Future<void> _createComponentRecipe() async {
    final result = await context.push<RecipeAuthor>('/library/recipes/new');
    if (result != null && mounted) {
      ref.invalidate(myPersonalRecipesProvider);
      setState(() => _definingRecipeId = result.id);
    }
  }

  Future<void> _submit() async {
    final l10n = AppLocalizations.of(context);
    final shelfLifeDays = int.tryParse(_shelfLifeDaysController.text.trim());

    if (_nameController.text.trim().isEmpty ||
        _definingRecipeId == null ||
        _yieldQuantityController.text.trim().isEmpty ||
        _yieldUnitController.text.trim().isEmpty ||
        shelfLifeDays == null ||
        _storageInstructionsController.text.trim().isEmpty) {
      setState(() => _errorMessage = l10n.houseMadeEditorMissingFieldsError);
      return;
    }

    setState(() {
      _submitting = true;
      _errorMessage = null;
    });

    try {
      await ref
          .read(ingredientsApiProvider)
          .createIngredient(
            createIngredientRequest: CreateIngredientRequest(
              (b) => b
                ..name = _nameController.text.trim()
                ..libraryScope =
                    CreateIngredientRequestLibraryScopeEnum.personal
                ..houseMade.replace(
                  CreateHouseMadeRequest(
                    (hb) => hb
                      ..definingRecipeId = _definingRecipeId
                      ..yieldQuantity = num.parse(
                        _yieldQuantityController.text.trim(),
                      )
                      ..yieldUnit = _yieldUnitController.text.trim()
                      ..shelfLifeDays = shelfLifeDays
                      ..storageInstructions = _storageInstructionsController
                          .text
                          .trim(),
                  ),
                ),
            ),
          );

      if (mounted) {
        context.pop();
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
    final recipes = ref.watch(myPersonalRecipesProvider);

    return Scaffold(
      key: const Key('houseMadeEditorScreen'),
      appBar: AppBar(title: Text(l10n.houseMadeEditorTitle)),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: ListView(
          children: [
            TextField(
              key: const Key('houseMadeEditorNameField'),
              controller: _nameController,
              decoration: InputDecoration(
                labelText: l10n.houseMadeEditorNameLabel,
              ),
            ),
            const SizedBox(height: 16),
            recipes.when(
              loading: () => const LinearProgressIndicator(),
              error: (error, stack) => Text(describeIdentityError(error)),
              data: (items) => items.isEmpty
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(l10n.houseMadeEditorNoRecipesHint),
                        const SizedBox(height: 8),
                        OutlinedButton(
                          key: const Key(
                            'houseMadeEditorCreateComponentRecipeButton',
                          ),
                          onPressed: _createComponentRecipe,
                          child: Text(l10n.recipeEditorSubmitButton),
                        ),
                      ],
                    )
                  : DropdownButtonFormField<String>(
                      key: const Key('houseMadeEditorDefiningRecipeDropdown'),
                      initialValue: _definingRecipeId,
                      decoration: InputDecoration(
                        labelText: l10n.houseMadeEditorDefiningRecipeLabel,
                      ),
                      items: [
                        for (final recipe in items)
                          DropdownMenuItem(
                            value: recipe.id,
                            child: Text(recipe.primaryName),
                          ),
                      ],
                      onChanged: (value) =>
                          setState(() => _definingRecipeId = value),
                    ),
            ),
            const SizedBox(height: 12),
            TextField(
              key: const Key('houseMadeEditorYieldQuantityField'),
              controller: _yieldQuantityController,
              decoration: InputDecoration(
                labelText: l10n.houseMadeEditorYieldQuantityLabel,
              ),
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              key: const Key('houseMadeEditorYieldUnitField'),
              controller: _yieldUnitController,
              decoration: InputDecoration(
                labelText: l10n.houseMadeEditorYieldUnitLabel,
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              key: const Key('houseMadeEditorShelfLifeDaysField'),
              controller: _shelfLifeDaysController,
              decoration: InputDecoration(
                labelText: l10n.houseMadeEditorShelfLifeDaysLabel,
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 12),
            TextField(
              key: const Key('houseMadeEditorStorageInstructionsField'),
              controller: _storageInstructionsController,
              decoration: InputDecoration(
                labelText: l10n.houseMadeEditorStorageInstructionsLabel,
              ),
              maxLines: 3,
            ),
            if (_errorMessage case final error?) ...[
              const SizedBox(height: 16),
              ApiErrorDisplay(
                message: error,
                messageKey: const Key('houseMadeEditorErrorMessage'),
              ),
            ],
            const SizedBox(height: 24),
            ElevatedButton(
              key: const Key('houseMadeEditorSubmitButton'),
              onPressed: _submitting ? null : _submit,
              child: Text(l10n.houseMadeEditorSubmitButton),
            ),
          ],
        ),
      ),
    );
  }
}
