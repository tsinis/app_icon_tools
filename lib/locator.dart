import 'package:get_it/get_it.dart';

import 'services/navigation_service.dart';

GetIt locator = GetIt.instance;

class Locators {
  static void setupLocator() => locator.registerLazySingleton(() => NavigationService());
}
