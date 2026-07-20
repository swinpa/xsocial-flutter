import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../common/network/typedef.dart';


final class LoginResponse {
  const LoginResponse({
    required this.userToken,
    required this.nickname,
    required this.avatar,
    required this.userId,
    required this.imToken,
    required this.imUid,
    required this.rtcUid,
    this.globalRoomId,
    this.extRoomId,
  });

  final String userToken;
  final String nickname;
  final String avatar;
  final String userId;
  final String imToken;
  final String imUid;
  final String rtcUid;
  final String? globalRoomId;
  final String? extRoomId;

  factory LoginResponse.fromJson(Json json) {
    return LoginResponse(
      userToken: json['user_token'] as String,
      nickname: json['nickname'] as String,
      avatar: json['avatar'] as String,
      userId: json['user_id'] as String,
      imToken: json['im_token'] as String,
      imUid: json['im_uid'] as String,
      rtcUid: json['rtc_uid'] as String,
      globalRoomId: json['global_room_id'] as String?,
      extRoomId: json['ext_room_id'] as String?,
    );
  }

  Json toJson() => {
    'user_token': userToken,
    'nickname': nickname,
    'avatar': avatar,
    'user_id': userId,
    'im_token': imToken,
    'im_uid': imUid,
    'rtc_uid': rtcUid,
    'global_room_id': globalRoomId,
    'ext_room_id': extRoomId,
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



  static String? get userToken => _info?.userToken;

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
