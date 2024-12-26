import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'connectivity_model.dart';
export 'connectivity_model.dart';

class ConnectivityWidget extends StatefulWidget {
  const ConnectivityWidget({super.key});

  @override
  State<ConnectivityWidget> createState() => _ConnectivityWidgetState();
}

class _ConnectivityWidgetState extends State<ConnectivityWidget>
    with TickerProviderStateMixin {
  late ConnectivityModel _model;

  final animationsMap = <String, AnimationInfo>{};

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ConnectivityModel());

    animationsMap.addAll({
      'containerOnPageLoadAnimation': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          ShakeEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 1000.0.ms,
            hz: 10,
            offset: const Offset(0.0, 0.0),
            rotation: 0.087,
          ),
        ],
      ),
    });
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

    return Material(
      color: Colors.transparent,
      elevation: 1.0,
      shape: const CircleBorder(),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeInOutQuint,
        width: 30.0,
        height: 30.0,
        decoration: BoxDecoration(
          color: FlutterFlowTheme.of(context).info,
          boxShadow: const [
            BoxShadow(
              blurRadius: 4.0,
              color: Color(0x33000000),
              offset: Offset(
                0.0,
                2.0,
              ),
            )
          ],
          shape: BoxShape.circle,
          border: Border.all(
            color: FFAppState().ONLINE
                ? FlutterFlowTheme.of(context).success
                : FlutterFlowTheme.of(context).warning,
            width: 0.5,
          ),
        ),
        child: Stack(
          children: [
            if (FFAppState().ONLINE)
              Align(
                alignment: const AlignmentDirectional(0.0, 0.0),
                child: Icon(
                  Icons.wifi,
                  color: FlutterFlowTheme.of(context).primary,
                  size: 24.0,
                ),
              ),
            if (!FFAppState().ONLINE)
              Align(
                alignment: const AlignmentDirectional(0.0, 0.0),
                child: Icon(
                  Icons.wifi_off,
                  color: FlutterFlowTheme.of(context).error,
                  size: 24.0,
                ),
              ),
          ],
        ),
      ),
    ).animateOnPageLoad(animationsMap['containerOnPageLoadAnimation']!);
  }
}
