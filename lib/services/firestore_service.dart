import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
//import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iooi/screens/homepage.dart';

class FirestoreCategory {
  var catCollRef = FirebaseFirestore.instance.collection("category");

//*addcategory
  addCategoryToFirestore(
      {required String categoryName, required bool isSelected}) async {
    try {
      await catCollRef.add({
        "catname": categoryName,
        "isSelected": isSelected,
      });
      log("added successfully");
    } catch (e) {
      log(e.toString());
    }
  }

  updateCatValue(
      {required String catName,
      required bool isSelected,
      required String docId}) async {
    Map<String, dynamic> updatedMap = {
      //"catname": catName,
      "isSelected": isSelected
    };
    await catCollRef.doc(docId).update(updatedMap);
  }
}

class FirestoreNotes {
  var collRef = FirebaseFirestore.instance.collection("notes");

//*add notes
  Future<String> addNotes(
      {required String docId,
      required String categoryNameAsDocId,
      required String title,
      required BuildContext context,
      required String content}) async {
    log("function lauched");
    log("docId$docId");
    log("categoryname$categoryNameAsDocId");
    Map<String, dynamic> data = {
      "date": docId,
      "category": categoryNameAsDocId,
      "title": title,
      "content": content,
      "isPinned": false,
      "isDone": false
    };
    try {
      collRef.doc(docId).set({"date": docId});
      var res = await collRef
          .doc(docId)
          .collection("cats&notes")
          .doc(categoryNameAsDocId)
          .collection("all$categoryNameAsDocId")
          .doc(categoryNameAsDocId)
          .get();
      log("res==${res.data()}");
      if (res.data() != null) {
        log("++++++++++data notempty");
        if (res.data()!.isNotEmpty) {
          collRef
              .doc(docId)
              .collection("cats&notes")
              .doc(categoryNameAsDocId)
              .update({"cateogry": categoryNameAsDocId});
          //!do update
          collRef
              .doc(docId)
              .collection("cats&notes")
              .doc(categoryNameAsDocId)
              .collection("all$categoryNameAsDocId")
              .doc(title)
              .update(data);
          return "notes added successfully";
        }
      } else {
        log("}}}}}}}}}data empty");
        collRef
            .doc(docId)
            .collection("cats&notes")
            .doc(categoryNameAsDocId)
            .set({"category": categoryNameAsDocId});
        //!do set
        collRef
            .doc(docId)
            .collection("cats&notes")
            .doc(categoryNameAsDocId)
            .collection("all$categoryNameAsDocId")
            .doc(title)
            .set(data);
      }
      return "notes added successfully";
    } catch (e) {
      log("error${e.toString()}");
      return "failed with error ${e.toString()}";
    }
  }

//*update pinvalue
  updatePinValue(
      {required String docId,
      required String categoryNameAsDocId,
      required String title,
      required bool boolValue}) async {
    await collRef
        .doc(docId)
        .collection("cats&notes")
        .doc(categoryNameAsDocId)
        .collection("all$categoryNameAsDocId")
        .doc(title)
        .update({"isPinned": boolValue});
  }

//?updat donev
  Future<bool> updateToDone(
      {required String docId,
      required String categoryNameAsDocId,
      required String title,
      required bool boolValue,
      required context}) async {
    try {
      await collRef
          .doc(docId)
          .collection("cats&notes")
          .doc(categoryNameAsDocId)
          .collection("all$categoryNameAsDocId")
          .doc(title)
          .update({"isDone": boolValue});
      log("updated");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        duration: const Duration(seconds: 1),
        backgroundColor: const Color.fromARGB(255, 26, 26, 26),
        behavior: SnackBarBehavior.floating,
        content: Center(
          child: Text(
            boolValue
                ? "Successflly you've achieved this task"
                : "Marked as not done",
            style: GoogleFonts.inter(
                color: boolValue ? Colors.green : Colors.white),
          ),
        ),
      ));
      return !boolValue;
    } catch (e) {
      log(e.toString());
      return boolValue;
    }
  }

  Future deleteNote(
      {required String date,
      required String category,
      required String title,
      required context}) async {
    String? message;
    try {
      await collRef
          .doc(date)
          .collection("cats&notes")
          .doc(category)
          .collection("all$category")
          .doc(title)
          .delete();
      message == "success";
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          duration: Duration(seconds: 2),
          backgroundColor: Color.fromARGB(255, 26, 26, 26),
          behavior: SnackBarBehavior.floating,
          content: Center(
            child: Text("s"),
          ),
        ),
      );
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => const HomePage()));
    } catch (e) {
      message = e.toString();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: const Duration(seconds: 2),
          backgroundColor: const Color.fromARGB(255, 26, 26, 26),
          behavior: SnackBarBehavior.floating,
          content: Center(
            child: Text(message),
          ),
        ),
      );
    }
  }
////?undo from done
//  undoFromDoneNOn(
//      {required String docId,
//      required String categoryNameAsDocId,
//      required String title,
//      required bool boolValue}) async {
//    await collRef
//        .doc(docId)
//        .collection("cats&notes")
//        .doc(categoryNameAsDocId)
//        .collection("all$categoryNameAsDocId")
//        .doc(title)
//        .update({"isDone": boolValue});
//  }

  Future getAllPinnedNotes({required String docId}) async {
    List<Map<String, dynamic>> pinnedList = [];
    var catsAndNotesRef =
        await collRef.doc(docId).collection("cats&notes").get();
    //for (var element in catsAndNotesRef.docs) {
    //  if (element.data()["isPinned"] == true) {
    //    log("hahha${element.id}");
    //  }
    //}
    QuerySnapshot<Map<String, dynamic>>? notesRef;
    for (var element in catsAndNotesRef.docs) {
      try {
        notesRef = await collRef
            .doc(docId)
            .collection("cats&notes")
            .doc(element.id)
            .collection("all${element.id}")
            .get();
      } catch (e) {
        log("e=$e");
      }
    }
    List<dynamic> catsAndnotesList = [];
    catsAndNotesRef.docs.map((e) {
      log("data=+++++++++++=${e.data()}");
      catsAndnotesList.add(e.id);
    });
    catsAndnotesList.map((e) {});
    for (var element in notesRef!.docs) {
      pinnedList.add(element.data());
      //log("pin==$pinnedList");
    }
    log(pinnedList.length.toString());
    return pinnedList;
  }

  deleteDidTheseNotes(String dateAsDocId) async {
    var docRef = await collRef.doc(dateAsDocId).collection("cats&notes").get();
    Map<String, dynamic> mapData = {};
    for (var element in docRef.docs) {
      var allCatRef = await collRef
          .doc(dateAsDocId)
          .collection("cats&notes")
          .doc(element.id)
          .collection("all${element.id}")
          .get();
      for (var element1 in allCatRef.docs) {
        if (element1["isDone"] == true) {
          if (mapData.containsKey(element.id)) {
            mapData[element.id]!.add(element1.data());
          } else {
            mapData[element.id] = [element1.data()];
          }
        }
      }
    }
  }

  updateNote(
      {required String oldTitle,
      required String date,
      required String category,
      required String newTitle,
      required String content,
      context}) async {
    log("date$date");
    log(category);
    log(newTitle);
    log("content$content");
    //log(date);
    Map<String, dynamic> data = {
      "title": newTitle,
      "content": content,
    };
    try {
      log("oldTitle$oldTitle");
      log("newTitle$newTitle");
      log("conent$content");
      if (oldTitle == newTitle) {
        await collRef
            .doc(date)
            .collection("cats&notes")
            .doc(category)
            .collection("all$category")
            .doc(newTitle)
            .update(data);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            //margin: const EdgeInsets.all(10),
            backgroundColor: const Color.fromARGB(255, 26, 26, 26),
            content: Center(
              child: Text(
                "Note updated",
                style: GoogleFonts.inter(
                  color: Colors.white,
                ),
              ),
            ),
          ),
        );
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: ((context) => const HomePage())));
      } else {
        DocumentSnapshot<Map<String, dynamic>> oldDocRef = await collRef
            .doc(date)
            .collection("cats&notes")
            .doc(category)
            .collection("all$category")
            .doc(oldTitle)
            .get();
        await collRef
            .doc(date)
            .collection("cats&notes")
            .doc(category)
            .collection("all$category")
            .doc(newTitle)
            .set(oldDocRef.data()!);
        await collRef
            .doc(date)
            .collection("cats&notes")
            .doc(category)
            .collection("all$category")
            .doc(newTitle)
            .update(data);
        await collRef
            .doc(date)
            .collection("cats&notes")
            .doc(category)
            .collection("all$category")
            .doc(oldTitle)
            .delete();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            //margin: const EdgeInsets.all(10),
            backgroundColor: const Color.fromARGB(255, 26, 26, 26),
            content: Center(
              child: Text(
                "Note updated",
                style: GoogleFonts.inter(
                  color: Colors.white,
                ),
              ),
            ),
          ),
        );
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: ((context) => const HomePage())));
      }
      //get old docsdata
    } catch (e) {
      log(e.toString());
    }
  }

  Future<Map<String, List<Map<dynamic, dynamic>>>> getPinnedOrAchievedNotes(
      String didTheseOrPinned, String dateAsDocId) async {
    var collRef = FirebaseFirestore.instance.collection("notes");
    var docRef = await collRef.doc(dateAsDocId).collection("cats&notes").get();
    if (didTheseOrPinned == "pinned") {
      List<Map<String, List<Map>>> data = [];
      Map<String, List<Map>> mapdData = {};
      for (var element in docRef.docs) {
        var allCatRef = await collRef
            .doc(dateAsDocId)
            .collection("cats&notes")
            .doc(element.id)
            .collection("all${element.id}")
            .get();
        for (var element1 in allCatRef.docs) {
          if (element1["isPinned"] == true) {
            if (mapdData.containsKey(element.id)) {
              mapdData[element.id]!.add(element1.data());
            } else {
              mapdData[element.id] = [element1.data()];
            }
          }
        }
      }
      data.add(mapdData);
      return mapdData;
    } else {
      log(dateAsDocId);
      List<Map<String, List<Map>>> data = [];
      Map<String, List<Map>> mapdData = {};
      for (var element in docRef.docs) {
        var allCatRef = await collRef
            .doc(dateAsDocId)
            .collection("cats&notes")
            .doc(element.id)
            .collection("all${element.id}")
            .get();
        for (var element1 in allCatRef.docs) {
          if (element1["isDone"] == true) {
            if (mapdData.containsKey(element.id)) {
              mapdData[element.id]!.add(element1.data());
            } else {
              mapdData[element.id] = [element1.data()];
            }
          }
        }
      }
      data.add(mapdData);
      log("dataList===${mapdData}");
      return mapdData;
    }
  }
}

class AuthService {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  Future<User?> isUserLoggedIn() async {
    final user = firebaseAuth.currentUser;
    return user;
  }
}

class FireStoreStorage {
  final storageRef = FirebaseStorage.instance.ref();

  // Create a child reference
// imagesRef now points to "images"
  uploadFile(String fileName, File file) async {
    FirebaseAppCheck.instance.activate();
    Reference imageRef = storageRef.child("image");
    Reference fileRef = imageRef.child(fileName);
    try {
      fileRef.putFile(file);
    } catch (e) {
      log(e.toString());
    }
  }
}
