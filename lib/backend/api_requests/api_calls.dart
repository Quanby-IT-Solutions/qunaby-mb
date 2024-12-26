import 'dart:convert';

import 'package:flutter/foundation.dart';

import '/flutter_flow/flutter_flow_util.dart';
import 'api_manager.dart';

export 'api_manager.dart' show ApiCallResponse;

const _kPrivateApiFunctionName = 'ffPrivateApiCall';

class GetMessagesCall {
  static Future<ApiCallResponse> call({
    String? chatId = '',
  }) async {
    final ffApiRequestBody = '''
{
  "p_chat_id": "$chatId"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'Get Messages',
      apiUrl:
          'https://vnsnxkhiyguywgggwdau.supabase.co/rest/v1/rpc/get_chat_messages',
      callType: ApiCallType.POST,
      headers: {
        'Content-Type': 'application/json',
        'apikey':
            'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InZuc254a2hpeWd1eXdnZ2d3ZGF1Iiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTcyMTEzMzkwMCwiZXhwIjoyMDM2NzA5OTAwfQ.2bhfGH3Mtr0SU7_cekh_1WZljNdrygTAjQNV4eT_DLQ',
        'Authorization':
            'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InZuc254a2hpeWd1eXdnZ2d3ZGF1Iiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTcyMTEzMzkwMCwiZXhwIjoyMDM2NzA5OTAwfQ.2bhfGH3Mtr0SU7_cekh_1WZljNdrygTAjQNV4eT_DLQ',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  static List<int>? messageId(dynamic response) => (getJsonField(
        response,
        r'''$[:].message_id''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<int>(x))
          .withoutNulls
          .toList();
  static List<String>? chatId(dynamic response) => (getJsonField(
        response,
        r'''$[:].chat_id''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<String>(x))
          .withoutNulls
          .toList();
  static List<String>? context(dynamic response) => (getJsonField(
        response,
        r'''$[:].content''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<String>(x))
          .withoutNulls
          .toList();
  static List? attachmentUrl(dynamic response) => getJsonField(
        response,
        r'''$[:].attachment_url''',
        true,
      ) as List?;
  static List<String>? messageTimestamp(dynamic response) => (getJsonField(
        response,
        r'''$[:].message_timestamp''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<String>(x))
          .withoutNulls
          .toList();
  static List<bool>? isRead(dynamic response) => (getJsonField(
        response,
        r'''$[:].is_read''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<bool>(x))
          .withoutNulls
          .toList();
  static List<String>? syncStatus(dynamic response) => (getJsonField(
        response,
        r'''$[:].sync_status''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<String>(x))
          .withoutNulls
          .toList();
  static List<String>? senderId(dynamic response) => (getJsonField(
        response,
        r'''$[:].sender_id''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<String>(x))
          .withoutNulls
          .toList();
  static List<String>? lenderName(dynamic response) => (getJsonField(
        response,
        r'''$[:].sender_name''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<String>(x))
          .withoutNulls
          .toList();
  static List<String>? recieverId(dynamic response) => (getJsonField(
        response,
        r'''$[:].receiver_id''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<String>(x))
          .withoutNulls
          .toList();
  static List<String>? recieverName(dynamic response) => (getJsonField(
        response,
        r'''$[:].receiver_name''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<String>(x))
          .withoutNulls
          .toList();
  static List? lastSeenById(dynamic response) => getJsonField(
        response,
        r'''$[:].last_seen_by_id''',
        true,
      ) as List?;
  static List? lastSeenByName(dynamic response) => getJsonField(
        response,
        r'''$[:].last_seen_by_name''',
        true,
      ) as List?;
  static List<bool>? currentUserSeen(dynamic response) => (getJsonField(
        response,
        r'''$[:].current_user_seen''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<bool>(x))
          .withoutNulls
          .toList();
}

class UpdateLastSeenAndReadCall {
  static Future<ApiCallResponse> call({
    String? chatId = '',
    String? userId = '',
  }) async {
    final ffApiRequestBody = '''
{
  "p_chat_id": "$chatId",
  "p_user_id": "$userId"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'Update Last Seen and Read',
      apiUrl:
          'https://vnsnxkhiyguywgggwdau.supabase.co/rest/v1/rpc/update_last_seen_and_read',
      callType: ApiCallType.POST,
      headers: {
        'Content-Type': 'application/json',
        'apikey':
            'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InZuc254a2hpeWd1eXdnZ2d3ZGF1Iiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTcyMTEzMzkwMCwiZXhwIjoyMDM2NzA5OTAwfQ.2bhfGH3Mtr0SU7_cekh_1WZljNdrygTAjQNV4eT_DLQ',
        'Authorization':
            'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InZuc254a2hpeWd1eXdnZ2d3ZGF1Iiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTcyMTEzMzkwMCwiZXhwIjoyMDM2NzA5OTAwfQ.2bhfGH3Mtr0SU7_cekh_1WZljNdrygTAjQNV4eT_DLQ',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  static List<int>? messageId(dynamic response) => (getJsonField(
        response,
        r'''$[:].message_id''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<int>(x))
          .withoutNulls
          .toList();
  static List<String>? chatId(dynamic response) => (getJsonField(
        response,
        r'''$[:].chat_id''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<String>(x))
          .withoutNulls
          .toList();
  static List<String>? context(dynamic response) => (getJsonField(
        response,
        r'''$[:].content''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<String>(x))
          .withoutNulls
          .toList();
  static List? attachmentUrl(dynamic response) => getJsonField(
        response,
        r'''$[:].attachment_url''',
        true,
      ) as List?;
  static List<String>? messageTimestamp(dynamic response) => (getJsonField(
        response,
        r'''$[:].message_timestamp''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<String>(x))
          .withoutNulls
          .toList();
  static List<bool>? isRead(dynamic response) => (getJsonField(
        response,
        r'''$[:].is_read''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<bool>(x))
          .withoutNulls
          .toList();
  static List<String>? syncStatus(dynamic response) => (getJsonField(
        response,
        r'''$[:].sync_status''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<String>(x))
          .withoutNulls
          .toList();
  static List<String>? senderId(dynamic response) => (getJsonField(
        response,
        r'''$[:].sender_id''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<String>(x))
          .withoutNulls
          .toList();
  static List<String>? lenderName(dynamic response) => (getJsonField(
        response,
        r'''$[:].sender_name''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<String>(x))
          .withoutNulls
          .toList();
  static List<String>? recieverId(dynamic response) => (getJsonField(
        response,
        r'''$[:].receiver_id''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<String>(x))
          .withoutNulls
          .toList();
  static List<String>? recieverName(dynamic response) => (getJsonField(
        response,
        r'''$[:].receiver_name''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<String>(x))
          .withoutNulls
          .toList();
  static List? lastSeenById(dynamic response) => getJsonField(
        response,
        r'''$[:].last_seen_by_id''',
        true,
      ) as List?;
  static List? lastSeenByName(dynamic response) => getJsonField(
        response,
        r'''$[:].last_seen_by_name''',
        true,
      ) as List?;
  static List<bool>? currentUserSeen(dynamic response) => (getJsonField(
        response,
        r'''$[:].current_user_seen''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<bool>(x))
          .withoutNulls
          .toList();
}

class GetUserLastConversationsCall {
  static Future<ApiCallResponse> call({
    String? pUserId = '',
  }) async {
    final ffApiRequestBody = '''
{
  "p_user_id": "$pUserId"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'Get User Last Conversations',
      apiUrl:
          'https://vnsnxkhiyguywgggwdau.supabase.co/rest/v1/rpc/get_user_last_conversations',
      callType: ApiCallType.POST,
      headers: {
        'Content-Type': 'application/json',
        'apikey':
            'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InZuc254a2hpeWd1eXdnZ2d3ZGF1Iiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTcyMTEzMzkwMCwiZXhwIjoyMDM2NzA5OTAwfQ.2bhfGH3Mtr0SU7_cekh_1WZljNdrygTAjQNV4eT_DLQ',
        'Authorization':
            'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InZuc254a2hpeWd1eXdnZ2d3ZGF1Iiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTcyMTEzMzkwMCwiZXhwIjoyMDM2NzA5OTAwfQ.2bhfGH3Mtr0SU7_cekh_1WZljNdrygTAjQNV4eT_DLQ',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  static List<String>? chatId(dynamic response) => (getJsonField(
        response,
        r'''$[:].chat_id''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<String>(x))
          .withoutNulls
          .toList();
  static List<int>? lastMessageId(dynamic response) => (getJsonField(
        response,
        r'''$[:].last_message_id''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<int>(x))
          .withoutNulls
          .toList();
  static List<String>? content(dynamic response) => (getJsonField(
        response,
        r'''$[:].content''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<String>(x))
          .withoutNulls
          .toList();
  static List? attachmentUrl(dynamic response) => getJsonField(
        response,
        r'''$[:].attachment_url''',
        true,
      ) as List?;
  static List<String>? messageTimestamp(dynamic response) => (getJsonField(
        response,
        r'''$[:].message_timestamp''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<String>(x))
          .withoutNulls
          .toList();
  static List<bool>? isRead(dynamic response) => (getJsonField(
        response,
        r'''$[:].is_read''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<bool>(x))
          .withoutNulls
          .toList();
  static List<String>? syncStatus(dynamic response) => (getJsonField(
        response,
        r'''$[:].sync_status''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<String>(x))
          .withoutNulls
          .toList();
  static List<String>? conversationPartnerId(dynamic response) => (getJsonField(
        response,
        r'''$[:].conversation_partner_id''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<String>(x))
          .withoutNulls
          .toList();
  static List<String>? conversationPartnerName(dynamic response) =>
      (getJsonField(
        response,
        r'''$[:].conversation_partner_name''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<String>(x))
          .withoutNulls
          .toList();
  static List? lastSeenNyId(dynamic response) => getJsonField(
        response,
        r'''$[:].last_seen_by_id''',
        true,
      ) as List?;
  static List? lastSeenByName(dynamic response) => getJsonField(
        response,
        r'''$[:].last_seen_by_name''',
        true,
      ) as List?;
  static List<bool>? currentUserSeen(dynamic response) => (getJsonField(
        response,
        r'''$[:].current_user_seen''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<bool>(x))
          .withoutNulls
          .toList();
}

class FetchMbTilesCall {
  static Future<ApiCallResponse> call() async {
    return ApiManager.instance.makeApiCall(
      callName: 'fetchMbTiles',
      apiUrl:
          'https://vnsnxkhiyguywgggwdau.supabase.co/storage/v1/object/public/mb-files/trails.mbtiles',
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
