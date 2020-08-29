import 'package:fdottedline/fdottedline.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_dropzone/flutter_dropzone.dart';

import '../app_appearance.dart';

class DragAndDrop extends StatefulWidget {
  @override
  _DragAndDropState createState() => _DragAndDropState();
}

class _DragAndDropState extends State<DragAndDrop> {
  // ignore: unused_field
  DropzoneViewController _controller;

  String _message = 'Drop your PNG here or';

  bool _highlighted = false;

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
                      onDrop: (dynamic _file) => setState(() => _message = '${_file.name} dropped'),
                      onCreated: (_assignController) => _controller = _assignController,
                      onHover: () => setState(() => _highlighted = true),
                      onLeave: () => setState(() => _highlighted = false),
                      // onLoaded: () => print('Drop zone loaded'),
                      // onError: (_file) => print('Drop zone error: $_file'),
                    ),
                    SizedBox(
                      height: 100,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(_message),
                          MyApp.button(() => _onButtonPress),
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

  void get _onButtonPress => print('Pressed Browse button'); // TODO: Add real func. to button.
}
