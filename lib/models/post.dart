import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String description;
  final String uid;
  final String username;
  final String postId;
  final datePublished;
  final String photoUrl;
  final String profImage;
  final likes;

  const Post({
    required this.description,
    required this.uid,
    required this.username,
    required this.postId,
    required this.datePublished,
    required this.photoUrl,
    required this.profImage,
    required this.likes,
  });

  Map<String, dynamic> toJson() => {
    "description": description,
    "uid": uid,
    "photoUrl": photoUrl,
    "username": username,
    "postId": postId,
    "datePublished": datePublished,
    "profImage": profImage,
    "likes": likes,
  };

  static Post fronSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return Post(
      username: snapshot["username"],
      uid: snapshot["uid"],
      description: snapshot["description"],
      photoUrl: snapshot["photoUrl"],
      postId: snapshot["postId"],
      profImage: snapshot["profImage"],
      likes: snapshot["likes"],
      datePublished: snapshot["datePublished"],
    );
  }



}