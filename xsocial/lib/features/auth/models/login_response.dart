import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../common/network/typedef.dart';
import 'user.dart';

/**
  登录接口返回的原始数据。
 */
final class LoginResponse {
  const LoginResponse({
    required this.user_token,
    required this.nickname,
    required this.avatar,
    required this.user_id,
    required this.im_token,
    required this.im_uid,
    required this.rtc_uid,
    required this.level,
    required this.country,
    this.sex,
    this.nickname_color,
    this.ct,
    this.global_room_id,
    this.ext_room_id,
  });

  final String user_token;
  final String nickname;
  final String avatar;
  final String user_id;
  final String im_token;
  final String im_uid;
  final String rtc_uid;
  final String level;
  final String country;
  final String? sex;
  final String? nickname_color;
  final String? ct;
  final String? global_room_id;
  final String? ext_room_id;

  factory LoginResponse.fromJson(Json json) {
    return LoginResponse(
      user_token: json['user_token'] as String,
      nickname: json['nickname'] as String,
      avatar: json['avatar'] as String,
      user_id: json['user_id'] as String,
      im_token: json['im_token'] as String,
      im_uid: json['im_uid'] as String,
      rtc_uid: json['rtc_uid'] as String,
      level: json['level'] as String,
      country: json['country'] as String,
      sex: json['sex'] as String?,
      nickname_color: json['nickname_color'] as String?,
      ct: json['ct'] as String?,
      global_room_id: json['global_room_id'] as String?,
      ext_room_id: json['ext_room_id'] as String?,
    );
  }

  Json toJson() => {
    'user_token': user_token,
    'nickname': nickname,
    'avatar': avatar,
    'user_id': user_id,
    'im_token': im_token,
    'im_uid': im_uid,
    'rtc_uid': rtc_uid,
    'level': level,
    'country': country,
    'sex': sex,
    'nickname_color': nickname_color,
    'ct': ct,
    'global_room_id': global_room_id,
    'ext_room_id': ext_room_id,
  };
}

/// 登录成功后解析出的业务结果。
///
/// 我希望APP启动时，从缓存读取改数据，判断是否登录过，如果登录过，则直接进入首页。
/// 同时登录接口成功后赋值更新该字段并缓存。
final class AuthResult {
  AuthResult._(); // 私有构造，不允许外部直接创建

  static var infokey = 'auth_info';
  static LoginResponse? _info;

  /// 当前缓存的登录数据，null 表示未登录。
  static LoginResponse? get info => _info;



  static String? get userToken => _info?.user_token;

  /// APP 启动时调用，从缓存恢复登录状态。
  static Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(infokey);
    if (raw == null) return;

    try {
      final json = jsonDecode(raw) as Json;
      _info = LoginResponse.fromJson(json);
    } catch (_) {
      await prefs.remove(infokey);
    }
  }

  /// 登录成功后调用，缓存数据并更新状态。
  static Future<void> login(LoginResponse data) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(infokey, jsonEncode(data.toJson()));
    _info = data;
  }

  /// 退出登录时调用，清除缓存和状态。
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(infokey);
    _info = null;
  }
}
