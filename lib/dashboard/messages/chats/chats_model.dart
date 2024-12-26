import '/flutter_flow/flutter_flow_util.dart';
import '/utils/components/chat_list_container/chat_list_container_widget.dart';
import '/utils/components/connectivity/connectivity_widget.dart';
import 'chats_widget.dart' show ChatsWidget;
import 'package:flutter/material.dart';

class ChatsModel extends FlutterFlowModel<ChatsWidget> {
  ///  State fields for stateful widgets in this page.

  // Model for connectivity component.
  late ConnectivityModel connectivityModel;
  // Models for chatListContainer dynamic component.
  late FlutterFlowDynamicModels<ChatListContainerModel> chatListContainerModels;

  @override
  void initState(BuildContext context) {
    connectivityModel = createModel(context, () => ConnectivityModel());
    chatListContainerModels =
        FlutterFlowDynamicModels(() => ChatListContainerModel());
  }

  @override
  void dispose() {
    connectivityModel.dispose();
    chatListContainerModels.dispose();
  }
}
