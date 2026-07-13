import 'package:api_client/api_client.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/api/api_client_provider.dart';

final conceptDetailProvider = FutureProvider.family<ConceptDetail, String>((
  ref,
  id,
) async {
  final api = ref.watch(catalogApiProvider);
  final response = await api.getConcept(id: id);
  return response.data!;
});
