// ignore: avoid_web_libraries_in_flutter
import 'dart:html';

import 'package:fdottedline/fdottedline.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_dropzone/flutter_dropzone.dart';
import 'package:provider/provider.dart';

import '../../generated/l10n.dart';
import '../../models/upload_file.dart';
import 'adaptive/browse_button.dart';

class DragAndDrop extends StatelessWidget {
  // static DropzoneViewController _controller;
  @override
  Widget build(BuildContext context) => FDottedLine(
        corner: FDottedLineCorner.all(20),
        color: const Color(0x7C888888),
        child: Container(
          width: 300,
          height: 300,
          color: const Color(0x11888888), //TODO: Replace with a Rive animation.
          child: Stack(
            alignment: Alignment.center,
            children: [
              DropzoneView(
                operation: DragOperation.copy,
                cursor: CursorType.pointer,
                onDrop: (dynamic _file) async => await context.read<UploadFile>().checkDropped(_file as File),
                // onCreated: (_assignController) => _controller = _assignController,
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
                    Text(context.watch<UploadFile>().isProperFile
                        ? S.of(context).dragAndDropHere
                        : S.of(context).wrongFile),
                    BrowseButton(
                        text: S.of(context).browse,
                        onPressed: () async => await context.read<UploadFile>().checkSelected()),
                    // TODO: Add info text here.
                  ],
                ),
              ),
            ],
          ),
        ),
      );
}
