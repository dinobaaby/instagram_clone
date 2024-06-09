import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../pages/add_post_screen.dart';
import '../pages/feed_screen.dart';
import '../pages/profile_screen.dart';
import '../pages/search_screen.dart';

const webScreenSize = 600;
final homeScreenItems = [
  const FeedScrenn(),
  const SearchScreen(),
   AddPostScreen(),
  Text("notif"),
  ProfileScreen(uid: FirebaseAuth.instance.currentUser!.uid),
];
