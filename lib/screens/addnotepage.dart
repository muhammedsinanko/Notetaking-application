// ignore_for_file: must_be_immutable

import 'dart:developer';
import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/firestore_service.dart';
import 'package:intl/intl.dart';

class AddNotePage extends StatefulWidget {
  String? noteDate, noteCategoryName, noteTitle, noteContent;
  AddNotePage(
      {super.key,
      this.noteTitle,
      this.noteContent,
      this.noteCategoryName,
      this.noteDate});

  @override
  State<AddNotePage> createState() => _AddNotePageState();
}

class _AddNotePageState extends State<AddNotePage> {
  //CatNameListModel catNameListModel = CatNameListModel(catNameList: []);
  TextEditingController titleController = TextEditingController();
  TextEditingController noteController = TextEditingController();
  final titleAndNotesFormKey = GlobalKey<FormState>();
  TextEditingController catNameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isTextFieldVisible = false;
  String? oldTitle;
  @override
  void initState() {
    oldTitle = widget.noteTitle;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String? noteTitle = widget.noteTitle;
    String? noteContent = widget.noteContent;
    double screenHeight = MediaQuery.of(context).size.height;
    if (noteTitle != null) {
      titleController = TextEditingController(text: noteTitle);
      noteController = TextEditingController(text: noteContent);
    }

    //final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
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
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: Row(
              children: [
                InkWell(
                    onTap: () {
                      bool titleAndNoteBool = titleAndNotValidation();
                      if (titleAndNoteBool) {
                        //*check if the edit or add
                        if (oldTitle == null || widget.noteContent == null) {
                          showModelBottomsheet(
                            context: context,
                            screenHeight: screenHeight,
                          );
                        } else {
                          log(titleController.text); //*its updating
                          noteTitle = titleController.text;
                          noteContent = noteController.text;
                          FirestoreNotes().updateNote(
                              oldTitle: oldTitle!,
                              date: widget.noteDate!,
                              category: widget.noteCategoryName!,
                              newTitle: noteTitle!,
                              content: noteContent!,
                              context: context);
                        }
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            //margin: const EdgeInsets.symmetric(
                            //  horizontal: 10,
                            //  vertical: 20,
                            //),
                            behavior: SnackBarBehavior.floating,
                            backgroundColor:
                                const Color.fromARGB(255, 51, 51, 51),
                            content: Center(
                              child: Text(
                                "Please fill title and it's note",
                                style: GoogleFonts.inter(
                                  fontSize: 14,
                                  color: Colors.red.shade300,
                                ),
                              ),
                            ),
                          ),
                        );
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: primaryColor,
                        borderRadius: BorderRadius.circular(25),
                      ),
                      alignment: Alignment.center,
                      width: 100,
                      height: 40,
                      child: Text(
                        "Save",
                        style: GoogleFonts.quicksand(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w700),
                      ),
                    )),
              ],
            ),
          ),
        ],
      ),
      backgroundColor: backroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SingleChildScrollView(
                  child: Form(
                    key: titleAndNotesFormKey,
                    child: Column(
                      children: [
                        TextFormField(
                          onChanged: (value) {
                            widget.noteTitle = value;
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please enter a title of your note";
                            } else {
                              return null;
                            }
                          },
                          controller: titleController,
                          cursorColor: primaryColor,
                          textAlign: TextAlign.left,
                          style: GoogleFonts.quicksand(
                            color: Colors.white,
                            textStyle: const TextStyle(
                              overflow: TextOverflow.ellipsis,
                            ),
                            fontWeight: FontWeight.w700,
                            fontSize: 24,
                          ),
                          decoration: InputDecoration(
                            hintMaxLines: 1,
                            hintText: 'Title',
                            hintStyle: GoogleFonts.quicksand(
                              color: const Color.fromARGB(255, 145, 145, 145),
                            ),
                            border: InputBorder.none,
                          ),
                        ),
                        SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          reverse: true,
                          child: TextFormField(
                            onChanged: (value) {
                              widget.noteContent = value;
                            },
                            maxLength: null,
                            scrollPhysics: null,
                            maxLines: 24,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Please enter your note";
                              } else {
                                return null;
                              }
                            },
                            controller: noteController,
                            cursorColor: primaryColor,
                            textAlign: TextAlign.left,
                            style: GoogleFonts.quicksand(
                              color: Colors.white,
                              textStyle: const TextStyle(
                                overflow: TextOverflow.ellipsis,
                              ),
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                            //controller: noteController,
                            decoration: InputDecoration(
                              hintMaxLines: 1,
                              hintText: 'Notes',
                              hintStyle: GoogleFonts.quicksand(
                                color: const Color.fromARGB(255, 145, 145, 145),
                              ),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<dynamic> showModelBottomsheet({
    required BuildContext context,
    required double screenHeight,
  }) async {
    FirestoreCategory firestoreCategory = FirestoreCategory();
    return showModalBottomSheet(
        isScrollControlled: true,
        clipBehavior: Clip.none,
        context: context,
        builder: (context) {
          List<QueryDocumentSnapshot<Object?>> catDocsList = [];
          List<String> categoryNameList = [];
          List<bool> categoryValueList = [];
          return StatefulBuilder(
            builder: (context, setState) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
              decoration: const ShapeDecoration(
                color: Color(0xff252525),
                shape: SmoothRectangleBorder(
                  borderRadius: SmoothBorderRadius.only(
                    topLeft: SmoothRadius(cornerRadius: 25, cornerSmoothing: 1),
                    topRight:
                        SmoothRadius(cornerRadius: 25, cornerSmoothing: 1),
                  ),
                ),
              ),
              //height: screenHeight / 1.3,
              width: double.infinity,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Text(
                            'Category',
                            style: GoogleFonts.quicksand(
                                fontSize: 16,
                                color: Colors.white,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                        const SizedBox(
                          height: 6,
                        ),
                        Divider(
                          color: Colors.grey.shade800,
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsetsDirectional.zero,
                            elevation: 0,
                            backgroundColor: Colors.transparent,
                          ),
                          onPressed: () {
                            //*making textfield visible
                            setState(() => isTextFieldVisible = true);
                          },
                          icon: Icon(
                            Icons.add,
                            color: primaryColor,
                          ),
                          label: Text(
                            'add new category',
                            style: GoogleFonts.quicksand(
                              color: primaryColor,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Visibility(
                          visible: isTextFieldVisible,
                          child: Column(
                            children: [
                              Form(
                                key: _formKey,
                                child: Container(
                                  margin:
                                      const EdgeInsets.only(top: 2, bottom: 6),
                                  height: 40,
                                  child: TextFormField(
                                    style: GoogleFonts.quicksand(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600),
                                    keyboardType: TextInputType.text,
                                    decoration: InputDecoration(
                                      enabledBorder: const UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            width: 0.6, color: Colors.white70),
                                      ),
                                      hintText: "Category name",
                                      hintStyle: GoogleFonts.montserrat(
                                        fontSize: 12,
                                        color: Colors.grey.shade600,
                                      ),
                                    ),
                                    controller: catNameController,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return "Please enter a new category name";
                                      } else {
                                        return null;
                                      }
                                    },
                                  ),
                                ),
                              ),
                              Align(
                                alignment: Alignment.center,
                                child: TextButton(
                                  onPressed: () {
                                    String catName = catNameController.text;
                                    if (catName.isNotEmpty) {
                                      //?add cat
                                      if (categoryNameList.isNotEmpty) {
                                        for (var element in categoryNameList) {
                                          if (element != catName) {
                                            firestoreCategory
                                                .addCategoryToFirestore(
                                                    categoryName: catName,
                                                    isSelected: true);
                                            setState(
                                              () => isTextFieldVisible = false,
                                            );
                                          } else {
                                            showDialog(
                                              context: context,
                                              builder: (context) => AlertDialog(
                                                contentPadding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 8),
                                                content: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                        '$catName already exists'),
                                                    IconButton(
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        icon: const Icon(
                                                            Icons.done))
                                                  ],
                                                ),
                                              ),
                                            );
                                          }
                                          break;
                                        }
                                      } else {
                                        FirestoreCategory()
                                            .addCategoryToFirestore(
                                                categoryName: catName,
                                                isSelected: true);
                                      }
                                    } else {
                                      _formKey.currentState!.validate();
                                    }
                                  },
                                  child: Text(
                                    'Add',
                                    style: GoogleFonts.quicksand(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700,
                                        color: primaryColor),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 6,
                        ),
                        //*category listvivew
                        SizedBox(
                          height: screenHeight / 4,
                          child: StreamBuilder<QuerySnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection("category")
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
                              if (snapshot.hasError) {
                                return Center(
                                    child: Text(snapshot.error.toString()));
                              }
                              if (snapshot.data != null) {
                                if (snapshot.data!.docs.isNotEmpty) {
                                  catDocsList = snapshot.data!.docs;
                                  log("docsList$catDocsList");
                                  return ListView.builder(
                                    itemCount: snapshot.data!.docs.length,
                                    itemBuilder: (context, index) {
                                      categoryValueList.add(snapshot
                                          .data!.docs[index]["isSelected"]);
                                      log(categoryValueList.toString());
                                      categoryNameList.add(snapshot
                                          .data!.docs[index]["catname"]);
                                      log(categoryNameList.toString());
                                      return StatefulBuilder(
                                        builder: (context, setState) {
                                          return CheckboxListTile(
                                            title: Text(
                                              snapshot.data!.docs[index]
                                                  ["catname"],
                                              style: GoogleFonts.quicksand(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                            value: snapshot.data!.docs[index]
                                                ["isSelected"],
                                            onChanged: (value) {
                                              final docId =
                                                  snapshot.data!.docs[index].id;
                                              String catname = snapshot
                                                  .data!.docs[index]["catname"];

                                              setState(
                                                () {
                                                  firestoreCategory
                                                      .updateCatValue(
                                                          catName: catname,
                                                          isSelected: value!,
                                                          docId: docId);
                                                },
                                              );
                                            },
                                          );
                                        },
                                      );
                                    },
                                  );
                                }
                              }

                              if (snapshot.data == null) {
                                return Center(
                                    child: Text(
                                  "Have no category added Please add a category",
                                  style: GoogleFonts.manrope(
                                      color: Colors.red, fontSize: 12),
                                ));
                              } else {
                                return Center(
                                    child: Text(
                                  "Have no category added Please add a category",
                                  style: GoogleFonts.inter(
                                      color: Colors.red, fontSize: 13),
                                ));
                              }
                            },
                          ),
                        )
                      ],
                    ),
                    InkWell(
                      onTap: () {
                        saveClick(catDocsList: catDocsList, context: context);
                      },
                      child: Container(
                        alignment: Alignment.center,
                        height: 45,
                        width: double.infinity,
                        decoration: ShapeDecoration(
                          shape: SmoothRectangleBorder(
                            borderRadius: SmoothBorderRadius(
                                cornerRadius: 15, cornerSmoothing: 1.9),
                          ),
                          color: primaryColor,
                        ),
                        child: Text(
                          'Save',
                          style: GoogleFonts.quicksand(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  bool titleAndNotValidation() {
    final titleText = titleController.text;
    final noteText = noteController.text;
    if (titleText.isNotEmpty && noteText.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }

  saveClick(
      {required List<QueryDocumentSnapshot<Object?>> catDocsList,
      required context}) {
    String message = "failed";
    DateTime chooseDate = DateTime.now();
    //var splitted = formattedDate.split("-");
    //log('Splitted:${splitted[3]}');
    final String title = titleController.text;
    final String note = noteController.text;
    List<String> selectedCategoryList =
        extractSelectedCategory(catDocsList: catDocsList);
    if (selectedCategoryList.isNotEmpty) {
      log("categorynamelist== $selectedCategoryList");
      showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime.now(),
              lastDate: DateTime.utc(2025))
          .then(
        (value) async {
          log(value.toString());
          chooseDate = value!;
          String formattedDate = formatDate(chooseDate);
          //log("title$title");
          //log("content$note");
          //log("date$formattedDate");
          //log("categorylist$selectedCategoryList");

          for (String categoryName in selectedCategoryList) {
            message = await FirestoreNotes().addNotes(
                docId: formattedDate,
                categoryNameAsDocId: categoryName,
                title: title,
                content: note,
                context: context);
          }
          log("message$message");
          // ignore: use_build_context_synchronously
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              backgroundColor: Colors.black,
              iconPadding:
                  const EdgeInsets.symmetric(vertical: 12, horizontal: 15),
              icon: Align(
                alignment: Alignment.topRight,
                child: InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: const Icon(
                    Icons.close,
                    size: 22,
                  ),
                ),
              ),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  message == "notes added successfully"
                      ? const Icon(
                          Icons.done,
                          color: Colors.green,
                        )
                      : const Icon(
                          Icons.error,
                          color: Colors.red,
                        ),
                  //const SizedBox(
                  //  width: 4,
                  //),
                  Text(
                    message,
                    style: message == "notes added successfully"
                        ? GoogleFonts.inter(fontSize: 15, color: Colors.green)
                        : GoogleFonts.inter(fontSize: 15, color: Colors.white),
                  ),
                ],
              ),
              //actions: [
              //  IconButton(
              //    onPressed: () {
              //      Navigator.of(context).pushReplacement(MaterialPageRoute(
              //          builder: ((context) => const HomePage())));
              //    },
              //    icon: const Icon(Icons.home),
              //  )
              //],
            ),
          );
        },
      );
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          contentPadding: const EdgeInsets.symmetric(horizontal: 8),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Please select a category",
                style: GoogleFonts.inter(fontSize: 13, color: Colors.red),
              ),
              IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.done))
            ],
          ),
        ),
      );
    }
  }

  String formatDate(DateTime chooseDate) {
    var date = DateTime.parse(chooseDate.toString());
    String dayName = DateFormat('EEEE').format(date);
    String formattedDate = "${date.day}-${date.month}-${date.year}-$dayName";
    log(formattedDate);
    return formattedDate;
  }

  List<String> extractSelectedCategory(
      {required List<QueryDocumentSnapshot<Object?>> catDocsList}) {
    List<String> selectedCatList = [];
    for (var element in catDocsList) {
      if (element["isSelected"] == true) {
        selectedCatList.add(element["catname"]);
      }
    }
    log("selectedList$selectedCatList");
    return selectedCatList;
  }
}
