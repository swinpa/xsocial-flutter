import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../features/auth/models/login_response.dart';
import '../features/auth/pages/login_page.dart';
import '../common/widget/webview_page.dart';

/// 根据登录状态自动跳转的路由配置。
final goRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    redirect: (context, state) {
      final loggedIn = AuthResult.info != null;
      final onLogin = state.matchedLocation == '/login';
      final onWebview = state.matchedLocation == '/webview';

      // 未登录且不在登录页/webview → 跳转登录页
      if (!loggedIn && !onLogin && !onWebview) return '/login';
      // 已登录且在登录页 → 跳转首页
      if (loggedIn && onLogin) return '/';

      return null;
    },
    routes: [
      GoRoute(
        path: '/',
        name: 'home',
        builder: (context, state) => const PlaceholderPage(title: 'Home'),
      ),
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: '/webview',
        name: 'webview',
        builder: (context, state) {
          final url = state.uri.queryParameters['url'] ?? '';
          final title = state.uri.queryParameters['title'] ?? '';
          return WebViewPage(url: url, title: title);
        },
      ),
    ],
  );
});

final router = GoRouter(
  initialLocation: '/',
  redirect: (context, state) {
    final loggedIn = AuthResult.info != null;
    final onLogin = state.matchedLocation == '/login';
    final onWebview = state.matchedLocation == '/webview';

    if (!loggedIn && !onLogin && !onWebview) return '/login';
    if (loggedIn && onLogin) return '/';

    return null;
  },
  routes: [
    GoRoute(
      path: '/',
      name: 'home',
      builder: (context, state) => const PlaceholderPage(title: 'Home'),
    ),
    GoRoute(
      path: '/login',
      name: 'login',
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: '/webview',
      name: 'webview',
      builder: (context, state) {
        final url = state.uri.queryParameters['url'] ?? '';
        final title = state.uri.queryParameters['title'] ?? '';
        return WebViewPage(url: url, title: title);
      },
    ),
  ],
);

/// Placeholder pages — replace with real screens.
class PlaceholderPage extends StatelessWidget {
  const PlaceholderPage({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('This is a placeholder page.'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                await AuthResult.logout();
                if (context.mounted) context.go('/login');
              },
              child: const Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }
}
