// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class LastMessagesStruct extends BaseStruct {
  LastMessagesStruct({
    String? chatId,
    int? lastMessageId,
    String? content,
    String? attachmentUrl,
    String? messageTimestamp,
    bool? isRead,
    String? syncStatus,
    String? conversationPartnerId,
    String? conversationPartnerName,
    String? lastSeenById,
    String? lastSeenByName,
    bool? currentUserSeen,
  })  : _chatId = chatId,
        _lastMessageId = lastMessageId,
        _content = content,
        _attachmentUrl = attachmentUrl,
        _messageTimestamp = messageTimestamp,
        _isRead = isRead,
        _syncStatus = syncStatus,
        _conversationPartnerId = conversationPartnerId,
        _conversationPartnerName = conversationPartnerName,
        _lastSeenById = lastSeenById,
        _lastSeenByName = lastSeenByName,
        _currentUserSeen = currentUserSeen;

  // "chat_id" field.
  String? _chatId;
  String get chatId => _chatId ?? '';
  set chatId(String? val) => _chatId = val;

  bool hasChatId() => _chatId != null;

  // "last_message_id" field.
  int? _lastMessageId;
  int get lastMessageId => _lastMessageId ?? 0;
  set lastMessageId(int? val) => _lastMessageId = val;

  void incrementLastMessageId(int amount) =>
      lastMessageId = lastMessageId + amount;

  bool hasLastMessageId() => _lastMessageId != null;

  // "content" field.
  String? _content;
  String get content => _content ?? '';
  set content(String? val) => _content = val;

  bool hasContent() => _content != null;

  // "attachment_url" field.
  String? _attachmentUrl;
  String get attachmentUrl => _attachmentUrl ?? '';
  set attachmentUrl(String? val) => _attachmentUrl = val;

  bool hasAttachmentUrl() => _attachmentUrl != null;

  // "message_timestamp" field.
  String? _messageTimestamp;
  String get messageTimestamp => _messageTimestamp ?? '';
  set messageTimestamp(String? val) => _messageTimestamp = val;

  bool hasMessageTimestamp() => _messageTimestamp != null;

  // "is_read" field.
  bool? _isRead;
  bool get isRead => _isRead ?? false;
  set isRead(bool? val) => _isRead = val;

  bool hasIsRead() => _isRead != null;

  // "sync_status" field.
  String? _syncStatus;
  String get syncStatus => _syncStatus ?? '';
  set syncStatus(String? val) => _syncStatus = val;

  bool hasSyncStatus() => _syncStatus != null;

  // "conversation_partner_id" field.
  String? _conversationPartnerId;
  String get conversationPartnerId => _conversationPartnerId ?? '';
  set conversationPartnerId(String? val) => _conversationPartnerId = val;

  bool hasConversationPartnerId() => _conversationPartnerId != null;

  // "conversation_partner_name" field.
  String? _conversationPartnerName;
  String get conversationPartnerName => _conversationPartnerName ?? '';
  set conversationPartnerName(String? val) => _conversationPartnerName = val;

  bool hasConversationPartnerName() => _conversationPartnerName != null;

  // "last_seen_by_id" field.
  String? _lastSeenById;
  String get lastSeenById => _lastSeenById ?? '';
  set lastSeenById(String? val) => _lastSeenById = val;

  bool hasLastSeenById() => _lastSeenById != null;

  // "last_seen_by_name" field.
  String? _lastSeenByName;
  String get lastSeenByName => _lastSeenByName ?? '';
  set lastSeenByName(String? val) => _lastSeenByName = val;

  bool hasLastSeenByName() => _lastSeenByName != null;

  // "current_user_seen" field.
  bool? _currentUserSeen;
  bool get currentUserSeen => _currentUserSeen ?? false;
  set currentUserSeen(bool? val) => _currentUserSeen = val;

  bool hasCurrentUserSeen() => _currentUserSeen != null;

  static LastMessagesStruct fromMap(Map<String, dynamic> data) =>
      LastMessagesStruct(
        chatId: data['chat_id'] as String?,
        lastMessageId: castToType<int>(data['last_message_id']),
        content: data['content'] as String?,
        attachmentUrl: data['attachment_url'] as String?,
        messageTimestamp: data['message_timestamp'] as String?,
        isRead: data['is_read'] as bool?,
        syncStatus: data['sync_status'] as String?,
        conversationPartnerId: data['conversation_partner_id'] as String?,
        conversationPartnerName: data['conversation_partner_name'] as String?,
        lastSeenById: data['last_seen_by_id'] as String?,
        lastSeenByName: data['last_seen_by_name'] as String?,
        currentUserSeen: data['current_user_seen'] as bool?,
      );

  static LastMessagesStruct? maybeFromMap(dynamic data) => data is Map
      ? LastMessagesStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'chat_id': _chatId,
        'last_message_id': _lastMessageId,
        'content': _content,
        'attachment_url': _attachmentUrl,
        'message_timestamp': _messageTimestamp,
        'is_read': _isRead,
        'sync_status': _syncStatus,
        'conversation_partner_id': _conversationPartnerId,
        'conversation_partner_name': _conversationPartnerName,
        'last_seen_by_id': _lastSeenById,
        'last_seen_by_name': _lastSeenByName,
        'current_user_seen': _currentUserSeen,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'chat_id': serializeParam(
          _chatId,
          ParamType.String,
        ),
        'last_message_id': serializeParam(
          _lastMessageId,
          ParamType.int,
        ),
        'content': serializeParam(
          _content,
          ParamType.String,
        ),
        'attachment_url': serializeParam(
          _attachmentUrl,
          ParamType.String,
        ),
        'message_timestamp': serializeParam(
          _messageTimestamp,
          ParamType.String,
        ),
        'is_read': serializeParam(
          _isRead,
          ParamType.bool,
        ),
        'sync_status': serializeParam(
          _syncStatus,
          ParamType.String,
        ),
        'conversation_partner_id': serializeParam(
          _conversationPartnerId,
          ParamType.String,
        ),
        'conversation_partner_name': serializeParam(
          _conversationPartnerName,
          ParamType.String,
        ),
        'last_seen_by_id': serializeParam(
          _lastSeenById,
          ParamType.String,
        ),
        'last_seen_by_name': serializeParam(
          _lastSeenByName,
          ParamType.String,
        ),
        'current_user_seen': serializeParam(
          _currentUserSeen,
          ParamType.bool,
        ),
      }.withoutNulls;

  static LastMessagesStruct fromSerializableMap(Map<String, dynamic> data) =>
      LastMessagesStruct(
        chatId: deserializeParam(
          data['chat_id'],
          ParamType.String,
          false,
        ),
        lastMessageId: deserializeParam(
          data['last_message_id'],
          ParamType.int,
          false,
        ),
        content: deserializeParam(
          data['content'],
          ParamType.String,
          false,
        ),
        attachmentUrl: deserializeParam(
          data['attachment_url'],
          ParamType.String,
          false,
        ),
        messageTimestamp: deserializeParam(
          data['message_timestamp'],
          ParamType.String,
          false,
        ),
        isRead: deserializeParam(
          data['is_read'],
          ParamType.bool,
          false,
        ),
        syncStatus: deserializeParam(
          data['sync_status'],
          ParamType.String,
          false,
        ),
        conversationPartnerId: deserializeParam(
          data['conversation_partner_id'],
          ParamType.String,
          false,
        ),
        conversationPartnerName: deserializeParam(
          data['conversation_partner_name'],
          ParamType.String,
          false,
        ),
        lastSeenById: deserializeParam(
          data['last_seen_by_id'],
          ParamType.String,
          false,
        ),
        lastSeenByName: deserializeParam(
          data['last_seen_by_name'],
          ParamType.String,
          false,
        ),
        currentUserSeen: deserializeParam(
          data['current_user_seen'],
          ParamType.bool,
          false,
        ),
      );

  @override
  String toString() => 'LastMessagesStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is LastMessagesStruct &&
        chatId == other.chatId &&
        lastMessageId == other.lastMessageId &&
        content == other.content &&
        attachmentUrl == other.attachmentUrl &&
        messageTimestamp == other.messageTimestamp &&
        isRead == other.isRead &&
        syncStatus == other.syncStatus &&
        conversationPartnerId == other.conversationPartnerId &&
        conversationPartnerName == other.conversationPartnerName &&
        lastSeenById == other.lastSeenById &&
        lastSeenByName == other.lastSeenByName &&
        currentUserSeen == other.currentUserSeen;
  }

  @override
  int get hashCode => const ListEquality().hash([
        chatId,
        lastMessageId,
        content,
        attachmentUrl,
        messageTimestamp,
        isRead,
        syncStatus,
        conversationPartnerId,
        conversationPartnerName,
        lastSeenById,
        lastSeenByName,
        currentUserSeen
      ]);
}

LastMessagesStruct createLastMessagesStruct({
  String? chatId,
  int? lastMessageId,
  String? content,
  String? attachmentUrl,
  String? messageTimestamp,
  bool? isRead,
  String? syncStatus,
  String? conversationPartnerId,
  String? conversationPartnerName,
  String? lastSeenById,
  String? lastSeenByName,
  bool? currentUserSeen,
}) =>
    LastMessagesStruct(
      chatId: chatId,
      lastMessageId: lastMessageId,
      content: content,
      attachmentUrl: attachmentUrl,
      messageTimestamp: messageTimestamp,
      isRead: isRead,
      syncStatus: syncStatus,
      conversationPartnerId: conversationPartnerId,
      conversationPartnerName: conversationPartnerName,
      lastSeenById: lastSeenById,
      lastSeenByName: lastSeenByName,
      currentUserSeen: currentUserSeen,
    );
