import 'package:package_info_plus/package_info_plus.dart';
final class AppInfo {
  AppInfo._({
    required this.appName,
    required this.packageName,
    required this.version,
    required this.buildNumber,
  });

  final String appName;
  /// Package name (bundle identifier) of the app.
  final String packageName;
  final String version;
  final String buildNumber;

  static Future<AppInfo> load() async {
    final info = await PackageInfo.fromPlatform();
    return AppInfo._(
      appName: info.appName,
      packageName: info.packageName,
      version: info.version,
      buildNumber: info.buildNumber,
    );
  }
}