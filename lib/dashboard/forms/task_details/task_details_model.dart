import '/flutter_flow/flutter_flow_util.dart';
import '/utils/components/connectivity/connectivity_widget.dart';
import '/utils/components/saving_mode/saving_mode_widget.dart';
import 'task_details_widget.dart' show TaskDetailsWidget;
import 'package:flutter/material.dart';

class TaskDetailsModel extends FlutterFlowModel<TaskDetailsWidget> {
  ///  Local state fields for this page.

  bool? isReFTPClicked = false;

  String statusOutput = 'Up to date';

  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Custom Action - updateOnlinePpirFormsFromOfflinePpirForms] action in taskDetails widget.
  String? message;
  // Stores action output result for [Custom Action - getDateTimeNow] action in taskDetails widget.
  DateTime? dateNow;
  // Stores action output result for [Custom Action - updateOnlinePpirFormsFromOfflinePpirForms] action in Text widget.
  String? messageCopy;
  // Model for connectivity component.
  late ConnectivityModel connectivityModel;
  // Stores action output result for [Custom Action - generateTaskXml] action in reFTP widget.
  String? generatedXML;
  // Stores action output result for [Custom Action - saveToFTP] action in reFTP widget.
  bool? isFtpSaved;
  // Model for savingMode component.
  late SavingModeModel savingModeModel;

  @override
  void initState(BuildContext context) {
    connectivityModel = createModel(context, () => ConnectivityModel());
    savingModeModel = createModel(context, () => SavingModeModel());
  }

  @override
  void dispose() {
    connectivityModel.dispose();
    savingModeModel.dispose();
  }
}
