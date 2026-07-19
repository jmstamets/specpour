// T061/T063: venue manager — lists the caller's venues and lets them add a
// new one. A recipe/ingredient/equipment author picks which of these venues
// a bar-scoped item belongs to directly in that item's own editor (T058's
// venueId field) rather than through a separately-persisted "active venue"
// concept, which nothing in spec.md's US3 scenarios calls for.

import 'package:api_client/api_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/api/api_client_provider.dart';
import '../../core/auth/identity_auth_service.dart' show describeIdentityError;
import '../../core/l10n/gen/app_localizations.dart';
import '../../core/widgets/api_error_display.dart';

final myVenuesProvider = FutureProvider.autoDispose<List<Venue>>((ref) async {
  final response = await ref.watch(venuesApiProvider).listVenues();
  return response.data!.items.toList();
});

class VenuesScreen extends ConsumerWidget {
  const VenuesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final venues = ref.watch(myVenuesProvider);

    return Scaffold(
      key: const Key('venuesScreen'),
      appBar: AppBar(title: Text(l10n.venuesTitle)),
      floatingActionButton: FloatingActionButton(
        key: const Key('venueCreateFab'),
        tooltip: l10n.venueCreateButton,
        onPressed: () => _showCreateVenueSheet(context, ref),
        child: const Icon(Icons.add),
      ),
      body: venues.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Padding(
          padding: const EdgeInsets.all(24),
          child: ApiErrorDisplay(message: describeIdentityError(error)),
        ),
        data: (items) => items.isEmpty
            ? Center(
                key: const Key('venuesEmptyState'),
                child: Text(l10n.venuesEmptyMessage),
              )
            : ListView(
                children: [
                  for (final venue in items)
                    ListTile(
                      key: Key('venueListItem-${venue.id}'),
                      leading: const Icon(Icons.storefront_outlined),
                      title: Text(venue.name),
                      subtitle: venue.address == null
                          ? null
                          : Text(venue.address!),
                    ),
                ],
              ),
      ),
    );
  }

  Future<void> _showCreateVenueSheet(BuildContext context, WidgetRef ref) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (context) => const _CreateVenueSheet(),
    );
  }
}

class _CreateVenueSheet extends ConsumerStatefulWidget {
  const _CreateVenueSheet();

  @override
  ConsumerState<_CreateVenueSheet> createState() => _CreateVenueSheetState();
}

class _CreateVenueSheetState extends ConsumerState<_CreateVenueSheet> {
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  final _latitudeController = TextEditingController();
  final _longitudeController = TextEditingController();
  String? _errorMessage;
  bool _submitting = false;

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _latitudeController.dispose();
    _longitudeController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final l10n = AppLocalizations.of(context);
    if (_nameController.text.trim().isEmpty) {
      setState(() => _errorMessage = l10n.venueMissingFieldsError);
      return;
    }

    setState(() {
      _submitting = true;
      _errorMessage = null;
    });

    try {
      await ref
          .read(venuesApiProvider)
          .createVenue(
            createVenueRequest: CreateVenueRequest(
              (b) => b
                ..name = _nameController.text.trim()
                ..address = _addressController.text.trim().isEmpty
                    ? null
                    : _addressController.text.trim()
                ..latitude = double.tryParse(_latitudeController.text.trim())
                ..longitude = double.tryParse(_longitudeController.text.trim()),
            ),
          );

      ref.invalidate(myVenuesProvider);
      if (mounted) {
        Navigator.of(context).pop();
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

    return Padding(
      key: const Key('createVenueSheet'),
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            key: const Key('venueNameField'),
            controller: _nameController,
            decoration: InputDecoration(labelText: l10n.venueNameLabel),
          ),
          const SizedBox(height: 12),
          TextField(
            key: const Key('venueAddressField'),
            controller: _addressController,
            decoration: InputDecoration(labelText: l10n.venueAddressLabel),
          ),
          const SizedBox(height: 12),
          TextField(
            key: const Key('venueLatitudeField'),
            controller: _latitudeController,
            decoration: InputDecoration(labelText: l10n.venueLatitudeLabel),
            keyboardType: const TextInputType.numberWithOptions(
              decimal: true,
              signed: true,
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            key: const Key('venueLongitudeField'),
            controller: _longitudeController,
            decoration: InputDecoration(labelText: l10n.venueLongitudeLabel),
            keyboardType: const TextInputType.numberWithOptions(
              decimal: true,
              signed: true,
            ),
          ),
          if (_errorMessage case final error?) ...[
            const SizedBox(height: 16),
            ApiErrorDisplay(
              message: error,
              messageKey: const Key('venueErrorMessage'),
            ),
          ],
          const SizedBox(height: 20),
          ElevatedButton(
            key: const Key('venueSubmitButton'),
            onPressed: _submitting ? null : _submit,
            child: Text(l10n.venueSubmitButton),
          ),
        ],
      ),
    );
  }
}
