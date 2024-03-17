import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebaseinstagram/screens/add_post_screen.dart';
import 'package:firebaseinstagram/screens/feed_screen.dart';
import 'package:firebaseinstagram/screens/profile_screen.dart';
import 'package:firebaseinstagram/screens/search_screen.dart';
import 'package:flutter/material.dart';

const webScreenSize = 600;
final homeScreenItems = [
  const FeedScrenn(),
  const SearchScreen(),
  const AddPostScreen(),
  Text("notif"),
  ProfileScreen(uid: FirebaseAuth.instance.currentUser!.uid),
];
