import 'package:flutter/widgets.dart';

class NavigationService {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  Future navigateTo(String routeName, {dynamic arguments}) => //TODO Object instead of dynamic?
      navigatorKey.currentState.pushReplacementNamed(routeName, arguments: arguments);

  void goBack() => navigatorKey.currentState.pop();
}
