import 'package:community_material_icon/community_material_icon.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../constants/default_non_null_values.dart';
import '../../../../generated/l10n.dart';
import '../../../../models/setup_icon.dart';
import '../../../../models/user_interface.dart';
import '../../../widgets/adaptive/buttons/button.dart';
import '../../../widgets/adaptive/buttons/icon_button.dart';
import '../../../widgets/adaptive/slider.dart';
import '../../../widgets/drag_and_drop.dart';
import '../../../widgets/icons/apdative_icon.dart';
import '../../../widgets/icons/regular_icon.dart';

class PreviewSection extends StatelessWidget {
  const PreviewSection({
    @required bool canChangeShape,
    @required bool isAdaptive,
    @required bool supportTransparency,
    @required bool haveAdaptiveBg,
    @required bool pwaIcon,
    @required double staticCornerRadius,
    Key key,
  })  : _staticCornerRadius = staticCornerRadius,
        _haveAdaptiveBg = haveAdaptiveBg,
        _supportTransparency = supportTransparency,
        _isAdaptive = isAdaptive,
        _canChangeShape = canChangeShape,
        _pwaIcon = pwaIcon,
        super(key: key);

  final bool _canChangeShape, _isAdaptive, _supportTransparency, _haveAdaptiveBg, _pwaIcon;
  final double _staticCornerRadius;
  static const double _previewSize = UserInterface.previewIconSize;

  @override
  Widget build(BuildContext context) {
    final double adjustableRadius = context.select((SetupIcon icon) => icon.cornerRadius);
    final bool haveAdaptiveFg = context.select((SetupIcon icon) => icon.haveAdaptiveForeground);
    final bool haveAdaptiveAssets = _haveAdaptiveBg && haveAdaptiveFg;

    return SizedBox(
      width: _previewSize,
      height: 550,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: SelectableText(_canChangeShape
                  ? (_isAdaptive
                      ? S.of(context).uploadAdaptiveFg
                      : (_pwaIcon ? S.of(context).maskable : S.of(context).previewShapes))
                  : S.of(context).iconPreview)),
          if (!haveAdaptiveFg && _isAdaptive)
            _haveAdaptiveBg
                ? Stack(children: [
                    Container(
                        clipBehavior: Clip.antiAlias,
                        height: _previewSize,
                        width: _previewSize,
                        decoration: const BoxDecoration(
                            color: Colors.grey, borderRadius: BorderRadius.all(Radius.circular(20))),
                        child: const Opacity(opacity: 0.5, child: AdaptiveIcon())),
                    const DragAndDrop(foreground: true)
                  ])
                : const DragAndDrop(foreground: true)
          else
            GestureDetector(
              onTap: () => context.read<SetupIcon>().devicePreview(),
              child: Container(
                clipBehavior: Clip.antiAlias,
                height: _previewSize,
                width: _previewSize,
                decoration: BoxDecoration(
                    boxShadow: const [
                      BoxShadow(color: Colors.black12, spreadRadius: 2, blurRadius: 4, offset: Offset(0, 2))
                    ],
                    borderRadius:
                        BorderRadius.all(Radius.circular(_canChangeShape ? adjustableRadius : _staticCornerRadius))),
                child: _isAdaptive
                    ? const Hero(tag: 'adaptive', child: AdaptiveIcon())
                    : Hero(
                        tag: 'regular',
                        child: RegularIcon(
                            supportTransparency: _supportTransparency, cornerRadius: NullSafeValues.deviceShape)),
              ),
            ),
          if (_canChangeShape)
            SizedBox(
              width: 292,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Icon(CommunityMaterialIcons.square_outline, color: Color(0x80808080)),
                  AdaptiveSlider(
                      radius: adjustableRadius,
                      // label: adjustableRadius.round().toString(),
                      onChanged: (newRadius) => context.read<SetupIcon>().setRadius(newRadius)),
                  const Icon(CommunityMaterialIcons.circle_outline, color: Color(0x80808080)),
                ],
              ),
            )
          else
            const SizedBox(height: 48),
          ...[
            AdaptiveButton(
                isDisabled: !(!_isAdaptive || (_isAdaptive && haveAdaptiveAssets)),
                text: S.of(context).devicePreview,
                onPressed: () => context.read<SetupIcon>().devicePreview()),
            if (_isAdaptive) AdaptiveIconButtons(withAdaptives: haveAdaptiveAssets),
            // else
            // SizedBox(height: isPortrait ? 0 : 20),
            // if (_isAdaptive) const SizedBox(height: 44) else const SizedBox(height: 64),
            if (_isAdaptive && haveAdaptiveFg)
              AdaptiveButton(
                  text: S.of(context).removeForeground,
                  isDestructive: true,
                  onPressed: () => context.read<SetupIcon>().removeadaptiveForeground()),
          ]
        ],
      ),
    );
  }
}
