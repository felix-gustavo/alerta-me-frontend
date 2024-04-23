import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../ui/pages/home_page/index.dart';
import '../ui/pages/login_page/index.dart';
import '../ui/pages/not_found_page/index.dart';

GoRouter getRouter() => GoRouter(
      initialLocation: '/home',
      redirect: (context, goRouterState) async {
        final isLoginRoute = goRouterState.location == '/login';

        if (FirebaseAuth.instance.currentUser == null) {
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
