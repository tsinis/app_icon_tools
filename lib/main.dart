import 'package:desktop_window/desktop_window.dart';
import 'package:flutter/widgets.dart';
import 'package:platform_info/platform_info.dart';
import 'package:provider/provider.dart';

import 'locator.dart';
import 'models/setup_icon.dart';
import 'models/upload_file.dart';
import 'models/user_interface.dart';
import 'ui/app_appearance.dart';

//TODO Add accesibility and semantic labels.
//TODO Migrate to null-safety when it's become stable.
// TODO Make proper folder organization.
Future main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (!platform.isWeb && platform.isDesktop) {
    //TODO Return Flutter Team version of it's plugin.
    await DesktopWindow.setMinWindowSize(const Size(320, 840));
    await DesktopWindow.setWindowSize(const Size(420, 840));
  }

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
