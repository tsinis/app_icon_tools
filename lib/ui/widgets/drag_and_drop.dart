import 'package:fdottedline/fdottedline.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dropzone/flutter_dropzone.dart';
import 'package:provider/provider.dart';

import '../../generated/l10n.dart';
import '../../models/upload_file.dart';
import '../../models/user_interface.dart';
import 'adaptive/buttons/button.dart';
import 'success_animated_icon.dart';

class DragAndDrop extends StatelessWidget {
  const DragAndDrop({this.background = false, this.foreground = false, Key key}) : super(key: key);

  final bool background, foreground;
  // static DropzoneViewController _controller;

  @override
  Widget build(BuildContext context) {
    final bool isAdaptive = background || foreground;
    final bool isValidFile = context.select((UploadFile upload) => upload.isValidFile) ?? true;
    final bool isLoading = context.select((UploadFile upload) => upload.loading) ?? false;
    final bool isDone = context.select((UploadFile upload) => upload.done) ?? false;
    const int minIconSize = UploadFile.minIconSize;
    const int minAdaptiveSize = UploadFile.minAdaptiveSize;

    return FDottedLine(
      corner: FDottedLineCorner.all(20),
      color: const Color(0x7C888888),
      dottedLength: 10,
      space: kIsWeb ? 6 : 0,
      child: Container(
        width: UserInterface.previewIconSize,
        height: UserInterface.previewIconSize,
        color: const Color(0x11888888),
        child: (isDone && !isAdaptive)
            ? const SuccessAnimatedIcon()
            : isLoading
                ? Column(mainAxisAlignment: MainAxisAlignment.center, mainAxisSize: MainAxisSize.min, children: [
                    Padding(
                        padding: const EdgeInsets.only(top: !kIsWeb ? 20 : 0), child: Text(S.of(context).verifying)),
                    if (!kIsWeb)
                      Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: SizedBox(
                              width: 40,
                              height: 40,
                              child: UserInterface.isCupertino
                                  ? const CupertinoActivityIndicator()
                                  : const CircularProgressIndicator()))
                  ])
                : Stack(
                    alignment: Alignment.center,
                    children: [
                      if (kIsWeb)
                        DropzoneView(
                          operation: DragOperation.copy,
                          cursor: CursorType.pointer,
                          onDrop: (dynamic file) async => await context
                              .read<UploadFile>()
                              .checkDropped(file, background: background, foreground: foreground),
                          // onCreated: (_assignController) => _controller = _assignController,
                          // onHover: () => setState(() => _highlighted = true),
                          // onLeave: () => setState(() => _highlighted = false),
                          // onLoaded: () => print('Drop zone loaded'),
                          // onError: (_image) => print('Drop zone error: $_image'),
                        ),
                      SizedBox(
                        height: 250,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                                isValidFile
                                    ? (kIsWeb ? S.of(context).dragAndDropHere : S.of(context).select)
                                    : S.of(context).wrongFile,
                                maxLines: 1),
                            AdaptiveButton(
                                text: S.of(context).browse,
                                onPressed: () async => await context
                                    .read<UploadFile>()
                                    .checkSelected(background: background, foreground: foreground)),
                            Opacity(
                                opacity: 0.66,
                                child: Text(S.of(context).iconAttributes, style: const TextStyle(fontSize: 14))),
                            _DataThemeWorkaround(
                              DataTable(
                                sortAscending: false,
                                showCheckboxColumn: false,
                                headingRowHeight: 0,
                                dataRowHeight: 22,
                                dividerThickness: 0.5,
                                horizontalMargin: 48,
                                columnSpacing: 40,
                                columns: const [
                                  DataColumn(label: SizedBox.shrink()),
                                  DataColumn(label: SizedBox.shrink())
                                ],
                                rows: <DataRow>[
                                  DataRow(
                                    onSelectChanged: (_) async =>
                                        await context.read<UserInterface>().openGuidelinesURL(),
                                    cells: <DataCell>[
                                      DataCell(_InfoCellText(S.of(context).fileFormat, bold: true)),
                                      DataCell(
                                        Tooltip(
                                            message:
                                                'Google Play & App Store ${S.of(context).storeRequirement}', //TODO Remove irrelevant info.
                                            child: Text(UploadFile.expectedFileExtension.toUpperCase(),
                                                style: const TextStyle(fontWeight: FontWeight.bold))),
                                      )
                                    ],
                                  ),
                                  DataRow(
                                      onSelectChanged: (_) async =>
                                          await context.read<UserInterface>().openGuidelinesURL(),
                                      cells: <DataCell>[
                                        DataCell(_InfoCellText(S.of(context).colorProfile)),
                                        DataCell(Tooltip(
                                            message: 'Google Play & App Store ${S.of(context).storeRequirement}',
                                            child: const Text('sRGB')))
                                      ]),
                                  DataRow(
                                      onSelectChanged: (_) async =>
                                          await context.read<UserInterface>().openGuidelinesURL(fromGoogle: true),
                                      cells: <DataCell>[
                                        DataCell(_InfoCellText(S.of(context).maxKB)),
                                        DataCell(Tooltip(
                                            message: 'Google Play ${S.of(context).storeRequirement}',
                                            child: const Text('1024KB')))
                                      ]),
                                  DataRow(
                                      onSelectChanged: (_) async =>
                                          await context.read<UserInterface>().openGuidelinesURL(isAdaptive: isAdaptive),
                                      cells: <DataCell>[
                                        DataCell(_InfoCellText(S.of(context).imageSize)),
                                        DataCell(Tooltip(
                                            message: (isAdaptive ? 'Google Play ' : 'App Store ') +
                                                S.of(context).storeRequirement,
                                            child: Text(
                                                isAdaptive
                                                    ? '$minAdaptiveSize×$minAdaptiveSize px'
                                                    : '$minIconSize×$minIconSize px',
                                                maxLines: 1)))
                                      ])
                                ],
                              ),
                            ),
                            Tooltip(
                              message: S.of(context).transparencyiOS,
                              child: Opacity(
                                opacity: 0.5,
                                child: Tooltip(
                                  message: S.of(context).transparencyiOS,
                                  child: Text.rich(
                                    TextSpan(
                                        text: 'PPI ⩾ 72, ${S.of(context).noInterlacing}\n',
                                        children: [TextSpan(text: isAdaptive ? '' : S.of(context).addBackground)]),
                                    textAlign: TextAlign.center,
                                    maxLines: 2,
                                    style: const TextStyle(fontSize: 11),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
      ),
    );
  }
}

class _InfoCellText extends StatelessWidget {
  const _InfoCellText(this._text, {Key key, this.bold = false}) : super(key: key);
  final String _text;
  final bool bold;

  @override
  Widget build(BuildContext context) => Opacity(
      opacity: 0.5,
      child: Text(_text, maxLines: 1, style: TextStyle(fontWeight: bold ? FontWeight.bold : FontWeight.w300)));
}

//TODO: Check when https://github.com/flutter/flutter/issues/19228 is closed.
class _DataThemeWorkaround extends StatelessWidget {
  const _DataThemeWorkaround(this._child, {Key key}) : super(key: key);
  final Widget _child;

  @override
  Widget build(BuildContext context) => UserInterface.isCupertino
      ? Material(
          type: MaterialType.transparency,
          child: Theme(data: context.select((UserInterface ui) => ui.materialTheme), child: _child))
      : SizedBox(child: _child);
}
