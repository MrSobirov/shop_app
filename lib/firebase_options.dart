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
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAWXLV30kzXfhgBowdQf9VKUXxNpWG7DU8',
    appId: '1:239998286613:android:7f17262c0b6cd66911471c',
    messagingSenderId: '239998286613',
    projectId: 'shopapp-50487',
    databaseURL: 'https://shopapp-50487-default-rtdb.firebaseio.com',
    storageBucket: 'shopapp-50487.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCQn4md0zhjfNfjFrQm1UXK2b1_JrlAEuY',
    appId: '1:239998286613:ios:9573e7f492b40d7211471c',
    messagingSenderId: '239998286613',
    projectId: 'shopapp-50487',
    databaseURL: 'https://shopapp-50487-default-rtdb.firebaseio.com',
    storageBucket: 'shopapp-50487.appspot.com',
    iosClientId: '239998286613-mn36oh991pkqduf1ohne65s41espk5m3.apps.googleusercontent.com',
    iosBundleId: 'com.example.shopApp',
  );
}
