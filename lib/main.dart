
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebaseinstagram/pages/login_screen.dart';
import 'package:firebaseinstagram/providers/user_provider.dart';
import 'package:firebaseinstagram/responsive/mobile_screen_layout.dart';
import 'package:firebaseinstagram/responsive/responsive_layout_screen.dart';
import 'package:firebaseinstagram/responsive/web_screen_layout.dart';
import 'package:firebaseinstagram/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';

void main() async {
  // WidgetsFlutterBinding.ensureInitialized();
  //  await Firebase.initializeApp(
  //      options: const FirebaseOptions(
  //        apiKey: 'AIzaSyAdB7CqPLFWb3qzAqKLnoWAltDSM-UMP9w',
  //        appId: '1:1050918042154:android:968ea1f21dc28f8cc86153',
  //        messagingSenderId: '1050918042154',
  //        projectId: 'metaapp-1ec0d',
  //        storageBucket: 'metaapp-1ec0d.appspot.com',
  //      )
  //  );
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider(),),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Instagram Clone',
        theme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: mobileBackgroundColor,
        ),
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