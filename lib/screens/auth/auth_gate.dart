import 'package:android_dev/screens/auth/login_screen.dart';
import 'package:android_dev/screens/auth/providers/auth_providers.dart';
import 'package:android_dev/screens/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// First screen of the app: logged in -> MainScreen, logged out -> LoginScreen.
class AuthGate extends ConsumerWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    return user.when(
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (error, _) =>
          Scaffold(body: Center(child: Text('Could not open database: $error'))),
      data: (user) => user == null ? const LoginScreen() : const MainScreen(),
    );
  }
}
