import '/auth/supabase_auth/auth_util.dart';
import '/backend/sqlite/sqlite_manager.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/utils/components/page_loader/page_loader_widget.dart';
import '/custom_code/actions/index.dart' as actions;
import '/flutter_flow/custom_functions.dart' as functions;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'sync_model.dart';
export 'sync_model.dart';

class SyncWidget extends StatefulWidget {
  const SyncWidget({super.key});

  @override
  State<SyncWidget> createState() => _SyncWidgetState();
}

class _SyncWidgetState extends State<SyncWidget> with TickerProviderStateMixin {
  late SyncModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  LatLng? currentUserLocationValue;

  final animationsMap = <String, AnimationInfo>{};

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => SyncModel());

    animationsMap.addAll({
      'iconOnPageLoadAnimation': AnimationInfo(
        loop: true,
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          RotateEffect(
            curve: Curves.easeIn,
            delay: 0.0.ms,
            duration: 600.0.ms,
            begin: 0.0,
            end: 1.0,
          ),
        ],
      ),
      'textOnPageLoadAnimation': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          VisibilityEffect(duration: 150.ms),
          FadeEffect(
            curve: Curves.easeInOut,
            delay: 150.0.ms,
            duration: 300.0.ms,
            begin: 0.0,
            end: 1.0,
          ),
          ScaleEffect(
            curve: Curves.easeInOut,
            delay: 150.0.ms,
            duration: 300.0.ms,
            begin: const Offset(0.8, 0.8),
            end: const Offset(1.0, 1.0),
          ),
          TiltEffect(
            curve: Curves.easeInOut,
            delay: 150.0.ms,
            duration: 300.0.ms,
            begin: const Offset(0, 1.396),
            end: const Offset(0, 0),
          ),
          MoveEffect(
            curve: Curves.easeInOut,
            delay: 150.0.ms,
            duration: 300.0.ms,
            begin: const Offset(0.0, 40.0),
            end: const Offset(0.0, 0.0),
          ),
        ],
      ),
      'columnOnActionTriggerAnimation': AnimationInfo(
        trigger: AnimationTrigger.onActionTrigger,
        applyInitialState: true,
        effectsBuilder: () => [
          ScaleEffect(
            curve: Curves.easeInOutQuint,
            delay: 0.0.ms,
            duration: 600.0.ms,
            begin: const Offset(1.0, 1.0),
            end: const Offset(1.0, 1.0),
          ),
        ],
      ),
      'buttonOnActionTriggerAnimation': AnimationInfo(
        trigger: AnimationTrigger.onActionTrigger,
        applyInitialState: true,
        effectsBuilder: () => [
          ShimmerEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 600.0.ms,
            color: const Color(0x80FFFFFF),
            angle: 0.524,
          ),
        ],
      ),
    });
    setupAnimations(
      animationsMap.values.where((anim) =>
          anim.trigger == AnimationTrigger.onActionTrigger ||
          !anim.applyInitialState),
      this,
    );
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<SelectProfileRow>>(
      future: SQLiteManager.instance.selectProfile(
        email: currentUserEmail,
      ),
      builder: (context, snapshot) {
        // Customize what your widget looks like when it's loading.
        if (!snapshot.hasData) {
          return Scaffold(
            backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
            body: Center(
              child: SizedBox(
                width: MediaQuery.sizeOf(context).width * 1.0,
                height: MediaQuery.sizeOf(context).height * 1.0,
                child: const PageLoaderWidget(),
              ),
            ),
          );
        }
        final syncSelectProfileRowList = snapshot.data!;

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
              body: SafeArea(
                top: true,
                child: Padding(
                  padding:
                      const EdgeInsetsDirectional.fromSTEB(20.0, 20.0, 20.0, 20.0),
                  child: Container(
                    width: MediaQuery.sizeOf(context).width * 1.0,
                    height: MediaQuery.sizeOf(context).height * 1.0,
                    constraints: BoxConstraints(
                      minWidth: MediaQuery.sizeOf(context).width * 1.0,
                      minHeight: MediaQuery.sizeOf(context).height * 1.0,
                      maxWidth: MediaQuery.sizeOf(context).width * 1.0,
                      maxHeight: MediaQuery.sizeOf(context).height * 1.0,
                    ),
                    decoration: const BoxDecoration(),
                    child: Column(
                      key: const ValueKey('Column_d3zz'),
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                          splashColor: Colors.transparent,
                          focusColor: Colors.transparent,
                          hoverColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          onTap: () async {
                            currentUserLocationValue =
                                await getCurrentUserLocation(
                                    defaultLocation: const LatLng(0.0, 0.0));
                            if (!_model.isSync) {
                              await SQLiteManager.instance
                                  .dELETEAllRowsForTASKSAndPPIR();
                              // Number Iteration
                              _model.startSync = true;
                              _model.isSync = true;
                              _model.isSynced = false;
                              safeSetState(() {});
                              _model.regionCode = await SQLiteManager.instance
                                  .oFFLINESelectREGIONCODE(
                                id: syncSelectProfileRowList
                                    .firstOrNull?.regionId,
                              );
                              _model.isSyced = await actions.syncFromFTP(
                                _model.regionCode?.firstOrNull?.regionCode,
                              );
                              _model.syncMessage = await actions
                                  .syncOnlineTaskAndPpirToOffline();
                              await UserLogsTable().insert({
                                'user_id': currentUserUid,
                                'activity': 'Resyncing Tasks',
                                'longlat':
                                    '${functions.getLng(currentUserLocationValue).toString()}, ${functions.getLat(currentUserLocationValue).toString()}',
                              });
                              _model.isSync = false;
                              _model.startSync = false;
                              _model.isSynced = true;
                              safeSetState(() {});
                            } else {
                              if (kDebugMode) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Already Syncing',
                                      style: GoogleFonts.getFont(
                                        'Roboto',
                                        color: FlutterFlowTheme.of(context)
                                            .primaryText,
                                      ),
                                    ),
                                    duration: const Duration(milliseconds: 4000),
                                    backgroundColor:
                                        FlutterFlowTheme.of(context).secondary,
                                  ),
                                );
                              }
                            }

                            safeSetState(() {});
                          },
                          child: Container(
                            width: 300.0,
                            decoration: const BoxDecoration(),
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Stack(
                                  children: [
                                    if (!_model.isSync)
                                      FaIcon(
                                        FontAwesomeIcons.sync,
                                        color: FlutterFlowTheme.of(context)
                                            .secondaryText,
                                        size: 200.0,
                                      ),
                                    if (_model.isSync)
                                      FaIcon(
                                        FontAwesomeIcons.sync,
                                        color: FlutterFlowTheme.of(context)
                                            .primary,
                                        size: 200.0,
                                      ).animateOnPageLoad(animationsMap[
                                          'iconOnPageLoadAnimation']!),
                                  ],
                                ),
                                Align(
                                  alignment: const AlignmentDirectional(0.0, -1.0),
                                  child: AnimatedDefaultTextStyle(
                                    style: FlutterFlowTheme.of(context)
                                        .labelMedium
                                        .override(
                                          fontFamily: 'Readex Pro',
                                          letterSpacing: 0.0,
                                        ),
                                    duration: const Duration(milliseconds: 600),
                                    curve: Curves.easeIn,
                                    child: Text(
                                      () {
                                        if ((_model.isSync == true) &&
                                            (_model.isSynced == false)) {
                                          return 'Syncing';
                                        } else if ((_model.isSync == false) &&
                                            (_model.isSynced == true)) {
                                          return 'Tap again to sync';
                                        } else {
                                          return 'Tap to sync';
                                        }
                                      }(),
                                      textAlign: TextAlign.center,
                                    ),
                                  ).animateOnPageLoad(animationsMap[
                                      'textOnPageLoadAnimation']!),
                                ),
                              ]
                                  .divide(const SizedBox(height: 20.0))
                                  .around(const SizedBox(height: 20.0)),
                            ),
                          ),
                        ),
                        if (_model.isSynced)
                          Column(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                FFLocalizations.of(context).getText(
                                  '2algl1qt' /* Sync Success */,
                                ),
                                textAlign: TextAlign.center,
                                style: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                      fontFamily: 'Readex Pro',
                                      letterSpacing: 0.0,
                                    ),
                              ),
                              FFButtonWidget(
                                onPressed: () async {
                                  FFAppState().syncCount = 0;
                                  FFAppState().update(() {});

                                  context.goNamed('dashboard');
                                },
                                text: FFLocalizations.of(context).getText(
                                  'nzwziy9t' /* Dashboard */,
                                ),
                                icon: const Icon(
                                  Icons.home,
                                  size: 15.0,
                                ),
                                options: FFButtonOptions(
                                  width: 200.0,
                                  height: 40.0,
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      24.0, 0.0, 24.0, 0.0),
                                  iconPadding: const EdgeInsetsDirectional.fromSTEB(
                                      0.0, 0.0, 0.0, 0.0),
                                  color: FlutterFlowTheme.of(context).primary,
                                  textStyle: FlutterFlowTheme.of(context)
                                      .titleSmall
                                      .override(
                                        fontFamily: 'Readex Pro',
                                        color: Colors.white,
                                        letterSpacing: 0.0,
                                      ),
                                  elevation: 3.0,
                                  borderSide: const BorderSide(
                                    color: Colors.transparent,
                                    width: 1.0,
                                  ),
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                              ).animateOnActionTrigger(
                                animationsMap[
                                    'buttonOnActionTriggerAnimation']!,
                              ),
                            ]
                                .divide(const SizedBox(height: 10.0))
                                .around(const SizedBox(height: 10.0)),
                          ).animateOnActionTrigger(
                            animationsMap['columnOnActionTriggerAnimation']!,
                          ),
                      ]
                          .divide(const SizedBox(height: 10.0))
                          .around(const SizedBox(height: 10.0)),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
