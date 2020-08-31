import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../generated/l10n.dart';
import '../../locator.dart';
import '../../models/constants.dart';
import '../../services/navigation_service.dart';
import '../../services/platform_detector.dart';
import '../router.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    if (CurrentPlatform.isApple) {
      return CupertinoApp(
          navigatorKey: locator<NavigationService>().navigatorKey,
          localizationsDelegates: localizationDelgates,
          supportedLocales: S.delegate.supportedLocales,
          theme: const CupertinoThemeData(brightness: Brightness.dark),
          onGenerateRoute: UiRouter.generateRoute,
          initialRoute: UiRouter.initialRoute);
    } else {
      return MaterialApp(
          navigatorKey: locator<NavigationService>().navigatorKey,
          localizationsDelegates: localizationDelgates,
          supportedLocales: S.delegate.supportedLocales,
          theme: ThemeData(brightness: Brightness.dark),
          onGenerateRoute: UiRouter.generateRoute,
          initialRoute: UiRouter.initialRoute);
    }
  }
}
