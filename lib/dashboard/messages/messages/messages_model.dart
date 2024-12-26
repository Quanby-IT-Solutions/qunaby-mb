import '/backend/api_requests/api_calls.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/utils/components/connectivity/connectivity_widget.dart';
import 'messages_widget.dart' show MessagesWidget;
import 'package:flutter/material.dart';

class MessagesModel extends FlutterFlowModel<MessagesWidget> {
  ///  State fields for stateful widgets in this page.

  final formKey = GlobalKey<FormState>();
  // Stores action output result for [Backend Call - API (Update Last Seen and Read)] action in messages widget.
  ApiCallResponse? apiResultw5j;
  // Model for connectivity component.
  late ConnectivityModel connectivityModel;
  // State field(s) for inputChat widget.
  FocusNode? inputChatFocusNode;
  TextEditingController? inputChatTextController;
  String? Function(BuildContext, String?)? inputChatTextControllerValidator;

  @override
  void initState(BuildContext context) {
    connectivityModel = createModel(context, () => ConnectivityModel());
  }

  @override
  void dispose() {
    connectivityModel.dispose();
    inputChatFocusNode?.dispose();
    inputChatTextController?.dispose();
  }
}
