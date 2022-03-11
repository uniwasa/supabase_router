import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:supabase_quickstart/auth_controller.dart';

import 'package:supabase_quickstart/pages/account_page.dart';
import 'package:supabase_quickstart/pages/example_page.dart';
import 'package:supabase_quickstart/pages/login_page.dart';
import 'package:supabase_quickstart/pages/splash_page.dart';

class MyApp extends ConsumerStatefulWidget {
  const MyApp({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  late final _router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const SplashPage(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: '/account',
        builder: (context, state) => const AccountPage(),
      ),
      GoRoute(
        path: '/example',
        builder: (context, state) => const ExamplePage(),
      ),
    ],
    redirect: (state) {
      // locationを保存するプロバイダかなんかを用意すればいいかな。
      print(state.location);
      print(ref.read(authControllerProvider).session);

      final session = ref.read(authControllerProvider).session;

      return session.when(
        data: (data) {
          final goingToSplash = state.location == '/';
          if (goingToSplash) return '/login';

          final bool loggedIn;
          if (data == null) {
            loggedIn = false;
          } else {
            loggedIn = true;
          }

          final goingToLogin = state.location == '/login';
          if (!loggedIn && !goingToLogin) {
            print('ログインにリダイレクト');
            return '/login';
          }

          if (loggedIn && goingToLogin) {
            print('アカウントにリダイレクト');
            return '/account';
          }

          print('リダイレクトしません');
          return null;
        },
        error: (error, stack) => null,
        loading: () => null,
      );
    },
    refreshListenable: ref.watch(authControllerProvider),
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routeInformationParser: _router.routeInformationParser,
      routerDelegate: _router.routerDelegate,
    );
  }
}
