import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_ojt/assets/assets.gen.dart';
import 'package:flutter_ojt/viewmodels/providers/auth/auth_providers.dart';
import 'package:flutter_ojt/viewmodels/providers/common_providers.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';

class ProfileView extends HookConsumerWidget {
  const ProfileView({super.key, required this.user});
  final auth.User user;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey = GlobalKey<FormState>();
    final authStateNotifier = ref.watch(authStateNotifierProvider.notifier);
    final authState = ref.watch(authStateNotifierProvider);
    final userData = authState.user?.userData;

    // Initialize controllers with existing user data
    final nameController = useTextEditingController(text: userData?.name ?? '');
    final emailController = useTextEditingController(text: user.email ?? '');

    // Dispose controllers when the widget is disposed
    useEffect(() {
      return () {
        nameController.dispose();
        emailController.dispose();
      };
    }, []);

    // // Handle profile update
    // Future<void> _updateProfile() async {
    //   if (formKey.currentState!.validate()) {
    //     try {
    //       await authStateNotifier.updateUserProfile(
    //         name: nameController.text,
    //         email: emailController.text,
    //         userId: user.uid,
    //       );
    //       ScaffoldMessenger.of(context).showSnackBar(
    //         const SnackBar(content: Text('Profile updated successfully')),
    //       );
    //     } catch (e) {
    //       ScaffoldMessenger.of(context).showSnackBar(
    //         SnackBar(content: Text('Failed to update profile: $e')),
    //       );
    //     }
    //   }
    // }

    return Center(
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.7,
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Profile picture section
              GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (context) => SafeArea(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ListTile(
                            leading: const Icon(Icons.camera),
                            title: const Text('Take a photo'),
                            onTap: () async {
                              try {
                                await authStateNotifier.pickImage(
                                    source: ImageSource.camera,
                                    ref: ref,
                                    userId: user.uid);
                                if (context.mounted) Navigator.pop(context);
                              } catch (e) {
                                scaffoldMessengerKey.currentState?.showSnackBar(
                                  SnackBar(
                                      content:
                                          Text('Failed to update profile: $e')),
                                );
                              }
                            },
                          ),
                          ListTile(
                            leading: const Icon(Icons.photo_library),
                            title: const Text('Choose from gallery'),
                            onTap: () {
                              try {
                                authStateNotifier.pickImage(
                                    source: ImageSource.gallery,
                                    ref: ref,
                                    userId: user.uid);
                                Navigator.pop(context);
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content:
                                          Text('Failed to update profile: $e')),
                                );
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
                child: CircleAvatar(
                  radius: 80,
                  backgroundImage: userData?.profileImageUrl != null
                      ? NetworkImage(userData!.profileImageUrl)
                      : AssetImage(Assets.images.profilePlaceholderImg.path)
                          as ImageProvider,
                ),
              ),
              const SizedBox(height: 20),

              // Form section
              Form(
                key: formKey,
                child: Column(
                  children: [
                    // Name field
                    TextFormField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        labelText: 'Name',
                        hintText: 'Enter your name',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Email field
                    TextFormField(
                      controller: emailController,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        hintText: 'Enter your email',
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        if (!value.contains('@')) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 32),

                    // Update button
                    ElevatedButton(
                      onPressed: null,
                      child: const Text('Update Profile'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
