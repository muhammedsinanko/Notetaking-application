import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../constants.dart';

// ignore: must_be_immutable
class PinnedPageGridView extends StatefulWidget {
  double screenHeight;
  AsyncSnapshot<Map<String, List<Map<dynamic, dynamic>>>> fSnapshot;
  PinnedPageGridView(
      {super.key, required this.screenHeight, required this.fSnapshot});

  @override
  State<PinnedPageGridView> createState() => _PinnedPageGridViewState();
}

class _PinnedPageGridViewState extends State<PinnedPageGridView> {
  @override
  Widget build(BuildContext context) {
    AsyncSnapshot<Map<String, List<Map<dynamic, dynamic>>>> fSnapshot =
        widget.fSnapshot;
    double screenWidth = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: GridView.builder(
        itemCount: fSnapshot.data!.length,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              //Navigator.of(context).push(MaterialPageRoute(
              //    builder: ((context) => NoteDetailPage(
              //        noteDate: noteDate,
              //        noteCategoryName: noteCategoryName,
              //        noteTitle: noteTitle,
              //        noteContent: noteContent))));
            },
            child: Container(
              padding: const EdgeInsets.only(
                left: 12,
                right: 4,
                top: 10,
                bottom: 8,
              ),
              height: widget.screenHeight / 4.54,
              width: 183.5,
              decoration: ShapeDecoration(
                shape: SmoothRectangleBorder(
                  borderRadius: SmoothBorderRadius(
                    cornerRadius: 40,
                    cornerSmoothing: 01,
                  ),
                ),
                gradient: LinearGradient(
                    colors: [noteContainerColor, noteContainerBottomColor],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //?container for title
                  Flexible(
                    child: Container(
                      padding: EdgeInsets.all(widget.screenHeight / 116),
                      decoration: ShapeDecoration(
                        gradient: LinearGradient(
                            colors: [
                              headingContainerColor,
                              headingContainerColor.withOpacity(0.8),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight),
                        shape: SmoothRectangleBorder(
                          borderRadius: SmoothBorderRadius(
                              cornerRadius: 14, cornerSmoothing: 1),
                        ),
                      ),
                      child: Text(
                        fSnapshot.data!.keys.elementAt(index),
                        style: GoogleFonts.quicksand(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 6,
                  ),
                  //for (var valueElement in element.value)
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: fSnapshot.data!.values.length,
                    itemBuilder: (context, index) {
                      return Text(
                        fSnapshot.data!.values.elementAt(index)[index]["title"],
                        style: GoogleFonts.quicksand(
                            color: Colors.white, height: 0),
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        },
        shrinkWrap: true,
        physics: const ScrollPhysics(),
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
            crossAxisSpacing: 1,
            mainAxisSpacing: 1,
            //mainAxisExtent: 0.5,
            maxCrossAxisExtent: screenWidth / 1.9,
            mainAxisExtent: widget.screenHeight / 4.54),
      ),
    );
  }
}
