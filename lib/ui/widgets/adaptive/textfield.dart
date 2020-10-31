import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../models/user_interface.dart';

class AdaptiveTextField extends StatelessWidget {
  const AdaptiveTextField({Key key, this.onChanged, this.hint, this.label, this.autofillHints}) : super(key: key);

  final List<String> autofillHints;
  final String hint, label;
  final Function(String value) onChanged;

  @override
  Widget build(BuildContext context) => UserInterface.isApple
      ? Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 10),
          child: CupertinoTextField(
              onChanged: onChanged,
              inputFormatters: [FilteringTextInputFormatter.deny(RegExp('[0-9,.:!]'))],
              clearButtonMode: OverlayVisibilityMode.editing,
              keyboardType: TextInputType.text,
              autofillHints: autofillHints,
              autofocus: true,
              placeholder: hint),
        )
      : TextField(
          onChanged: onChanged,
          inputFormatters: [FilteringTextInputFormatter.deny(RegExp('[0-9,.:!]'))],
          keyboardType: TextInputType.text,
          autofillHints: autofillHints,
          autofocus: true,
          decoration: InputDecoration(
              labelText: label,
              hintText: hint,
              prefixIcon: const Padding(padding: EdgeInsets.only(left: 6), child: Icon(Icons.search)),
              border: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(8)))),
        );
}
