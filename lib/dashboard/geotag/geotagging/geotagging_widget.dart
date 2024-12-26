import '/auth/supabase_auth/auth_util.dart';
import '/backend/sqlite/sqlite_manager.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/utils/components/dialogs/continue_go_back_dialog/continue_go_back_dialog_widget.dart';
import 'dart:async';
import '/custom_code/actions/index.dart' as actions;
import '/custom_code/widgets/index.dart' as custom_widgets;
import '/flutter_flow/custom_functions.dart' as functions;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'geotagging_model.dart';
export 'geotagging_model.dart';

class GeotaggingWidget extends StatefulWidget {
  const GeotaggingWidget({
    super.key,
    required this.taskId,
    required this.taskType,
    required this.taskStatus,
    required this.assignmentId,
  });

  final String? taskId;
  final String? taskType;
  final String? taskStatus;
  final String? assignmentId;

  @override
  State<GeotaggingWidget> createState() => _GeotaggingWidgetState();
}

class _GeotaggingWidgetState extends State<GeotaggingWidget>
    with TickerProviderStateMixin {
  late GeotaggingModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  LatLng? currentUserLocationValue;

  final animationsMap = <String, AnimationInfo>{};

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => GeotaggingModel());

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      currentUserLocationValue =
          await getCurrentUserLocation(defaultLocation: const LatLng(0.0, 0.0));
      await actions.updateUserLogs(
        context,
      );
      _model.getCurrentLocationAddress =
          await actions.fetchAddressFromCoordinates(
        functions.getLng(currentUserLocationValue),
        functions.getLat(currentUserLocationValue),
      );
      _model.isGeotagStart = false;
      _model.isFinished = false;
      safeSetState(() {});
      if (FFAppState().ONLINE) {
        FFAppState().mapLoadedWithInternet = true;
        safeSetState(() {});
      }
    });

    getCurrentUserLocation(defaultLocation: const LatLng(0.0, 0.0), cached: true)
        .then((loc) => safeSetState(() => currentUserLocationValue = loc));
    animationsMap.addAll({
      'iconOnPageLoadAnimation': AnimationInfo(
        loop: true,
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          RotateEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 600.0.ms,
            begin: 0.0,
            end: 1.0,
          ),
        ],
      ),
    });
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();
    if (currentUserLocationValue == null) {
      return Container(
        color: FlutterFlowTheme.of(context).primaryBackground,
        child: Center(
          child: SizedBox(
            width: 100.0,
            height: 100.0,
            child: SpinKitRipple(
              color: FlutterFlowTheme.of(context).primary,
              size: 100.0,
            ),
          ),
        ),
      );
    }

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          key: scaffoldKey,
          backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
          body: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: MediaQuery.sizeOf(context).height * 0.75,
                        child: Stack(
                          alignment: const AlignmentDirectional(0.0, 0.0),
                          children: [
                            InkWell(
                              splashColor: Colors.transparent,
                              focusColor: Colors.transparent,
                              hoverColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              onTap: () async {
                                if (FFAppState().ONLINE) {
                                  FFAppState().mapLoadedWithInternet = true;
                                  safeSetState(() {});
                                }
                              },
                              child: SizedBox(
                                width: MediaQuery.sizeOf(context).width * 1.0,
                                height: MediaQuery.sizeOf(context).height * 1.0,
                                child: custom_widgets.MapBox(
                                  width: MediaQuery.sizeOf(context).width * 1.0,
                                  height:
                                      MediaQuery.sizeOf(context).height * 1.0,
                                  accessToken: FFAppState().accessToken,
                                  taskId: widget.taskId,
                                ),
                              ),
                            ),
                            Column(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      20.0, 0.0, 20.0, 0.0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Align(
                                        alignment:
                                            const AlignmentDirectional(0.85, -0.4),
                                        child: Builder(
                                          builder: (context) => Padding(
                                            padding:
                                                const EdgeInsetsDirectional.fromSTEB(
                                                    0.0, 50.0, 0.0, 0.0),
                                            child: FlutterFlowIconButton(
                                              borderColor: Colors.transparent,
                                              borderRadius: 30.0,
                                              borderWidth: 1.0,
                                              buttonSize: 40.0,
                                              fillColor:
                                                  FlutterFlowTheme.of(context)
                                                      .primary,
                                              icon: Icon(
                                                Icons.chevron_left_rounded,
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .info,
                                                size: 20.0,
                                              ),
                                              onPressed: () async {
                                                currentUserLocationValue =
                                                    await getCurrentUserLocation(
                                                        defaultLocation:
                                                            const LatLng(0.0, 0.0));
                                                await showDialog(
                                                  context: context,
                                                  builder: (dialogContext) {
                                                    return Dialog(
                                                      elevation: 0,
                                                      insetPadding:
                                                          EdgeInsets.zero,
                                                      backgroundColor:
                                                          Colors.transparent,
                                                      alignment:
                                                          const AlignmentDirectional(
                                                                  0.0, 0.0)
                                                              .resolve(
                                                                  Directionality.of(
                                                                      context)),
                                                      child: GestureDetector(
                                                        onTap: () {
                                                          FocusScope.of(
                                                                  dialogContext)
                                                              .unfocus();
                                                          FocusManager.instance
                                                              .primaryFocus
                                                              ?.unfocus();
                                                        },
                                                        child:
                                                            const ContinueGoBackDialogWidget(),
                                                      ),
                                                    );
                                                  },
                                                ).then((value) => safeSetState(
                                                    () => _model.confirmBack =
                                                        value));

                                                if (_model.confirmBack!) {
                                                  await SQLiteManager.instance
                                                      .updatePPIRFormGpx(
                                                    taskId: widget.taskId,
                                                    gpx: ' ',
                                                    isDirty:
                                                        !FFAppState().ONLINE,
                                                  );
                                                  unawaited(
                                                    () async {
                                                      await UserLogsTable()
                                                          .insert({
                                                        'user_id':
                                                            currentUserUid,
                                                        'activity':
                                                            'Navigate back to Task details',
                                                        'longlat':
                                                            '${functions.getLng(currentUserLocationValue).toString()}, ${functions.getLat(currentUserLocationValue).toString()}',
                                                      });
                                                    }(),
                                                  );

                                                  context.goNamed(
                                                    'taskDetails',
                                                    queryParameters: {
                                                      'taskId': serializeParam(
                                                        widget.taskId,
                                                        ParamType.String,
                                                      ),
                                                      'taskStatus':
                                                          serializeParam(
                                                        widget.taskStatus,
                                                        ParamType.String,
                                                      ),
                                                    }.withoutNulls,
                                                  );
                                                }
                                                FFAppState().routeStarted =
                                                    false;
                                                FFAppState().update(() {});

                                                safeSetState(() {});
                                              },
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(
                            24.0, 16.0, 24.0, 0.0),
                        child: Container(
                          width: MediaQuery.sizeOf(context).width * 1.0,
                          decoration: const BoxDecoration(),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                valueOrDefault<String>(
                                  widget.assignmentId,
                                  'Assignment Id',
                                ),
                                style: FlutterFlowTheme.of(context)
                                    .headlineMedium
                                    .override(
                                      fontFamily: 'Inter',
                                      color:
                                          FlutterFlowTheme.of(context).accent1,
                                      letterSpacing: 0.0,
                                    ),
                              ),
                              Container(
                                height: 32.0,
                                decoration: BoxDecoration(
                                  color: _model.isGeotagStart == false
                                      ? FlutterFlowTheme.of(context).accent1
                                      : FlutterFlowTheme.of(context).warning,
                                  borderRadius: BorderRadius.circular(12.0),
                                  border: Border.all(
                                    color: FlutterFlowTheme.of(context)
                                        .secondaryBackground,
                                  ),
                                ),
                                child: Align(
                                  alignment: const AlignmentDirectional(0.0, 0.0),
                                  child: Padding(
                                    padding: const EdgeInsetsDirectional.fromSTEB(
                                        12.0, 0.0, 12.0, 0.0),
                                    child: AnimatedDefaultTextStyle(
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                            fontFamily: 'Readex Pro',
                                            letterSpacing: 0.0,
                                          ),
                                      duration: const Duration(milliseconds: 600),
                                      curve: Curves.easeIn,
                                      child: Text(
                                        _model.isGeotagStart != true
                                            ? (_model.isFinished
                                                ? 'Saving'
                                                : 'Waiting to start')
                                            : 'Waiting to finish',
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(
                            24.0, 0.0, 24.0, 0.0),
                        child: Container(
                          width: MediaQuery.sizeOf(context).width * 1.0,
                          decoration: const BoxDecoration(),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    FFLocalizations.of(context).getText(
                                      'qx4ly86s' /* Address:  */,
                                    ),
                                    style: FlutterFlowTheme.of(context)
                                        .labelSmall
                                        .override(
                                          fontFamily: 'Readex Pro',
                                          color: FlutterFlowTheme.of(context)
                                              .primaryText,
                                          letterSpacing: 0.0,
                                        ),
                                  ),
                                  SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Text(
                                          FFAppState().ONLINE
                                              ? valueOrDefault<String>(
                                                  functions.getAddress(_model
                                                      .getCurrentLocationAddress),
                                                  '{}',
                                                )
                                              : 'No Adress to fetch because you are offline.',
                                          style: FlutterFlowTheme.of(context)
                                              .labelSmall
                                              .override(
                                                fontFamily: 'Readex Pro',
                                                letterSpacing: 0.0,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    FFLocalizations.of(context).getText(
                                      'lvzg53kl' /* Lng:  */,
                                    ),
                                    style: FlutterFlowTheme.of(context)
                                        .labelSmall
                                        .override(
                                          fontFamily: 'Readex Pro',
                                          color: FlutterFlowTheme.of(context)
                                              .primaryText,
                                          letterSpacing: 0.0,
                                        ),
                                  ),
                                  Text(
                                    functions
                                        .getLng(currentUserLocationValue)
                                        .toString(),
                                    style: FlutterFlowTheme.of(context)
                                        .labelSmall
                                        .override(
                                          fontFamily: 'Readex Pro',
                                          letterSpacing: 0.0,
                                        ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    FFLocalizations.of(context).getText(
                                      'zuoev2f9' /* Lat:  */,
                                    ),
                                    style: FlutterFlowTheme.of(context)
                                        .labelSmall
                                        .override(
                                          fontFamily: 'Readex Pro',
                                          color: FlutterFlowTheme.of(context)
                                              .primaryText,
                                          letterSpacing: 0.0,
                                        ),
                                  ),
                                  Text(
                                    functions
                                        .getLat(currentUserLocationValue)
                                        .toString(),
                                    style: FlutterFlowTheme.of(context)
                                        .labelSmall
                                        .override(
                                          fontFamily: 'Readex Pro',
                                          letterSpacing: 0.0,
                                        ),
                                  ),
                                ],
                              ),
                            ]
                                .divide(const SizedBox(height: 5.0))
                                .around(const SizedBox(height: 5.0)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (_model.isGeotagStart == false)
                InkWell(
                  splashColor: Colors.transparent,
                  focusColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onTap: () async {
                    currentUserLocationValue = await getCurrentUserLocation(
                        defaultLocation: const LatLng(0.0, 0.0));
                    if (_model.isFinished) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Saving is in progress.',
                            style: TextStyle(
                              color: FlutterFlowTheme.of(context).primaryText,
                            ),
                          ),
                          duration: const Duration(milliseconds: 4000),
                          backgroundColor:
                              FlutterFlowTheme.of(context).secondary,
                        ),
                      );
                    } else {
                      if (FFAppState().ONLINE) {
                        _model.isGeotagStart = true;
                        _model.isFinished = false;
                        safeSetState(() {});
                        FFAppState().routeStarted = true;
                        safeSetState(() {});
                        unawaited(
                          () async {
                            await UserLogsTable().insert({
                              'user_id': currentUserUid,
                              'activity': 'Started Tracking',
                              'longlat':
                                  '${functions.getLng(currentUserLocationValue).toString()}, ${functions.getLat(currentUserLocationValue).toString()}',
                            });
                          }(),
                        );
                      } else {
                        _model.isGeotagStart = true;
                        _model.isFinished = false;
                        safeSetState(() {});
                        FFAppState().routeStarted = true;
                        safeSetState(() {});
                      }
                    }
                  },
                  child: Container(
                    width: double.infinity,
                    height: 80.0,
                    decoration: BoxDecoration(
                      color: _model.isGeotagStart == false
                          ? FlutterFlowTheme.of(context).accent1
                          : FlutterFlowTheme.of(context).warning,
                      boxShadow: const [
                        BoxShadow(
                          blurRadius: 5.0,
                          color: Color(0x411D2429),
                          offset: Offset(
                            0.0,
                            2.0,
                          ),
                        )
                      ],
                      borderRadius: BorderRadius.circular(0.0),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Stack(
                          children: [
                            if (_model.isFinished == true)
                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    0.0, 0.0, 5.0, 0.0),
                                child: Icon(
                                  FFIcons.kloading,
                                  color:
                                      FlutterFlowTheme.of(context).primaryText,
                                  size: 20.0,
                                ).animateOnPageLoad(
                                    animationsMap['iconOnPageLoadAnimation']!),
                              ),
                            if (_model.isFinished == false)
                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    0.0, 0.0, 5.0, 0.0),
                                child: FaIcon(
                                  FontAwesomeIcons.play,
                                  color:
                                      FlutterFlowTheme.of(context).primaryText,
                                  size: 20.0,
                                ),
                              ),
                          ],
                        ),
                        Text(
                          _model.isFinished ? 'Saving' : 'Start',
                          style:
                              FlutterFlowTheme.of(context).bodyLarge.override(
                                    fontFamily: 'Readex Pro',
                                    letterSpacing: 0.0,
                                  ),
                        ),
                      ],
                    ),
                  ),
                ),
              if (_model.isGeotagStart == true)
                InkWell(
                  splashColor: Colors.transparent,
                  focusColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onTap: () async {
                    currentUserLocationValue = await getCurrentUserLocation(
                        defaultLocation: const LatLng(0.0, 0.0));
                    FFAppState().routeStarted = false;
                    safeSetState(() {});
                    if (FFAppState().ONLINE) {
                      unawaited(
                        () async {
                          await UserLogsTable().insert({
                            'user_id': currentUserUid,
                            'activity': 'Finished Tracking',
                            'longlat':
                                '${functions.getLng(currentUserLocationValue).toString()}, ${functions.getLat(currentUserLocationValue).toString()}',
                          });
                        }(),
                      );
                      await TasksTable().update(
                        data: {
                          'status': 'ongoing',
                        },
                        matchingRows: (rows) => rows.eq(
                          'id',
                          widget.taskId,
                        ),
                      );
                    }
                    await SQLiteManager.instance.updateTaskStatus(
                      taskId: widget.taskId,
                      status: 'ongoing',
                      isDirty: !FFAppState().ONLINE,
                    );
                    _model.isGeotagStart = false;
                    _model.isFinished = true;
                    safeSetState(() {});

                    context.goNamed(
                      'gpxSuccess',
                      queryParameters: {
                        'taskId': serializeParam(
                          widget.taskId,
                          ParamType.String,
                        ),
                      }.withoutNulls,
                      extra: <String, dynamic>{
                        kTransitionInfoKey: const TransitionInfo(
                          hasTransition: true,
                          transitionType: PageTransitionType.scale,
                          alignment: Alignment.bottomCenter,
                          duration: Duration(milliseconds: 300),
                        ),
                      },
                    );
                  },
                  child: Container(
                    width: double.infinity,
                    height: 80.0,
                    decoration: BoxDecoration(
                      color: _model.isGeotagStart == false
                          ? FlutterFlowTheme.of(context).accent1
                          : FlutterFlowTheme.of(context).warning,
                      boxShadow: const [
                        BoxShadow(
                          blurRadius: 5.0,
                          color: Color(0x411D2429),
                          offset: Offset(
                            0.0,
                            2.0,
                          ),
                        )
                      ],
                      borderRadius: BorderRadius.circular(0.0),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              0.0, 0.0, 5.0, 0.0),
                          child: FaIcon(
                            FontAwesomeIcons.stop,
                            color: Colors.white,
                            size: 20.0,
                          ),
                        ),
                        Text(
                          FFLocalizations.of(context).getText(
                            'cmxtd6yw' /* Finish */,
                          ),
                          style:
                              FlutterFlowTheme.of(context).bodyLarge.override(
                                    fontFamily: 'Readex Pro',
                                    color: Colors.white,
                                    letterSpacing: 0.0,
                                  ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
