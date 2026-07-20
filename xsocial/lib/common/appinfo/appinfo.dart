import 'package:package_info_plus/package_info_plus.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_udid/flutter_udid.dart';
import 'dart:ui';

final class AppInfo {
  AppInfo._();

  static late final AppInfo obj;

  late final String appName;
  late final String packageName;
  late final String version;
  late final String buildNumber;
  
  late final String lang;
  late final String osUuid;
  late final String osType;
  late final String osVersion;
  late final String phoneBrand;
  late final String phoneType;
  late final String phoneOsVersion;

  static Future<void> init() async {
    final info = await PackageInfo.fromPlatform();
    final deviceInfo = DeviceInfoPlugin();
    final iosInfo = await deviceInfo.iosInfo;
    String uuid = await FlutterUdid.udid;
    
    obj = AppInfo._()
      ..appName = info.appName
      ..packageName = info.packageName
      ..version = info.version
      ..buildNumber = info.buildNumber
      ..osUuid = uuid
      ..osType = 'iOS'
      ..osVersion = iosInfo.systemVersion
      ..phoneBrand = 'Apple'
      ..phoneType = iosInfo.model
      ..phoneOsVersion = "iOS${iosInfo.systemVersion}";
  }

  String localeIdentifier() {
    final locale = PlatformDispatcher.instance.locale;
    if (locale.countryCode?.isNotEmpty == true) {
      return '${locale.languageCode}_${locale.countryCode}';
    }

    return locale.languageCode;
  }
}

