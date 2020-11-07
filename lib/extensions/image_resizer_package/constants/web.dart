import 'package:image_resizer/image_resizer.dart';

import '../web_favicon.dart';

const List<WebIcon> webIcons = [
  FavIcon(), //TODO! Workaround. Remove and create HTML generator for PWA instead.
  WebIcon(size: 192, prefix: 'icons/Icon-'),
  WebIcon(size: 512, prefix: 'icons/Icon-'),
];
