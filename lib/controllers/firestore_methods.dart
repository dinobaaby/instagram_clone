

import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebaseinstagram/controllers/storage_methods.dart';
import 'package:firebaseinstagram/models/post.dart';

import 'package:uuid/uuid.dart';

class FirestoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;


  // upload post
  Future<String> uploadPost(
      String description,
      Uint8List file,
      String uid,
      String username,
      String profImage,
  ) async{
    String res = "Some error occurred";
    try{
      String photoUrl = await StorageMethods().uploadImageToStorage("postsi", file, true);
      String postId = const Uuid().v1();
      Post post = Post(
        description: description,
        uid: uid,
        username: username,
        postId: postId,
        datePublished: DateTime.now(),
        photoUrl: photoUrl,
        profImage: profImage,
        likes: []
      );

      _firestore.collection("postsi").doc(postId).set(post.toJson());

      res = "success";

    }catch(err){
      res = err.toString();
    }
    return res;
  }

  // Delete a post
  Future<void> deletePost(String postId) async{
    try{
      await _firestore.collection("postsi").doc(postId).delete();
    }catch(e){
      print(e.toString());
    }
  }



  Future<void> likePost(String postId, String uid, List likes) async{
    try{
      if(likes.contains(uid)){
        await _firestore.collection("postsi").doc(postId).update({
          'likes' : FieldValue.arrayRemove([uid]),
        });
      }else{
        await _firestore.collection("postsi").doc(postId).update({
          'likes' : FieldValue.arrayUnion([uid]),
        });
      }
    }catch(e){
      print(e.toString());
    }
  }

  Future<String> postComment(String postId, String text, String uid,
      String name, String profilePic) async {
    String res = "Some error occurred";
    try {
      if (text.isNotEmpty) {
        // if the likes list contains the user uid, we need to remove it
        String commentId = const Uuid().v1();
        _firestore
            .collection('postsi')
            .doc(postId)
            .collection('comments')
            .doc(commentId)
            .set({
          'profilePic': profilePic,
          'name': name,
          'uid': uid,
          'text': text,
          'commentId': commentId,
          'datePublished': DateTime.now(),
        });
        res = 'success';
      } else {
        res = "Please enter text";
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }


  Future<void> followUser(
      String uid,
      String followId,

      ) async {
    try{
      DocumentSnapshot snap = await _firestore.collection("users").doc(uid).get();
      List following = (snap.data()! as dynamic)['following'];

      if(following.contains(followId)){
            await _firestore.collection("users").doc(followId).update({
              'followers' : FieldValue.arrayRemove([uid]),
            });

            await _firestore.collection("users").doc(uid).update({
              'following' : FieldValue.arrayRemove([followId]),
            });
      }else{
          await _firestore.collection("users").doc(followId).update({
            'followers' : FieldValue.arrayUnion([uid]),
          });

          await _firestore.collection("users").doc(uid).update({
            'following' : FieldValue.arrayUnion([followId]),
          });
      }
    }catch(e){

    }
  }
}