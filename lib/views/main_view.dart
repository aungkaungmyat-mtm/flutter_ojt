import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_ojt/assets/assets.gen.dart';
import 'package:flutter_ojt/config/logger.dart';
import 'package:flutter_ojt/viewmodels/providers/auth/auth_providers.dart';
import 'package:flutter_ojt/viewmodels/providers/common_providers.dart';
import 'package:flutter_ojt/views/auth/login_view.dart';
import 'package:flutter_ojt/views/home/home_view.dart';
import 'package:flutter_ojt/views/profile/profile_view.dart';
import 'package:flutter_ojt/views/todo/todo_view.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class MainView extends HookConsumerWidget {
  const MainView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authUserRepository = ref.read(authUserRepositoryProvider);
    final isLoading = ref.read(isLoadingProvider.notifier);
    final selectedIndex = useState(1);
    final titleText = ['Todo', 'Home', 'Profile'];
    final authUserAsync = ref.watch(authUserStreamProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('${titleText[selectedIndex.value]} View'),
        actions: [
          GestureDetector(
            onTap: () async {
              try {
                isLoading.state = true;
                authUserRepository.logout();
                scaffoldMessengerKey.currentState?.showSnackBar(
                  const SnackBar(
                    content: Text('User Logged Out'),
                  ),
                );
                if (!context.mounted) return;
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => const LoginView()),
                );
              } on FirebaseAuthException catch (e) {
                logger.e('Error during logout: ${e.message}');
                scaffoldMessengerKey.currentState?.showSnackBar(
                  SnackBar(
                    content: Text('Error during logout: ${e.message}'),
                  ),
                );
              } finally {
                isLoading.state = false;
              }
            },
            child: Container(
              margin: const EdgeInsets.all(20),
              alignment: Alignment.center,
              width: 37,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
              ),
              child: isLoading.state
                  ? CircularProgressIndicator()
                  : SvgPicture.asset(
                      Assets.icons.logoutIcon,
                    ),
            ),
          )
        ],
      ),
      body: authUserAsync.when(
        data: (authUser) {
          final screens = [
            const TodoView(),
            const HomeView(),
            if (authUser != null) ProfileView(user: authUser),
          ];

          return screens[selectedIndex.value];
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) {
          selectedIndex.value = index; // Update the selected tab
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.note_add,
              color: Colors.black,
            ),
            activeIcon: Icon(
              Icons.note_add,
              color: Colors.yellow,
            ),
            label: 'Todo',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person,
              color: Colors.blue,
            ),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
