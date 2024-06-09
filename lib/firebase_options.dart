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

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyD8-NohmEk8bwuOmSDBfL3k95o2gMd2yrU',
    appId: '1:175008199258:web:57c4aaa5b28f8577f85e63',
    messagingSenderId: '175008199258',
    projectId: 'meta-app-a9df7',
    authDomain: 'meta-app-a9df7.firebaseapp.com',
    storageBucket: 'meta-app-a9df7.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCh4ltBS62TXUtfIFwKdfXY5vYqd6TddUs',
    appId: '1:175008199258:android:eb8514aa6bdfb47ef85e63',
    messagingSenderId: '175008199258',
    projectId: 'meta-app-a9df7',
    storageBucket: 'meta-app-a9df7.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyC5d2tUOqmDiX4MtOntDlvOt34HvC40iW4',
    appId: '1:175008199258:ios:23b19bb97a34e005f85e63',
    messagingSenderId: '175008199258',
    projectId: 'meta-app-a9df7',
    storageBucket: 'meta-app-a9df7.appspot.com',
    iosBundleId: 'com.example.metaApp',
  );
}
