// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class MessagesStruct extends BaseStruct {
  MessagesStruct({
    int? messageId,
    String? chatUuid,
    String? content,
    String? attachmentUrl,
    String? messageTimestamp,
    bool? isRead,
    String? syncStatus,
    String? senderId,
    String? senderName,
    String? receiverId,
    String? receiverName,
    String? lastSeenById,
    String? lastSeenByName,
  })  : _messageId = messageId,
        _chatUuid = chatUuid,
        _content = content,
        _attachmentUrl = attachmentUrl,
        _messageTimestamp = messageTimestamp,
        _isRead = isRead,
        _syncStatus = syncStatus,
        _senderId = senderId,
        _senderName = senderName,
        _receiverId = receiverId,
        _receiverName = receiverName,
        _lastSeenById = lastSeenById,
        _lastSeenByName = lastSeenByName;

  // "message_id" field.
  int? _messageId;
  int get messageId => _messageId ?? 0;
  set messageId(int? val) => _messageId = val;

  void incrementMessageId(int amount) => messageId = messageId + amount;

  bool hasMessageId() => _messageId != null;

  // "chat_uuid" field.
  String? _chatUuid;
  String get chatUuid => _chatUuid ?? '';
  set chatUuid(String? val) => _chatUuid = val;

  bool hasChatUuid() => _chatUuid != null;

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

  // "sender_id" field.
  String? _senderId;
  String get senderId => _senderId ?? '';
  set senderId(String? val) => _senderId = val;

  bool hasSenderId() => _senderId != null;

  // "sender_name" field.
  String? _senderName;
  String get senderName => _senderName ?? '';
  set senderName(String? val) => _senderName = val;

  bool hasSenderName() => _senderName != null;

  // "receiver_id" field.
  String? _receiverId;
  String get receiverId => _receiverId ?? '';
  set receiverId(String? val) => _receiverId = val;

  bool hasReceiverId() => _receiverId != null;

  // "receiver_name" field.
  String? _receiverName;
  String get receiverName => _receiverName ?? '';
  set receiverName(String? val) => _receiverName = val;

  bool hasReceiverName() => _receiverName != null;

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

  static MessagesStruct fromMap(Map<String, dynamic> data) => MessagesStruct(
        messageId: castToType<int>(data['message_id']),
        chatUuid: data['chat_uuid'] as String?,
        content: data['content'] as String?,
        attachmentUrl: data['attachment_url'] as String?,
        messageTimestamp: data['message_timestamp'] as String?,
        isRead: data['is_read'] as bool?,
        syncStatus: data['sync_status'] as String?,
        senderId: data['sender_id'] as String?,
        senderName: data['sender_name'] as String?,
        receiverId: data['receiver_id'] as String?,
        receiverName: data['receiver_name'] as String?,
        lastSeenById: data['last_seen_by_id'] as String?,
        lastSeenByName: data['last_seen_by_name'] as String?,
      );

  static MessagesStruct? maybeFromMap(dynamic data) =>
      data is Map ? MessagesStruct.fromMap(data.cast<String, dynamic>()) : null;

  Map<String, dynamic> toMap() => {
        'message_id': _messageId,
        'chat_uuid': _chatUuid,
        'content': _content,
        'attachment_url': _attachmentUrl,
        'message_timestamp': _messageTimestamp,
        'is_read': _isRead,
        'sync_status': _syncStatus,
        'sender_id': _senderId,
        'sender_name': _senderName,
        'receiver_id': _receiverId,
        'receiver_name': _receiverName,
        'last_seen_by_id': _lastSeenById,
        'last_seen_by_name': _lastSeenByName,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'message_id': serializeParam(
          _messageId,
          ParamType.int,
        ),
        'chat_uuid': serializeParam(
          _chatUuid,
          ParamType.String,
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
        'sender_id': serializeParam(
          _senderId,
          ParamType.String,
        ),
        'sender_name': serializeParam(
          _senderName,
          ParamType.String,
        ),
        'receiver_id': serializeParam(
          _receiverId,
          ParamType.String,
        ),
        'receiver_name': serializeParam(
          _receiverName,
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
      }.withoutNulls;

  static MessagesStruct fromSerializableMap(Map<String, dynamic> data) =>
      MessagesStruct(
        messageId: deserializeParam(
          data['message_id'],
          ParamType.int,
          false,
        ),
        chatUuid: deserializeParam(
          data['chat_uuid'],
          ParamType.String,
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
        senderId: deserializeParam(
          data['sender_id'],
          ParamType.String,
          false,
        ),
        senderName: deserializeParam(
          data['sender_name'],
          ParamType.String,
          false,
        ),
        receiverId: deserializeParam(
          data['receiver_id'],
          ParamType.String,
          false,
        ),
        receiverName: deserializeParam(
          data['receiver_name'],
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
      );

  @override
  String toString() => 'MessagesStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is MessagesStruct &&
        messageId == other.messageId &&
        chatUuid == other.chatUuid &&
        content == other.content &&
        attachmentUrl == other.attachmentUrl &&
        messageTimestamp == other.messageTimestamp &&
        isRead == other.isRead &&
        syncStatus == other.syncStatus &&
        senderId == other.senderId &&
        senderName == other.senderName &&
        receiverId == other.receiverId &&
        receiverName == other.receiverName &&
        lastSeenById == other.lastSeenById &&
        lastSeenByName == other.lastSeenByName;
  }

  @override
  int get hashCode => const ListEquality().hash([
        messageId,
        chatUuid,
        content,
        attachmentUrl,
        messageTimestamp,
        isRead,
        syncStatus,
        senderId,
        senderName,
        receiverId,
        receiverName,
        lastSeenById,
        lastSeenByName
      ]);
}

MessagesStruct createMessagesStruct({
  int? messageId,
  String? chatUuid,
  String? content,
  String? attachmentUrl,
  String? messageTimestamp,
  bool? isRead,
  String? syncStatus,
  String? senderId,
  String? senderName,
  String? receiverId,
  String? receiverName,
  String? lastSeenById,
  String? lastSeenByName,
}) =>
    MessagesStruct(
      messageId: messageId,
      chatUuid: chatUuid,
      content: content,
      attachmentUrl: attachmentUrl,
      messageTimestamp: messageTimestamp,
      isRead: isRead,
      syncStatus: syncStatus,
      senderId: senderId,
      senderName: senderName,
      receiverId: receiverId,
      receiverName: receiverName,
      lastSeenById: lastSeenById,
      lastSeenByName: lastSeenByName,
    );
