// ignore: avoid_web_libraries_in_flutter
import 'dart:html';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:fdottedline/fdottedline.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_dropzone/flutter_dropzone.dart';
import 'package:provider/provider.dart';

import '../../generated/l10n.dart';
import '../../models/upload_file.dart';
import '../../models/user_interface.dart';
import 'adaptive/browse_button.dart';

class DragAndDrop extends StatelessWidget {
  const DragAndDrop({this.showIconReq = true, Key key}) : super(key: key);
  final bool showIconReq;
  // static DropzoneViewController _controller;
  @override
  Widget build(BuildContext context) {
    // ignore: avoid_types_on_closure_parameters
    final bool _isProperFile = context.select((UploadFile _upload) => _upload.isProperFile);
    return FDottedLine(
      corner: FDottedLineCorner.all(20),
      color: const Color(0x7C888888),
      child: Container(
        width: 300,
        height: 300,
        color: const Color(0x11888888), //TODO: Replace with a Rive animation, maybe.
        child: Stack(
          alignment: Alignment.center,
          children: [
            DropzoneView(
              operation: DragOperation.copy,
              cursor: CursorType.pointer,
              onDrop: (dynamic _file) async => await context.read<UploadFile>().checkDropped(_file),
              // onCreated: (_assignController) => _controller = _assignController,
              // onHover: () => setState(() => _highlighted = true),
              // onLeave: () => setState(() => _highlighted = false),
              // onLoaded: () => print('Drop zone loaded'),
              // onError: (_image) => print('Drop zone error: $_image'),
            ),
            SizedBox(
              height: 250,
              child: Column(
                mainAxisAlignment: showIconReq ? MainAxisAlignment.spaceBetween : MainAxisAlignment.center,
                children: [
                  AutoSizeText(_isProperFile ? S.of(context).dragAndDropHere : S.of(context).wrongFile,
                      maxLines: 1, minFontSize: 17),
                  BrowseButton(
                      text: S.of(context).browse,
                      onPressed: () async => await context.read<UploadFile>().checkSelected()),
                  if (showIconReq) ...[
                    Opacity(
                        opacity: 0.66, child: Text(S.of(context).iconAttributes, style: const TextStyle(fontSize: 14))),
                    Material(
                      type: MaterialType.transparency,
                      //TODO: Fix font color on Cupertino dark theme.
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
                              DataCell(InfoCellText(S.of(context).fileFormat)),
                              DataCell(
                                Tooltip(
                                  message: 'Google Play & App Store ${S.of(context).storeRequirement}',
                                  child: const Text('PNG'),
                                ),
                              )
                            ],
                          ),
                          DataRow(
                              onSelectChanged: (_) async => await context.read<UserInterface>().openGuidelinesURL(),
                              cells: <DataCell>[
                                DataCell(InfoCellText(S.of(context).colorProfile)),
                                DataCell(Tooltip(
                                    message: 'Google Play & App Store ${S.of(context).storeRequirement}',
                                    child: const Text('sRGB')))
                              ]),
                          DataRow(
                              onSelectChanged: (_) async =>
                                  await context.read<UserInterface>().openGuidelinesURL(fromGoogle: true),
                              cells: <DataCell>[
                                DataCell(InfoCellText(S.of(context).maxKB)),
                                DataCell(Tooltip(
                                    message: 'Google Play ${S.of(context).storeRequirement}',
                                    child: const Text('1024KB')))
                              ]),
                          DataRow(
                              onSelectChanged: (_) async => await context.read<UserInterface>().openGuidelinesURL(),
                              cells: <DataCell>[
                                DataCell(InfoCellText(S.of(context).imageSize)),
                                DataCell(Tooltip(
                                    message: 'App Store ${S.of(context).storeRequirement}',
                                    child: const Text('1024×1024 px')))
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class InfoCellText extends StatelessWidget {
  const InfoCellText(this._text, {Key key}) : super(key: key);
  final String _text;
  @override
  Widget build(BuildContext context) => Opacity(
      opacity: 0.5,
      child: Text(
        _text,
        maxLines: 1,
        // style: TextStyle(color: Theme.of(context).textTheme.bodyText1.color),
      ));
}
