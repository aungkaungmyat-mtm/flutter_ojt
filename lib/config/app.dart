import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_ojt/viewmodels/providers/auth/auth_providers.dart';
import 'package:flutter_ojt/viewmodels/providers/common_providers.dart';
import 'package:flutter_ojt/views/auth/signup_view.dart';
import 'package:flutter_ojt/views/main_view.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class MyApp extends HookConsumerWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authUser = ref.watch(authUserStreamProvider);
    final authStateNotifier = ref.watch(authStateNotifierProvider.notifier);

    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      scaffoldMessengerKey: scaffoldMessengerKey,
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: authUser.when(
        data: (user) {
          if (user != null) {
            useEffect(() {
              authStateNotifier.getUserFuture(authUserId: user.uid);
              return null;
            }, [user]);
            return const MainView();
          } else {
            return const SignupView();
          }
        },
        loading: () => const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        ),
        error: (error, stackTrace) {
          return Scaffold(
            body: Center(
              child: Text('Error: $error'),
            ),
          );
        },
      ),
    );
  }
}
