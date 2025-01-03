// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        return windows;
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCFMEASLyx2WS8VdDS3T5FjXcalKHcJOB8',
    appId: '1:740616161713:web:238216132030ec613a1590',
    messagingSenderId: '740616161713',
    projectId: 'flutter-ojt-af746',
    authDomain: 'flutter-ojt-af746.firebaseapp.com',
    storageBucket: 'flutter-ojt-af746.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyC-n5K24xcdz-zSWPCoEFA8inJeFR2pGZs',
    appId: '1:740616161713:android:0e174d4bb6ee98c53a1590',
    messagingSenderId: '740616161713',
    projectId: 'flutter-ojt-af746',
    storageBucket: 'flutter-ojt-af746.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCk2Hob3yjopcG6Qe9RQCONAt1PlLKdmJc',
    appId: '1:740616161713:ios:4da8f632c3cbd0cb3a1590',
    messagingSenderId: '740616161713',
    projectId: 'flutter-ojt-af746',
    storageBucket: 'flutter-ojt-af746.firebasestorage.app',
    iosBundleId: 'com.example.flutterOjt',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCk2Hob3yjopcG6Qe9RQCONAt1PlLKdmJc',
    appId: '1:740616161713:ios:4da8f632c3cbd0cb3a1590',
    messagingSenderId: '740616161713',
    projectId: 'flutter-ojt-af746',
    storageBucket: 'flutter-ojt-af746.firebasestorage.app',
    iosBundleId: 'com.example.flutterOjt',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyCFMEASLyx2WS8VdDS3T5FjXcalKHcJOB8',
    appId: '1:740616161713:web:a8f41273e60374203a1590',
    messagingSenderId: '740616161713',
    projectId: 'flutter-ojt-af746',
    authDomain: 'flutter-ojt-af746.firebaseapp.com',
    storageBucket: 'flutter-ojt-af746.firebasestorage.app',
  );
}
