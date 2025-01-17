import 'dart:convert';
import 'dart:typed_data';
import '../cloud_functions/cloud_functions.dart';
import '../schema/structs/index.dart';

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
        'Authorization': 'Token ${token}',
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
          'https://api.tiqets.com/v2/products/${productId}/checkout_information',
      callType: ApiCallType.GET,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Token ${token}',
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
        'Authorization': 'Token ${token}',
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
        'Authorization': 'Token ${token}',
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
        'Authorization': 'Token ${token}',
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

class TestCall {
  static Future<ApiCallResponse> call() async {
    return ApiManager.instance.makeApiCall(
      callName: 'test',
      apiUrl:
          'http://127.0.0.1:8000/tiqets/?lat=48.864716&lng=2.349014&radius=10',
      callType: ApiCallType.GET,
      headers: {},
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

class LocalhostCall {
  static Future<ApiCallResponse> call({
    double? lat = 48.864716,
    double? lng = 2.349014,
    int? radius = 10,
    String? startDate = '2024-11-23',
    String? endDate = '2024-11-30',
    int? startTime = 9,
    int? endTime = 15,
    int? numSeniors = 0,
    int? numAdults = 2,
    int? numYouth = 0,
    int? numChildren = 1,
    String? budget = 'Cheap',
  }) async {
    return ApiManager.instance.makeApiCall(
      callName: 'localhost',
      apiUrl: 'http://127.0.0.1:8000/generate/',
      callType: ApiCallType.GET,
      headers: {},
      params: {
        'lat': lat,
        'lng': lng,
        'radius': radius,
        'start_date': startDate,
        'end_date': endDate,
        'start_time': startTime,
        'end_time': endTime,
        'num_seniors': numSeniors,
        'num_adults': numAdults,
        'num_youth': numYouth,
        'num_children': numChildren,
        'budget': budget,
      },
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  static List? itineraries(dynamic response) => getJsonField(
        response,
        r'''$.itineraries''',
        true,
      ) as List?;
}

class HerokuPreferencesCall {
  static Future<ApiCallResponse> call({
    double? lat = 48.864716,
    double? lng = 2.349014,
    int? radius = 10,
    String? startDate = '2024-11-23',
    String? endDate = '2024-11-30',
    String? startTime = '9:00',
    String? endTime = '15:00',
    int? numSeniors = 0,
    int? numAdults = 2,
    int? numYouth = 0,
    int? numChildren = 1,
    String? budget = 'Cheap',
    String? categories = '',
  }) async {
    final response = await makeCloudCall(
      _kPrivateApiFunctionName,
      {
        'callName': 'HerokuPreferencesCall',
        'variables': {
          'lat': lat,
          'lng': lng,
          'radius': radius,
          'startDate': startDate,
          'endDate': endDate,
          'startTime': startTime,
          'endTime': endTime,
          'numSeniors': numSeniors,
          'numAdults': numAdults,
          'numYouth': numYouth,
          'numChildren': numChildren,
          'budget': budget,
          'categories': categories,
        },
      },
    );
    return ApiCallResponse.fromCloudCallResponse(response);
  }

  static List? preferences(dynamic response) => getJsonField(
        response,
        r'''$.preferences''',
        true,
      ) as List?;
}

class HerokuItinerariesCall {
  static Future<ApiCallResponse> call({
    double? lat = 48.864716,
    double? lng = 2.349014,
    int? radius = 10,
    String? startDate = '2024-11-23',
    String? endDate = '2024-11-30',
    String? startTime = '9:00',
    String? endTime = '18:00',
    int? numSeniors = 0,
    int? numAdults = 2,
    int? numYouth = 0,
    int? numChildren = 1,
    String? budget = 'Cheap',
    String? requiredPlaces = '',
    String? removedPlaces = '',
    String? categories = '',
  }) async {
    final response = await makeCloudCall(
      _kPrivateApiFunctionName,
      {
        'callName': 'HerokuItinerariesCall',
        'variables': {
          'lat': lat,
          'lng': lng,
          'radius': radius,
          'startDate': startDate,
          'endDate': endDate,
          'startTime': startTime,
          'endTime': endTime,
          'numSeniors': numSeniors,
          'numAdults': numAdults,
          'numYouth': numYouth,
          'numChildren': numChildren,
          'budget': budget,
          'requiredPlaces': requiredPlaces,
          'removedPlaces': removedPlaces,
          'categories': categories,
        },
      },
    );
    return ApiCallResponse.fromCloudCallResponse(response);
  }

  static List? itineraries(dynamic response) => getJsonField(
        response,
        r'''$.itineraries''',
        true,
      ) as List?;
}

class HerokuImageCall {
  static Future<ApiCallResponse> call({
    String? cityName = 'London',
  }) async {
    final response = await makeCloudCall(
      _kPrivateApiFunctionName,
      {
        'callName': 'HerokuImageCall',
        'variables': {
          'cityName': cityName,
        },
      },
    );
    return ApiCallResponse.fromCloudCallResponse(response);
  }

  static String? image(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.image''',
      ));
  static String? cityName(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.city_name''',
      ));
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
