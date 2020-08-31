import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../locator.dart';
import '../../models/constants.dart';
import '../../services/navigation_service.dart';
import '../../services/platform_detector.dart';
import '../router.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) => CurrentPlatform.isApple //TODO: Add night/day theme switch.
      ? CupertinoApp(
          //TODO: Add Scaffold background color according to theme.
          navigatorKey: locator<NavigationService>().navigatorKey,
          localizationsDelegates: localizationDelgates,
          supportedLocales: supportedLocales,
          theme: const CupertinoThemeData(brightness: Brightness.dark),
          onGenerateRoute: UiRouter.generateRoute,
          initialRoute: UiRouter.initialScreen)
      : MaterialApp(
          navigatorKey: locator<NavigationService>().navigatorKey,
          localizationsDelegates: localizationDelgates,
          supportedLocales: supportedLocales,
          theme: ThemeData(brightness: Brightness.dark),
          onGenerateRoute: UiRouter.generateRoute,
          initialRoute: UiRouter.initialScreen);
}
