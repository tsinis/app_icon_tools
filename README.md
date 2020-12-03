# App Icon Tools 🖼️

![Screenshot](preview.png)

## Description

This multiplatform app is powered by Flutter and was created for simple and intuitive preview and generation of (launcher/desktop) app icons, for the most popular operating systems. It doesn't contain tracking or any advertising and is available for free as an open-source. PRs, suggestions, translations, etc. – are welcome!

### Features

Here are some of the unique features of this application:

* It creates icons not only for Android and iOS but for all platforms that Flutter supports (at the moment, the Linux platform from Flutter does not generate icons, but once the Flutter team fixes this problem, everything is ready).
* It can show icons in different shapes and with safety zone masks.
* It can show the parallax animation of adaptive Android icons (where you will find such functionality online :)?).
* It shows the icons as they would look on real devices.
* It generates icons not destructive way — all you get is an archive, the contents of which you can check before you overwrite your files.
* It works natively on all platforms that Flutter supports.
* It will find you and show you the Issues that can cause you problems with displaying or App stores refusal.
* The project supports multiple languages, and you can easily add your own.

### Run it online

---

:warning: **Important! BEFORE YOU START!**

This project in form of PWA **will only run on most recent browsers, with Chromium (Chrome, Edge, etc.) engine v83 or newer. Also, I've tested it on Firefox v77+**, so it might be OK too. Don't even try to run it on Safari, Internet Explorer and so on — they can't handle it!

---

Thanks to [Codemagic](https://codemagic.io), you can just follow this link and run it in your modern browser:

[https://icon-tools.codemagic.app](https://icon-tools.codemagic.app)

## Releases

You can find binaries for Android, macOS and Web in [Releases](https://github.com/tsinis/app_icon_tools/releases) section of this GitHub repository.

## Building

*Not all packages are ready for null-safety yet. Please run as:*

``flutter run --no-sound-null-safety``

 *Web version should also have a SKIA flag enabled:*

 ``flutter run --no-sound-null-safety --dart-define=FLUTTER_WEB_USE_SKIA=true``

**README will be updated and localized.**
