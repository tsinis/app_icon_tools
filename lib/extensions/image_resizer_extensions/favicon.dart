import 'package:image_resizer/image_resizer.dart';

class FavIcon extends WebIcon {
  const FavIcon({this.favSize = 16, this.favPrefix = 'icons/favicon'}) : super(size: favSize, prefix: favPrefix);

  final String favPrefix;
  final int favSize;

  @override
  String get filename => 'favicon.$ext';
}
