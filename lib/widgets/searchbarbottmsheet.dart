// ignore_for_file: must_be_immutable

import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../constants.dart';

class SearchbarBottomSheet extends StatefulWidget {
  String initialDate;
  SearchbarBottomSheet({super.key, required this.initialDate});

  @override
  State<SearchbarBottomSheet> createState() => _SearchbarBottomSheetState();
}

class _SearchbarBottomSheetState extends State<SearchbarBottomSheet> {
  List<String> dateList = [];
  List<QueryDocumentSnapshot<Map<String, dynamic>>> noteList = [];
  List<QueryDocumentSnapshot<Map<String, dynamic>>> containsList = [];
  String searchSuggession = 'Search category, note title';
  TextEditingController searchController = TextEditingController();
  @override
  void initState() {
    getDataFromFirebase(dateId: widget.initialDate);
    getAllDateFromFirebase();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    List<String> initailDateSplitted = widget.initialDate.split("-");
    String initialDateFormatted = initailDateSplitted[0].length == 1
        ? "0${initailDateSplitted[0]},${initailDateSplitted[3]}"
        : "${initailDateSplitted[0]},${initailDateSplitted[3]}";

    //*List of fulldata
    return Container(
      margin: const EdgeInsets.only(top: 30),
      width: double.infinity,
      decoration: BoxDecoration(
          color: backroundColor, borderRadius: BorderRadius.circular(25)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding:
                const EdgeInsets.only(left: 10, right: 15, top: 40, bottom: 20),
            //alignment: Alignment.center,
            height: 98, width: double.infinity,
            decoration: BoxDecoration(
                color: const Color(0xff343434).withOpacity(0.4),
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(35),
                    topRight: Radius.circular(35),
                    bottomLeft: Radius.circular(40),
                    bottomRight: Radius.circular(40))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                //*back arrow

                IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    //icon: SvgPicture.asset(
                    //  'asset/svg/arrow back.svg',
                    //  height: 16,
                    //  color: Colors.white,
                    //),
                    icon: const Icon(Icons.arrow_back_outlined,
                        color: Colors.white)),
                Container(
                    height: 41,
                    width: screenWidth / 1.3,
                    //color: noteContainerColor,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: primaryColor,
                      gradient: LinearGradient(
                          colors: [
                            noteContainerColor.withOpacity(0.55),
                            noteContainerColor.withOpacity(0.38)
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomRight),
                    ),
                    child: TextFormField(
                      onChanged: onSearch,
                      decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 15, horizontal: 10),
                          //prefixIconConstraints: BoxConstraints.tight(
                          //  const Size.square(38),
                          //),
                          prefixIconColor: Colors.grey,
                          prefixIcon: const Icon(Icons.search),
                          border: const OutlineInputBorder(
                              borderSide: BorderSide.none),
                          hintText: "Search category, notes... ",
                          hintStyle: GoogleFonts.quicksand(
                              fontSize: 14, color: Colors.grey)),
                    )),
              ],
            ),
          ),

          //*dropdown
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 15,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DropdownMenu(
                  width: MediaQuery.of(context).size.width / 2,
                  textStyle: GoogleFonts.quicksand(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                  hintText: initialDateFormatted,
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
                  onSelected: (value) {
                    setState(() {
                      getDataFromFirebase(dateId: value!);
                    });
                  },
                ),
//*listview
                containsList.isNotEmpty
                    ? ListView.builder(
                        shrinkWrap: true,
                        itemCount: containsList.length,
                        itemBuilder: (context, index) => Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 10),
                                  height: screenHeight / 6.1,
                                  width: double.infinity,
                                  decoration: ShapeDecoration(
                                      color: const Color(0xff1e1e1e),
                                      shape: SmoothRectangleBorder(
                                          side: const BorderSide(
                                            width: 3,
                                            color: Colors.grey,
                                          ),
                                          borderRadius: SmoothBorderRadius(
                                              cornerRadius: 30,
                                              cornerSmoothing: 1))),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            'category: ',
                                            style: GoogleFonts.manrope(
                                                color: Colors.grey),
                                          ),
                                          Text(
                                            containsList[index]["category"],
                                            style: GoogleFonts.manrope(
                                                color: Colors.grey),
                                          ),
                                        ],
                                      ),
                                      Text(
                                        containsList[index]["title"],
                                        style: GoogleFonts.quicksand(
                                            fontSize: 22,
                                            fontWeight: FontWeight.w700,
                                            color: primaryColor),
                                      ),
                                      Flexible(
                                        child: Text(
                                          containsList[index]["content"],
                                          style: GoogleFonts.manrope(
                                              color: Colors.grey),
                                          maxLines: 3,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                )
                              ],
                            ))
                    : Container(
                        margin: const EdgeInsets.only(top: 220),
                        child: Center(
                          child: Text(
                            searchSuggession,
                            style: GoogleFonts.inter(
                                color: const Color.fromARGB(255, 145, 145, 145),
                                fontSize: 13),
                          ),
                        ),
                      )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> getAllDateFromFirebase() async {
    var collRef = FirebaseFirestore.instance.collection("notes");
    var dateSnapshot = await collRef.get();
    for (var element in dateSnapshot.docs) {
      collRef.doc(element.id).get();
      dateList.add(element.id);
    }
  }

  Future<void> getDataFromFirebase({required String dateId}) async {
    noteList.clear();
    var catNoteRef = await FirebaseFirestore.instance
        .collection("notes")
        .doc(dateId)
        .collection("cats&notes")
        .get();
    for (var element in catNoteRef.docs) {
      QuerySnapshot<Map<String, dynamic>> noteRef = await FirebaseFirestore
          .instance
          .collection("notes")
          .doc(dateId)
          .collection("cats&notes")
          .doc(element.id)
          .collection("all${element.id}")
          .get();
      for (var element1 in noteRef.docs) {
        setState(() {
          noteList.add(element1);
        });
      }
    }
    log(noteList.length.toString());
  }

//*searching if the entered value contains
  onSearch(String? value) {
    setState(() {
      containsList.clear();
    });
    log("value$value");

    if (value != null && value.isNotEmpty) {
      noteList.map((e) {
        if (e["category"].toString().toLowerCase().contains(value) ||
            e["title"].toString().toLowerCase().contains(value) ||
            e["date"].toString().toLowerCase().contains(value)) {
          log(e["title"]);
          setState(() {
            containsList.add(e);
            log(containsList.toString());
          });
        } else {
          setState(() {
            searchSuggession = "'$value' named category or note not found";
          });
        }
      }).toList();
    } else {
      setState(() {
        searchSuggession = "Search category, notes... ";
      });
    }
  }
}
