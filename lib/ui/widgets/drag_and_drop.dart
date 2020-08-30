import 'package:fdottedline/fdottedline.dart';
import 'package:file_picker_web/file_picker_web.dart';

import 'package:flutter/widgets.dart';
import 'package:flutter_dropzone/flutter_dropzone.dart';
import 'package:file_picker_platform_interface/file_picker_platform_interface.dart';

import 'package:provider/provider.dart';

import '../../generated/l10n.dart';
import '../../models/image_file.dart';
import 'adaptive/browse_button.dart';

class DragAndDrop extends StatefulWidget {
  const DragAndDrop({Key key}) : super(key: key);
  @override
  _DragAndDropState createState() => _DragAndDropState();
}

class _DragAndDropState extends State<DragAndDrop> {
  // ignore: unused_field
  DropzoneViewController _controller;

  bool _highlighted = false;

  // ignore: avoid_annotating_with_dynamic
  Future<bool> _checkUpload(dynamic _uploadedImage) async => await context.read<ImageFile>().checkImage(_uploadedImage);

  @override
  Widget build(BuildContext context) => Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: FDottedLine(
              corner: FDottedLineCorner.all(20),
              color: const Color(0x7C888888),
              child: Container(
                width: 300,
                height: 300,
                color: _highlighted ? const Color(0x0991FF00) : const Color(0x11888888),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    DropzoneView(
                      operation: DragOperation.copy,
                      cursor: CursorType.pointer,
                      // ignore: avoid_annotating_with_dynamic
                      onDrop: _checkUpload,
                      onCreated: (_assignController) => _controller = _assignController,
                      onHover: () => setState(() => _highlighted = true),
                      onLeave: () => setState(() => _highlighted = false),
                      // onLoaded: () => print('Drop zone loaded'),
                      // onError: (_image) => print('Drop zone error: $_image'),
                    ),
                    SizedBox(
                      height: 100,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(S.of(context).dropPNG),
                          BrowseButton(
                              text: S.of(context).browse,
                              onPressed: () async => await FilePicker.getFile(
                                    type: FileType.custom,
                                    allowedExtensions: ['png'],
                                  ).then(_checkUpload).whenComplete(() => null)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      );
}
