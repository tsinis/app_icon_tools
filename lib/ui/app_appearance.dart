import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants/locales.dart';
import '../locator_dependency_injection.dart';
import '../models/user_interface.dart';
import '../services/navigation_service.dart';
import '../services/router.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Locale locale = Locale(context.select((UserInterface ui) => ui.locale));

    return UserInterface.isCupertino
        ? CupertinoApp(
            navigatorKey: locator<NavigationService>().navigatorKey,
            localizationsDelegates: localizationDelgates,
            supportedLocales: supportedLocales,
            locale: locale,
            theme: context.select((UserInterface ui) => ui.cupertinoTheme),
            onGenerateRoute: UiRouter.generateRoute,
            initialRoute: UiRouter.initialScreen)
        : MaterialApp(
            navigatorKey: locator<NavigationService>().navigatorKey,
            localizationsDelegates: localizationDelgates,
            supportedLocales: supportedLocales,
            locale: locale,
            theme: context.select((UserInterface ui) => ui.materialTheme),
            onGenerateRoute: UiRouter.generateRoute,
            initialRoute: UiRouter.initialScreen);
  }
}
