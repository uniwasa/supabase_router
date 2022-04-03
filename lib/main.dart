import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:supabase_quickstart/config.dart';

import 'app.dart';

Future<void> main() async {
  final config = Config();
  print(config.supabaseAnonKey);
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: config.supabaseUrl,
    anonKey: config.supabaseAnonKey,
  );
  runApp(const ProviderScope(child: MyApp()));
}
