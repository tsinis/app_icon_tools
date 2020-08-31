// ignore: avoid_web_libraries_in_flutter
import 'dart:html';

import 'package:fdottedline/fdottedline.dart';
import 'package:file_picker_platform_interface/file_picker_platform_interface.dart';
import 'package:file_picker_web/file_picker_web.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_dropzone/flutter_dropzone.dart';
import 'package:provider/provider.dart';

import '../../generated/l10n.dart';
import '../../models/upload_file.dart';
import 'adaptive/browse_button.dart';

// ignore: unused_element
DropzoneViewController _controller;
Widget image = const SizedBox(width: 1, height: 1);

class DragAndDrop extends StatelessWidget {
  // bool _highlighted = false;

  // Future<bool> _checkUpload(dynamic _uploadedImage, BuildContext context) async =>
  //     await context.read<UploadFile>().checkImage(_uploadedImage);

  @override
  Widget build(BuildContext context) => FDottedLine(
        corner: FDottedLineCorner.all(20),
        color: const Color(0x7C888888),
        child: Container(
          width: 300,
          height: 300,
          color:
              //  _highlighted ? const Color(0x0991FF00) :
              const Color(0x11888888),
          child: Stack(
            alignment: Alignment.center,
            children: [
              DropzoneView(
                operation: DragOperation.copy,
                cursor: CursorType.pointer,
                onDrop: (dynamic _file) async => await context.read<UploadFile>().checkImage(_file),
                onCreated: (_assignController) => _controller = _assignController,
                // onHover: () => setState(() => _highlighted = true),
                // onLeave: () => setState(() => _highlighted = false),
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
                        onPressed: () async =>
                            await FilePicker.getFile(type: FileType.custom, allowedExtensions: ['png'])
                                .then((dynamic _file) async => await context.read<UploadFile>().checkImage(_file))),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
}
