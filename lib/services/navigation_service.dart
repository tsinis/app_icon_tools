import 'package:flutter/widgets.dart';

class NavigationService {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  Future navigateTo(String routeName, {Object arguments}) =>
      navigatorKey.currentState.pushReplacementNamed(routeName, arguments: arguments);

  void goBack() => navigatorKey.currentState.pop();
}
