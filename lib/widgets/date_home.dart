// ignore_for_file: must_be_immutable, unused_local_variable

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../constants.dart';

class DateListViewHome extends StatefulWidget {
  int selectedDateIndex, selectedCategoryIndex;
  List dateDocsList, splittedDateDocList;
  DateListViewHome({
    super.key,
    required this.dateDocsList,
    required this.selectedDateIndex,
    required this.selectedCategoryIndex,
    required this.splittedDateDocList,
  });

  @override
  State<DateListViewHome> createState() => _DateListViewHomeState();
}

class _DateListViewHomeState extends State<DateListViewHome> {
  @override
  Widget build(BuildContext context) {
    List dateDocsList = widget.dateDocsList;
    int selectedDateIndex = widget.selectedDateIndex;
    int selectedCategoryIndex = widget.selectedCategoryIndex;
    List splittedDateDocList = widget.splittedDateDocList;
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return SizedBox(
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
                  splittedDateDocList[index][0].toString().length == 1
                      ? "0${splittedDateDocList[selectedDateIndex][0]},${splittedDateDocList[selectedDateIndex][3]}"
                      : "${splittedDateDocList[selectedDateIndex][0]},${splittedDateDocList[selectedDateIndex][3]}";
                },
              );

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
                      ? LinearGradient(colors: [
                          const Color(
                            0xff9C2CF7,
                          ),
                          const Color(0xff9C2CF7).withOpacity(0.75)
                        ], begin: Alignment.topLeft, end: Alignment.bottomRight)
                      : LinearGradient(
                          colors: [
                              const Color(
                                0xff777777,
                              ).withOpacity(0.32),
                              const Color(0xff393939).withOpacity(0.66 - 0.35)
                            ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight)),
              child: Text(
                textAlign: TextAlign.center,
                splittedDateDocList[index][0].toString().length != 1
                    ? "${splittedDateDocList[index][0].toString()}${splittedDateDocList[index][3].toString()}"
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
    );
  }
}
