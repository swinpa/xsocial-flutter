import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../providers/auth_provider.dart';
import '../models/login_response.dart';
import '../widgets/login_button.dart';
import '../../../common/widget/rich_text.dart';

/// ═══════════════════════════════════════════════════════════════
/// ⚠️  Google Sign-In 配置（iOS 必填）
/// ═══════════════════════════════════════════════════════════════
///
/// 从 Firebase Console 下载最新的 GoogleService-Info.plist，
/// 将文件中的 CLIENT_ID 值复制到下面的常量中。
///
///   Firebase Console → 项目 ay-hiplay-test → Project settings → General
///   → Your apps → iOS 应用 → 下载 GoogleService-Info.plist
///   → 打开文件，复制 CLIENT_ID 的值
///
/// 示例值: '677356098210-xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx.apps.googleusercontent.com'
///
/// 同时还需要用相同值更新:
///   - ios/Runner/GoogleService-Info.plist 中的 CLIENT_ID
///   - ios/Runner/Info.plist 中的 CFBundleURLSchemes 的 URL Scheme
///
const String kGoogleClientId = '464898300810-k12760u37c2rkrtlpluurg5f9l9mnqeb.apps.googleusercontent.com';

final class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

final class _LoginPageState extends ConsumerState<LoginPage> {
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _loading = false;
  bool _googleLoading = false;
  bool _appleLoading = false;

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Future<void> _onLogin() async {
  //   final phone = _phoneController.text.trim();
  //   final password = _passwordController.text.trim();

  //   if (phone.isEmpty || password.isEmpty) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(content: Text('Please fill in all fields')),
  //     );
  //     return;
  //   }

  //   setState(() => _loading = true);

  //   try {
  //     final repo = ref.read(authRepositoryProvider);
  //     final loginData = await repo.login(phone, password);
  //     await AuthResult.login(loginData);

  //     if (context.mounted) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text('Welcome ${loginData.nickname}!')),
  //       );
  //       context.go('/');
  //     }
  //   } catch (e) {
  //     if (context.mounted) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text('Login failed: $e')),
  //       );
  //     }
  //   } finally {
  //     if (mounted) setState(() => _loading = false);
  //   }
  // }

  Future<void> _handleGoogleLogin() async {
    if (kGoogleClientId.isEmpty) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Google 登录未配置: 请先设置 CLIENT_ID (见 login_page.dart 顶部说明)')),
        );
      }
      return;
    }

    setState(() => _googleLoading = true);
    try {
      final googleSignIn = GoogleSignIn(clientId: kGoogleClientId);
      final account = await googleSignIn.signIn();
      if (account == null) return; // 用户取消

      final auth = await account.authentication;
      final idToken = auth.idToken;
      if (idToken == null) {
        throw Exception('Failed to get Google idToken');
      }

      Map<String, String> params = {
        "openid": auth.idToken ?? "", //  result.user.userID ?? "",
        "nickname": account.displayName ?? "",
        "email": account.email,
        "avatar": account.photoUrl ?? "",
        "verify_token": auth.accessToken ?? "",
        "account_type": "2"//账户类型:1=facebook,2=google,3=apple
    };


      final repo = ref.read(authRepositoryProvider);
      final loginData = await repo.login(params);
      await AuthResult.login(loginData);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Welcome ${loginData.nickname}!')),
        );
        context.go('/');
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Google login failed: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _googleLoading = false);
    }
  }

  Future<void> _handleAppleLogin() async {
    setState(() => _appleLoading = true);
    try {
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );
      final idToken = credential.identityToken;
      if (idToken == null) {
        throw Exception('Failed to get Apple identityToken');
      }

      final repo = ref.read(authRepositoryProvider);
      final loginData = await repo.loginWithSocial(
        provider: 'apple',
        idToken: idToken,
        authorizationCode: credential.authorizationCode,
      );
      await AuthResult.login(loginData);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Welcome ${loginData.nickname}!')),
        );
        context.go('/');
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Apple login failed: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _appleLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topLeft,
            colors: [Color(0xFF1CDBC7), Color(0xFF0DD4D1)],
          ),
          image: DecorationImage(
            image: AssetImage('assets/images/login_bg.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(48),
          child: Column(
            children: [
              SizedBox(height: 112),
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset(
                  'assets/images/app_icon.png',
                  width: 88,
                  height: 88,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(height: 12),
              Text(
                'HiPlay',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              SizedBox(height: 62),

              PrimaryButton(
                leading: Image.asset(
                  'assets/images/login_fbicon.png',
                  width: 20,
                  height: 20,
                  fit: BoxFit.cover,
                ),
                onPressed: () {
                  // Facebook login — TBD
                },
                child: Text("Sign in with Facebook"),
              ),
              SizedBox(height: 20),
              PrimaryButton(
                loading: _appleLoading,
                leading: Image.asset(
                  'assets/images/login_appleicon.png',
                  width: 20,
                  height: 20,
                  fit: BoxFit.cover,
                ),
                onPressed: () {
                  if (_appleLoading) return;
                  _handleAppleLogin();

                },
                child: Text("Sign in with Apple"),
              ),
              SizedBox(height: 20),
              PrimaryButton(
                loading: _googleLoading,
                leading: Image.asset(
                  'assets/images/login_googleicon.png',
                  width: 20,
                  height: 20,
                  fit: BoxFit.cover,
                ),
                onPressed: (){
                  if (_googleLoading) return;
                  _handleGoogleLogin();
                },
                child: Text("Sign in with Google"),
              ),
              SizedBox(height: 55),
              RichClickableText(
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0x99FFFFFF),
                ),
                children: [
                  const ClickableTextSpan(
                    text: "登录即表示你同意 ",
                  ),
                  ClickableTextSpan(
                    text: "用户协议",
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                    onTap: () => context.push(
                      '/webview?url=${Uri.encodeQueryComponent('https://gray-api.yayuesocialtest.com/privacy/user.html')}&title=${Uri.encodeQueryComponent('用户协议')}',
                    ),
                  ),
                  const ClickableTextSpan(
                    text: "和",
                  ),
                  ClickableTextSpan(
                    text: "隐私政策",
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                    onTap: () => context.push(
                      '/webview?url=${Uri.encodeQueryComponent('https://gray-api.yayuesocialtest.com/privacy/user.html')}&title=${Uri.encodeQueryComponent('隐私政策')}',
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
