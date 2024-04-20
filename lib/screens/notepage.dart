// ignore_for_file: must_be_immutable
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iooi/services/firestore_service.dart';
import '../constants.dart';
import 'addnotepage.dart';

class NoteDetailPage extends StatefulWidget {
  String noteDate, noteCategoryName, noteTitle, noteContent;
  bool isDone;
  NoteDetailPage({
    super.key,
    required this.noteDate,
    required this.noteCategoryName,
    required this.noteTitle,
    required this.noteContent,
    required this.isDone,
  });
  @override
  State<NoteDetailPage> createState() => _NoteDetailPageState();
}

//bool isDone = widget.isDone;
bool updatedBool = false;

class _NoteDetailPageState extends State<NoteDetailPage> {
  //@override
  //void initState() {
  //  checkIfMarkAsDone();
  //  super.initState();
  //}

  @override
  Widget build(BuildContext context) {
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
          widget.noteTitle,
          style: GoogleFonts.quicksand(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 5),
            child: TextButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => AddNotePage(
                          noteDate: widget.noteDate,
                          noteTitle: widget.noteTitle,
                          noteContent: widget.noteContent,
                          noteCategoryName: widget.noteCategoryName,
                        )));
              },
              //child: Text(
              //  "edit",
              //  style: GoogleFonts.quicksand(
              //    color: const Color(0xff2C65F7),
              //    fontSize: 18,
              //    fontWeight: FontWeight.w600,
              //  ),
              //),
              child: PopupMenuButton(
                popUpAnimationStyle: AnimationStyle(
                    curve: Curves.bounceOut,
                    duration: const Duration(milliseconds: 800)),
                color: Colors.white,
                iconColor: Colors.white,
                itemBuilder: ((context) => [
                      PopupMenuItem(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => AddNotePage(
                                noteDate: widget.noteDate,
                                noteTitle: widget.noteTitle,
                                noteContent: widget.noteContent,
                                noteCategoryName: widget.noteCategoryName,
                              ),
                            ),
                          );
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const Icon(
                              Icons.edit,
                              color: Colors.black,
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            Text(
                              "edit",
                              style: GoogleFonts.quicksand(
                                //color: const Color(0xff2C65F7),
                                color: Colors.black, fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        onTap: () {
                          FirestoreNotes().deleteNote(
                              date: widget.noteDate,
                              category: widget.noteCategoryName,
                              title: widget.noteTitle,
                              context: context);
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const Icon(
                              Icons.delete,
                              color: Colors.black,
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            Text(
                              "Delete",
                              style: GoogleFonts.quicksand(
                                //color: const Color(0xff2C65F7),
                                color: Colors.black, fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      )
                    ]),
              ),
            ),
          )
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 10,
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        widget.noteTitle,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.quicksand(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        IconButton(
                          onPressed: () async {
                            log(widget.isDone.toString());
                            updatedBool = await FirestoreNotes().updateToDone(
                                docId: widget.noteDate,
                                categoryNameAsDocId: widget.noteCategoryName,
                                title: widget.noteTitle,
                                boolValue: !widget.isDone,
                                context: context);
                            setState(() {
                              widget.isDone = !widget.isDone;
                            });
                          },
                          icon: widget.isDone
                              ? Icon(
                                  Icons.done_all,
                                  size: 30,
                                  color: primaryColor,
                                )
                              : const Icon(
                                  Icons.done,
                                  size: 30,
                                  color: Colors.white,
                                ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(
                  height: 6,
                ),
                Text(
                  widget.noteContent,
                  style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                      //letterSpacing: 0,
                      height: 0),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  //checkIfMarkAsDone() async {
  //  var ref = await FirebaseFirestore.instance
  //      .collection("notes")
  //      .doc(widget.noteDate)
  //      .collection("cats&notes")
  //      .doc(widget.noteCategoryName)
  //      .collection("all${widget.noteCategoryName}")
  //      .doc(widget.noteTitle)
  //      .get();
  //  if (ref.data() != null) {
  //    if (ref.data()!["isDone"] == true) {
  //      if (mounted) {
  //        setState(() {
  //          widget.isDone = true;
  //        });
  //        log(widget.isDone.toString());
  //      }
  //    } else {
  //      if (mounted) {
  //        setState(() {
  //          widget.isDone = false;
  //        });
  //        log(widget.isDone.toString());
  //      }
  //    }
  //  }
  //}
}
