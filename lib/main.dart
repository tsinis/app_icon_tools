import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import 'locator.dart';
import 'models/image_file.dart';
import 'services/platform_detector.dart';
import 'ui/views/app_appearance.dart';

void main() {
  setupLocator();
  CurrentPlatform.detect();
  runApp(ChangeNotifierProvider<ImageFile>(create: (_) => ImageFile(), child: const MyApp()));
}
