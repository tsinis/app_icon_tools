// import 'dart:io' as io;

import 'package:flutter/widgets.dart';
import 'package:platform_info/platform_info.dart';
import 'package:provider/provider.dart';
import 'package:window_size/window_size.dart';

import 'locator.dart';
import 'models/setup_icon.dart';
import 'models/upload_file.dart';
import 'models/user_interface.dart';
import 'ui/views/app_appearance.dart';

void main() {
  print('This is desktop app: ${platform.isDesktop}');
  if (platform.isDesktop) {
    WidgetsFlutterBinding.ensureInitialized();
    setWindowTitle('Flutter Launcher Icon Preview');
    setWindowMinSize(const Size(320, 800));
  }
  setupLocator();
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider<UserInterface>(create: (_) => UserInterface()),
    ChangeNotifierProvider<UploadFile>(create: (_) => UploadFile()),
    ChangeNotifierProxyProvider<UploadFile, SetupIcon>(
        create: (_) => SetupIcon(),
        update: (_, uploadFile, setupIcon) => setupIcon
          ..adaptiveForeground = uploadFile.recivedForeground
          ..adaptiveBackground = uploadFile.recivedBackground
          ..icon = uploadFile.recivedIcon),
  ], child: const MyApp()));
}
