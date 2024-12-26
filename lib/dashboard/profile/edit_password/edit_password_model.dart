import '/flutter_flow/flutter_flow_util.dart';
import '/utils/components/connectivity/connectivity_widget.dart';
import 'edit_password_widget.dart' show EditPasswordWidget;
import 'package:flutter/material.dart';

class EditPasswordModel extends FlutterFlowModel<EditPasswordWidget> {
  ///  Local state fields for this page.

  bool isPasswordVerified = true;

  String passwordChangeMessage = '\${editPasswordResult}';

  ///  State fields for stateful widgets in this page.

  final formKey = GlobalKey<FormState>();
  // Model for connectivity component.
  late ConnectivityModel connectivityModel;
  // State field(s) for old_password widget.
  FocusNode? oldPasswordFocusNode;
  TextEditingController? oldPasswordTextController;
  late bool oldPasswordVisibility;
  String? Function(BuildContext, String?)? oldPasswordTextControllerValidator;
  String? _oldPasswordTextControllerValidator(
      BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return FFLocalizations.of(context).getText(
        'c2yh7kit' /* Field is required */,
      );
    }

    return null;
  }

  // State field(s) for new_password widget.
  FocusNode? newPasswordFocusNode;
  TextEditingController? newPasswordTextController;
  late bool newPasswordVisibility;
  String? Function(BuildContext, String?)? newPasswordTextControllerValidator;
  String? _newPasswordTextControllerValidator(
      BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return FFLocalizations.of(context).getText(
        '1ey470jp' /* Field is required */,
      );
    }

    return null;
  }

  // State field(s) for confirm_new_password widget.
  FocusNode? confirmNewPasswordFocusNode;
  TextEditingController? confirmNewPasswordTextController;
  late bool confirmNewPasswordVisibility;
  String? Function(BuildContext, String?)?
      confirmNewPasswordTextControllerValidator;
  String? _confirmNewPasswordTextControllerValidator(
      BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return FFLocalizations.of(context).getText(
        'idz4ks80' /* Field is required */,
      );
    }

    return null;
  }

  @override
  void initState(BuildContext context) {
    connectivityModel = createModel(context, () => ConnectivityModel());
    oldPasswordVisibility = false;
    oldPasswordTextControllerValidator = _oldPasswordTextControllerValidator;
    newPasswordVisibility = false;
    newPasswordTextControllerValidator = _newPasswordTextControllerValidator;
    confirmNewPasswordVisibility = false;
    confirmNewPasswordTextControllerValidator =
        _confirmNewPasswordTextControllerValidator;
  }

  @override
  void dispose() {
    connectivityModel.dispose();
    oldPasswordFocusNode?.dispose();
    oldPasswordTextController?.dispose();

    newPasswordFocusNode?.dispose();
    newPasswordTextController?.dispose();

    confirmNewPasswordFocusNode?.dispose();
    confirmNewPasswordTextController?.dispose();
  }
}
