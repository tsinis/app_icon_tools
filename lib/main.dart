import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import 'locator_dependency_injection.dart';
import 'models/setup_icon.dart';
import 'models/upload_file.dart';
import 'models/user_interface.dart';
import 'services/desktop_window_sizer.dart';
import 'ui/app_appearance.dart';

//TODO Migrate to null-safety when it's become stable and packages are ready.
Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  DesktopWindow.setupSize();
  // ignore: unawaited_futures
  UserInterface.setupUI();
  Locators.setupLocator();

  runApp(MultiProvider(providers: [
    ChangeNotifierProvider<UserInterface>(create: (_) => UserInterface()),
    ChangeNotifierProvider<UploadFile>(create: (_) => UploadFile()),
    ChangeNotifierProxyProvider<UploadFile, SetupIcon>(
      create: (_) => SetupIcon(),
      update: (_, file, icon) => icon
        ..foregroundIssues = file.detectedFgIssues
        ..backgroundIssues = file.detectedBgIssues
        ..iconIssues = file.detectedIconIssues
        ..adaptiveForeground = file.recivedForeground
        ..adaptiveBackground = file.recivedBackground
        ..regularIcon = file.recivedIcon,
    ),
  ], child: const MyApp()));
}
