import 'package:adjust_sdk/adjust.dart';
import 'package:adjust_sdk/adjust_config.dart';

final class XSAttribution {
  void initSDK() {
    // Initialize Adjust SDK
    AdjustConfig config = AdjustConfig('5eq8ekynd8xs', AdjustEnvironment.sandbox);
    config.logLevel = AdjustLogLevel.verbose;
    Adjust.initSdk(config);
  }
}