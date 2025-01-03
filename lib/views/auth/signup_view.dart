import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_ojt/assets/assets.gen.dart';
import 'package:flutter_ojt/config/logger.dart';
import 'package:flutter_ojt/customs/widgets/loading_overlay_widget.dart';
import 'package:flutter_ojt/viewmodels/providers/auth/auth_providers.dart';
import 'package:flutter_ojt/viewmodels/providers/common_providers.dart';
import 'package:flutter_ojt/views/auth/login_view.dart';
import 'package:flutter_ojt/views/main_view.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SignupView extends HookConsumerWidget {
  const SignupView({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey = useMemoized(() => GlobalKey<FormState>());
    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();
    final obscureText = useState(true);
    final isLoading = ref.read(isLoadingProvider.notifier);
    final userRepository = ref.read(authUserRepositoryProvider);

    return LoadingOverlayWidget(
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Sign Up'),
          ),
          backgroundColor: Colors.white,
          body: Center(
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.7,
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
                            // Regular expression for basic email validation
                            const String emailPattern =
                                r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$';
                            final RegExp regex = RegExp(emailPattern);

                            if (!regex.hasMatch(value)) {
                              return 'Please enter a valid email address';
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
                              if (formKey.currentState?.validate() ?? false) {
                                try {
                                  isLoading.state = true;
                                  final email = emailController.text.trim();
                                  final password =
                                      passwordController.text.trim();
                                  await userRepository.signup(
                                    email: email,
                                    password: password,
                                  );
                                  scaffoldMessengerKey.currentState
                                      ?.showSnackBar(
                                    const SnackBar(
                                      content:
                                          Text('User Successfully Registered'),
                                    ),
                                  );
                                  if (!context.mounted) return;
                                  Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const LoginView()),
                                  );
                                } on FirebaseAuthException catch (e) {
                                  logger.e("Error during signup: ${e.message}");
                                  scaffoldMessengerKey.currentState
                                      ?.showSnackBar(
                                    SnackBar(
                                      content: Text(
                                          'Error during signup: ${e.message}'),
                                    ),
                                  );
                                } finally {
                                  isLoading.state = false;
                                }
                              }
                            },
                            child: isLoading.state
                                ? CircularProgressIndicator()
                                : const Text('Sign Up')),
                        const SizedBox(
                          height: 20,
                        ),
                        RichText(
                          text: TextSpan(
                            text: 'Already have an account? ',
                            style: const TextStyle(color: Colors.blue),
                            children: [
                              TextSpan(
                                text: 'Login',
                                style: const TextStyle(color: Colors.redAccent),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => const LoginView(),
                                      ),
                                    );
                                  },
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        const Text('Or'),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Flexible(
                              child: ElevatedButton.icon(
                                onPressed: () async {
                                  try {
                                    isLoading.state = true;
                                    await userRepository.googleSignIn();

                                    scaffoldMessengerKey.currentState!
                                        .showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                            "User Successfully Registered"),
                                      ),
                                    );
                                    if (!context.mounted) return;

                                    final user =
                                        FirebaseAuth.instance.currentUser;

                                    if (user != null) {
                                      Navigator.of(context).pushReplacement(
                                        MaterialPageRoute(
                                          builder: (context) => MainView(),
                                        ),
                                      );
                                    }
                                  } on FirebaseAuthException catch (e) {
                                    String errorMessage =
                                        'Sign up failed, please try again';
                                    if (e.code == 'weak-password') {
                                      errorMessage = 'The password is too weak';
                                    } else if (e.code ==
                                        'email-already-in-use') {
                                      errorMessage =
                                          'The email is already registered';
                                    }

                                    scaffoldMessengerKey.currentState!
                                        .showSnackBar(
                                      SnackBar(
                                        content: Text(errorMessage),
                                      ),
                                    );
                                  } finally {
                                    isLoading.state = false;
                                  }
                                },
                                label: const Text('Sign up with Google'),
                                icon: SvgPicture.asset(
                                  Assets.icons.googleLogoIcon,
                                  width:
                                      MediaQuery.of(context).size.width * 0.07,
                                ),
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.all(5),
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
