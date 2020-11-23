// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values

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

  /// `Done`
  String get done {
    return Intl.message(
      'Done',
      name: 'done',
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

  /// `App restart required`
  String get restart {
    return Intl.message(
      'App restart required',
      name: 'restart',
      desc: '',
      args: [],
    );
  }

  /// `iOS-style UI`
  String get cupertino {
    return Intl.message(
      'iOS-style UI',
      name: 'cupertino',
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

  /// `Please select your image:`
  String get select {
    return Intl.message(
      'Please select your image:',
      name: 'select',
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

  /// `Back`
  String get backButton {
    return Intl.message(
      'Back',
      name: 'backButton',
      desc: '',
      args: [],
    );
  }

  /// `Export icons as ZIP archive`
  String get saveAsZip {
    return Intl.message(
      'Export icons as ZIP archive',
      name: 'saveAsZip',
      desc: '',
      args: [],
    );
  }

  /// `About this app`
  String get about {
    return Intl.message(
      'About this app',
      name: 'about',
      desc: '',
      args: [],
    );
  }

  /// `UI Settings`
  String get appSettings {
    return Intl.message(
      'UI Settings',
      name: 'appSettings',
      desc: '',
      args: [],
    );
  }

  /// `Choose platforms for export`
  String get choosePlatforms {
    return Intl.message(
      'Choose platforms for export',
      name: 'choosePlatforms',
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

  /// `Maskable PWA Icon (Min. Safe Area)`
  String get maskable {
    return Intl.message(
      'Maskable PWA Icon (Min. Safe Area)',
      name: 'maskable',
      desc: '',
      args: [],
    );
  }

  /// `Select PWA Background color`
  String get pwaColor {
    return Intl.message(
      'Select PWA Background color',
      name: 'pwaColor',
      desc: '',
      args: [],
    );
  }

  /// `Icon for OS:`
  String get operatingSystem {
    return Intl.message(
      'Icon for OS:',
      name: 'operatingSystem',
      desc: '',
      args: [],
    );
  }

  /// `Zoom to check {platform} icon`
  String lookOnDevice(Object platform) {
    return Intl.message(
      'Zoom to check $platform icon',
      name: 'lookOnDevice',
      desc: '',
      args: [platform],
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

  /// `Select Adaptive Background`
  String get uploadAdaptiveBg {
    return Intl.message(
      'Select Adaptive Background',
      name: 'uploadAdaptiveBg',
      desc: '',
      args: [],
    );
  }

  /// `Select Adaptive Foreground`
  String get uploadAdaptiveFg {
    return Intl.message(
      'Select Adaptive Foreground',
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

  /// `Remove Foreground`
  String get removeForeground {
    return Intl.message(
      'Remove Foreground',
      name: 'removeForeground',
      desc: '',
      args: [],
    );
  }

  /// `Preview possible background color`
  String get iconBgColor {
    return Intl.message(
      'Preview possible background color',
      name: 'iconBgColor',
      desc: '',
      args: [],
    );
  }

  /// `Please select background/foreground first.`
  String get noBackground {
    return Intl.message(
      'Please select background/foreground first.',
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

  /// `Please wait a moment.`
  String get wait {
    return Intl.message(
      'Please wait a moment.',
      name: 'wait',
      desc: '',
      args: [],
    );
  }

  /// `Background as color`
  String get colorAsBg {
    return Intl.message(
      'Background as color',
      name: 'colorAsBg',
      desc: '',
      args: [],
    );
  }

  /// `Platforms to Export`
  String get exportPlatforms {
    return Intl.message(
      'Platforms to Export',
      name: 'exportPlatforms',
      desc: '',
      args: [],
    );
  }

  /// `Long press to remove!`
  String get longPress {
    return Intl.message(
      'Long press to remove!',
      name: 'longPress',
      desc: '',
      args: [],
    );
  }

  /// `Wait please, the file is being verified.`
  String get verifying {
    return Intl.message(
      'Wait please, the file is being verified.',
      name: 'verifying',
      desc: '',
      args: [],
    );
  }

  /// `Regular Icon:`
  String get regularIcon {
    return Intl.message(
      'Regular Icon:',
      name: 'regularIcon',
      desc: '',
      args: [],
    );
  }

  /// `Adaptive Foreground:`
  String get adaptiveForeground {
    return Intl.message(
      'Adaptive Foreground:',
      name: 'adaptiveForeground',
      desc: '',
      args: [],
    );
  }

  /// `Adaptive Background:`
  String get adaptiveBackground {
    return Intl.message(
      'Adaptive Background:',
      name: 'adaptiveBackground',
      desc: '',
      args: [],
    );
  }

  /// `!!! The image is smaller than required, the result Icon can be pixelized during upscaling.`
  String get tooSmall {
    return Intl.message(
      '!!! The image is smaller than required, the result Icon can be pixelized during upscaling.',
      name: 'tooSmall',
      desc: '',
      args: [],
    );
  }

  /// `!! The file size is bigger than the limit. You may have trouble publishing it to app stores.`
  String get tooHeavy {
    return Intl.message(
      '!! The file size is bigger than the limit. You may have trouble publishing it to app stores.',
      name: 'tooHeavy',
      desc: '',
      args: [],
    );
  }

  /// `! The image is not square. Icon can be deformed, or the edges of the trim can be visible.`
  String get notSqaure {
    return Intl.message(
      '! The image is not square. Icon can be deformed, or the edges of the trim can be visible.',
      name: 'notSqaure',
      desc: '',
      args: [],
    );
  }

  /// `ℹ️  The image have Alpha Channel (transparency). `
  String get isTransparent {
    return Intl.message(
      'ℹ️  The image have Alpha Channel (transparency). ',
      name: 'isTransparent',
      desc: '',
      args: [],
    );
  }

  /// `*iOS Launcher dоn't support transparency in any app Icon (including PWA).\nThe Alpha channel will be replaced with black color on iOS.`
  String get transparencyIOS {
    return Intl.message(
      '*iOS Launcher dоn\'t support transparency in any app Icon (including PWA).\nThe Alpha channel will be replaced with black color on iOS.',
      name: 'transparencyIOS',
      desc: '',
      args: [],
    );
  }

  /// `ℹ️  The Foreground have no Alpha Channel (transparency). In this case, the background image will not be visible at all.`
  String get transparencyAdaptive {
    return Intl.message(
      'ℹ️  The Foreground have no Alpha Channel (transparency). In this case, the background image will not be visible at all.',
      name: 'transparencyAdaptive',
      desc: '',
      args: [],
    );
  }

  /// `Search`
  String get search {
    return Intl.message(
      'Search',
      name: 'search',
      desc: '',
      args: [],
    );
  }

  /// `Find your language here…`
  String get findLang {
    return Intl.message(
      'Find your language here…',
      name: 'findLang',
      desc: '',
      args: [],
    );
  }

  /// `Done! Icons ZIP is in the Downloads folder.`
  String get downloadsFolder {
    return Intl.message(
      'Done! Icons ZIP is in the Downloads folder.',
      name: 'downloadsFolder',
      desc: '',
      args: [],
    );
  }

  /// `Done! You can share your icons with the world.`
  String get share {
    return Intl.message(
      'Done! You can share your icons with the world.',
      name: 'share',
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
      Locale.fromSubtags(languageCode: 'ru'),
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