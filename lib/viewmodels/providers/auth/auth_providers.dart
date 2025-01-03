import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter_ojt/repositories/auth/auth_user_repository.dart';
import 'package:flutter_ojt/viewmodels/notifiers/auth/auth_state.dart';
import 'package:flutter_ojt/viewmodels/notifiers/auth/auth_state_notifier.dart';
import 'package:flutter_ojt/viewmodels/providers/user/user_providers.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final authStateNotifierProvider =
    StateNotifierProvider<AuthStateNotifier, AuthState>((ref) {
  final authUserRepository = ref.watch(authUserRepositoryProvider);
  final userDataRepository = ref.watch(userDataRepositoryProvider);

  return AuthStateNotifier(authUserRepository, userDataRepository);
});

final authUserRepositoryProvider = Provider<AuthUserRepository>((ref) {
  return AuthUserRepository();
});

final authUserStreamProvider = StreamProvider.autoDispose<auth.User?>((ref) {
  return ref.watch(authUserRepositoryProvider).authUserStream();
});
