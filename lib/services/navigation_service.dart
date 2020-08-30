import 'package:flutter/material.dart';

class NavigationService {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  // ignore: avoid_annotating_with_dynamic
  Future<dynamic> navigateTo(String routeName, {dynamic arguments}) =>
      navigatorKey.currentState.pushNamed(routeName, arguments: arguments);

  void goBack() => navigatorKey.currentState.pop();
}
