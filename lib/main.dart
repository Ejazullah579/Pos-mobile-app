import 'dart:async';
import 'package:flutter/services.dart';
import 'package:pro1/app/locator.dart';
import 'package:pro1/app/router.gr.dart' as routers;
import 'package:flutter/material.dart';
import 'package:pro1/models/setup_bottom_sheet_ui.dart';
import 'package:pro1/ui/themes/theme_setup.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:stacked_themes/stacked_themes.dart';
import 'package:firebase_core/firebase_core.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setupLocator();
  setupBottomSheetUi();
  await ThemeManager.initialise();
  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp() {
    scheduleMicrotask(() => SystemChrome.setEnabledSystemUIOverlays([]));
  }

  @override
  Widget build(BuildContext context) {
    return ThemeBuilder(
      themes: getThemes(),
      defaultThemeMode: ThemeMode.light,
      darkTheme: darkTheme(),
      lightTheme: lightTheme(),
      builder: (context, regularTheme, darkTheme, themeMode) => MaterialApp(
        theme: regularTheme,
        darkTheme: darkTheme,
        themeMode: themeMode,
        title: 'BarCode Shop',
        debugShowCheckedModeBanner: false,
        initialRoute: routers.Routes.startupView,
        onGenerateRoute: routers.Router().onGenerateRoute,
        navigatorKey: StackedService.navigatorKey,
      ),
    );
  }
}
