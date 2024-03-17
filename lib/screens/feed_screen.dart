import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebaseinstagram/utils/colors.dart';
import 'package:firebaseinstagram/utils/global_variable.dart';
import 'package:firebaseinstagram/widgets/post_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class FeedScrenn extends StatelessWidget {
  const FeedScrenn({super.key});


  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return SafeArea(
        child: Scaffold(
          appBar: width > webScreenSize ? null : AppBar(
            backgroundColor: width > webScreenSize ? webBackgroundColor : mobileBackgroundColor,
            centerTitle: false,
            title: SvgPicture.asset('assets/logos/ic_instagram.svg', color: primaryColor,height: 32,),
            actions: [
              IconButton(
                  onPressed: (){},
                  icon: const Icon(Icons.message_outlined)
              )
            ],
          ),
          body: StreamBuilder(
            stream: FirebaseFirestore.instance.collection('posts').snapshots(),
            builder: (context,AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot){
              if(snapshot.connectionState == ConnectionState.waiting){
                return const Center(child: CircularProgressIndicator(),);
              }
              return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) =>  Container(
                    margin: EdgeInsets.symmetric(
                      horizontal: width > webScreenSize ? width*0.3:0,
                      vertical: width > webScreenSize? 15:0,
                    ),
                    child: PostCard(
                      snap: snapshot.data!.docs[index].data(),
                    ),
                  ));
            },
          ),
        )
    );
  }
}
