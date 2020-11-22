import 'package:flutter/widgets.dart';

class NavigationService {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  Future navigateTo(String routeName) => navigatorKey.currentState.pushReplacementNamed(routeName);

  void goBack() => navigatorKey.currentState.pop();
}
