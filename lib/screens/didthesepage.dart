import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants.dart';

import '../services/firestore_service.dart';

class DidThesePage extends StatefulWidget {
  const DidThesePage({super.key});

  @override
  State<DidThesePage> createState() => _DidThesePageState();
}

class _DidThesePageState extends State<DidThesePage> {
  @override
  void initState() {
    getAllDateFromFirebase();
    super.initState();
  }

  Map<String, List<Map>> mapdData = {};
  String initialDate = '';
  String formattedInitialDate = '';
  String selectedDate = '';
  List<String> dateList = [];
  @override
  Widget build(BuildContext context) {
    if (initialDate.isNotEmpty) {
      List<String> formattedInitialDateList = initialDate.split("-");
      formattedInitialDate =
          "${formattedInitialDateList[0]},${formattedInitialDateList[3]}";
    }

    log("rebuilding...");
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
          "Did these",
          style: GoogleFonts.quicksand(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SafeArea(
          child: initialDate.isNotEmpty
              ? Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
//*Dropdown menu

                      DropdownMenu(
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

//*Futurebuilder
                      FutureBuilder(
                        future: FirestoreNotes()
                            .getPinnedOrAchievedNotes("did these", initialDate),
                        builder: (context, fSnapshot) {
                          if (fSnapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                                child: CircularProgressIndicator());
                          }
                          if (fSnapshot.data != null) {
                            if (fSnapshot.data!.isNotEmpty) {
                              return Expanded(
                                  child: Column(
                                children: [
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  for (var element in fSnapshot.data!.entries)
                                    Container(
                                      margin: const EdgeInsets.only(bottom: 14),
                                      padding: const EdgeInsets.only(
                                          left: 15,
                                          right: 15,
                                          top: 18,
                                          bottom: 15),
                                      decoration: ShapeDecoration(
                                        color: didTheseContainerColor,
                                        shape: SmoothRectangleBorder(
                                          side: BorderSide(
                                            width: 4,
                                            color: primaryColor,
                                            strokeAlign:
                                                BorderSide.strokeAlignInside,
                                          ),
                                          borderRadius: SmoothBorderRadius(
                                            cornerRadius: 39,
                                            cornerSmoothing: 1,
                                          ),
                                        ),
                                      ),
                                      child: Column(
                                        children: [
//*category row

                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  Text(
                                                    "All achieved",
                                                    style:
                                                        GoogleFonts.quicksand(
                                                            color: Colors.white,
                                                            fontSize: 18,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w600),
                                                  ),
                                                  const SizedBox(
                                                    width: 5,
                                                  ),
                                                  Text(
                                                    element.key,
                                                    style:
                                                        GoogleFonts.quicksand(
                                                            color: Colors.white,
                                                            fontSize: 18,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w600),
                                                  ),
                                                ],
                                              ),
                                              //SvgPicture.asset(
                                              //    "asset/svg/close.svg")
                                              //IconButton(
                                              //    onPressed: () {},
                                              //    icon: const Icon(
                                              //      Icons.cancel,
                                              //      size: 28,
                                              //    ))
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 12,
                                          ),
//*noteListview
                                          for (var valueElement
                                              in element.value)
                                            Container(
                                              width: double.infinity,
                                              margin: const EdgeInsets.only(
                                                  bottom: 12),
                                              padding: const EdgeInsets.all(10),
                                              decoration: ShapeDecoration(
                                                color: const Color(0xff353535),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      SmoothBorderRadius(
                                                          cornerRadius: 20,
                                                          cornerSmoothing: 1),
                                                ),
                                              ),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    valueElement["title"],
                                                    style:
                                                        GoogleFonts.quicksand(
                                                      color: Colors.white,
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                  Text(
                                                    valueElement["content"],
                                                    style: GoogleFonts.inter(
                                                        color: const Color
                                                            .fromARGB(
                                                            255, 213, 213, 213),
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w300),
                                                  ),
                                                ],
                                              ),
                                            )
                                        ],
                                      ),
                                    )
                                ],
                              ));
                            } else {
                              return Center(
                                  child: Container(
                                margin: const EdgeInsets.only(top: 200),
                                child: Text(
                                  "0 note achieved on this day",
                                  style: GoogleFonts.inter(
                                      color: const Color(0xffFF3434)),
                                ),
                              ));
                            }

                            //ListView.builder(
                            //  itemCount: 2,
                            //  shrinkWrap: true,
                            //  itemBuilder: (context, index) {
                            //    return
                            //  },
                            //);
                          } else {
                            log('else');
                            return Center(
                                child: Text(
                              "0 note achieved on this day",
                              style: GoogleFonts.inter(
                                  color: const Color(0xffFF3434)),
                            ));
                          }
                        },
                      ),
                    ],
                  ),
                )
              : Center(
                  child: Text("fetching data...",
                      style: GoogleFonts.inter(
                        color: Colors.white,
                      )),
                )),
    );
  }

  void getAllDateFromFirebase() async {
    dateList.clear();
    var collRef = await FirebaseFirestore.instance.collection("notes").get();
    for (var element in collRef.docs) {
      dateList.add(element.id);
    }
    if (mounted) {
      setState(() {
        initialDate = collRef.docs.last.id;
      });
    }
  }

  //Future<Map<String, List<Map<dynamic, dynamic>>>> getAllPinned(
  //    String dateAsDocId) async {
  //  var collRef = FirebaseFirestore.instance.collection("notes");
  //  var docRef = await collRef.doc(dateAsDocId).collection("cats&notes").get();

  //  List<Map<String, List<Map>>> data = [];

  //  for (var element in docRef.docs) {
  //    var allCatRef = await collRef
  //        .doc(dateAsDocId)
  //        .collection("cats&notes")
  //        .doc(element.id)
  //        .collection("all${element.id}")
  //        .get();
  //    for (var element1 in allCatRef.docs) {
  //      if (element1["isDone"] == true) {
  //        if (mapdData.containsKey(element.id)) {
  //          mapdData[element.id]!.add(element1.data());
  //        } else {
  //          mapdData[element.id] = [element1.data()];
  //        }
  //      }
  //    }
  //  }
  //  data.add(mapdData);
  //  //log("dataList===${mapdData!}");
  //  return mapdData;
  //}
}
