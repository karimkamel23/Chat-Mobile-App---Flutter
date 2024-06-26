// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyC3WKGi7o3heiZZpJnuApM2iPTJSvNsMV4',
    appId: '1:506437893789:web:1c1e589f1159b7cc869e74',
    messagingSenderId: '506437893789',
    projectId: 'chatapp-c7e12',
    authDomain: 'chatapp-c7e12.firebaseapp.com',
    storageBucket: 'chatapp-c7e12.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCAdC2rsrtIJ22u7g6FIwv8_hd7oOuGRtU',
    appId: '1:506437893789:android:abc6e522a38084a6869e74',
    messagingSenderId: '506437893789',
    projectId: 'chatapp-c7e12',
    storageBucket: 'chatapp-c7e12.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCEMuwxFaGl7oXwYVv5tfiKaStiDlcP-d8',
    appId: '1:506437893789:ios:3bb3b498402b0402869e74',
    messagingSenderId: '506437893789',
    projectId: 'chatapp-c7e12',
    storageBucket: 'chatapp-c7e12.appspot.com',
    iosBundleId: 'com.example.chatapp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCEMuwxFaGl7oXwYVv5tfiKaStiDlcP-d8',
    appId: '1:506437893789:ios:0864b83cadbee4db869e74',
    messagingSenderId: '506437893789',
    projectId: 'chatapp-c7e12',
    storageBucket: 'chatapp-c7e12.appspot.com',
    iosBundleId: 'com.example.chatapp.RunnerTests',
  );
}
