import 'dart:html';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../stores/auth/auth_store.dart';
import '../ui/pages/home_page/index.dart';
import '../ui/pages/login_page/index.dart';
import '../ui/pages/not_found_page/index.dart';
import '../ui/pages/skill_logged_page/index.dart';
import '../ui/pages/skill_login_page/index.dart';

GoRouter getRoutes(BuildContext context) {
  final authStore = Provider.of<AuthStore>(context, listen: false);

  return GoRouter(
    initialLocation: '/home',
    refreshListenable: authStore.isAuthenticated,
    redirect: (context, goRouterState) async {
      final uri = Uri.parse(window.location.href);
      Map<String, dynamic> queryParameters = Map.from(uri.queryParameters);

      final clientId = queryParameters['client_id'];
      const clientIdEnv = String.fromEnvironment('CLIENT_ID');

      bool isAuthorized = clientId == clientIdEnv;

      if (authStore.isAuthenticated.value) {
        return isAuthorized ? '/skill-logged' : '/home';
      }

      if (isAuthorized) return '/skill-login';

      switch (goRouterState.location) {
        case '/home':
          return '/login';
        case '/skill-login' || '/skill-logged':
          return '/not-found';
        default:
          return null;
      }
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
      GoRoute(
        path: '/skill-login',
        builder: (context, state) => const SelectionArea(
          child: SkillLoginPage(),
        ),
      ),
      GoRoute(
        path: '/skill-logged',
        builder: (context, state) => const SelectionArea(
          child: SkillLoggedPage(),
        ),
      ),
    ],
  );
}
