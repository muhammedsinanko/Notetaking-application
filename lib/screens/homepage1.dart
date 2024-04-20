import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants.dart';
import '../services/firestore_service.dart';
import '../widgets/bottomsheet.dart';
import 'pinnednotes.dart';

class Demo extends StatefulWidget {
  const Demo({super.key});

  @override
  State<Demo> createState() => _DemoState();
}

class _DemoState extends State<Demo> {
  @override
  void initState() {
    getDate();
    super.initState();
  }

  getDate() async {
    var collRef = FirebaseFirestore.instance.collection("notes");
    var docRef = await collRef.get();
    for (var element in docRef.docs) {
      setState(() {
        dateDocsList.add(element.id);
      });
    }
  }

  List<String> dateDocsList = [];
  int selectedDateIndex = 0;
  int selectedCategoryIndex = 0;
  final searchBarController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    //FirestoreNotes().getAllPinned();
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: backroundColor,
      bottomSheet: BottomSheetConainer(
        screenHeight: screenHeight,
      ),
      body: SafeArea(
//*base stream builder
        child: Column(
          children: [
            StreamBuilder(
                stream:
                    FirebaseFirestore.instance.collection("notes").snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (snapshot.data != null) {
                    if (snapshot.data!.docs.isNotEmpty) {
                      List<QueryDocumentSnapshot<Map<String, dynamic>>>
                          docsList = snapshot.data!.docs;
                      List docsListSplitted = [];
                      List<String> docsIdList = [];
                      for (var element in docsList) {
                        docsIdList.add(element.id);
                        List<String> splittedDate = element.id.split("-");
                        docsListSplitted.add(splittedDate);
                      }
                      String date = snapshot.data!.docs.last.id;
                      //for (var element in docsList) {
                      //  String date = element.id;
                      //  List<String> splittedDate = date.split("-");
                      //  docsListSplitted.add(splittedDate);
                      //  log(docsListSplitted.toString());
                      //}
                      List<String> splittedDateList = date.split("-");
                      log("datelsplit$splittedDateList");
                      return Column(children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 20.0, right: 20.0, top: 20, bottom: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              //*date
                              Text(
                                splittedDateList[1].length == 1
                                    ? "0${splittedDateList[1]},${splittedDateList[3]}"
                                    : "${splittedDateList[1]},${splittedDateList[3]}",
                                style: GoogleFonts.quicksand(
                                    fontSize: 29,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white),
                              ),

                              //*actions buttons
                              Row(
                                children: [
                                  InkWell(
                                      onTap: () {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: ((context) =>
                                                    const PinnedNotesScreen())));
                                      },
                                      //child: SvgPicture.asset(
                                      //  "asset/svg/done.svg",
                                      //  //height: 20,
                                      //  //width: 20,
                                      //  color: const Color(0xffb3b3b3),
                                      //),
                                      child: IconButton(
                                          onPressed: () {},
                                          icon: const Icon(Icons.arrow_back))),
                                  const SizedBox(
                                    width: 2,
                                  ),
                                  InkWell(
                                      onTap: () {},
                                      //child: SvgPicture.asset(
                                      //  "asset/svg/search svg.svg",
                                      //  //height: 20,
                                      //  //width: 20,
                                      //  color: const Color(0xffb3b3b3),
                                      //),
                                      child: IconButton(
                                          onPressed: () {},
                                          icon: const Icon(Icons.arrow_back))),
                                ],
                              ),
                            ],
                          ),
                        ),

                        //*date listview
                        SizedBox(
                          height: screenHeight / 12.5,
                          child: ListView.builder(
                            padding: const EdgeInsets.only(
                              left: 20,
                              right: 20,
                            ),
                            scrollDirection: Axis.horizontal,
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (context, index) {
                              return InkWell(
                                onTap: () {
                                  setState(() {
                                    selectedDateIndex = index;
                                    selectedCategoryIndex = 0;
                                  });

                                  final height = screenHeight / 12.5;
                                  debugPrint(height.toString());
                                },
                                child: Container(
                                  width: screenHeight / 13.5,
                                  height: screenWidth / 12.5,
                                  padding: const EdgeInsets.all(2),
                                  alignment: Alignment.center,
                                  margin: const EdgeInsets.only(right: 2),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(16.0),
                                      gradient: selectedDateIndex == index
                                          ? LinearGradient(
                                              colors: [
                                                  const Color(
                                                    0xff9C2CF7,
                                                  ),
                                                  const Color(0xff9C2CF7)
                                                      .withOpacity(0.75)
                                                ],
                                              begin: Alignment.topLeft,
                                              end: Alignment.bottomRight)
                                          : LinearGradient(
                                              colors: [
                                                  const Color(
                                                    0xff777777,
                                                  ).withOpacity(0.32),
                                                  const Color(0xff393939)
                                                      .withOpacity(0.66 - 0.35)
                                                ],
                                              begin: Alignment.topLeft,
                                              end: Alignment.bottomRight)),
                                  child: Text(
                                    "${docsListSplitted[index][0]}\n${docsListSplitted[index][3]}",
                                    style: GoogleFonts.quicksand(
                                        fontSize: 13,
                                        fontWeight: selectedDateIndex == index
                                            ? FontWeight.w600
                                            : FontWeight.w400,
                                        color: selectedDateIndex == index
                                            ? Colors.white
                                            : const Color(0xff8B8B8B)),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        //*searchbar
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 9),
                          child: Form(
                            child: Container(
                              height: 42,
                              width: double.infinity,
                              //color: noteContainerColor,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                gradient: LinearGradient(
                                    colors: [
                                      const Color(0xff777777).withOpacity(0.32),
                                      const Color(0xff393939)
                                          .withOpacity(0.65)
                                          .withOpacity(0.35)
                                    ],
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomRight),
                              ),
                              child: TextFormField(
                                controller: searchBarController,
                                decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.symmetric(
                                        vertical: 15),
                                    prefixIconConstraints: BoxConstraints.tight(
                                      const Size.square(38),
                                    ),
                                    prefixIconColor: Colors.grey,
                                    prefixIcon: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10),
                                        //child: SvgPicture.asset(
                                        //  "asset/svg/search svg.svg",
                                        //),
                                        child: IconButton(
                                            onPressed: () {},
                                            icon:
                                                const Icon(Icons.arrow_back))),
                                    //contentPadding:
                                    //    EdgeInsets.symmetric(horizontal: 10),
                                    border: const OutlineInputBorder(
                                        borderSide: BorderSide.none),
                                    hintText: "Search notes",
                                    hintStyle: GoogleFonts.quicksand(
                                        fontSize: 14, color: Colors.grey)),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 6,
                        ),

                        //*category listview
                        StreamBuilder(
                            stream: FirebaseFirestore.instance
                                .collection("notes")
                                .doc(snapshot.data!.docs[selectedDateIndex].id)
                                .collection("cats&notes")
                                .snapshots(),
                            builder: (context, catSnapshot) {
                              if (catSnapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
                              if (snapshot.data != null) {
                                if (snapshot.data!.docs.isNotEmpty) {
                                  return Column(
                                    children: [
                                      SizedBox(
                                        height: screenHeight / 18.045,
                                        child: ListView.builder(
                                          padding: const EdgeInsets.only(
                                            left: 5,
                                            right: 5,
                                          ),
                                          itemCount:
                                              catSnapshot.data!.docs.length,
                                          scrollDirection: Axis.horizontal,
                                          itemBuilder: (context, index) =>
                                              InkWell(
                                            onTap: () {
                                              setState(() {
                                                selectedCategoryIndex = index;
                                              });
                                            },
                                            child: Row(
                                              children: [
                                                Container(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 13,
                                                      vertical: 11),
                                                  alignment: Alignment.center,
                                                  height: screenHeight / 18.045,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            32),
                                                    gradient:
                                                        selectedCategoryIndex !=
                                                                index
                                                            ? LinearGradient(
                                                                colors: [
                                                                    const Color(
                                                                            0xff777777)
                                                                        .withOpacity(
                                                                            0.32),
                                                                    const Color(
                                                                            0xff393939)
                                                                        .withOpacity(
                                                                            0.65)
                                                                        .withOpacity(
                                                                            0.35)
                                                                  ],
                                                                begin: Alignment
                                                                    .topCenter,
                                                                end: Alignment
                                                                    .bottomRight)
                                                            : LinearGradient(
                                                                colors: [
                                                                    primaryColor,
                                                                    primaryColor
                                                                        .withOpacity(
                                                                            0.65)
                                                                  ]),
                                                  ),
                                                  child: Text(
                                                    catSnapshot
                                                        .data!.docs[index].id,
                                                    style: GoogleFonts.quicksand(
                                                        fontSize: 13,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: selectedCategoryIndex !=
                                                                index
                                                            ? unSelectedTextColor
                                                            : Colors.white),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: 2,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
//*gridview builder
                                      StreamBuilder<QuerySnapshot>(
                                          stream: FirebaseFirestore.instance
                                              .collection("notes")
                                              .doc(snapshot.data!
                                                  .docs[selectedDateIndex].id)
                                              .collection("cats&notes")
                                              .doc(catSnapshot
                                                  .data!
                                                  .docs[selectedCategoryIndex]
                                                  .id)
                                              .collection(
                                                  "all${catSnapshot.data!.docs[selectedCategoryIndex].id}")
                                              .snapshots(),
                                          builder: (context, noteSnapshot) {
                                            if (noteSnapshot.data != null) {
                                              log(noteSnapshot.data!
                                                  .toString());
                                              if (noteSnapshot
                                                  .data!.docs.isNotEmpty) {
                                                log("has data");
                                                return SizedBox(
                                                  height: screenHeight / 1.6,
                                                  child: Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 1,
                                                        vertical: 10),
                                                    //*gridview
                                                    child:
                                                        SingleChildScrollView(
                                                      child: GridView.builder(
                                                        shrinkWrap: true,
                                                        physics:
                                                            const ScrollPhysics(),
                                                        gridDelegate:
                                                            SliverGridDelegateWithMaxCrossAxisExtent(
                                                                crossAxisSpacing:
                                                                    1,
                                                                mainAxisSpacing:
                                                                    1,
                                                                //mainAxisExtent: 0.5,
                                                                maxCrossAxisExtent:
                                                                    187,
                                                                mainAxisExtent:
                                                                    screenHeight /
                                                                        4.54),
                                                        itemCount: noteSnapshot
                                                            .data!.docs.length,
                                                        itemBuilder:
                                                            (context, index) {
                                                          bool isPinned =
                                                              noteSnapshot.data!
                                                                          .docs[
                                                                      index]
                                                                  ["isPinned"];
                                                          return Container(
                                                            padding:
                                                                const EdgeInsets
                                                                    .only(
                                                                    left: 10,
                                                                    right: 4,
                                                                    top: 6,
                                                                    bottom: 8),
                                                            height:
                                                                screenHeight /
                                                                    4.54,
                                                            width: 183.5,
                                                            decoration:
                                                                ShapeDecoration(
                                                              shape:
                                                                  SmoothRectangleBorder(
                                                                borderRadius:
                                                                    SmoothBorderRadius(
                                                                        cornerRadius:
                                                                            40,
                                                                        cornerSmoothing:
                                                                            01),
                                                              ),
                                                              gradient: LinearGradient(
                                                                  colors: [
                                                                    noteContainerColor,
                                                                    noteContainerColor
                                                                        .withOpacity(
                                                                            0.51)
                                                                  ],
                                                                  begin: Alignment
                                                                      .topLeft,
                                                                  end: Alignment
                                                                      .bottomRight),
                                                            ),
                                                            child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                //?container for title
                                                                Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  children: [
                                                                    Flexible(
                                                                      child:
                                                                          Container(
                                                                        padding:
                                                                            EdgeInsets.all(screenHeight /
                                                                                116),
                                                                        decoration:
                                                                            ShapeDecoration(
                                                                          gradient: LinearGradient(
                                                                              colors: [
                                                                                headingContainerColor,
                                                                                headingContainerColor.withOpacity(0.8),
                                                                              ],
                                                                              begin: Alignment.topLeft,
                                                                              end: Alignment.bottomRight),
                                                                          shape:
                                                                              SmoothRectangleBorder(
                                                                            borderRadius:
                                                                                SmoothBorderRadius(cornerRadius: 14, cornerSmoothing: 1),
                                                                          ),
                                                                        ),
                                                                        child:
                                                                            Text(
                                                                          softWrap:
                                                                              false,
                                                                          noteSnapshot
                                                                              .data!
                                                                              .docs[index]
                                                                              .id,
                                                                          style:
                                                                              GoogleFonts.quicksand(
                                                                            color:
                                                                                Colors.white,
                                                                            fontSize:
                                                                                14,
                                                                            fontWeight:
                                                                                FontWeight.w500,
                                                                          ),
                                                                          maxLines:
                                                                              1,
                                                                          overflow:
                                                                              TextOverflow.ellipsis,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    IconButton(
                                                                        style: IconButton.styleFrom(
                                                                            backgroundColor: Colors.white.withOpacity(
                                                                                0.7),
                                                                            elevation:
                                                                                0),
                                                                        onPressed:
                                                                            () {
                                                                          String categoryNameAsDocId = catSnapshot
                                                                              .data!
                                                                              .docs[selectedCategoryIndex]
                                                                              .id;
                                                                          String docId = snapshot
                                                                              .data!
                                                                              .docs[selectedDateIndex]
                                                                              .id;
                                                                          String title = noteSnapshot
                                                                              .data!
                                                                              .docs[index]
                                                                              .id;

                                                                          setState(
                                                                              () {
                                                                            isPinned =
                                                                                !noteSnapshot.data!.docs[index]["isPinned"];
                                                                          });

                                                                          log("value==$isPinned");
                                                                          FirestoreNotes().updatePinValue(
                                                                              docId: docId,
                                                                              categoryNameAsDocId: categoryNameAsDocId,
                                                                              title: title,
                                                                              boolValue: isPinned);
                                                                          //?calling a SnackBar
                                                                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                                                              duration: const Duration(seconds: 1),
                                                                              backgroundColor: const Color.fromARGB(255, 26, 26, 26),
                                                                              behavior: SnackBarBehavior.floating,
                                                                              content: Center(
                                                                                child: Text(
                                                                                  isPinned != true ? "note Unpinned" : "note pinned",
                                                                                  style: GoogleFonts.inter(color: Colors.white),
                                                                                ),
                                                                              )));
                                                                        },
                                                                        //icon: SvgPicture
                                                                        //    .asset(
                                                                        //  "asset/svg/pin.svg",
                                                                        //  height:
                                                                        //      18,
                                                                        //  color: isPinned !=
                                                                        //          true
                                                                        //      ? Colors.black.withOpacity(0.2)
                                                                        //      : primaryColor,
                                                                        //),
                                                                        icon: IconButton(
                                                                            onPressed:
                                                                                () {},
                                                                            icon:
                                                                                const Icon(Icons.arrow_back)))
                                                                  ],
                                                                ),
                                                                for (var element
                                                                    in noteSnapshot
                                                                        .data!
                                                                        .docs)
                                                                  Flexible(
                                                                    child: Text(
                                                                      element[
                                                                          "content"],
                                                                      style: GoogleFonts.quicksand(
                                                                          color: Colors
                                                                              .white,
                                                                          height:
                                                                              0),
                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis,
                                                                      maxLines:
                                                                          6,
                                                                    ),
                                                                  )
                                                              ],
                                                            ),
                                                          );
                                                        },
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              } else {
                                                return const Center(
                                                  child: Text("NO data"),
                                                );
                                              }
                                            } else {
                                              return const Center(
                                                child:
                                                    CircularProgressIndicator(),
                                              );
                                            }
                                          })
                                    ],
                                  );
                                } else {
                                  return const Center(
                                    child: Text("Something went wrong"),
                                  );
                                }
                              } else {
                                return const Center(
                                  child: Text("Something went wrong"),
                                );
                              }
                            }),
                      ]);
                    } else {
                      return Center(
                          //!show no data add notes
                          child: Text(
                        "No data",
                        style: GoogleFonts.inter(color: Colors.amber),
                      ));
                    }
                  } else {
                    return const Center(
                      child: Text("No data"),
                    );
                  }
                }),
          ],
        ),
      ),
    );
  }
}
