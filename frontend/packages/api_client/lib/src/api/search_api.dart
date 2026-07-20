//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

import 'dart:async';

import 'package:built_value/json_object.dart';
import 'package:built_value/serializer.dart';
import 'package:dio/dio.dart';

import 'package:api_client/src/api_util.dart';
import 'package:api_client/src/model/problem_details.dart';
import 'package:api_client/src/model/search_result_page.dart';

class SearchApi {

  final Dio _dio;

  final Serializers _serializers;

  const SearchApi(this._dio, this._serializers);

  /// Full-text search across recipes, ingredients, equipment, glossary terms, and articles (FR-049)
  /// Guest-accessible (FR-004b) unless &#x60;makeable&#x3D;true&#x60; is used. Search itself owns no schema and has no opinion on content facets (T141 ADR) — this endpoint returns entity references only (&#x60;entityType&#x60;/&#x60;entityId&#x60;); fetch the full record from that entity&#39;s own GET-by-id endpoint. Rating-facet composition lands in T149. &#x60;q&#x60; returning nothing is a pre-existing adapter limitation, not a facet bug — this endpoint requires non-empty text; browsing (no &#x60;q&#x60;) is &#x60;GET /recipes&#x60;&#39;s job, not this one&#39;s.
  ///
  /// Parameters:
  /// * [q] - Free-text query (websearch_to_tsquery syntax).
  /// * [uses] - Hierarchy-aware \"uses:<ingredient>\" facet (T155/FR-050), narrowing results to recipes referencing the ingredient (or any descendant). Applied INSIDE the search adapter's own query, before pagination (T148 — previously a post-filter that could shrink a page below `limit`).
  /// * [makeable] - Makeable-from-inventory facet (T148, FR-050) — bearer-only (401 if not authenticated). Narrows recipe-type results to the caller's own fully-makeable and near-miss recipes, applied the same way as `uses` (inside the adapter's query, before pagination). Combining `uses` and `makeable` intersects (both must match). Only public recipes are ever reachable via this endpoint (unlike `GET /recipes`'s `scope`/`makeable`, which also surfaces the caller's own private recipes) — Search's index only ever carries public content.
  /// * [cursor] - Opaque pagination cursor from a previous page's `nextCursor`.
  /// * [limit] - Maximum number of items to return.
  /// * [cancelToken] - A [CancelToken] that can be used to cancel the operation
  /// * [headers] - Can be used to add additional headers to the request
  /// * [extras] - Can be used to add flags to the request
  /// * [validateStatus] - A [ValidateStatus] callback that can be used to determine request success based on the HTTP status of the response
  /// * [onSendProgress] - A [ProgressCallback] that can be used to get the send progress
  /// * [onReceiveProgress] - A [ProgressCallback] that can be used to get the receive progress
  ///
  /// Returns a [Future] containing a [Response] with a [SearchResultPage] as data
  /// Throws [DioException] if API call or serialization fails
  Future<Response<SearchResultPage>> search({ 
    String? q,
    String? uses,
    String? makeable,
    String? cursor,
    int? limit = 20,
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
    ValidateStatus? validateStatus,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    final _path = r'/search';
    final _options = Options(
      method: r'GET',
      headers: <String, dynamic>{
        ...?headers,
      },
      extra: <String, dynamic>{
        'secure': <Map<String, String>>[
          {
            'type': 'http',
            'scheme': 'bearer',
            'name': 'bearerAuth',
          },
        ],
        ...?extra,
      },
      validateStatus: validateStatus,
    );

    final _queryParameters = <String, dynamic>{
      if (q != null) r'q': encodeQueryParameter(_serializers, q, const FullType(String)),
      if (uses != null) r'uses': encodeQueryParameter(_serializers, uses, const FullType(String)),
      if (makeable != null) r'makeable': encodeQueryParameter(_serializers, makeable, const FullType(String)),
      if (cursor != null) r'cursor': encodeQueryParameter(_serializers, cursor, const FullType(String)),
      if (limit != null) r'limit': encodeQueryParameter(_serializers, limit, const FullType(int)),
    };

    final _response = await _dio.request<Object>(
      _path,
      options: _options,
      queryParameters: _queryParameters,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );

    SearchResultPage? _responseData;

    try {
      final rawResponse = _response.data;
      _responseData = rawResponse == null ? null : _serializers.deserialize(
        rawResponse,
        specifiedType: const FullType(SearchResultPage),
      ) as SearchResultPage;

    } catch (error, stackTrace) {
      throw DioException(
        requestOptions: _response.requestOptions,
        response: _response,
        type: DioExceptionType.unknown,
        error: error,
        stackTrace: stackTrace,
      );
    }

    return Response<SearchResultPage>(
      data: _responseData,
      headers: _response.headers,
      isRedirect: _response.isRedirect,
      requestOptions: _response.requestOptions,
      redirects: _response.redirects,
      statusCode: _response.statusCode,
      statusMessage: _response.statusMessage,
      extra: _response.extra,
    );
  }

}
