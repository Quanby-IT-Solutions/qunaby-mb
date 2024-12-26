import '/backend/sqlite/sqlite_manager.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/form_field_controller.dart';
import '/utils/components/connectivity/connectivity_widget.dart';
import 'ppir_form_widget.dart' show PpirFormWidget;
import 'package:flutter/material.dart';

class PpirFormModel extends FlutterFlowModel<PpirFormWidget> {
  ///  Local state fields for this page.

  bool isMapDownloaded = false;

  bool hasGpx = true;

  bool hasSigInsured = true;

  bool hasSigIuia = true;

  String? capturedBlobOutput;

  ///  State fields for stateful widgets in this page.

  final formKey = GlobalKey<FormState>();
  // Stores action output result for [Backend Call - SQLite (SELECT PROFILE)] action in ppirForm widget.
  List<SelectProfileRow>? profile;
  // Stores action output result for [Backend Call - SQLite (Select Ppir Forms)] action in ppirForm widget.
  List<SelectPpirFormsRow>? qCapturedImage;
  // Model for connectivity component.
  late ConnectivityModel connectivityModel;
  // Stores action output result for [Alert Dialog - Custom Dialog] action in IconButton widget.
  bool? confirmback;
  // Stores action output result for [Custom Action - generateTaskXml] action in Text widget.
  String? generatedTaskXmlFile;
  // Stores action output result for [Alert Dialog - Custom Dialog] action in repeatGeotagButtonT widget.
  bool? confirmReGeotag;
  // Stores action output result for [Custom Action - getGpxLink] action in downloadButton widget.
  String? gpxLink;
  // State field(s) for ppir_track_coordinates widget.
  FocusNode? ppirTrackCoordinatesFocusNode;
  TextEditingController? ppirTrackCoordinatesTextController;
  String? Function(BuildContext, String?)?
      ppirTrackCoordinatesTextControllerValidator;
  String? _ppirTrackCoordinatesTextControllerValidator(
      BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return FFLocalizations.of(context).getText(
        'n9qxzlnc' /* Field is required */,
      );
    }

    return null;
  }

  // State field(s) for ppir_track_total_area widget.
  FocusNode? ppirTrackTotalAreaFocusNode1;
  TextEditingController? ppirTrackTotalAreaTextController1;
  String? Function(BuildContext, String?)?
      ppirTrackTotalAreaTextController1Validator;
  String? _ppirTrackTotalAreaTextController1Validator(
      BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return FFLocalizations.of(context).getText(
        '1g01x7w4' /* Field is required */,
      );
    }

    return null;
  }

  // State field(s) for ppir_track_date_time widget.
  FocusNode? ppirTrackDateTimeFocusNode;
  TextEditingController? ppirTrackDateTimeTextController;
  String? Function(BuildContext, String?)?
      ppirTrackDateTimeTextControllerValidator;
  String? _ppirTrackDateTimeTextControllerValidator(
      BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return FFLocalizations.of(context).getText(
        'qewwk8ln' /* Field is required */,
      );
    }

    return null;
  }

  // State field(s) for ppir_track_total_area widget.
  FocusNode? ppirTrackTotalAreaFocusNode2;
  TextEditingController? ppirTrackTotalAreaTextController2;
  String? Function(BuildContext, String?)?
      ppirTrackTotalAreaTextController2Validator;
  String? _ppirTrackTotalAreaTextController2Validator(
      BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return FFLocalizations.of(context).getText(
        'pj4tf8fn' /* Field is required */,
      );
    }

    return null;
  }

  // State field(s) for ppir_track_farmloc widget.
  FocusNode? ppirTrackFarmlocFocusNode;
  TextEditingController? ppirTrackFarmlocTextController;
  String? Function(BuildContext, String?)?
      ppirTrackFarmlocTextControllerValidator;
  String? _ppirTrackFarmlocTextControllerValidator(
      BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return FFLocalizations.of(context).getText(
        'vr769179' /* Field is required */,
      );
    }

    return null;
  }

  // State field(s) for ppir_svp_act_selection widget.
  FormFieldController<String>? ppirSvpActSelectionValueController;
  // State field(s) for riceDropdown widget.
  String? riceDropdownValue;
  FormFieldController<String>? riceDropdownValueController;
  // State field(s) for cornDropdown widget.
  String? cornDropdownValue;
  FormFieldController<String>? cornDropdownValueController;
  // State field(s) for ppir_area_act_field widget.
  FocusNode? ppirAreaActFieldFocusNode;
  TextEditingController? ppirAreaActFieldTextController;
  String? Function(BuildContext, String?)?
      ppirAreaActFieldTextControllerValidator;
  String? _ppirAreaActFieldTextControllerValidator(
      BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return FFLocalizations.of(context).getText(
        'f7d4dwme' /* Field is required */,
      );
    }

    return null;
  }

  // State field(s) for ppir_area_dop_ds_field widget.
  FocusNode? ppirAreaDopDsFieldFocusNode;
  TextEditingController? ppirAreaDopDsFieldTextController;
  String? Function(BuildContext, String?)?
      ppirAreaDopDsFieldTextControllerValidator;
  String? _ppirAreaDopDsFieldTextControllerValidator(
      BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return FFLocalizations.of(context).getText(
        'x8h9ctg8' /* Field is required */,
      );
    }

    return null;
  }

  DateTime? datePicked1;
  // State field(s) for ppir_area_dop_tp_field widget.
  FocusNode? ppirAreaDopTpFieldFocusNode;
  TextEditingController? ppirAreaDopTpFieldTextController;
  String? Function(BuildContext, String?)?
      ppirAreaDopTpFieldTextControllerValidator;
  String? _ppirAreaDopTpFieldTextControllerValidator(
      BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return FFLocalizations.of(context).getText(
        'g73iojeh' /* Field is required */,
      );
    }

    return null;
  }

  DateTime? datePicked2;
  bool isDataUploading = false;
  FFUploadedFile uploadedLocalFile =
      FFUploadedFile(bytes: Uint8List.fromList([]));

  // Stores action output result for [Custom Action - convertCapturedImageToBase64] action in captureButton widget.
  String? base64;
  // State field(s) for capturedImageBlobInput widget.
  FocusNode? capturedImageBlobInputFocusNode;
  TextEditingController? capturedImageBlobInputTextController;
  String? Function(BuildContext, String?)?
      capturedImageBlobInputTextControllerValidator;
  String? _capturedImageBlobInputTextControllerValidator(
      BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return FFLocalizations.of(context).getText(
        'q79tvmns' /* Must have a captured Image */,
      );
    }

    return null;
  }

  // State field(s) for ppir_remarks_field widget.
  FocusNode? ppirRemarksFieldFocusNode;
  TextEditingController? ppirRemarksFieldTextController;
  String? Function(BuildContext, String?)?
      ppirRemarksFieldTextControllerValidator;
  String? _ppirRemarksFieldTextControllerValidator(
      BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return FFLocalizations.of(context).getText(
        'rny5ce43' /* Field is required */,
      );
    }

    return null;
  }

  // State field(s) for ppir_prepared_by_name_field widget.
  FocusNode? ppirPreparedByNameFieldFocusNode;
  TextEditingController? ppirPreparedByNameFieldTextController;
  String? Function(BuildContext, String?)?
      ppirPreparedByNameFieldTextControllerValidator;
  String? _ppirPreparedByNameFieldTextControllerValidator(
      BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return FFLocalizations.of(context).getText(
        'hxfm3oxy' /* Field is required */,
      );
    }

    return null;
  }

  // State field(s) for ppir_confirmed_by_name_field widget.
  FocusNode? ppirConfirmedByNameFieldFocusNode;
  TextEditingController? ppirConfirmedByNameFieldTextController;
  String? Function(BuildContext, String?)?
      ppirConfirmedByNameFieldTextControllerValidator;
  String? _ppirConfirmedByNameFieldTextControllerValidator(
      BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return FFLocalizations.of(context).getText(
        'gug2f3ir' /* Field is required */,
      );
    }

    return null;
  }

  // Stores action output result for [Alert Dialog - Custom Dialog] action in cancelButton widget.
  bool? confirmCancel;
  // Stores action output result for [Alert Dialog - Custom Dialog] action in saveButton widget.
  bool? continueSave;
  // Stores action output result for [Custom Action - getDateTimeNow] action in saveButton widget.
  DateTime? dateNow;
  // Stores action output result for [Validate Form] action in submitButton widget.
  bool? isValidated;
  // Stores action output result for [Alert Dialog - Custom Dialog] action in submitButton widget.
  bool? continueSubmit;
  // Stores action output result for [Custom Action - getDateTimeNow] action in submitButton widget.
  DateTime? dateNowForSubmit;
  // Stores action output result for [Backend Call - Update Row(s)] action in submitButton widget.
  List<PpirFormsRow>? savePPIRCopy;
  // Stores action output result for [Custom Action - generateTaskXml] action in submitButton widget.
  String? generatedXML;
  // Stores action output result for [Custom Action - saveToFTP] action in submitButton widget.
  bool? isFtpSaved;
  // Stores action output result for [Backend Call - Update Row(s)] action in submitButton widget.
  List<TasksRow>? asubmitDate;

  @override
  void initState(BuildContext context) {
    connectivityModel = createModel(context, () => ConnectivityModel());
    ppirTrackCoordinatesTextControllerValidator =
        _ppirTrackCoordinatesTextControllerValidator;
    ppirTrackTotalAreaTextController1Validator =
        _ppirTrackTotalAreaTextController1Validator;
    ppirTrackDateTimeTextControllerValidator =
        _ppirTrackDateTimeTextControllerValidator;
    ppirTrackTotalAreaTextController2Validator =
        _ppirTrackTotalAreaTextController2Validator;
    ppirTrackFarmlocTextControllerValidator =
        _ppirTrackFarmlocTextControllerValidator;
    ppirAreaActFieldTextControllerValidator =
        _ppirAreaActFieldTextControllerValidator;
    ppirAreaDopDsFieldTextControllerValidator =
        _ppirAreaDopDsFieldTextControllerValidator;
    ppirAreaDopTpFieldTextControllerValidator =
        _ppirAreaDopTpFieldTextControllerValidator;
    capturedImageBlobInputTextControllerValidator =
        _capturedImageBlobInputTextControllerValidator;
    ppirRemarksFieldTextControllerValidator =
        _ppirRemarksFieldTextControllerValidator;
    ppirPreparedByNameFieldTextControllerValidator =
        _ppirPreparedByNameFieldTextControllerValidator;
    ppirConfirmedByNameFieldTextControllerValidator =
        _ppirConfirmedByNameFieldTextControllerValidator;
  }

  @override
  void dispose() {
    connectivityModel.dispose();
    ppirTrackCoordinatesFocusNode?.dispose();
    ppirTrackCoordinatesTextController?.dispose();

    ppirTrackTotalAreaFocusNode1?.dispose();
    ppirTrackTotalAreaTextController1?.dispose();

    ppirTrackDateTimeFocusNode?.dispose();
    ppirTrackDateTimeTextController?.dispose();

    ppirTrackTotalAreaFocusNode2?.dispose();
    ppirTrackTotalAreaTextController2?.dispose();

    ppirTrackFarmlocFocusNode?.dispose();
    ppirTrackFarmlocTextController?.dispose();

    ppirAreaActFieldFocusNode?.dispose();
    ppirAreaActFieldTextController?.dispose();

    ppirAreaDopDsFieldFocusNode?.dispose();
    ppirAreaDopDsFieldTextController?.dispose();

    ppirAreaDopTpFieldFocusNode?.dispose();
    ppirAreaDopTpFieldTextController?.dispose();

    capturedImageBlobInputFocusNode?.dispose();
    capturedImageBlobInputTextController?.dispose();

    ppirRemarksFieldFocusNode?.dispose();
    ppirRemarksFieldTextController?.dispose();

    ppirPreparedByNameFieldFocusNode?.dispose();
    ppirPreparedByNameFieldTextController?.dispose();

    ppirConfirmedByNameFieldFocusNode?.dispose();
    ppirConfirmedByNameFieldTextController?.dispose();
  }

  /// Additional helper methods.
  String? get ppirSvpActSelectionValue =>
      ppirSvpActSelectionValueController?.value;
}
