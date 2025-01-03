import 'dart:io';

import 'package:flutter_ojt/config/logger.dart';
import 'package:flutter_ojt/repositories/auth/auth_user_repository.dart';
import 'package:flutter_ojt/repositories/userdata/user_data_repository.dart';
import 'package:flutter_ojt/viewmodels/notifiers/auth/auth_state.dart';
import 'package:flutter_ojt/viewmodels/providers/user/user_providers.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';

class AuthStateNotifier extends StateNotifier<AuthState> {
  AuthStateNotifier(this._authUserRepository, this._userDataRepository)
      : super(AuthState());

  final BaseAuthUserRepository _authUserRepository;
  final BaseUserDataRepository _userDataRepository;

  Future<void> getUserFuture({required String authUserId}) async {
    final authUser =
        await _authUserRepository.getUserFuture(authUserId: authUserId);
    if (authUser == null) {
      await _authUserRepository.createUserProfile(authUserId: authUserId);
      final newUser =
          await _authUserRepository.getUserFuture(authUserId: authUserId);
      state = state.copyWith(user: newUser);
    } else {
      state = state.copyWith(user: authUser);
    }
  }

  Future<String?> pickImage({
    required ImageSource source,
    required WidgetRef ref,
    required String userId,
  }) async {
    try {
      final pickedFile = await ImagePicker().pickImage(source: source);
      if (pickedFile == null) {
        logger.i('No image selected');
        return null;
      }

      logger.i('Picked file: ${pickedFile.path}');

      final file = File(pickedFile.path);

      final imageUrl = await _userDataRepository.uploadProfileImage(
        userId: userId,
        image: file,
      );

      if (imageUrl == null) {
        logger.e('Failed to upload image');
        return null;
      }

      ref.read(profileImageUrlProvider.notifier).state = imageUrl;
      await _authUserRepository.updateUserProfile(
        authUserId: userId,
        updates: {'userData.profileImageUrl': imageUrl},
      );

      logger.i('Profile image updated successfully');
      return imageUrl;
    } catch (e, stackTrace) {
      logger.e(
        'Error during image picking or upload',
        error: e,
        stackTrace: stackTrace,
      );
      return null;
    }
  }
}
