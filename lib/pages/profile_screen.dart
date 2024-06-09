import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:firebaseinstagram/utils/colors.dart';
import 'package:firebaseinstagram/utils/utils.dart';
import 'package:firebaseinstagram/widgets/follow_button.dart';
import 'package:flutter/material.dart';

import '../controllers/auth_methods.dart';
import '../controllers/firestore_methods.dart';
import 'login_screen.dart';


class ProfileScreen extends StatefulWidget {
  final String uid;
  const ProfileScreen({super.key, required this.uid});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  var userData =  {};
  int postLength = 0;
  int followers = 0;
  int following = 0;
  bool isFollowing = false;
  bool isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  getData() async {
    setState(() {
      isLoading  = true;
    });
    try{
      var userSnap =  await FirebaseFirestore.instance.collection("usersi").doc(widget.uid).get();
      
      var postSnap = await FirebaseFirestore
          .instance
          .collection("postsi")
          .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .get();
      postLength = postSnap.docs.length;
      userData = userSnap.data()!;
      followers = userSnap.data()!['followers'].length;
      following = userSnap.data()!['following'].length;
      isFollowing = userSnap.data()!['followers'].contains(FirebaseAuth.instance.currentUser!.uid);

      setState(() {

      });
    }catch(e){
      showSankBar(e.toString(), context);
    }
    setState(() {
      isLoading = false;
    });
  }


  @override
  Widget build(BuildContext context) {
    return isLoading ? const Center(child: CircularProgressIndicator(),) : SafeArea(
        child: Scaffold(
            appBar: AppBar(
              backgroundColor: mobileBackgroundColor,
              title: Text(userData["username"]),
              centerTitle: false,
            ),
          body: ListView(
            children: [
              Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.grey,
                            backgroundImage: NetworkImage(userData['photoUrl']),
                            radius: 40,
                          ),
                          Expanded(
                            flex: 1,
                            child: Column(
                                children:[
                                  Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [
                                      buildStatColumn(postLength, "posts"),
                                      buildStatColumn(followers, "followers"),
                                      buildStatColumn(following, "following"),

                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      FirebaseAuth.instance.currentUser!.uid == widget.uid ? FollowButton(
                                        backgroundColor: mobileBackgroundColor,
                                        textColor: primaryColor,
                                        borderColor: Colors.grey,
                                        text: "Sign out",
                                        function: () async {
                                          await AuthMethods().signOut();
                                          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const LoginScreen()));
                                        },
                                      ): isFollowing ? FollowButton(
                                        backgroundColor: Colors.white,
                                        textColor: Colors.black,
                                        borderColor: Colors.grey,
                                        text: "Unfollow",
                                        function: () async {
                                          await FirestoreMethods()
                                              .followUser(FirebaseAuth
                                              .instance.currentUser!
                                              .uid, userData["uid"]);

                                            setState(() {
                                              isFollowing = false;
                                              followers--;
                                            });
                                        },
                                      ) : FollowButton(
                                        backgroundColor: Colors.blue,
                                        textColor: Colors.white,
                                        borderColor: Colors.blue,
                                        text: "Follow",
                                        function: () async {
                                          await FirestoreMethods()
                                              .followUser(FirebaseAuth
                                              .instance.currentUser!
                                              .uid, userData["uid"]);

                                          setState(() {
                                            isFollowing = true;
                                            following++;
                                          });
                                        },
                                      ),
                                    ],
                                  )
                              ]
                            ),

                          ),

                        ],
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.only(top: 15),
                        child: Text(
                            userData["username"],
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.only(top: 1),
                        child: Text(
                         userData["username"],

                        ),
                      )
                    ],
                  ),

              ),
              const Divider(),
              FutureBuilder(
                  future: FirebaseFirestore
                            .instance
                            .collection("posts")
                            .where('uid', isEqualTo: widget.uid).get(),
                  builder: (context, snapshot){
                    if(snapshot.connectionState == ConnectionState.waiting){
                      return const Center(child: CircularProgressIndicator(),);
                    }
                    return GridView.builder(
                        shrinkWrap: true,
                        itemCount: (snapshot.data! as dynamic).docs.length,
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 5,
                            mainAxisSpacing:1.5,
                            childAspectRatio: 1
                        ),
                        itemBuilder: (context, index){
                          DocumentSnapshot snap = (snapshot.data! as dynamic).docs[index];

                          return Container(
                            child: Image(
                              image: NetworkImage(
                                (snap.data()! as dynamic)['photoUrl'],
                              ),
                              fit: BoxFit.cover,
                            ),
                          );
                        }
                    );
                  }
              )
            ],
          ),
        )
    );
  }

  Column buildStatColumn(int num, String label){
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(num.toString(), style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
        Container(
            margin: const EdgeInsets.only(top: 2),
            child: Text(label, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w400, color: Colors.grey),)
        )
      ],
    );
  }


}
