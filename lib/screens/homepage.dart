// ignore_for_file: deprecated_member_use
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/bottomsheet_home.dart';
import '../constants.dart';
import '../services/firestore_service.dart';
import '../widgets/searchbar_home.dart';
import 'didthesepage.dart';
import 'notepage.dart';
import 'pinnednotes.dart';
import 'profilepage.dart';

// ignore: must_be_immutable
class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //Connectivity connectivity = Connectivity();
  List<String> dateDocs = [];
  List dateDocsList = [];
  List splittedDateDocList = [];
  int selectedDateIndex = 0;
  int selectedCategoryIndex = 0;
  final searchTextController = TextEditingController();
  //String date = '';
  var searchedValue;
//*Split date//
  splitDateDoc() {
    splittedDateDocList.clear();
    for (String element in dateDocsList) {
      List<String> dateSplitted = element.split("-");
      splittedDateDocList.add(dateSplitted);
    }
    log("splitted date=$splittedDateDocList");
  } //*finished

  @override
  void initState() {
    log("init lauched");
    getDateDocsDate();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    log("diddep lauched");
    getDateDocsDate();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    log("doclist==$dateDocsList");
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    splitDateDoc();

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leadingWidth: 43,
        leading: IconButton(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            //style: ButtonStyle(),
            onPressed: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const ProfilePage()));
            },
            icon: const Icon(
              Icons.person,
              color: Colors.white,
              size: 27,
            )),
        backgroundColor: backroundColor,
        title: Text(
          "All notes",
          style: GoogleFonts.quicksand(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
              padding: EdgeInsets.zero,
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const PinnedNotesScreen()));
              },
              icon: SvgPicture.asset(
                "asset/typcn--pin.svg",
                fit: BoxFit.contain,
                height: 28,
                //width: 30,
                color: Colors.white,
              )),
          IconButton(
              padding: const EdgeInsets.only(right: 18),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const DidThesePage()));
              },
              icon: const Icon(
                Icons.done_all,
                color: Colors.white,
                size: 30,
              ))
        ],
      ),
      bottomSheet: const BottomSheetHome(),
      backgroundColor: backroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: dateDocsList.isNotEmpty
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 20.0, right: 20.0, top: 0, bottom: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          //*date--

                          Text(
                            splittedDateDocList[selectedDateIndex][0]
                                        .toString()
                                        .length ==
                                    1
                                ? "0${splittedDateDocList[selectedDateIndex][0]},${splittedDateDocList[selectedDateIndex][3]}"
                                : "${splittedDateDocList[selectedDateIndex][0]},${splittedDateDocList[selectedDateIndex][3]}",
                            style: GoogleFonts.quicksand(
                                fontSize: 29,
                                fontWeight: FontWeight.w500,
                                color: Colors.white),
                          ),
                          //*actions buttons------
                        ],
                      ),
                    ),
                    //*date listview
                    SizedBox(
                      height: screenHeight / 12.5,
                      child: ListView.builder(
                        shrinkWrap: true,
                        padding: const EdgeInsets.only(
                          left: 20,
                          right: 20,
                        ),
                        scrollDirection: Axis.horizontal,
                        itemCount: dateDocsList.length,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {
                              setState(
                                () {
                                  selectedDateIndex = index;
                                  selectedCategoryIndex = 0;
                                  splittedDateDocList[index][0]
                                              .toString()
                                              .length ==
                                          1
                                      ? "0${splittedDateDocList[selectedDateIndex][0]},${splittedDateDocList[selectedDateIndex][3]}"
                                      : "${splittedDateDocList[selectedDateIndex][0]},${splittedDateDocList[selectedDateIndex][3]}";
                                },
                              );

                              final height = screenHeight / 12.5;
                              debugPrint(height.toString());
                            },
                            child: Container(
                              width: screenHeight / 11,
                              height: screenWidth / 12.5,
                              padding: const EdgeInsets.all(2),
                              alignment: Alignment.center,
                              margin: const EdgeInsets.only(right: 3),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(22.0),
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
                                textAlign: TextAlign.center,
                                splittedDateDocList[index][0]
                                            .toString()
                                            .length !=
                                        1
                                    ? "${splittedDateDocList[index][0].toString()}\n${splittedDateDocList[index][3].toString()}"
                                    : "0${splittedDateDocList[index][0]}\n${splittedDateDocList[index][3]}",
                                style: GoogleFonts.quicksand(
                                    fontSize: 13,
                                    fontWeight: selectedDateIndex == index
                                        ? FontWeight.w600
                                        : FontWeight.w400,
                                    color: selectedDateIndex == index
                                        ? Colors.white
                                        : lighTextColor),
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                    SearchBarHome(
                      dateDocsList: dateDocsList,
                      selectedDateIndex: selectedDateIndex,
                    ),

                    StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection("notes")
                            .doc(dateDocsList[selectedDateIndex])
                            .collection("cats&notes")
                            .snapshots(),
                        builder: (context, catSnapshot) {
                          if (catSnapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          } else if (catSnapshot.hasError) {
                            return Center(
                              child: Text(
                                catSnapshot.error.toString(),
                                style: GoogleFonts.inter(
                                  color: Colors.red,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            );
                          } else if (catSnapshot.hasData) {
                            //*categeory Listview to categorise notes by date

                            return Column(
                              children: [
                                const SizedBox(
                                  height: 12,
                                ),
                                SizedBox(
                                  height: screenHeight / 18.045,
                                  child: ListView.builder(
                                    padding: const EdgeInsets.only(
                                      left: 5,
                                      right: 5,
                                    ),
                                    itemCount: catSnapshot.data!.docs.length,
                                    scrollDirection: Axis.horizontal,
                                    itemBuilder: (context, index) => InkWell(
                                      onTap: () {
                                        setState(() {
                                          selectedCategoryIndex = index;
                                        });
                                      },
                                      child: Container(
                                        margin: const EdgeInsets.only(right: 3),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 13, vertical: 11),
                                        alignment: Alignment.center,
                                        height: screenHeight / 18.045,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(32),
                                          gradient: selectedCategoryIndex !=
                                                  index
                                              ? LinearGradient(
                                                  colors: [
                                                      const Color(0xff777777)
                                                          .withOpacity(0.32),
                                                      const Color(0xff393939)
                                                          .withOpacity(0.65)
                                                          .withOpacity(0.35)
                                                    ],
                                                  begin: Alignment.topCenter,
                                                  end: Alignment.bottomRight)
                                              : LinearGradient(colors: [
                                                  primaryColor,
                                                  primaryColor.withOpacity(0.65)
                                                ]),
                                        ),
                                        child: Text(
                                          catSnapshot.data!.docs[index].id,
                                          style: GoogleFonts.quicksand(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w500,
                                              color:
                                                  selectedCategoryIndex != index
                                                      ? unSelectedTextColor
                                                      : Colors.white),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                StreamBuilder<QuerySnapshot>(
                                    stream: FirebaseFirestore.instance
                                        .collection("notes")
                                        .doc(dateDocsList[selectedDateIndex])
                                        .collection("cats&notes")
                                        .doc(catSnapshot.data!
                                            .docs[selectedCategoryIndex].id)
                                        .collection(
                                            "all${catSnapshot.data!.docs[selectedCategoryIndex].id}")
                                        .snapshots(),
                                    builder: (context, noteSnapshot) {
                                      if (noteSnapshot.data != null) {
                                        log(noteSnapshot.data!.toString());
                                        if (noteSnapshot
                                            .data!.docs.isNotEmpty) {
                                          log("has data");
                                          return SizedBox(
                                            height: screenHeight / 1.6,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 5,
                                                      vertical: 10),
                                              //*gridview
                                              child: GridView.builder(
                                                shrinkWrap: true,
                                                physics: const ScrollPhysics(),
                                                gridDelegate:
                                                    SliverGridDelegateWithMaxCrossAxisExtent(
                                                        crossAxisSpacing: 2,
                                                        mainAxisSpacing: 2,
                                                        //mainAxisExtent: 0.5,
                                                        maxCrossAxisExtent:
                                                            screenWidth / 2.0,
                                                        mainAxisExtent:
                                                            screenHeight / 4.5),
                                                itemCount: noteSnapshot
                                                    .data!.docs.length,
                                                itemBuilder: (context, index) {
                                                  bool isPinned = noteSnapshot
                                                      .data!
                                                      .docs[index]["isPinned"];
                                                  return InkWell(
                                                    onTap: () {
                                                      Navigator.of(context)
                                                          .push(
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              NoteDetailPage(
                                                            noteDate: dateDocsList[
                                                                selectedDateIndex],
                                                            noteCategoryName:
                                                                catSnapshot
                                                                    .data!
                                                                    .docs[
                                                                        selectedCategoryIndex]
                                                                    .id,
                                                            noteTitle: noteSnapshot
                                                                    .data!
                                                                    .docs[index]
                                                                ["title"],
                                                            noteContent:
                                                                noteSnapshot
                                                                        .data!
                                                                        .docs[index]
                                                                    ["content"],
                                                            isDone: noteSnapshot
                                                                    .data!
                                                                    .docs[index]
                                                                ["isDone"],
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                    child: Container(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 10,
                                                              right: 4,
                                                              top: 6,
                                                              bottom: 8),
                                                      //height: screenHeight / 4.54,
                                                      //width: screenHeight / 4.43,
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
                                                              noteContainerBottomColor
                                                            ],
                                                            begin: Alignment
                                                                .topCenter,
                                                            end: Alignment
                                                                .bottomCenter),
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
                                                                  padding: EdgeInsets.all(
                                                                      screenHeight /
                                                                          116),
                                                                  decoration:
                                                                      ShapeDecoration(
                                                                    gradient: LinearGradient(
                                                                        colors: [
                                                                          headingContainerColor,
                                                                          headingContainerColor
                                                                              .withOpacity(0.8),
                                                                        ],
                                                                        begin: Alignment
                                                                            .topLeft,
                                                                        end: Alignment
                                                                            .bottomRight),
                                                                    shape:
                                                                        SmoothRectangleBorder(
                                                                      borderRadius: SmoothBorderRadius(
                                                                          cornerRadius:
                                                                              14,
                                                                          cornerSmoothing:
                                                                              1),
                                                                    ),
                                                                  ),
                                                                  child: Text(
                                                                    softWrap:
                                                                        false,
                                                                    noteSnapshot
                                                                        .data!
                                                                        .docs[
                                                                            index]
                                                                        .id,
                                                                    style: GoogleFonts
                                                                        .quicksand(
                                                                      color: Colors
                                                                          .white,
                                                                      fontSize:
                                                                          14,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                    ),
                                                                    maxLines: 1,
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                  ),
                                                                ),
                                                              ),
                                                              IconButton(
                                                                  //style: IconButton.styleFrom(
                                                                  //    padding:
                                                                  //        EdgeInsets.all(
                                                                  //            0),
                                                                  //    backgroundColor: Colors
                                                                  //        .white
                                                                  //        .withOpacity(
                                                                  //            0.5),
                                                                  //    elevation:
                                                                  //        0),
                                                                  onPressed:
                                                                      () {
                                                                    String
                                                                        categoryNameAsDocId =
                                                                        catSnapshot
                                                                            .data!
                                                                            .docs[selectedCategoryIndex]
                                                                            .id;
                                                                    String
                                                                        docId =
                                                                        dateDocsList[
                                                                            selectedDateIndex];
                                                                    String
                                                                        title =
                                                                        noteSnapshot
                                                                            .data!
                                                                            .docs[index]
                                                                            .id;

                                                                    setState(
                                                                        () {
                                                                      isPinned = !noteSnapshot
                                                                          .data!
                                                                          .docs[index]["isPinned"];
                                                                    });

                                                                    log("value==$isPinned");
                                                                    FirestoreNotes().updatePinValue(
                                                                        docId:
                                                                            docId,
                                                                        categoryNameAsDocId:
                                                                            categoryNameAsDocId,
                                                                        title:
                                                                            title,
                                                                        boolValue:
                                                                            isPinned);
                                                                    //?calling a SnackBar
                                                                    ScaffoldMessenger.of(
                                                                            context)
                                                                        .showSnackBar(
                                                                      SnackBar(
                                                                        duration:
                                                                            const Duration(seconds: 2),
                                                                        backgroundColor: const Color
                                                                            .fromARGB(
                                                                            255,
                                                                            26,
                                                                            26,
                                                                            26),
                                                                        behavior:
                                                                            SnackBarBehavior.floating,
                                                                        content:
                                                                            Center(
                                                                          child:
                                                                              Text(
                                                                            isPinned != true
                                                                                ? "note Unpinned"
                                                                                : "note pinned",
                                                                            style:
                                                                                GoogleFonts.inter(color: isPinned != true ? Colors.white : Colors.green),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    );
                                                                  },
                                                                  //  icon: SvgPicture
                                                                  //      .asset(
                                                                  //    "asset/svg/pin.svg",
                                                                  //    height: 18,
                                                                  //    color: isPinned !=
                                                                  //            true
                                                                  //        ? Colors
                                                                  //            .black
                                                                  //            .withOpacity(
                                                                  //                0.2)
                                                                  //        : primaryColor,
                                                                  //  ),
                                                                  //)
                                                                  icon:
                                                                      SvgPicture
                                                                          .asset(
                                                                    isPinned !=
                                                                            true
                                                                        ? "asset/typcn--pin-outline.svg"
                                                                        : "asset/typcn--pin.svg",
                                                                    height: 28,
                                                                    color: isPinned !=
                                                                            true
                                                                        ? Colors
                                                                            .white
                                                                        : primaryColor,
                                                                  ))
                                                            ],
                                                          ),
                                                          for (var element
                                                              in noteSnapshot
                                                                  .data!.docs)
                                                            Flexible(
                                                              child: Text(
                                                                element[
                                                                    "content"],
                                                                style: GoogleFonts
                                                                    .quicksand(
                                                                        color: Colors
                                                                            .white,
                                                                        height:
                                                                            0),
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                maxLines: 6,
                                                              ),
                                                            )
                                                        ],
                                                      ),
                                                    ),
                                                  );
                                                },
                                              ),
                                            ),
                                          );
                                        } else {
                                          return Container(
                                            margin:
                                                const EdgeInsets.only(top: 50),
                                            child: Center(
                                              child: Text(
                                                "No data found ",
                                                style: GoogleFonts.inter(
                                                  color: Colors.grey,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                          );
                                        }
                                      } else {
                                        return const Center(
                                            //child: CircularProgressIndicator(),
                                            );
                                      }
                                    })
                              ],
                            );
                          } else {
                            return Column(
                              children: [
                                const SizedBox(
                                  height: 100,
                                ),
                                Center(
                                  child: Text(
                                    "No data found ",
                                    style: GoogleFonts.inter(
                                      color: Colors.red,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            );
                          }
                        })
                  ],
                )
              : Column(
                  children: [
                    const SizedBox(
                      height: 100,
                    ),
                    Center(
                      child: Text(
                        textAlign: TextAlign.center,
                        '''"you have added 0 notes yet"''',
                        style: GoogleFonts.inter(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  onSearch(String? value) {
    searchedValue = value!;
    if (searchedValue != null) {}
  }

  //*get dates added
  getDateDocsDate() async {
    var collRef = FirebaseFirestore.instance.collection("notes");
    var collData = await collRef.get();
    dateDocsList.clear();
    for (var element in collData.docs.reversed) {
      setState(() {
        dateDocsList.add(element.id);
        log('added to datedocs');
      });
    }
    log("s$dateDocs");
  }
}
//  Future<dynamic>? checkConnectivity(context) async {
//    checkConnectivityRes = await connectivity.checkConnectivity();
//    if (checkConnectivityRes == ConnectivityResult.mobile) {
//      log("workied");
//      return showDialog(
//          context: (context),
//          builder: (context) => const AlertDialog(
//                content: Text("Offline"),
//              ));
//    }
//    if (checkConnectivityRes == ConnectionState.active) {
//      log("hi");
//    } else {
//      log("d");
//    }
//  }
//}
//    Padding(
//  padding:
//      const EdgeInsets.symmetric(horizontal: 20, vertical: 9),
//  child: Form(
//    child: Container(
//      height: 42,
//      width: double.infinity,
//      //color: noteContainerColor,
//      decoration: BoxDecoration(
//        borderRadius: BorderRadius.circular(12),
//        gradient: LinearGradient(
//            colors: [
//              const Color(0xff777777).withOpacity(0.32),
//              const Color(0xff393939)
//                  .withOpacity(0.65)
//                  .withOpacity(0.35)
//            ],
//            begin: Alignment.topCenter,
//            end: Alignment.bottomRight),
//      ),
//      child: TextFormField(
//        //controller: searchBarController,
//        decoration: InputDecoration(
//            contentPadding:
//                const EdgeInsets.symmetric(vertical: 15),
//            prefixIconConstraints: BoxConstraints.tight(
//              const Size.square(38),
//            ),
//            prefixIconColor: Colors.grey,
//            prefixIcon: Padding(
//              padding:
//                  const EdgeInsets.symmetric(horizontal: 10),
//              child: SvgPicture.asset(
//                "asset/svg/search svg.svg",
//              ),
//            ),
//            //contentPadding:
//            //    EdgeInsets.symmetric(horizontal: 10),
//            border: const OutlineInputBorder(
//                borderSide: BorderSide.none),
//            hintText: "Search notes",
//            hintStyle: GoogleFonts.quicksand(
//                fontSize: 14, color: Colors.grey)),
//      ),
//    ),
//  ),
//),
