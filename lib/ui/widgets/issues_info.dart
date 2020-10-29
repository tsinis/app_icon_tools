import 'package:community_material_icon/community_material_icon.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../generated/l10n.dart';
import '../../models/setup_icon.dart';
import '../../models/user_interface.dart';

class IssuesInfo extends StatefulWidget {
  const IssuesInfo({Key key}) : super(key: key);

  @override
  _IssuesInfo createState() => _IssuesInfo();
}

const String _foreground = 'foreground', _background = 'background';

class _IssuesInfo extends State<IssuesInfo> with SingleTickerProviderStateMixin {
  Animation<double> _animation;
  AnimationController _animationController;
  List<int> _bgErrCodes, _fgErrCodes, _iconErrCodes;
  bool _exportIOS = true;

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(vsync: this, duration: const Duration(seconds: 2));
    final CurvedAnimation curve = CurvedAnimation(parent: _animationController, curve: Curves.linear);
    // ignore: prefer_int_literals
    _animation = Tween(begin: 0.2, end: 1.0).animate(curve);
    // ignore: cascade_invocations
    _animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _animationController.reverse();
      } else if (status == AnimationStatus.dismissed) {
        _animationController.forward();
      }
    });
    _animationController.forward();
  }

  Map<int, String> get _errorMessages => {
        0: S.of(context).tooSmall,
        1: S.of(context).tooHeavy,
        2: S.of(context).notSqaure,
        3: S.of(context).isTransparent
      };

  String get _issues {
    String _iconMsg = '', _fgMsg = '', _bgMsg = '';
    if (_iconErrCodes.isNotEmpty) {
      _iconMsg = _findIssues();
    }
    if (_fgErrCodes.isNotEmpty) {
      _fgMsg = _findIssues(where: _foreground);
    }
    if (_bgErrCodes.isNotEmpty) {
      _bgMsg = _findIssues(where: _background);
    }
    return _iconMsg + _fgMsg + _bgMsg;
  }

  String _findIssues({String where = 'icon'}) {
    final StringBuffer _msgBuffer = StringBuffer();
    switch (where) {
      case _background:
        {
          _msgBuffer.write(S.of(context).adaptiveBackground);
          for (final int _errorCode in _bgErrCodes) {
            _msgBuffer.write(_errorMessages[_errorCode]);
          }
          break;
        }
      case _foreground:
        {
          _msgBuffer.write(S.of(context).adaptiveForeground);
          for (final int _errorCode in _fgErrCodes) {
            _msgBuffer.write(_errorMessages[_errorCode]);
          }
          break;
        }
      default:
        {
          _msgBuffer.write(S.of(context).regularIcon);
          for (final int _errorCode in _iconErrCodes) {
            _msgBuffer.write(_errorMessages[_errorCode]);
          }
          if (_iconErrCodes.contains(3) && _exportIOS) {
            _msgBuffer.write(S.of(context).transparencyIOS);
          }
          break;
        }
    }
    return _msgBuffer.toString();
  }

  @override
  Widget build(BuildContext context) {
    _iconErrCodes = context.select((SetupIcon icon) => icon.listIconErrCodes);
    _fgErrCodes = context.select((SetupIcon icon) => icon.listFgErrCodes);
    _bgErrCodes = context.select((SetupIcon icon) => icon.listBgErrCodes);
    _exportIOS = context.select((SetupIcon icon) => icon.exportIOS);
    final String _message = _issues;
    return (_message.isEmpty)
        ? const SizedBox(width: 24)
        : Tooltip(
            textStyle: Theme.of(context).textTheme.button, //TODO Fix text color.
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 30),
            message: _message,
            child: FadeTransition(
              opacity: _animation,
              child: Icon(UserInterface.isApple
                  ? CupertinoIcons.exclamationmark_triangle
                  : CommunityMaterialIcons.alert_outline),
            ),
          );
  }
}
