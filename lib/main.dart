import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import 'locator.dart';
import 'models/upload_file.dart';
import 'services/platform_detector.dart';
import 'ui/views/app_appearance.dart';

void main() {
  setupLocator();
  CurrentPlatform.detect();
  runApp(ChangeNotifierProvider<UploadFile>(create: (_) => UploadFile(), child: const MyApp()));
}
