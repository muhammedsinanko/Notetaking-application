// ignore_for_file: must_be_immutable

import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../constants.dart';
import '../screens/addnotepage.dart';

class BottomSheetConainer extends StatelessWidget {
  double screenHeight = 812;
  BottomSheetConainer({super.key, required double screenHeight});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => AddNotePage()));
      },
      child: Container(
        padding: EdgeInsets.only(
          top: screenHeight / 54.133,
          right: screenHeight / 20.3,
          left: screenHeight / 20.3,
          bottom: screenHeight / 27.0667 - 5,
        ),
        height: screenHeight / 9.022,
        decoration: ShapeDecoration(
          shape: const SmoothRectangleBorder(
              borderRadius: SmoothBorderRadius.only(
                  topLeft: SmoothRadius(cornerRadius: 0, cornerSmoothing: 1),
                  topRight: SmoothRadius(cornerRadius: 0, cornerSmoothing: 1))),
          color: bottomSheetColor,
        ),
        child: Container(
          height: screenHeight / 16.24,
          decoration: ShapeDecoration(
              shape: SmoothRectangleBorder(
                  borderRadius:
                      SmoothBorderRadius(cornerRadius: 13, cornerSmoothing: 1)),
              color: backroundColor),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.add,
                color: primaryColor,
              ),
              InkWell(
                onTap: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => AddNotePage()));
                },
                child: Text(
                  'Add new note',
                  style: GoogleFonts.quicksand(
                      color: primaryColor,
                      fontSize: 14,
                      letterSpacing: 1.1,
                      fontWeight: FontWeight.w700),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
