import 'package:flutter/material.dart';

class NavigationService {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  Future<void> navigateTo(String routeName, {dynamic arguments}) =>
      navigatorKey.currentState.pushNamed(routeName, arguments: arguments);

  void goBack() => navigatorKey.currentState.pop();
}
