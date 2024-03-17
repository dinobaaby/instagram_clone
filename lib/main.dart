
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebaseinstagram/providers/user_provider.dart';
import 'package:firebaseinstagram/responsive/mobile_screen_layout.dart';
import 'package:firebaseinstagram/responsive/responsive_layout_screen.dart';
import 'package:firebaseinstagram/responsive/web_screen_layout.dart';
import 'package:firebaseinstagram/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
   await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyDQeUh5quVyXIcqm7D7j6eCR4cOc7F97jQ",
          appId: "1:534116838579:android:fc3f2ce22aaf2a906cd4c6",
          messagingSenderId: "534116838579",
          projectId: "flutter-add-b45a3",
          storageBucket: "flutter-add-b45a3.appspot.com",
      )
   );


  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider())
      ],
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Instagram clone',
          theme: ThemeData.dark(),
          // home: const ResponsiveLayout(
          //     webScreenLayout: WebScreenLayout(),
          //     mobileScreenLayout: MobileScreenLayout()
          // )
          home: StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.active) {
                // Checking if the snapshot has any data or not
                if (snapshot.hasData) {
                  // if snapshot has data which means user is logged in then we check the width of screen and accordingly display the screen layout
                  return const ResponsiveLayout(
                    mobileScreenLayout: MobileScreenLayout(),
                    webScreenLayout: WebScreenLayout(),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('${snapshot.error}'),
                  );
                }
              }
              // means connection to future hasnt been made yet
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              return const LoginScreen();
            },
          ),

      ),
    );
  }
}
