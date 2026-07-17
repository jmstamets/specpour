// T053: export account data and delete the account. Not yet reachable from
// any navigation chrome (same flagged gap as mfa_settings_screen.dart, T161)
// but a real, complete, directly-routable screen at /account/data.
//
// T178 (FR-003a): the export deliverable is a downloadable JSON artifact —
// the on-screen rendering below is a courtesy view, not the deliverable.

import 'package:api_client/api_client.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/auth/identity_auth_service.dart';
import '../../core/download/file_download_stub.dart'
    if (dart.library.js_interop) '../../core/download/file_download_web.dart';
import '../../core/l10n/gen/app_localizations.dart';
import '../../core/widgets/api_error_display.dart';

class AccountDataScreen extends ConsumerStatefulWidget {
  const AccountDataScreen({super.key});

  @override
  ConsumerState<AccountDataScreen> createState() => _AccountDataScreenState();
}

class _AccountDataScreenState extends ConsumerState<AccountDataScreen> {
  String? _errorMessage;
  MeExport? _export;
  bool _submitting = false;

  Future<void> _exportData() async {
    setState(() {
      _submitting = true;
      _errorMessage = null;
    });

    try {
      final export = await ref
          .read(identityAuthServiceProvider)
          .exportAccountData();
      // FR-003a: the download IS the deliverable — the on-screen state below
      // is only ever a courtesy view of a subset of the same payload.
      // Web-only for V1 (file_download_stub.dart's own doc comment); gated on
      // the kIsWeb runtime check, not just the conditional import, so native
      // callers (and this screen's own widget tests, which run on the Dart
      // VM where kIsWeb is also false) skip it rather than hitting the
      // stub's deliberate UnsupportedError.
      if (kIsWeb) {
        downloadJsonFile(
          filename: 'specpour-data-export-${export.userId}.json',
          jsonContent: standardSerializers.toJson(MeExport.serializer, export),
        );
      }
      if (mounted) {
        setState(() => _export = export);
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

  Future<void> _deleteAccount() async {
    final l10n = AppLocalizations.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        key: const Key('accountDataDeleteConfirmDialog'),
        title: Text(l10n.accountDataDeleteConfirmTitle),
        content: Text(l10n.accountDataDeleteConfirmMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.accountLifecycleCancelButton),
          ),
          TextButton(
            key: const Key('accountDataDeleteConfirmDialogButton'),
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(l10n.accountDataDeleteButton),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) {
      return;
    }

    setState(() {
      _submitting = true;
      _errorMessage = null;
    });

    try {
      await ref.read(identityAuthServiceProvider).deleteAccount();
      if (mounted) {
        context.go('/');
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
    final export = _export;

    return Scaffold(
      key: const Key('accountDataScreen'),
      appBar: AppBar(title: Text(l10n.accountDataTitle)),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: ListView(
          children: [
            if (_errorMessage case final error?) ...[
              ApiErrorDisplay(
                message: error,
                messageKey: const Key('accountDataErrorMessage'),
              ),
              const SizedBox(height: 16),
            ],
            ElevatedButton(
              key: const Key('accountDataExportButton'),
              onPressed: _submitting ? null : _exportData,
              child: Text(l10n.accountDataExportButton),
            ),
            if (export != null) ...[
              const SizedBox(height: 16),
              Text(
                l10n.accountDataExportDateOfBirth(
                  export.dateOfBirth.toString(),
                ),
                key: const Key('accountDataExportDateOfBirth'),
              ),
              Text(l10n.accountDataExportEmail(export.email)),
            ],
            const SizedBox(height: 32),
            Text(l10n.accountDataDeleteExplanation),
            const SizedBox(height: 8),
            ElevatedButton(
              key: const Key('accountDataDeleteButton'),
              onPressed: _submitting ? null : _deleteAccount,
              style: ElevatedButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.onError,
                backgroundColor: Theme.of(context).colorScheme.error,
              ),
              child: Text(l10n.accountDataDeleteButton),
            ),
          ],
        ),
      ),
    );
  }
}
