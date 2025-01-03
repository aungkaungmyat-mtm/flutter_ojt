import 'package:flutter/material.dart';
import 'package:flutter_ojt/viewmodels/providers/common_providers.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class LoadingOverlayWidget extends HookConsumerWidget {
  const LoadingOverlayWidget({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(isLoadingProvider);
    return Stack(children: [
      child,
      if (isLoading)
        const Opacity(
          opacity: 0.8,
          child: ModalBarrier(dismissible: false, color: Colors.black),
        ),
      if (isLoading)
        const Center(
          child: CircularProgressIndicator(color: Colors.white),
        )
    ]);
  }
}
