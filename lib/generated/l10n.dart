// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars

class S {
  S();
  
  static S current;
  
  static const AppLocalizationDelegate delegate =
    AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false) ? locale.languageCode : locale.toString();
    final localeName = Intl.canonicalizedLocale(name); 
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      S.current = S();
      
      return S.current;
    });
  } 

  static S of(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `en`
  String get locale {
    return Intl.message(
      'en',
      name: 'locale',
      desc: '',
      args: [],
    );
  }

  /// `Launcher Icons Preview`
  String get appName {
    return Intl.message(
      'Launcher Icons Preview',
      name: 'appName',
      desc: '',
      args: [],
    );
  }

  /// `Save`
  String get save {
    return Intl.message(
      'Save',
      name: 'save',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get cancel {
    return Intl.message(
      'Cancel',
      name: 'cancel',
      desc: '',
      args: [],
    );
  }

  /// `Settings`
  String get settings {
    return Intl.message(
      'Settings',
      name: 'settings',
      desc: '',
      args: [],
    );
  }

  /// `Dark Mode`
  String get dark {
    return Intl.message(
      'Dark Mode',
      name: 'dark',
      desc: '',
      args: [],
    );
  }

  /// `Drop your image here or`
  String get dragAndDropHere {
    return Intl.message(
      'Drop your image here or',
      name: 'dragAndDropHere',
      desc: '',
      args: [],
    );
  }

  /// `File doesn't meet the Requirements`
  String get wrongFile {
    return Intl.message(
      'File doesn\'t meet the Requirements',
      name: 'wrongFile',
      desc: '',
      args: [],
    );
  }

  /// `Browse`
  String get browse {
    return Intl.message(
      'Browse',
      name: 'browse',
      desc: '',
      args: [],
    );
  }

  /// `Launcher Icon Requirements:`
  String get iconAttributes {
    return Intl.message(
      'Launcher Icon Requirements:',
      name: 'iconAttributes',
      desc: '',
      args: [],
    );
  }

  /// `File format:`
  String get fileFormat {
    return Intl.message(
      'File format:',
      name: 'fileFormat',
      desc: '',
      args: [],
    );
  }

  /// `Dimensions:`
  String get imageSize {
    return Intl.message(
      'Dimensions:',
      name: 'imageSize',
      desc: '',
      args: [],
    );
  }

  /// `Max. file size:`
  String get maxKB {
    return Intl.message(
      'Max. file size:',
      name: 'maxKB',
      desc: '',
      args: [],
    );
  }

  /// `Color profile:`
  String get colorProfile {
    return Intl.message(
      'Color profile:',
      name: 'colorProfile',
      desc: '',
      args: [],
    );
  }

  /// `w/o interlacing.`
  String get noInterlacing {
    return Intl.message(
      'w/o interlacing.',
      name: 'noInterlacing',
      desc: '',
      args: [],
    );
  }

  /// `Adaptive icon can be set up in the next step.`
  String get addBackground {
    return Intl.message(
      'Adaptive icon can be set up in the next step.',
      name: 'addBackground',
      desc: '',
      args: [],
    );
  }

  /// `Technical requirements. Press for more info.`
  String get storeRequirement {
    return Intl.message(
      'Technical requirements. Press for more info.',
      name: 'storeRequirement',
      desc: '',
      args: [],
    );
  }

  /// `The iOS icons doesn't support transparency, alpha channel will be replaced with black color.`
  String get transparencyiOS {
    return Intl.message(
      'The iOS icons doesn\'t support transparency, alpha channel will be replaced with black color.',
      name: 'transparencyiOS',
      desc: '',
      args: [],
    );
  }

  /// `Preview possible shapes`
  String get previewShapes {
    return Intl.message(
      'Preview possible shapes',
      name: 'previewShapes',
      desc: '',
      args: [],
    );
  }

  /// `Icon Preview`
  String get iconPreview {
    return Intl.message(
      'Icon Preview',
      name: 'iconPreview',
      desc: '',
      args: [],
    );
  }

  /// `Upload Adaptive Background`
  String get uploadAdaptiveBg {
    return Intl.message(
      'Upload Adaptive Background',
      name: 'uploadAdaptiveBg',
      desc: '',
      args: [],
    );
  }

  /// `Upload Adaptive Foreground`
  String get uploadAdaptiveFg {
    return Intl.message(
      'Upload Adaptive Foreground',
      name: 'uploadAdaptiveFg',
      desc: '',
      args: [],
    );
  }

  /// `Remove Color`
  String get removeColor {
    return Intl.message(
      'Remove Color',
      name: 'removeColor',
      desc: '',
      args: [],
    );
  }

  /// `Remove Background`
  String get removeBackground {
    return Intl.message(
      'Remove Background',
      name: 'removeBackground',
      desc: '',
      args: [],
    );
  }

  /// `Remove Foreround`
  String get removeForeground {
    return Intl.message(
      'Remove Foreround',
      name: 'removeForeground',
      desc: '',
      args: [],
    );
  }

  /// `Icon Background Color`
  String get iconBgColor {
    return Intl.message(
      'Icon Background Color',
      name: 'iconBgColor',
      desc: '',
      args: [],
    );
  }

  /// `Please select adaptive background first.`
  String get noBackground {
    return Intl.message(
      'Please select adaptive background first.',
      name: 'noBackground',
      desc: '',
      args: [],
    );
  }

  /// `Preview Adaptive Icon parallax effect.`
  String get parallax {
    return Intl.message(
      'Preview Adaptive Icon parallax effect.',
      name: 'parallax',
      desc: '',
      args: [],
    );
  }

  /// `Device Preview`
  String get devicePreview {
    return Intl.message(
      'Device Preview',
      name: 'devicePreview',
      desc: '',
      args: [],
    );
  }

  /// `Export Icons`
  String get export {
    return Intl.message(
      'Export Icons',
      name: 'export',
      desc: '',
      args: [],
    );
  }

  /// `Please wait a moment`
  String get wait {
    return Intl.message(
      'Please wait a moment',
      name: 'wait',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    if (locale != null) {
      for (var supportedLocale in supportedLocales) {
        if (supportedLocale.languageCode == locale.languageCode) {
          return true;
        }
      }
    }
    return false;
  }
}