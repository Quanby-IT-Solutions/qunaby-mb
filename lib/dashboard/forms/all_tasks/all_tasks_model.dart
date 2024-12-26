import '/flutter_flow/flutter_flow_util.dart';
import '/utils/components/connectivity/connectivity_widget.dart';
import 'all_tasks_widget.dart' show AllTasksWidget;
import 'package:flutter/material.dart';

class AllTasksModel extends FlutterFlowModel<AllTasksWidget> {
  ///  Local state fields for this page.

  String statusOutput = 'Syncing...';

  bool isSyncDone = false;

  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Custom Action - isDirtyCount] action in allTasks widget.
  String? isDirtyCounterr;
  // Stores action output result for [Custom Action - syncOnlineTaskAndPpirToOffline] action in allTasks widget.
  String? outputMsg;
  // Stores action output result for [Custom Action - syncOnlineTaskAndPpirToOffline] action in Text widget.
  String? message;
  // Model for connectivity component.
  late ConnectivityModel connectivityModel;

  @override
  void initState(BuildContext context) {
    connectivityModel = createModel(context, () => ConnectivityModel());
  }

  @override
  void dispose() {
    connectivityModel.dispose();
  }
}
