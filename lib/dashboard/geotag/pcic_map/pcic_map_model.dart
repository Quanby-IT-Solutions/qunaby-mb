import '/flutter_flow/flutter_flow_util.dart';
import '/utils/components/connectivity/connectivity_widget.dart';
import 'pcic_map_widget.dart' show PcicMapWidget;
import 'package:flutter/material.dart';

class PcicMapModel extends FlutterFlowModel<PcicMapWidget> {
  ///  Local state fields for this page.

  bool isLoading = true;

  bool? isMapDeleted;

  ///  State fields for stateful widgets in this page.

  // State field(s) for TabBar widget.
  TabController? tabBarController;
  int get tabBarCurrentIndex =>
      tabBarController != null ? tabBarController!.index : 0;

  // Model for connectivity component.
  late ConnectivityModel connectivityModel;

  @override
  void initState(BuildContext context) {
    connectivityModel = createModel(context, () => ConnectivityModel());
  }

  @override
  void dispose() {
    tabBarController?.dispose();
    connectivityModel.dispose();
  }
}
