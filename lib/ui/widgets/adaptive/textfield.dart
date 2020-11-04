import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../models/user_interface.dart';

class AdaptiveTextField extends StatelessWidget {
  const AdaptiveTextField(
      {@required this.onChanged, @required this.hint, @required this.label, @required this.autofillHints, Key key})
      : super(key: key);

  final List<String> autofillHints;
  final String hint, label;
  final Function(String value) onChanged;

  @override
  Widget build(BuildContext context) {
    final Color _textColor = Theme.of(context).textTheme.bodyText1?.color ?? Colors.grey;
    return UserInterface.isApple
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
        : Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: TextField(
              onChanged: onChanged,
              inputFormatters: [FilteringTextInputFormatter.deny(RegExp('[0-9,.:!]'))],
              keyboardType: TextInputType.text,
              autofillHints: autofillHints,
              autofocus: true,
              decoration: InputDecoration(
                  labelStyle: TextStyle(color: _textColor.withOpacity(0.4)),
                  labelText: label,
                  hintText: hint,
                  hintStyle: TextStyle(color: _textColor.withOpacity(0.25)),
                  prefixIcon: Padding(
                      padding: const EdgeInsets.only(left: 6),
                      child: Icon(Icons.search, color: _textColor.withOpacity(0.4))),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 0.4, color: _textColor.withOpacity(0.4)),
                      borderRadius: const BorderRadius.all(Radius.circular(8))),
                  border: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(8)))),
            ),
          );
  }
}
