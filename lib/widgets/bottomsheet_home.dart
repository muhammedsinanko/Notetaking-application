import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../constants.dart';
import '../screens/addnotepage.dart';

class BottomSheetHome extends StatelessWidget {
  const BottomSheetHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 24, top: 10, right: 24, bottom: 17),
      decoration: BoxDecoration(
        color: noteContainerColor.withOpacity(0.3),
      ),
      height: 84,
      child: InkWell(
        onTap: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => AddNotePage()));
        },
        child: Container(
          decoration: ShapeDecoration(
              color: backroundColor,
              shape: RoundedRectangleBorder(
                  borderRadius: SmoothBorderRadius(
                      cornerRadius: 42, cornerSmoothing: 1))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.add,
                color: primaryColor,
                size: 30,
              ),
              const SizedBox(
                width: 12,
              ),
              Text(
                "Add new note",
                style: GoogleFonts.quicksand(
                  color: primaryColor,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
