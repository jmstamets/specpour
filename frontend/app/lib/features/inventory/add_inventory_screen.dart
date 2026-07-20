// T070/T069: the add-inventory screen — all three entry paths (photo, barcode,
// manual) funnel into the SAME manual-entry form below, prefilled differently
// depending on how the flow got there. Neither photo recognition nor barcode
// scanning actually resolves anything server-side yet (T069: no real vision
// provider configured, T202; no barcode/UPC database integration, never
// requested) — both always degrade to the user picking/confirming the bottle
// themselves, which is the honest, spec-compliant behavior (FR-030's
// "recognition failure degrades to manual form, never blocks entry").

import 'package:api_client/api_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../core/api/api_client_provider.dart';
import '../../core/auth/identity_auth_service.dart' show describeIdentityError;
import '../../core/l10n/gen/app_localizations.dart';
import '../../core/widgets/api_error_display.dart';
import 'inventory_providers.dart';
import 'scan/barcode_scan_screen.dart';

class AddInventoryScreen extends ConsumerStatefulWidget {
  const AddInventoryScreen({super.key});

  @override
  ConsumerState<AddInventoryScreen> createState() => _AddInventoryScreenState();
}

class _AddInventoryScreenState extends ConsumerState<AddInventoryScreen> {
  final _quantityController = TextEditingController();
  final _bottleSizeController = TextEditingController();
  final _ingredientController = TextEditingController();

  IngredientSummary? _selectedIngredient;
  CreateInventoryItemRequestSource_Enum _source =
      CreateInventoryItemRequestSource_Enum.manual;
  String? _statusMessage;
  String? _errorMessage;
  bool _submitting = false;

  @override
  void dispose() {
    _quantityController.dispose();
    _bottleSizeController.dispose();
    _ingredientController.dispose();
    super.dispose();
  }

  Future<void> _takePhoto() async {
    final l10n = AppLocalizations.of(context);
    final picker = ImagePicker();
    final photo = await picker.pickImage(source: ImageSource.gallery);
    if (photo == null || !mounted) {
      return;
    }

    setState(() {
      _submitting = true;
      _errorMessage = null;
    });

    try {
      // T069's backend contract accepts a photoUrl today (no real upload/
      // storage wiring yet — the vision provider is unconfigured and never
      // consumes it meaningfully); the picked file's own path stands in
      // until a real provider integration (T202) needs real bytes.
      final response = await ref
          .read(inventoryApiProvider)
          .recognizeBottle(
            recognizeRequest: RecognizeRequest((b) => b..photoUrl = photo.path),
          );
      final result = response.data!;

      if (!mounted) {
        return;
      }

      if (result.recognized &&
          result.manualEntryForm.prefilledIngredientId != null) {
        final ingredients = await ref.read(pickableIngredientsProvider.future);
        final match = ingredients
            .where((i) => i.id == result.manualEntryForm.prefilledIngredientId)
            .firstOrNull;
        setState(() {
          _selectedIngredient = match;
          _ingredientController.text =
              match?.name ??
              result.manualEntryForm.prefilledIngredientName ??
              '';
          _source = CreateInventoryItemRequestSource_Enum.photoRecognition;
          _statusMessage = l10n.addInventoryRecognizedMessage(
            result.manualEntryForm.prefilledIngredientName ?? '',
          );
        });
      } else {
        setState(() {
          _source = CreateInventoryItemRequestSource_Enum.manual;
          _statusMessage = l10n.addInventoryNotRecognizedMessage;
        });
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

  Future<void> _scanBarcode() async {
    final l10n = AppLocalizations.of(context);
    final scanned = await Navigator.of(context).push<String>(
      MaterialPageRoute(builder: (context) => const BarcodeScanScreen()),
    );
    if (scanned == null || !mounted) {
      return;
    }

    // No barcode/UPC database integration exists (never requested) — a scan
    // always degrades to the caller confirming the bottle manually, same as
    // an unrecognized photo. The scan's only effect is tagging the source.
    setState(() {
      _source = CreateInventoryItemRequestSource_Enum.barcode;
      _statusMessage = l10n.addInventoryBarcodeScannedMessage;
    });
  }

  Future<void> _submit() async {
    final l10n = AppLocalizations.of(context);
    final ingredient = _selectedIngredient;
    if (ingredient == null) {
      setState(() => _errorMessage = l10n.addInventoryMissingIngredientError);
      return;
    }

    setState(() {
      _submitting = true;
      _errorMessage = null;
    });

    try {
      await ref
          .read(inventoryApiProvider)
          .createInventoryItem(
            createInventoryItemRequest: CreateInventoryItemRequest(
              (b) => b
                ..ingredientId = ingredient.id
                ..quantity = num.tryParse(_quantityController.text.trim())
                ..bottleSize = _bottleSizeController.text.trim().isEmpty
                    ? null
                    : _bottleSizeController.text.trim()
                ..source_ = _source,
            ),
          );

      if (mounted) {
        // This screen was reached via go_router's context.push('/inventory/add')
        // — must pop via context.pop(), not raw Navigator.pop(), or Navigator
        // state corrupts on the next go_router push (a real bug found and
        // fixed this same way in HouseMadeIngredientEditorScreen).
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
    final ingredients = ref.watch(pickableIngredientsProvider);

    return Scaffold(
      key: const Key('addInventoryScreen'),
      appBar: AppBar(title: Text(l10n.addInventoryTitle)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    key: const Key('addInventoryPhotoButton'),
                    onPressed: _submitting ? null : _takePhoto,
                    icon: const Icon(Icons.camera_alt_outlined),
                    label: Text(l10n.addInventoryPhotoButton),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    key: const Key('addInventoryBarcodeButton'),
                    onPressed: _submitting ? null : _scanBarcode,
                    icon: const Icon(Icons.qr_code_scanner_outlined),
                    label: Text(l10n.addInventoryBarcodeButton),
                  ),
                ),
              ],
            ),
            if (_statusMessage case final message?) ...[
              const SizedBox(height: 12),
              Text(message, key: const Key('addInventoryStatusMessage')),
            ],
            const SizedBox(height: 20),
            ingredients.when(
              loading: () => const LinearProgressIndicator(),
              error: (error, stack) =>
                  ApiErrorDisplay(message: describeIdentityError(error)),
              data: (options) => Autocomplete<IngredientSummary>(
                displayStringForOption: (option) => option.name,
                optionsBuilder: (textEditingValue) {
                  if (textEditingValue.text.isEmpty) {
                    return options;
                  }
                  final query = textEditingValue.text.toLowerCase();
                  return options.where(
                    (o) => o.name.toLowerCase().contains(query),
                  );
                },
                onSelected: (option) => setState(() {
                  _selectedIngredient = option;
                  _ingredientController.text = option.name;
                }),
                fieldViewBuilder:
                    (context, controller, focusNode, onSubmitted) {
                      controller.text = _ingredientController.text;
                      return TextField(
                        key: const Key('addInventoryIngredientField'),
                        controller: controller,
                        focusNode: focusNode,
                        decoration: InputDecoration(
                          labelText: l10n.addInventoryIngredientLabel,
                          hintText: l10n.addInventoryIngredientHint,
                        ),
                      );
                    },
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              key: const Key('addInventoryQuantityField'),
              controller: _quantityController,
              decoration: InputDecoration(
                labelText: l10n.addInventoryQuantityLabel,
              ),
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              key: const Key('addInventoryBottleSizeField'),
              controller: _bottleSizeController,
              decoration: InputDecoration(
                labelText: l10n.addInventoryBottleSizeLabel,
              ),
            ),
            if (_errorMessage case final error?) ...[
              const SizedBox(height: 16),
              ApiErrorDisplay(
                message: error,
                messageKey: const Key('addInventoryErrorMessage'),
              ),
            ],
            const SizedBox(height: 20),
            ElevatedButton(
              key: const Key('addInventorySubmitButton'),
              onPressed: _submitting ? null : _submit,
              child: Text(l10n.addInventorySubmitButton),
            ),
          ],
        ),
      ),
    );
  }
}
