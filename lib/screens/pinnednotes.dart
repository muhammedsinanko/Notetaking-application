import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants.dart';
import '../services/firestore_service.dart';
import '../widgets/pinnedgridview.dart';

class PinnedNotesScreen extends StatefulWidget {
  const PinnedNotesScreen({
    super.key,
  });

  @override
  State<PinnedNotesScreen> createState() => _PinnedNotesScreenState();
}

class _PinnedNotesScreenState extends State<PinnedNotesScreen> {
  int selectedDateIndex = 0;
  List<String> dateList = [];
  String initialDate = '';
  String selectedDate = '';
  String formattedInitialDate = '';
  @override
  void initState() {
    getAllDateFromFirebase();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    log("Building...");
    if (initialDate.isNotEmpty) {
      List<String> formattedInitDateList = initialDate.split("-");
      formattedInitialDate =
          "${formattedInitDateList[0]},${formattedInitDateList[3]}";
    }
    final screenHeight = MediaQuery.of(context).size.height;
    //final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: backroundColor,
      appBar: AppBar(
        centerTitle: true,
        leadingWidth: 43,
        leading: IconButton(
          style: IconButton.styleFrom(padding: const EdgeInsets.only(left: 10)),
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.white,
          ),
        ),
        backgroundColor: backroundColor,
        title: Text(
          "Pinned",
          style: GoogleFonts.quicksand(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SafeArea(
          child: initialDate.isNotEmpty
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //*Dropdown menu

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: DropdownMenu(
                        width: MediaQuery.of(context).size.width / 2,
                        textStyle: GoogleFonts.quicksand(
                          color: Colors.white,
                          fontSize: 24,
                        ),
                        hintText: formattedInitialDate,
                        inputDecorationTheme: InputDecorationTheme(
                            hintStyle: GoogleFonts.quicksand(
                              color: Colors.white,
                              fontSize: 24,
                            ),
                            border: InputBorder.none),
                        dropdownMenuEntries: dateList.map((e) {
                          List<String> splittedDate = e.split("-");
                          String dataFormatted =
                              splittedDate[0].toString().length == 1
                                  ? "0${splittedDate[0]},${splittedDate[3]}"
                                  : "${splittedDate[0]},${splittedDate[3]}";
                          return DropdownMenuEntry(
                            value: e,
                            label: dataFormatted,
                            trailingIcon: Text(splittedDate[2]),
                          );
                        }).toList(),
                        onSelected: (value) async {
                          setState(() {
                            selectedDate = value!;
                            initialDate = selectedDate;
                          });
                        },
                      ),
                    ),
                    FutureBuilder(
                        future: FirestoreNotes()
                            .getPinnedOrAchievedNotes("pinned", initialDate),
                        builder: ((context, fSnapshot) {
                          if (fSnapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          if (fSnapshot.data != null &&
                              fSnapshot.data!.isNotEmpty) {
                            return PinnedPageGridView(
                                screenHeight: screenHeight,
                                fSnapshot: fSnapshot);
                          } else {
                            return Padding(
                              padding: const EdgeInsets.only(top: 150),
                              child: Center(
                                  child: Text(
                                "No pinned note on this day",
                                style: GoogleFonts.inter(
                                  color: Colors.grey,
                                ),
                              )),
                            );
                          }
                        }))
                  ],
                )
              : Center(
                  child: Text(
                    "fetching data...",
                    style: GoogleFonts.inter(
                      color: Colors.white,
                    ),
                  ),
                )),
    );
  }

  Future<List<Map<String, dynamic>>> getAllNotes(
      String dateAsDocId, String catName) async {
    List<Map<String, dynamic>> noteList = [];
    var collRef = await FirebaseFirestore.instance
        .collection("notes")
        .doc(dateAsDocId)
        .collection("cats&notes")
        .get();
    for (var element in collRef.docs) {
      noteList.add(element.data());
    }
    return noteList;
  }

  void getAllDateFromFirebase() async {
    log("function lauched");
    dateList.clear();
    var collRef = await FirebaseFirestore.instance.collection("notes").get();
    for (var element in collRef.docs) {
      dateList.add(element.id);
    }
    setState(() {
      initialDate = collRef.docs.last.id;
    });

    log("initail $initialDate");
  }
}
