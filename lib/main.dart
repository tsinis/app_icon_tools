import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import 'locator.dart';
import 'models/setup_icon.dart';
import 'models/upload_file.dart';
import 'models/user_interface.dart';
import 'ui/views/app_appearance.dart';

void main() {
  setupLocator();
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider<UserInterface>(create: (_) => UserInterface()),
    ChangeNotifierProvider<UploadFile>(create: (_) => UploadFile()),
    ChangeNotifierProxyProvider<UploadFile, SetupIcon>(
        create: (_) => SetupIcon(),
        update: (_, uploadFile, setupIcon) => setupIcon
          ..adaptiveForeground = uploadFile.recivedForeground
          ..adaptiveBackground = uploadFile.recivedBackground
          ..icon = uploadFile.recivedImage),
  ], child: const MyApp()));
}
