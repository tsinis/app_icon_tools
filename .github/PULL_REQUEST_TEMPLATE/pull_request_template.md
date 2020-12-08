# Localization Pull Request Template

## Description

Please include a summary of the change, describe which language is added, and follow requirements.

## Requirements

Localization PR should be addressed in the repository's default channel and contain exactly:

* 3 file changes in the [lib folder](./lib/)

  * [constants/locales.dart](./lib/constants/locales.dart) - 1 new line in *languageNames* map.
  * [generated/intl/messages_xx.dart](./lib/generated/intl/) - generated automatically via Flutter Intl extension.
  * [generated/l10n.dart](./lib/generated/l10n.dart) - generated automatically via Flutter Intl extension.

* 2 new files created in the [lib folder](./lib/)

  * [l10n/intl_xx.arb](./lib/l10n/) - at least 67 lines long.
  * [generated/intl/messages_xx.dart](./lib/generated/intl/) - generated automatically via Flutter Intl extension.

Where "xx" representing the two-letter code of your language name from [this DB](http://cldr.unicode.org/index/cldr-spec/picking-the-right-language-code#TOC-Choosing-the-Base-Language-Code).

## Final Note

PR will be merged as soon as at least 3 people will mark a PR message with 👍 thumbs up (+1) emoji.

---

<!-- Your part belongs here -->
## Language

Please describe what locale has been added here.

## Checklist

* [ ] My PR only contains changes described in [Requirements](#Requirements) section.
* [ ] My translation follows the Wiki's [Localization guidelines](https://github.com/tsinis/app_icon_tools/wiki/Localization) of this project.
* [ ] I checked the texts visually on device so that they are readable in their entirety.
* [ ] I have checked my code and translation and corrected any misspellings.
* [ ] I have performed a self-review of my own translation.
* [ ] My changes generate no new warnings.
* [ ] I'll wait for at least 3 persons to approve my translation.
