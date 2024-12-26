import '/flutter_flow/flutter_flow_util.dart';
import 'geotagging_widget.dart' show GeotaggingWidget;
import 'package:flutter/material.dart';

class GeotaggingModel extends FlutterFlowModel<GeotaggingWidget> {
  ///  Local state fields for this page.

  bool isGeotagStart = true;

  bool isFinished = true;

  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Custom Action - fetchAddressFromCoordinates] action in geotagging widget.
  dynamic getCurrentLocationAddress;
  // Stores action output result for [Alert Dialog - Custom Dialog] action in back widget.
  bool? confirmBack;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
