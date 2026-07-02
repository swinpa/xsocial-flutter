import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// The GoRouter configuration for XSocial.
final goRouterProvider = Provider<GoRouter>((ref) {
  return router;
});

final router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      name: 'home',
      builder: (context, state) => const PlaceholderPage(title: 'Home'),
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
      body: const Center(child: Text('Placeholder')),
    );
  }
}
