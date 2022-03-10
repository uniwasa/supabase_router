import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final authControllerProvider = ChangeNotifierProvider<AuthController>((ref) {
  return AuthController();
});

class AuthController extends ChangeNotifier {
  late final GotrueSubscription _subscription;
  Session? session;
  AuthController() : super() {
    Supabase.instance.client.auth.refreshSession();
    Supabase.instance.client.auth.onAuthStateChange((event, session) {
      print('状態変更');
      this.session = session;
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _subscription.data?.unsubscribe();
    super.dispose();
  }
}
