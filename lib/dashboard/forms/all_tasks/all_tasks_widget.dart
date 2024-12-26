import '/auth/supabase_auth/auth_util.dart';
import '/backend/sqlite/sqlite_manager.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/utils/components/connectivity/connectivity_widget.dart';
import '/utils/components/page_loader/page_loader_widget.dart';
import '/custom_code/actions/index.dart' as actions;
import '/custom_code/widgets/index.dart' as custom_widgets;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'all_tasks_model.dart';
export 'all_tasks_model.dart';

class AllTasksWidget extends StatefulWidget {
  const AllTasksWidget({
    super.key,
    String? taskStatus,
  }) : taskStatus = taskStatus ?? 'taskStatus';

  final String taskStatus;

  @override
  State<AllTasksWidget> createState() => _AllTasksWidgetState();
}

class _AllTasksWidgetState extends State<AllTasksWidget> {
  late AllTasksModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => AllTasksModel());

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      if (FFAppState().ONLINE) {
        _model.isDirtyCounterr = await actions.isDirtyCount();
        _model.statusOutput = _model.isDirtyCounterr != '0'
            ? 'Tap to update'
            : 'Tasks are updated';
        safeSetState(() {});
        if (_model.isDirtyCounterr != '0') {
          _model.statusOutput = 'Syncing...';
          _model.isSyncDone = false;
          safeSetState(() {});
          _model.outputMsg = await actions.syncOnlineTaskAndPpirToOffline();
          _model.statusOutput = 'Tasks are updated';
          _model.isSyncDone = true;
          safeSetState(() {});
        }
      }
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

    return FutureBuilder<List<SELECTPPIRFormsByAssigneeAndTaskStatusRow>>(
      future: SQLiteManager.instance.sELECTPPIRFormsByAssigneeAndTaskStatus(
        assignee: currentUserUid,
        status: widget.taskStatus,
      ),
      builder: (context, snapshot) {
        // Customize what your widget looks like when it's loading.
        if (!snapshot.hasData) {
          return Scaffold(
            backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
            body: const Center(
              child: SizedBox(
                width: 100.0,
                height: 100.0,
                child: PageLoaderWidget(),
              ),
            ),
          );
        }
        final allTasksSELECTPPIRFormsByAssigneeAndTaskStatusRowList =
            snapshot.data!;

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
              appBar: AppBar(
                backgroundColor: FlutterFlowTheme.of(context).primary,
                automaticallyImplyLeading: false,
                leading: FlutterFlowIconButton(
                  borderColor: Colors.transparent,
                  borderRadius: 30.0,
                  borderWidth: 1.0,
                  buttonSize: 60.0,
                  icon: Icon(
                    Icons.chevron_left,
                    color: FlutterFlowTheme.of(context).info,
                    size: 20.0,
                  ),
                  onPressed: () async {
                    context.goNamed('dashboard');
                  },
                ),
                title: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(4.0, 0.0, 0.0, 0.0),
                      child: Text(
                        () {
                          if (widget.taskStatus == 'for dispatch') {
                            return 'For Dispatch Tasks';
                          } else if (widget.taskStatus == 'ongoing') {
                            return 'Ongoing Tasks';
                          } else {
                            return 'Completed Tasks';
                          }
                        }(),
                        style: FlutterFlowTheme.of(context).titleSmall.override(
                              fontFamily: 'Readex Pro',
                              color: FlutterFlowTheme.of(context).info,
                              letterSpacing: 0.0,
                            ),
                      ),
                    ),
                    Container(
                      decoration: const BoxDecoration(),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                0.0, 0.0, 5.0, 0.0),
                            child: Container(
                              decoration: const BoxDecoration(),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  if (FFAppState().ONLINE)
                                    InkWell(
                                      splashColor: Colors.transparent,
                                      focusColor: Colors.transparent,
                                      hoverColor: Colors.transparent,
                                      highlightColor: Colors.transparent,
                                      onTap: () async {
                                        if (FFAppState().ONLINE) {
                                          _model.statusOutput = 'Syncing...';
                                          _model.isSyncDone = false;
                                          safeSetState(() {});
                                          _model.message = await actions
                                              .syncOnlineTaskAndPpirToOffline();
                                          _model.statusOutput =
                                              'Tasks are updated';
                                          _model.isSyncDone = true;
                                          safeSetState(() {});
                                        }

                                        safeSetState(() {});
                                      },
                                      child: Text(
                                        '[ ${_model.statusOutput} ]',
                                        style: FlutterFlowTheme.of(context)
                                            .titleSmall
                                            .override(
                                              fontFamily: 'Readex Pro',
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .info,
                                              fontSize: 12.0,
                                              letterSpacing: 0.0,
                                              fontWeight: FontWeight.w600,
                                            ),
                                      ),
                                    ),
                                  if (!FFAppState().ONLINE)
                                    Text(
                                      '[ No internet for sync ]',
                                      style: FlutterFlowTheme.of(context)
                                          .titleSmall
                                          .override(
                                            fontFamily: 'Readex Pro',
                                            color: FlutterFlowTheme.of(context)
                                                .error,
                                            fontSize: 12.0,
                                            letterSpacing: 0.0,
                                            fontWeight: FontWeight.w600,
                                          ),
                                    ),
                                ].divide(const SizedBox(width: 5.0)),
                              ),
                            ),
                          ),
                          wrapWithModel(
                            model: _model.connectivityModel,
                            updateCallback: () => safeSetState(() {}),
                            child: const ConnectivityWidget(),
                          ),
                        ].divide(const SizedBox(width: 5.0)),
                      ),
                    ),
                  ],
                ),
                actions: const [],
                centerTitle: false,
                elevation: 0.0,
              ),
              body: SafeArea(
                top: true,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: Container(
                          width: 0.0,
                          height: MediaQuery.sizeOf(context).height * 1.0,
                          constraints: BoxConstraints(
                            minWidth: MediaQuery.sizeOf(context).width * 1.0,
                            minHeight: MediaQuery.sizeOf(context).height * 1.0,
                          ),
                          decoration: BoxDecoration(
                            color:
                                FlutterFlowTheme.of(context).primaryBackground,
                            borderRadius: BorderRadius.circular(0.0),
                          ),
                          child: SizedBox(
                            width: MediaQuery.sizeOf(context).width * 1.0,
                            height: MediaQuery.sizeOf(context).height * 1.0,
                            child: custom_widgets.AllDataView(
                              width: MediaQuery.sizeOf(context).width * 1.0,
                              height: MediaQuery.sizeOf(context).height * 1.0,
                              data:
                                  allTasksSELECTPPIRFormsByAssigneeAndTaskStatusRowList
                                      .where(
                                          (e) => e.status == widget.taskStatus)
                                      .toList(),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ].divide(const SizedBox(height: 0.0)).around(const SizedBox(height: 0.0)),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
