import 'package:flutter/widgets.dart';

class NavigationService {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
//TODO Add ability to move back from setup screen to upload screen directly after coming back from device screen.
  Future<void> navigateTo(String routeName, {dynamic arguments}) =>
      navigatorKey.currentState.pushNamed(routeName, arguments: arguments);

  void goBack() => navigatorKey.currentState.pop();
}
