import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:quanby_geotagging/flutter_flow/flutter_flow_drop_down.dart';
import 'package:quanby_geotagging/flutter_flow/flutter_flow_icon_button.dart';
import 'package:quanby_geotagging/flutter_flow/flutter_flow_radio_button.dart';
import 'package:quanby_geotagging/flutter_flow/flutter_flow_widgets.dart';
import 'package:quanby_geotagging/flutter_flow/flutter_flow_theme.dart';
import 'package:quanby_geotagging/index.dart';
import 'package:quanby_geotagging/main.dart';
import 'package:quanby_geotagging/flutter_flow/flutter_flow_util.dart';

import 'package:provider/provider.dart';

import 'package:quanby_geotagging/backend/supabase/supabase.dart';
import 'package:quanby_geotagging/auth/supabase_auth/auth_util.dart';

import 'package:quanby_geotagging/backend/supabase/supabase.dart';
import 'package:quanby_geotagging/backend/sqlite/sqlite_manager.dart';

void main() async {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    await SupaFlow.initialize();

    await SQLiteManager.initialize();
    await FlutterFlowTheme.initialize();

    await FFLocalizations.initialize();
  });

  setUp(() async {
    await authManager.signOut();
    FFAppState.reset();
    final appState = FFAppState();
    await appState.initializePersistedState();
  });

  testWidgets('Login', (WidgetTester tester) async {
    _overrideOnError();

    await tester.pumpWidget(ChangeNotifierProvider(
      create: (context) => FFAppState(),
      child: MyApp(
        entryPage: LoginWidget(
          routeName: FFLocalizations.of(context).getText(
            'fybxjr1q' /* login */,
          ),
        ),
      ),
    ));

    await tester.enterText(
        find.byKey(ValueKey('emailField_vg1w')), 'sean@gmail.com');
    FocusManager.instance.primaryFocus?.unfocus();
    await tester.enterText(
        find.byKey(ValueKey('passwordField_5h9n')), 'password');
    FocusManager.instance.primaryFocus?.unfocus();
    await tester.tap(find.byKey(ValueKey('loginButton_f3dh')));
    await tester.pumpAndSettle(Duration(milliseconds: 5000));
    expect(find.byKey(ValueKey('Column_d3zz')), findsOneWidget);
  });
}

// There are certain types of errors that can happen during tests but
// should not break the test.
void _overrideOnError() {
  final originalOnError = FlutterError.onError!;
  FlutterError.onError = (errorDetails) {
    if (_shouldIgnoreError(errorDetails.toString())) {
      return;
    }
    originalOnError(errorDetails);
  };
}

bool _shouldIgnoreError(String error) {
  // It can fail to decode some SVGs - this should not break the test.
  if (error.contains('ImageCodecException')) {
    return true;
  }
  // Overflows happen all over the place,
  // but they should not break tests.
  if (error.contains('overflowed by')) {
    return true;
  }
  // Sometimes some images fail to load, it generally does not break the test.
  if (error.contains('No host specified in URI') ||
      error.contains('EXCEPTION CAUGHT BY IMAGE RESOURCE SERVICE')) {
    return true;
  }
  // These errors should be avoided, but they should not break the test.
  if (error.contains('setState() called after dispose()')) {
    return true;
  }

  return false;
}
