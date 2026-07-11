import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/l10n/gen/app_localizations.dart';
import 'age_gate_config.dart';
import 'age_gate_local_store.dart';
import 'age_gate_provider.dart';

/// T144: the DOB-entry age gate. A genuine form field (Material's native date
/// picker), never a checkbox — the entered date of birth exists only as local
/// widget state for the duration of one local comparison
/// ([isOfLegalAge]) and is never included in any request. Only the
/// resulting affirmed/not-affirmed boolean is ever persisted (locally, via
/// [AgeGateLocalStore]) or acted on.
class AgeGateScreen extends ConsumerStatefulWidget {
  const AgeGateScreen({required this.surface, this.onAffirmed, super.key});

  final String surface;
  final VoidCallback? onAffirmed;

  @override
  ConsumerState<AgeGateScreen> createState() => _AgeGateScreenState();
}

class _AgeGateScreenState extends ConsumerState<AgeGateScreen> {
  DateTime? _dateOfBirth;
  String? _validationError;
  bool _rejected = false;

  Future<void> _pickDate(BuildContext context) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(now.year - 21, now.month, now.day),
      firstDate: DateTime(now.year - 120),
      lastDate: now,
    );
    if (picked != null && mounted) {
      setState(() {
        _dateOfBirth = picked;
        _validationError = null;
      });
    }
  }

  Future<void> _confirm() async {
    final l10n = AppLocalizations.of(context);
    final dateOfBirth = _dateOfBirth;
    if (dateOfBirth == null) {
      setState(() => _validationError = l10n.ageGateMissingDateOfBirth);
      return;
    }

    final AgeGateConfig config = await ref.read(
      ageGateConfigProvider(widget.surface).future,
    );

    // The entered date is compared locally and then discarded — nothing derived
    // from it is sent anywhere or persisted beyond the boolean outcome below.
    final ofAge = isOfLegalAge(dateOfBirth, config.legalDrinkingAge);

    if (!mounted) {
      return;
    }

    if (!ofAge) {
      setState(() => _rejected = true);
      return;
    }

    await AgeGateLocalStore().setAffirmed();
    ref.invalidate(ageGateAffirmedProvider);
    widget.onAffirmed?.call();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    if (_rejected) {
      return Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text(
              l10n.ageGateUnderageMessage,
              key: const Key('ageGateUnderageMessage'),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(l10n.ageGateTitle)),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(l10n.ageGateExplanation),
            const SizedBox(height: 24),
            Text(
              l10n.ageGateDateOfBirthLabel,
              style: Theme.of(context).textTheme.labelLarge,
            ),
            const SizedBox(height: 8),
            OutlinedButton(
              key: const Key('ageGateDatePickerButton'),
              onPressed: () => _pickDate(context),
              child: Text(
                _dateOfBirth == null
                    ? l10n.ageGateDatePickerHint
                    : _formatDate(_dateOfBirth!),
              ),
            ),
            if (_validationError case final error?) ...[
              const SizedBox(height: 8),
              Text(
                error,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            ],
            const SizedBox(height: 24),
            ElevatedButton(
              key: const Key('ageGateConfirmButton'),
              onPressed: _confirm,
              child: Text(l10n.ageGateConfirmButton),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) =>
      '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
}
