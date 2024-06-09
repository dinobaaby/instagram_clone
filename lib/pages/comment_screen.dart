import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebaseinstagram/providers/user_provider.dart';
import 'package:firebaseinstagram/utils/colors.dart';
import 'package:firebaseinstagram/widgets/comment__card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/firestore_methods.dart';
import '../models/user.dart';


class CommentScreen extends StatefulWidget {
  final snap;
  const CommentScreen({super.key, required this.snap});

  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  final TextEditingController _commentController = TextEditingController();
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _commentController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<UserProvider>(context).getUser;
    return SafeArea(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: mobileBackgroundColor,
            title: const Text("Comment"),
            centerTitle: false,

          ),
          body: StreamBuilder(
            stream: FirebaseFirestore.instance.collection('postsi').doc(widget.snap['postId']).collection('comments').orderBy('datePublished', descending: true).snapshots(),
            builder: (context, snapshot){
              if(snapshot.connectionState == ConnectionState.waiting){
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) => CommentCard(snap: snapshot.data!.docs[index])
              );
            },
          ),
          bottomNavigationBar: SafeArea(
            child: Container(
              height: kToolbarHeight,
              margin: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom
              ),
              padding: const EdgeInsets.only(left: 16, right: 8),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(user.photoUrl),
                    radius: 18,
                  ),
                  Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 16, right: 8),
                        child: TextField(
                          controller: _commentController,
                          decoration: InputDecoration(
                            hintText: "Comment as ${user.username}",
                            border: InputBorder.none
                          ),
                        ),
                      )
                  ),
                  InkWell(
                    onTap: () async{
                         await FirestoreMethods().postComment(widget.snap['postId'], _commentController.text, user.uid, user.username, user.photoUrl);
                          _commentController.text = "";
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                      child: const Text("Post", style: TextStyle(color: Colors.blueAccent),),
                    ),
                  )

                ],
              ),
            ),
          ),
        )
    );
  }
}
