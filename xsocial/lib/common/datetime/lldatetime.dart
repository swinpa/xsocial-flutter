final class LLDateTime {
  const LLDateTime._();

  static String get utc {
    var res = DateTime.now().timeZoneOffset.inSeconds ~/ 3600;//"8";
    return res.toString();
  } 
  static String get timezone {
    return "Asia/Singapore";
  }
}