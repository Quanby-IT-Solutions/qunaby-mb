import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'page_loader_model.dart';
export 'page_loader_model.dart';

class PageLoaderWidget extends StatefulWidget {
  const PageLoaderWidget({super.key});

  @override
  State<PageLoaderWidget> createState() => _PageLoaderWidgetState();
}

class _PageLoaderWidgetState extends State<PageLoaderWidget> {
  late PageLoaderModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => PageLoaderModel());
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            color: FlutterFlowTheme.of(context).primaryBackground,
          ),
        ),
        Align(
          alignment: const AlignmentDirectional(0.0, 0.0),
          child: Container(
            width: double.infinity,
            height: 100.0,
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.contain,
                alignment: const AlignmentDirectional(0.0, 0.0),
                image: Image.asset(
                  'assets/images/pccc.gif',
                ).image,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
