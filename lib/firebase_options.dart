import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

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
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'YOUR-WEB-API-KEY',
    appId: 'YOUR-WEB-APP-ID',
    messagingSenderId: 'YOUR-SENDER-ID',
    projectId: 'kisan-sevak',
    authDomain: 'kisan-sevak.firebaseapp.com',
    storageBucket: 'kisan-sevak.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'YOUR-ANDROID-API-KEY',
    appId: 'YOUR-ANDROID-APP-ID',
    messagingSenderId: 'YOUR-SENDER-ID',
    projectId: 'kisan-sevak',
    storageBucket: 'kisan-sevak.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'YOUR-IOS-API-KEY',
    appId: 'YOUR-IOS-APP-ID',
    messagingSenderId: 'YOUR-SENDER-ID',
    projectId: 'kisan-sevak',
    storageBucket: 'kisan-sevak.appspot.com',
    iosClientId: 'YOUR-IOS-CLIENT-ID',
    iosBundleId: 'com.kisansevak.app',
  );
} 