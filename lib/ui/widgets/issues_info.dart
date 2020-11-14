import 'dart:math' show max;

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

class _IssuesInfo extends State<IssuesInfo> with SingleTickerProviderStateMixin {
  static const String _foreground = 'foreground', _background = 'background';
  Animation<double> _animation;
  AnimationController _animationController;
  final List<int> _bgErrCodes = [], _fgErrCodes = [], _iconErrCodes = [];
  bool _exportIOS = true, _exportAdaptive = true, _exportPWA = true;

  static const int _infoCode = 3;

  double get _hue {
    final int _iconIssuesCount = _iconErrCodes.length - (_iconErrCodes.contains(_infoCode) ? 1 : 0);
    final int _fgIssuesCount = _fgErrCodes.length - (_fgErrCodes.contains(_infoCode) ? 1 : 0);
    final int _bgIssuesCount = _bgErrCodes.length - (_bgErrCodes.contains(_infoCode) ? 1 : 0);
    return max(0, 70 - (17.5 * _iconIssuesCount) - (17.5 * _fgIssuesCount) - (17.5 * _bgIssuesCount));
  }

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
          _msgBuffer..write('\n\n')..write(S.of(context).adaptiveBackground);
          for (final int _errorCode in _bgErrCodes) {
            _msgBuffer..write('\n')..write(_errorMessages[_errorCode]);
          }
          break;
        }
      case _foreground:
        {
          _msgBuffer..write('\n\n')..write(S.of(context).adaptiveForeground);
          for (final int _errorCode in _fgErrCodes) {
            _msgBuffer..write('\n')..write(_errorMessages[_errorCode]);
          }
          if (!_fgErrCodes.contains(_infoCode) && _exportAdaptive) {
            _msgBuffer..write('\n')..write(S.of(context).transparencyAdaptive);
          }
          break;
        }
      default:
        {
          _msgBuffer..write('\n\n')..write(S.of(context).regularIcon);
          for (final int _errorCode in _iconErrCodes) {
            _msgBuffer..write('\n')..write(_errorMessages[_errorCode]);
          }
          if (_iconErrCodes.contains(_infoCode) && (_exportIOS || _exportPWA)) {
            _msgBuffer..write('\n')..write(S.of(context).transparencyIOS);
          }
          break;
        }
    }
    return _msgBuffer.toString();
  }

  @override
  Widget build(BuildContext context) {
    _iconErrCodes
      ..clear()
      ..addAll(context.select((SetupIcon icon) => icon.listIconErrCodes));
    _fgErrCodes
      ..clear()
      ..addAll(context.select((SetupIcon icon) => icon.listFgErrCodes));
    _bgErrCodes
      ..clear()
      ..addAll(context.select((SetupIcon icon) => icon.listBgErrCodes));
    _exportIOS = context.select((SetupIcon icon) => icon.exportIOS);
    _exportAdaptive = context.select((SetupIcon icon) => icon.exportAdaptive);
    _exportPWA = context.select((SetupIcon icon) => icon.exportWeb);
    final String _message = _issues;
    return (_message.isEmpty)
        ? const SizedBox(width: 28)
        : Tooltip(
            showDuration: Duration(seconds: 3 * (2 + _iconErrCodes.length + _bgErrCodes.length + _fgErrCodes.length)),
            decoration: BoxDecoration(
              color: Theme.of(context).bottomAppBarColor.withOpacity(0.84),
              borderRadius: const BorderRadius.all(Radius.circular(10)),
            ),
            textStyle: Theme.of(context).textTheme.button,
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
            message: _message,
            child: FadeTransition(
              opacity: _animation,
              child: Icon(
                  UserInterface.isApple
                      ? CupertinoIcons.exclamationmark_triangle
                      : CommunityMaterialIcons.alert_outline,
                  color: HSLColor.fromAHSL(1, _hue, 1, 0.5).toColor()),
            ),
          );
  }
}
