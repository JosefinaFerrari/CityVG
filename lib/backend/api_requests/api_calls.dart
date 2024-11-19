import 'dart:convert';

import 'package:flutter/foundation.dart';

import '/flutter_flow/flutter_flow_util.dart';
import 'api_manager.dart';

export 'api_manager.dart' show ApiCallResponse;

const _kPrivateApiFunctionName = 'ffPrivateApiCall';

class TiquetsCall {
  static Future<ApiCallResponse> call({
    String? token = '',
  }) async {
    return ApiManager.instance.makeApiCall(
      callName: 'tiquets',
      apiUrl: 'https://api.tiqets.com/v2/products',
      callType: ApiCallType.GET,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Token $token',
      },
      params: {
        'query': "Duomo di Milano",
      },
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class TiquetsSingleCall {
  static Future<ApiCallResponse> call({
    String? token = '',
    String? productId = '974092',
  }) async {
    return ApiManager.instance.makeApiCall(
      callName: 'tiquets single',
      apiUrl:
          'https://api.tiqets.com/v2/products/$productId/checkout_information',
      callType: ApiCallType.GET,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Token $token',
      },
      params: {},
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class CitiesCall {
  static Future<ApiCallResponse> call({
    String? token = '',
  }) async {
    return ApiManager.instance.makeApiCall(
      callName: 'cities',
      apiUrl: 'https://api.tiqets.com/v2/cities',
      callType: ApiCallType.GET,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Token $token',
      },
      params: {
        'country_id': 50109,
        'page_size': 100,
      },
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class CountriesCall {
  static Future<ApiCallResponse> call({
    String? token = '',
  }) async {
    return ApiManager.instance.makeApiCall(
      callName: 'countries',
      apiUrl: 'https://api.tiqets.com/v2/countries',
      callType: ApiCallType.GET,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Token $token',
      },
      params: {
        'page_size': 100,
      },
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class CountriesCopyCall {
  static Future<ApiCallResponse> call({
    String? token = '',
  }) async {
    return ApiManager.instance.makeApiCall(
      callName: 'countries Copy',
      apiUrl: 'https://api.tiqets.com/v2/countries',
      callType: ApiCallType.GET,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Token $token',
      },
      params: {
        'page_size': 100,
      },
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class RecommenderCall {
  static Future<ApiCallResponse> call() async {
    return ApiManager.instance.makeApiCall(
      callName: 'Recommender',
      apiUrl: 'https://cityvg-5fcc7f07e779.herokuapp.com/',
      callType: ApiCallType.GET,
      headers: {
        'Content-Type': 'application/json',
      },
      params: {},
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class ApiPagingParams {
  int nextPageNumber = 0;
  int numItems = 0;
  dynamic lastResponse;

  ApiPagingParams({
    required this.nextPageNumber,
    required this.numItems,
    required this.lastResponse,
  });

  @override
  String toString() =>
      'PagingParams(nextPageNumber: $nextPageNumber, numItems: $numItems, lastResponse: $lastResponse,)';
}

String _toEncodable(dynamic item) {
  if (item is DocumentReference) {
    return item.path;
  }
  return item;
}

String _serializeList(List? list) {
  list ??= <String>[];
  try {
    return json.encode(list, toEncodable: _toEncodable);
  } catch (_) {
    if (kDebugMode) {
      print("List serialization failed. Returning empty list.");
    }
    return '[]';
  }
}

String _serializeJson(dynamic jsonVar, [bool isList = false]) {
  jsonVar ??= (isList ? [] : {});
  try {
    return json.encode(jsonVar, toEncodable: _toEncodable);
  } catch (_) {
    if (kDebugMode) {
      print("Json serialization failed. Returning empty json.");
    }
    return isList ? '[]' : '{}';
  }
}
