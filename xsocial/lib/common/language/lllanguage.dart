import 'dart:ui';

final class LLLanguage {
  const LLLanguage._();

  static String get sysLanguage {
    return PlatformDispatcher.instance.locale.languageCode;
  }
  static String get localeIdentifier {
    final locale = PlatformDispatcher.instance.locale;
    if (locale.countryCode?.isNotEmpty == true) {
      return '${locale.languageCode}_${locale.countryCode}';
    }
    return locale.languageCode;
  }



}