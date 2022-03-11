import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final authControllerProvider = ChangeNotifierProvider<AuthController>((ref) {
  return AuthController();
});

class AuthController extends ChangeNotifier {
  late final GotrueSubscription _subscription;
  AsyncValue<Session?> session;
  AuthController()
      : session = const AsyncLoading(),
        super() {
    init();
  }

  Future<void> init() async {
    Supabase.instance.client.auth.onAuthStateChange((event, session) {
      print('状態変更');
      this.session = AsyncData(session);
      notifyListeners();
    });

    // await Future.delayed(const Duration(seconds: 2));
    final session = await Supabase.instance.client.auth.refreshSession();
    // 未ログイン時はonAuthStateChange走らないので、自分で設定
    if (session.data == null) {
      this.session = const AsyncData(null);
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _subscription.data?.unsubscribe();
    super.dispose();
  }
}
