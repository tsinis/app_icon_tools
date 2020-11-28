import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dropzone/flutter_dropzone.dart';
import 'package:provider/provider.dart';

import '../../constants/files_properties.dart';
import '../../generated/l10n.dart';
import '../../models/upload_file.dart';
import '../../models/user_interface.dart';
import 'adaptive/buttons/button.dart';
import 'success_animated_icon.dart';

// TODO Check when https://github.com/flutter/flutter/issues/30719 is closed.
class DragAndDrop extends StatelessWidget {
  const DragAndDrop({this.background = false, this.foreground = false, Key key}) : super(key: key);

  final bool background, foreground;
  // static DropzoneViewController _controller;
  bool get _isAdaptive => background || foreground;
  static const int _minIconSize = FilesProperties.minIconSize, _minAdaptiveSize = FilesProperties.minAdaptiveSize;

  @override
  Widget build(BuildContext context) {
    final bool isValidFile = context.select((UploadFile upload) => upload.isValidFile) ?? true;
    final bool isLoading = context.select((UploadFile upload) => upload.loading) ?? false;
    final bool isDone = context.select((UploadFile upload) => upload.done) ?? false;

    return DottedBorder(
      borderType: BorderType.RRect,
      padding: EdgeInsets.zero,
      radius: const Radius.circular(20),
      color: const Color(0x7C888888),
      dashPattern: const [10, if (kIsWeb) 6 else 0],
      child: Container(
        width: UserInterface.previewIconSize,
        height: UserInterface.previewIconSize,
        decoration: BoxDecoration(color: const Color(0x11888888), borderRadius: BorderRadius.circular(20)),
        child: (isDone && !_isAdaptive)
            ? const SuccessAnimatedIcon()
            : isLoading
                ? Column(mainAxisAlignment: MainAxisAlignment.center, mainAxisSize: MainAxisSize.min, children: [
                    Padding(
                        // ignore: avoid_redundant_argument_values
                        padding: const EdgeInsets.only(top: !kIsWeb ? 20 : 0),
                        child: SelectableText(S.of(context).verifying, textAlign: TextAlign.center)),
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
                            SelectableText(
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
                                child:
                                    SelectableText(S.of(context).iconAttributes, style: const TextStyle(fontSize: 14))),
                            _DataThemeWorkaround(
                              DataTable(
                                sortAscending: false,
                                showCheckboxColumn: false,
                                headingRowHeight: 0,
                                dataRowHeight: 22,
                                dividerThickness: 0.5,
                                horizontalMargin: 50,
                                columnSpacing: 30,
                                columns: const [DataColumn(label: SizedBox()), DataColumn(label: SizedBox())],
                                rows: <DataRow>[
                                  DataRow(
                                    // onSelectChanged: (_) async =>
                                    //     await context.read<UserInterface>().showGuidelines(),
                                    cells: <DataCell>[
                                      DataCell(_InfoCellText(S.of(context).fileFormat, bold: true)),
                                      DataCell(
                                        SelectableText(FilesProperties.expectedFileExtension.toUpperCase(),
                                            style: const TextStyle(fontWeight: FontWeight.bold)),
                                      )
                                    ],
                                  ),
                                  DataRow(
                                      // onSelectChanged: (_) async =>
                                      //     await context.read<UserInterface>().showGuidelines(),
                                      cells: <DataCell>[
                                        DataCell(_InfoCellText(S.of(context).colorProfile)),
                                        const DataCell(SelectableText('sRGB'))
                                      ]),
                                  DataRow(
                                      onSelectChanged: (_) async =>
                                          await context.read<UserInterface>().showGuidelines(fromGoogle: true),
                                      cells: <DataCell>[
                                        DataCell(_InfoCellText(S.of(context).maxKB)),
                                        DataCell(Tooltip(
                                            message: 'Google Play ${S.of(context).storeRequirement}',
                                            child: const SelectableText('${FilesProperties.maxFileSizeKB}KB')))
                                      ]),
                                  DataRow(
                                      onSelectChanged: (_) async =>
                                          await context.read<UserInterface>().showGuidelines(isAdaptive: _isAdaptive),
                                      cells: <DataCell>[
                                        DataCell(_InfoCellText(S.of(context).imageSize)),
                                        DataCell(Tooltip(
                                            message: (_isAdaptive ? 'Google Play ' : 'App Store ') +
                                                S.of(context).storeRequirement,
                                            child: SelectableText(
                                                _isAdaptive
                                                    ? '$_minAdaptiveSize×$_minAdaptiveSize px'
                                                    : '$_minIconSize×$_minIconSize px',
                                                maxLines: 1)))
                                      ])
                                ],
                              ),
                            ),
                            Tooltip(
                              message: S.of(context).transparencyIOS,
                              child: Opacity(
                                opacity: 0.5,
                                child: SelectableText.rich(
                                  TextSpan(
                                      text: _isAdaptive ? '' : S.of(context).addBackground,
                                      children: [TextSpan(text: '\nPPI ⩾ 72, ${S.of(context).noInterlacing}')]),
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                  style: const TextStyle(fontSize: 11),
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

  final bool bold;
  final String _text;

  @override
  Widget build(BuildContext context) => Opacity(
      opacity: 0.6,
      child:
          SelectableText(_text, maxLines: 1, style: TextStyle(fontWeight: bold ? FontWeight.bold : FontWeight.w300)));
}

//TODO Check when https://github.com/flutter/flutter/issues/19228 is closed.
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
