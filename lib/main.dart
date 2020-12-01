import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import 'locator_di.dart';
import 'models/setup_icon.dart';
import 'models/upload_file.dart';
import 'models/user_interface.dart';
import 'services/desktop_window_sizer.dart';
import 'ui/app_appearance.dart';

// Packages are not ready for null-safety yet. Run as:
// flutter run --no-sound-null-safety

//TODO! Investigate why the PWA online can't display SVGs, while locally everything works correctly.

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  DesktopWindow.setupSize();
  Locators.setupLocator();
  UserInterface.setupUI().whenComplete(
    () => runApp(MultiProvider(providers: [
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
    ], child: const MyApp())),
  );
}

//TODO Migrate to null-safety when it's become stable and packages are ready,
// https://github.com/dart-lang/intl_translation/issues/118 is critical to close.
