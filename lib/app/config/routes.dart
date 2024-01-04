import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../stores/auth/auth_store.dart';
import '../ui/pages/home_page/index.dart';
import '../ui/pages/login_page/index.dart';
import '../ui/pages/not_found_page/index.dart';

GoRouter getRoutes(BuildContext context) {
  final authStore = Provider.of<AuthStore>(context, listen: false);

  return GoRouter(
    initialLocation: '/home',
    refreshListenable: authStore.isAuthenticated,
    redirect: (context, goRouterState) async {
      final isLoginRoute = goRouterState.location == '/login';

      if (!authStore.isAuthenticated.value) {
        return isLoginRoute ? null : '/login';
      }
      if (isLoginRoute) return '/home';

      return null;
    },
    errorBuilder: (context, state) => const NotFoundPage(),
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const SelectionArea(child: LoginPage()),
      ),
      GoRoute(
        path: '/home',
        builder: (context, state) => const SelectionArea(child: HomePage()),
      ),
    ],
  );
}
