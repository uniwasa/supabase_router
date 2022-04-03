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
    urlPathStrategy: UrlPathStrategy.path,
    routes: [
      GoRoute(
        name: 'home',
        path: '/',
        builder: (context, state) => const AccountPage(),
      ),
      GoRoute(
        name: 'splash',
        path: '/splash',
        builder: (context, state) => const SplashPage(),
      ),
      GoRoute(
        name: 'login',
        path: '/login',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: '/example',
        builder: (context, state) => const ExamplePage(),
      ),
    ],
    redirect: (state) {
      final session = ref.read(authControllerProvider).session;
      return session.when(
        data: (data) {
          final goingToSplash = state.location == state.namedLocation('splash');
          if (goingToSplash) return state.namedLocation('home');

          final loggedIn = ref.read(authControllerProvider).loggedIn;
          final loginLoc = state.namedLocation('login');
          final goingToLogin = state.subloc == loginLoc;

          final homeLoc = state.namedLocation('home');
          final fromLoc = state.subloc == homeLoc ? '' : state.subloc;
          if (!loggedIn) {
            return goingToLogin
                ? null
                : state.namedLocation(
                    'login',
                    queryParams: {if (fromLoc.isNotEmpty) 'from': fromLoc},
                  );
          }

          if (goingToLogin) return state.queryParams['from'] ?? homeLoc;

          return null;
        },
        error: (error, stack) => null,
        loading: () {
          final splashLoc = state.namedLocation('splash');
          final goingToSplash = state.subloc == splashLoc;
          if (!goingToSplash) return splashLoc;
          return null;
        },
      );
    },
    refreshListenable: ref.watch(authControllerProvider),
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routeInformationParser: _router.routeInformationParser,
      routerDelegate: _router.routerDelegate,
      theme: ThemeData.dark().copyWith(
        primaryColor: Colors.green,
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            primary: Colors.green,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            onPrimary: Colors.white,
            primary: Colors.green,
          ),
        ),
      ),
    );
  }
}
