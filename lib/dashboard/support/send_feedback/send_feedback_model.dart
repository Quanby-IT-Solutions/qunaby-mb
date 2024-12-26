import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/form_field_controller.dart';
import 'send_feedback_widget.dart' show SendFeedbackWidget;
import 'package:flutter/material.dart';

class SendFeedbackModel extends FlutterFlowModel<SendFeedbackWidget> {
  ///  State fields for stateful widgets in this page.

  final formKey = GlobalKey<FormState>();
  // State field(s) for purposeDropDown widget.
  String? purposeDropDownValue;
  FormFieldController<String>? purposeDropDownValueController;
  // State field(s) for inputMessage widget.
  FocusNode? inputMessageFocusNode;
  TextEditingController? inputMessageTextController;
  String? Function(BuildContext, String?)? inputMessageTextControllerValidator;
  String? _inputMessageTextControllerValidator(
      BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return FFLocalizations.of(context).getText(
        'woi12gmx' /* Field is required */,
      );
    }

    return null;
  }

  // Stores action output result for [Validate Form] action in submitButton widget.
  bool? isValidated;

  @override
  void initState(BuildContext context) {
    inputMessageTextControllerValidator = _inputMessageTextControllerValidator;
  }

  @override
  void dispose() {
    inputMessageFocusNode?.dispose();
    inputMessageTextController?.dispose();
  }
}
