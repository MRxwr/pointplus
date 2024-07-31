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
    apiKey: 'AIzaSyD6GnAGNK4W3N2OGK1p61q3dxt4q87LFhA',
    appId: '1:25953648734:android:08ce1eab1d0d2287c674cf',
    messagingSenderId: '25953648734',
    projectId: 'points-a1a14',
    storageBucket: 'points-a1a14.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBXgDtkiPPYXxw0H_hyjvlLcsEhYm8NRcE',
    appId: '1:25953648734:ios:824b3223086b222ec674cf',
    messagingSenderId: '25953648734',
    projectId: 'points-a1a14',
    storageBucket: 'points-a1a14.appspot.com',
    androidClientId: '25953648734-1f6f1hm32od0rkp6paq70aul0n14dgrm.apps.googleusercontent.com',
    iosClientId: '25953648734-ogb1s2jmuhfijso5fefs08tal74lj5fp.apps.googleusercontent.com',
    iosBundleId: 'com.createco.pointplus',
  );
}
