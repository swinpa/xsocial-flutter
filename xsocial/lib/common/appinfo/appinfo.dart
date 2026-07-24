import 'dart:io';
import 'dart:ui';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_udid/flutter_udid.dart';
import 'package:package_info_plus/package_info_plus.dart';

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
    String uuid = await FlutterUdid.udid;

    String osType, osVersion, phoneType;
    if (Platform.isIOS) {
      final iosInfo = await deviceInfo.iosInfo;
      osType = 'iOS';
      osVersion = iosInfo.systemVersion;
      phoneType = iosInfo.model;
    } else if (Platform.isAndroid) {
      final androidInfo = await deviceInfo.androidInfo;
      osType = 'Android';
      osVersion = androidInfo.version.release;
      phoneType = androidInfo.model;
    } else {
      osType = Platform.operatingSystem;
      osVersion = Platform.operatingSystemVersion;
      phoneType = 'Desktop';
    }

    obj = AppInfo._()
      ..appName = info.appName
      ..packageName = info.packageName
      ..version = info.version
      ..buildNumber = info.buildNumber
      ..osUuid = uuid
      ..osType = osType
      ..osVersion = osVersion
      ..phoneBrand = 'Apple'
      ..phoneType = phoneType
      ..phoneOsVersion = '$osType$osVersion';
  }

  String localeIdentifier() {
    final locale = PlatformDispatcher.instance.locale;
    if (locale.countryCode?.isNotEmpty == true) {
      return '${locale.languageCode}_${locale.countryCode}';
    }

    return locale.languageCode;
  }
}

