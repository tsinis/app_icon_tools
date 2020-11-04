import 'package:auto_size_text/auto_size_text.dart';
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

class DragAndDrop extends StatelessWidget {
  const DragAndDrop({this.background = false, this.foreground = false, Key key}) : super(key: key);

  final bool background, foreground;

  // static DropzoneViewController _controller;

  @override
  Widget build(BuildContext context) {
    final bool _isAdaptive = background || foreground;
    final bool _isValidFile = context.select((UploadFile upload) => upload.isValidFile);
    final bool _loading = context.select((UploadFile upload) => upload.loading);
    const int _minIconSize = UploadFile.minIconSize;
    const int _minAdaptiveSize = UploadFile.minAdaptiveSize;
    return FDottedLine(
      corner: FDottedLineCorner.all(20),
      color: const Color(0x7C888888),
      space: kIsWeb ? 3 : 0,
      child: Container(
        width: UserInterface.previewIconSize,
        height: UserInterface.previewIconSize,
        color: const Color(0x11888888),
        child: _loading
            ? Center(child: Text(S.of(context).verifying, textAlign: TextAlign.center))
            : Stack(
                alignment: Alignment.center,
                children: [
                  if (kIsWeb) //TODO Check latest working version of drag and drop in Chrome.
                    DropzoneView(
                      operation: DragOperation.copy,
                      cursor: CursorType.pointer,
                      onDrop: (dynamic _file) async => await context
                          .read<UploadFile>()
                          .checkDropped(_file, background: background, foreground: foreground),
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
                        AutoSizeText(_isValidFile ? S.of(context).dragAndDropHere : S.of(context).wrongFile,
                            maxLines: 1, minFontSize: 17),
                        AdaptiveButton(
                            text: S.of(context).browse,
                            onPressed: () async => await context
                                .read<UploadFile>()
                                .checkSelected(background: background, foreground: foreground)),
                        Opacity(
                            opacity: 0.66,
                            child: Text(S.of(context).iconAttributes, style: const TextStyle(fontSize: 14))),
                        _DataThemeWorkaround(
                          child: DataTable(
                            sortAscending: false,
                            showCheckboxColumn: false,
                            headingRowHeight: 0,
                            dataRowHeight: 22,
                            dividerThickness: 0.5,
                            horizontalMargin: 48,
                            columnSpacing: 40,
                            columns: const [DataColumn(label: SizedBox.shrink()), DataColumn(label: SizedBox.shrink())],
                            rows: <DataRow>[
                              DataRow(
                                onSelectChanged: (_) async => await context.read<UserInterface>().openGuidelinesURL(),
                                cells: <DataCell>[
                                  DataCell(_InfoCellText(S.of(context).fileFormat)),
                                  DataCell(
                                    Tooltip(
                                      message: 'Google Play & App Store ${S.of(context).storeRequirement}',
                                      child: Text(UploadFile.expectedFileExtension.toUpperCase()),
                                    ),
                                  )
                                ],
                              ),
                              DataRow(
                                  onSelectChanged: (_) async => await context.read<UserInterface>().openGuidelinesURL(),
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
                                      await context.read<UserInterface>().openGuidelinesURL(isAdaptive: _isAdaptive),
                                  cells: <DataCell>[
                                    DataCell(_InfoCellText(S.of(context).imageSize)),
                                    DataCell(Tooltip(
                                        message: (_isAdaptive ? 'Google Play' : 'App Store') +
                                            S.of(context).storeRequirement,
                                        child: Text(_isAdaptive
                                            ? '$_minAdaptiveSize×$_minAdaptiveSize px'
                                            : '$_minIconSize×$_minIconSize px')))
                                  ])
                            ],
                          ),
                        ),
                        Tooltip(
                          message: S.of(context).transparencyiOS,
                          child: Opacity(
                            opacity: 0.5,
                            child: AutoSizeText.rich(
                              TextSpan(
                                  text: 'PPI ⩾ 72, ${S.of(context).noInterlacing}\n',
                                  children: [TextSpan(text: S.of(context).addBackground)]),
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              style: const TextStyle(fontSize: 10),
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
  const _InfoCellText(this._text, {Key key}) : super(key: key);
  final String _text;
  @override
  Widget build(BuildContext context) => Opacity(opacity: 0.5, child: Text(_text, maxLines: 1));
}

//TODO: Check when https://github.com/flutter/flutter/issues/19228 is closed.
class _DataThemeWorkaround extends StatelessWidget {
  const _DataThemeWorkaround({@required this.child, Key key}) : super(key: key);
  final Widget child;
  @override
  Widget build(BuildContext context) {
    final ThemeData _materialTheme = context.select((UserInterface ui) => ui.materialTheme);
    return UserInterface.isApple
        ? Material(type: MaterialType.transparency, child: Theme(data: _materialTheme, child: child))
        : SizedBox(child: child);
  }
}
