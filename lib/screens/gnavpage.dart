//import 'dart:developer';
//import 'package:flutter/material.dart';
//import 'package:google_fonts/google_fonts.dart';

//import 'homepage.dart';
//import 'pinnednotes.dart';
//import 'profilepage.dart';

//class GNavPage extends StatefulWidget {
//  const GNavPage({super.key});

//  @override
//  State<GNavPage> createState() => _GNavPageState();
//}

//class _GNavPageState extends State<GNavPage> {
//  List<Widget> pages = [
//    const PinnedNotesScreen(),
//    const HomePage(),
//    const ProfilePage()
//  ];
//  int selectedTabIndex = 0;
//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//      bottomNavigationBar: Container(
//        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
//        child: GNav(
//            onTabChange: (value) {
//              setState(() {
//                selectedTabIndex = value;
//                log(selectedTabIndex.toString());
//              });
//            },
//            selectedIndex: selectedTabIndex,
//            textStyle: GoogleFonts.quicksand(
//              color: Colors.white,
//              fontSize: 15,
//              fontWeight: FontWeight.w700,
//            ),
//            tabBorderRadius: 90,
//            curve: Curves.bounceIn,
//            backgroundColor: backroundColor,
//            activeColor: Colors.white,
//            gap: 4,
//            tabMargin: const EdgeInsets.symmetric(horizontal: 15, vertical: 13),
//            padding: const EdgeInsets.all(9),
//            tabs: [
//              GButton(
//                backgroundColor: primaryColor,
//                icon: Icons.colorize_sharp,
//                text: 'Pinned',
//                iconColor: const Color(0xff818181),
//                iconSize: 30,
//              ),
//              GButton(
//                icon: Icons.home_filled,
//                text: 'Home',
//                backgroundColor: primaryColor,
//                iconColor: const Color(0xff818181),
//                iconSize: 30,
//              ),
//              GButton(
//                backgroundColor: primaryColor,
//                icon: Icons.done_all,
//                text: 'Did these',
//                iconColor: const Color(0xff818181),
//                iconSize: 30,
//              ),
//            ]),
//      ),
//      body: IndexedStack(
//        index: selectedTabIndex,
//        children: pages,
//      ),
//    );
//  }
//}
