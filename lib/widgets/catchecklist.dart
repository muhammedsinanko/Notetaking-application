//// ignore_for_file: must_be_immutable

//import 'dart:developer';
//import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:figma_squircle/figma_squircle.dart';
//import 'package:flutter/material.dart';
//import 'package:google_fonts/google_fonts.dart';
//import 'package:notes_taking_app/services/firestore_services.dart';

//import '../../model/catnamelistmodel.dart';

//class CategoryCheckList extends StatefulWidget {
//  const CategoryCheckList({
//    super.key,
//  });

//  @override
//  State<CategoryCheckList> createState() => _CategoryCheckListState();
//}

//class _CategoryCheckListState extends State<CategoryCheckList> {
//  @override
//  Widget build(BuildContext context) {
//    return StreamBuilder<QuerySnapshot>(
//      stream: FirebaseFirestore.instance.collection('category').snapshots(),
//      builder: (context, snapshot) {
//        if (snapshot.connectionState == ConnectionState.waiting) {
//          return const Center(
//            child: CircularProgressIndicator(),
//          );
//        }
//        if (snapshot.hasError) {
//          return Center(
//            child: Text('${snapshot.error}'),
//          );
//        }

//        if (snapshot.hasData) {
//          catNameListModel.clearCatNameList();
//          for (var trueCatName in snapshot.data!.docs) {
//            log(trueCatName['isSelected'].toString());
//            if (trueCatName['isSelected'] == true) {
//              catNameListModel.addTrueCat(trueCatName['name']);
//            }
//          }
//          return ListView.builder(
//            itemCount: snapshot.data!.docs.length,
//            itemBuilder: (context, index) {
//              List<String> docIdList = [];
//              return CheckboxListTile(
//                fillColor: MaterialStateProperty.all(const Color(0xff56A119)),
//                checkboxShape: SmoothRectangleBorder(
//                  borderRadius:
//                      SmoothBorderRadius(cornerRadius: 6, cornerSmoothing: 1),
//                ),
//                checkColor: Colors.white,
//                controlAffinity: ListTileControlAffinity.leading,
//                activeColor: Colors.white,
//                title: Row(
//                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                  children: [
//                    Text(
//                      snapshot.data!.docs[index]['name'],
//                      style: GoogleFonts.quicksand(color: Colors.white),
//                    ),
//                  ],
//                ),
//                value: snapshot.data!.docs[index]['isSelected'],
//                onChanged: (value) async {
//                  final firestoreColl =
//                      FirebaseFirestore.instance.collection('category');
//                  await firestoreColl.get().then(
//                    (value) {
//                      for (var element in value.docs) {
//                        firestoreColl.doc(element.id);
//                        log(element.id.toString());
//                        docIdList.add(element.id);
//                        log(docIdList.toString());
//                      }
//                    },
//                  );
//                  log(snapshot.data!.toString());
//                  setState(() {
//                    FirestoreServicesCat()
//                        .updateValue(docName: docIdList[index], value: value!);
//                  });
//                },
//              );
//            },
//          );
//        } else {
//          return const Center(
//            child: Text('Something went wrong please try again'),
//          );
//        }
//      },
//    );
//  }
//}
