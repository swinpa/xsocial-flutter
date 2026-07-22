import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../providers/auth_provider.dart';
import '../models/login_response.dart';
import '../widgets/login_button.dart';
import '../../../common/widget/rich_text.dart';

final class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

final class _LoginPageState extends ConsumerState<LoginPage> {
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _loading = false;

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _onLogin() async {
    final phone = _phoneController.text.trim();
    final password = _passwordController.text.trim();

    if (phone.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }

    setState(() => _loading = true);

    try {
      final repo = ref.read(authRepositoryProvider);
      final loginData = await repo.login(phone, password);
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
          SnackBar(content: Text('Login failed: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _loading = false);
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
        child: 
        
        
        
        Padding(
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
                  
                },
                child: Text("Sign in with Facebook"),
              ),
              SizedBox(height: 20),
              PrimaryButton(
                
                leading: Image.asset(
                          'assets/images/login_appleicon.png',
                          width: 20,
                          height: 20,
                          fit: BoxFit.cover,
                        ),
                onPressed: () {
                  
                },
                child: Text("Sign in with Apple"),
              ),
              SizedBox(height: 20),
              PrimaryButton(
                
                leading: Image.asset(
                          'assets/images/login_googleicon.png',
                          width: 20,
                          height: 20,
                          fit: BoxFit.cover,
                        ),
                onPressed: () {
                  
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
              )
            ],
          ),
        ),
      ),
    );
  }
}
