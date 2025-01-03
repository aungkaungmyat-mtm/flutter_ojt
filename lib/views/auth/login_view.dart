import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_ojt/config/logger.dart';
import 'package:flutter_ojt/viewmodels/providers/auth/auth_providers.dart';
import 'package:flutter_ojt/viewmodels/providers/common_providers.dart';
import 'package:flutter_ojt/views/auth/signup_view.dart';
import 'package:flutter_ojt/views/main_view.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class LoginView extends HookConsumerWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    final isLoading = ref.read(isLoadingProvider.notifier);
    final obscureText = useState(true);
    final userRepository = ref.read(authUserRepositoryProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Login Page'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(left: 100, right: 100),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Form(
                key: formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: emailController,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        hintText: 'example@gmail.com',
                      ),
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'Email is required';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: passwordController,
                      obscureText: obscureText.value,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        hintText: '********',
                        suffixIcon: IconButton(
                          onPressed: () =>
                              obscureText.value = !obscureText.value,
                          icon: Icon(
                            obscureText.value
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                        ),
                      ),
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'Password is required';
                        }
                        if (value.length < 8) {
                          return 'Password must be at least 8 characters';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        if (!formKey.currentState!.validate()) return;
                        try {
                          isLoading.state = true;
                          final email = emailController.text.trim();
                          final password = passwordController.text.trim();
                          await userRepository.login(
                              email: email, password: password);

                          final authUser = FirebaseAuth.instance.currentUser;
                          logger.i('authUser:  $authUser');
                          if (authUser != null) {
                            scaffoldMessengerKey.currentState?.showSnackBar(
                              const SnackBar(
                                content: Text("Login Successful"),
                              ),
                            );
                            if (!context.mounted) return;
                            Navigator.of(context).pushAndRemoveUntil<void>(
                              MaterialPageRoute(
                                builder: (context) => MainView(),
                              ),
                              (route) => false,
                            );
                          } else {
                            scaffoldMessengerKey.currentState?.showSnackBar(
                              const SnackBar(
                                content: Text(
                                    "No user found after sign-in. Please try again."),
                              ),
                            );
                          }
                        } on FirebaseAuthException catch (e) {
                          String errorMessage =
                              'No account found with this email address.';
                          if (e.code == 'user-not-found') {
                            errorMessage = 'The email or password is incorrect';
                          }
                          logger.e('error during sign in: ${e.message}');
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(errorMessage),
                              ),
                            );
                          }
                        } finally {
                          isLoading.state = false;
                        }
                      },
                      child: isLoading.state
                          ? const CircularProgressIndicator(
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            )
                          : const Text('Login'),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              RichText(
                text: TextSpan(
                  text: 'Don\'t have an account? ',
                  style: const TextStyle(color: Colors.blue),
                  children: [
                    TextSpan(
                      text: 'Sign Up',
                      style: const TextStyle(color: Colors.redAccent),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Navigator.of(context).pushAndRemoveUntil<void>(
                            MaterialPageRoute(
                              builder: (context) => const SignupView(),
                            ),
                            (route) => false,
                          );
                        },
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
