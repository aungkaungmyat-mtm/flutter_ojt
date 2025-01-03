import 'package:flutter_ojt/repositories/userdata/user_data_repository.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final userDataRepositoryProvider = Provider<UserDataRepository>((ref) {
  return UserDataRepository();
});

final profileImageUrlProvider = StateProvider<String?>((ref) => null);
