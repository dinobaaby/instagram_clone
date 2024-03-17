

import 'package:firebaseinstagram/utils/colors.dart';
import 'package:firebaseinstagram/utils/global_variable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';



class MobileScreenLayout extends StatefulWidget{
  const MobileScreenLayout({super.key});
  @override
  State<MobileScreenLayout> createState() => _MobileScreenLayoutState();
}

class _MobileScreenLayoutState extends State<MobileScreenLayout> {
  int _page = 0;
  late PageController pageController;
  @override
  void initState() {
    super.initState();
    pageController = PageController();
  }
  
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    pageController.dispose();
  }
  
  void navigationTaped(int page){
    pageController.jumpToPage(page);
  }
  void onPageChanged(int page){
    setState(() {
      _page = page;
    });
  }
  @override
  Widget build(BuildContext context) {
    //User user = Provider.of<UserProvider>(context).getUser;
    return  SafeArea(
        child: Scaffold(
          body: PageView(
            children: homeScreenItems,
            physics: const NeverScrollableScrollPhysics(),
            controller: pageController,
            onPageChanged: onPageChanged,
          ),
          bottomNavigationBar: CupertinoTabBar(
              height: 65,
              backgroundColor: mobileBackgroundColor,
              items:  [
                bottomNavigationBarItemMethod(0, Icons.home),
                bottomNavigationBarItemMethod(1, Icons.search),
                bottomNavigationBarItemMethod(2, Icons.add_circle),
                bottomNavigationBarItemMethod(3, Icons.favorite),
                bottomNavigationBarItemMethod(4, Icons.person),
              ],
              onTap: navigationTaped,
          ),
        )
    );
  }
  BottomNavigationBarItem bottomNavigationBarItemMethod(int page, IconData iconItem){
    return BottomNavigationBarItem(
        icon: Icon(
          iconItem,
          color: _page == page? primaryColor: secondaryColor,
        ),
        label: "",
        backgroundColor: primaryColor
    );
  }
}
