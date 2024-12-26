import '/flutter_flow/flutter_flow_util.dart';
import '/utils/components/connectivity/connectivity_widget.dart';
import '/utils/components/profile_container/profile_container_widget.dart';
import '/utils/components/saving_mode/saving_mode_widget.dart';
import '/utils/components/tasks/tasks_widget.dart';
import 'dashboard_widget.dart' show DashboardWidget;
import 'package:flutter/material.dart';

class DashboardModel extends FlutterFlowModel<DashboardWidget> {
  ///  Local state fields for this page.

  String? statusOutput = 'Tap to update';

  bool isSyncDone = true;

  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Custom Action - isDirtyCount] action in dashboard widget.
  String? isDirtyCounter;
  // Stores action output result for [Custom Action - syncOnlineTaskAndPpirToOffline] action in dashboard widget.
  String? syncOnlineTaskAndPpirToOfflineOutput;
  // Stores action output result for [Custom Action - syncOnlineTaskAndPpirToOffline] action in Text widget.
  String? message;
  // Model for connectivity component.
  late ConnectivityModel connectivityModel;
  // Model for profileContainer component.
  late ProfileContainerModel profileContainerModel;
  // State field(s) for TabBar widget.
  TabController? tabBarController;
  int get tabBarCurrentIndex =>
      tabBarController != null ? tabBarController!.index : 0;

  // Models for tasks dynamic component.
  late FlutterFlowDynamicModels<TasksModel> tasksModels1;
  // Models for tasks dynamic component.
  late FlutterFlowDynamicModels<TasksModel> tasksModels2;
  // Models for tasks dynamic component.
  late FlutterFlowDynamicModels<TasksModel> tasksModels3;
  // Model for savingMode component.
  late SavingModeModel savingModeModel;

  @override
  void initState(BuildContext context) {
    connectivityModel = createModel(context, () => ConnectivityModel());
    profileContainerModel = createModel(context, () => ProfileContainerModel());
    tasksModels1 = FlutterFlowDynamicModels(() => TasksModel());
    tasksModels2 = FlutterFlowDynamicModels(() => TasksModel());
    tasksModels3 = FlutterFlowDynamicModels(() => TasksModel());
    savingModeModel = createModel(context, () => SavingModeModel());
  }

  @override
  void dispose() {
    connectivityModel.dispose();
    profileContainerModel.dispose();
    tabBarController?.dispose();
    tasksModels1.dispose();
    tasksModels2.dispose();
    tasksModels3.dispose();
    savingModeModel.dispose();
  }
}
