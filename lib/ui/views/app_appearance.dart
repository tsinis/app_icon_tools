import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../locator.dart';
import '../../models/constants.dart';
import '../../models/user_interface.dart';
import '../../services/navigation_service.dart';
import '../router.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    // print('Whole app rebuild');
    context.watch<UserInterface>().detectUISettings();
    //TODO: Add night/day theme switch.
    final Brightness _brightness = context.select((UserInterface ui) => ui.getTheme);
    final Locale _locale = Locale(context.select((UserInterface ui) => ui.locale));

    return UserInterface.isApple
        ? CupertinoApp(
            //TODO: Add Scaffold background color according to theme.
            navigatorKey: locator<NavigationService>().navigatorKey,
            localizationsDelegates: localizationDelgates,
            supportedLocales: supportedLocales,
            locale: _locale,
            theme: CupertinoThemeData(brightness: _brightness),
            onGenerateRoute: UiRouter.generateRoute,
            initialRoute: UiRouter.initialScreen)
        : MaterialApp(
            navigatorKey: locator<NavigationService>().navigatorKey,
            localizationsDelegates: localizationDelgates,
            supportedLocales: supportedLocales,
            locale: _locale,
            theme: ThemeData(brightness: _brightness),
            onGenerateRoute: UiRouter.generateRoute,
            initialRoute: UiRouter.initialScreen);
  }
}
