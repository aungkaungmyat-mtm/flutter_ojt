import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final isLoadingProvider = StateProvider<bool>((ref) => false);

final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();
