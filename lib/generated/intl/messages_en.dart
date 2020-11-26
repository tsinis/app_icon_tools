// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'en';

  static m0(platform) => "Zoom to check ${platform} icon";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static _notInlinedMessages(_) => <String, Function> {
    "about" : MessageLookupByLibrary.simpleMessage("About this app"),
    "adaptiveBackground" : MessageLookupByLibrary.simpleMessage("Adaptive Background:"),
    "adaptiveForeground" : MessageLookupByLibrary.simpleMessage("Adaptive Foreground:"),
    "addBackground" : MessageLookupByLibrary.simpleMessage("An adaptive icon can be set up in the next step."),
    "appName" : MessageLookupByLibrary.simpleMessage("App Icon Tools"),
    "appSettings" : MessageLookupByLibrary.simpleMessage("UI Settings"),
    "backButton" : MessageLookupByLibrary.simpleMessage("Back"),
    "browse" : MessageLookupByLibrary.simpleMessage("Browse"),
    "cancel" : MessageLookupByLibrary.simpleMessage("Cancel"),
    "choosePlatforms" : MessageLookupByLibrary.simpleMessage("Choose platforms for export"),
    "colorAsBg" : MessageLookupByLibrary.simpleMessage("Background as color"),
    "colorProfile" : MessageLookupByLibrary.simpleMessage("Color profile:"),
    "cupertino" : MessageLookupByLibrary.simpleMessage("iOS-style UI"),
    "dark" : MessageLookupByLibrary.simpleMessage("Dark Mode"),
    "devicePreview" : MessageLookupByLibrary.simpleMessage("Device Preview"),
    "done" : MessageLookupByLibrary.simpleMessage("Done"),
    "downloadsFolder" : MessageLookupByLibrary.simpleMessage("Done! Icons ZIP is in the Downloads folder."),
    "dragAndDropHere" : MessageLookupByLibrary.simpleMessage("Drop your image here or"),
    "export" : MessageLookupByLibrary.simpleMessage("Export Icons"),
    "exportPlatforms" : MessageLookupByLibrary.simpleMessage("Platforms to Export"),
    "fileFormat" : MessageLookupByLibrary.simpleMessage("File format:"),
    "findLang" : MessageLookupByLibrary.simpleMessage("Find your language here…"),
    "iconAttributes" : MessageLookupByLibrary.simpleMessage("Launcher Icon Requirements:"),
    "iconBgColor" : MessageLookupByLibrary.simpleMessage("Preview possible background-color"),
    "iconPreview" : MessageLookupByLibrary.simpleMessage("Icon Preview"),
    "imageSize" : MessageLookupByLibrary.simpleMessage("Dimensions:"),
    "isTransparent" : MessageLookupByLibrary.simpleMessage("ℹ️  The image has an Alpha Channel (transparency)."),
    "legalese" : MessageLookupByLibrary.simpleMessage("This multiplatform app was created for simple and intuitive preview and generation of (launcher/desktop) app icons, for the most popular operating systems. It doesn\'t contain tracking or any advertising and is available for free as an open-source. PRs, suggestions, translations, etc. – are welcome!"),
    "locale" : MessageLookupByLibrary.simpleMessage("en"),
    "longPress" : MessageLookupByLibrary.simpleMessage("Long press to remove!"),
    "lookOnDevice" : m0,
    "maskable" : MessageLookupByLibrary.simpleMessage("Maskable PWA Icon (min. Safe Area)"),
    "maxKB" : MessageLookupByLibrary.simpleMessage("Max. file size:"),
    "noBackground" : MessageLookupByLibrary.simpleMessage("Please select the background/foreground first"),
    "noInterlacing" : MessageLookupByLibrary.simpleMessage("w/o interlacing."),
    "notSqaure" : MessageLookupByLibrary.simpleMessage("!The image is not square. The icon can be deformed, or the edges of the trim can be visible."),
    "officialDocs" : MessageLookupByLibrary.simpleMessage("Click here for more information from the official documentation."),
    "operatingSystem" : MessageLookupByLibrary.simpleMessage("Icon for OS:"),
    "parallax" : MessageLookupByLibrary.simpleMessage("Preview Adaptive Icon parallax effect"),
    "pleaseRate" : MessageLookupByLibrary.simpleMessage("Please rate the repository if you liked this app:"),
    "previewShapes" : MessageLookupByLibrary.simpleMessage("Preview possible shapes"),
    "pwaColor" : MessageLookupByLibrary.simpleMessage("Select PWA Background color"),
    "pwaVersion" : MessageLookupByLibrary.simpleMessage("This is the PWA version, but there is also a native version of this app for your OS."),
    "regularIcon" : MessageLookupByLibrary.simpleMessage("Regular Icon:"),
    "removeBackground" : MessageLookupByLibrary.simpleMessage("Remove Background"),
    "removeColor" : MessageLookupByLibrary.simpleMessage("Remove Color"),
    "removeForeground" : MessageLookupByLibrary.simpleMessage("Remove Foreground"),
    "restart" : MessageLookupByLibrary.simpleMessage("App restart required"),
    "save" : MessageLookupByLibrary.simpleMessage("Save"),
    "saveAsZip" : MessageLookupByLibrary.simpleMessage("Export icons as ZIP archive"),
    "search" : MessageLookupByLibrary.simpleMessage("Search"),
    "select" : MessageLookupByLibrary.simpleMessage("Please select your image"),
    "settings" : MessageLookupByLibrary.simpleMessage("Settings"),
    "share" : MessageLookupByLibrary.simpleMessage("Done! You can share your icons with the world."),
    "storeRequirement" : MessageLookupByLibrary.simpleMessage("Technical requirements. Press for more info."),
    "tooHeavy" : MessageLookupByLibrary.simpleMessage("!! The file size is bigger than the limit. You may have trouble publishing it to app stores."),
    "tooSmall" : MessageLookupByLibrary.simpleMessage("!!! The image is smaller than required, the result Icon can be pixelized during upscaling."),
    "transparencyAdaptive" : MessageLookupByLibrary.simpleMessage("ℹ️  The Foreground has no Alpha Channel (transparency). In this case, the background image will not be visible at all."),
    "transparencyIOS" : MessageLookupByLibrary.simpleMessage("*iOS Launcher dоn\'t support transparency in any app Icon (including PWA).\nThe Alpha channel will be replaced with black color on iOS."),
    "uploadAdaptiveBg" : MessageLookupByLibrary.simpleMessage("Select Adaptive Background"),
    "uploadAdaptiveFg" : MessageLookupByLibrary.simpleMessage("Select Adaptive Foreground"),
    "verifying" : MessageLookupByLibrary.simpleMessage("Wait please, the file is being verified."),
    "wait" : MessageLookupByLibrary.simpleMessage("Please wait a moment."),
    "wrongFile" : MessageLookupByLibrary.simpleMessage("File doesn\'t meet the Requirements")
  };
}
