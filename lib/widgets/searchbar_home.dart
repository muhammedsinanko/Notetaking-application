// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../constants.dart';
import 'searchbarbottmsheet.dart';

class SearchBarHome extends StatelessWidget {
  int selectedDateIndex;
  List dateDocsList;
  SearchBarHome({
    super.key,
    required this.dateDocsList,
    required this.selectedDateIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 9),
      child: InkWell(
        onTap: () {
          showModalBottomSheet(
              backgroundColor: Colors.black26,
              isScrollControlled: true,
              context: context,
              builder: (context) => SearchbarBottomSheet(
                    initialDate: dateDocsList[selectedDateIndex],
                  ));
        },
        child: Container(
          padding: const EdgeInsets.only(left: 15),
          height: 41,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: LinearGradient(
                colors: [noteContainerColor, noteContainerBottomColor],
                begin: Alignment.topCenter,
                end: Alignment.bottomRight),
          ),
          child: Row(
            children: [
              //SvgPicture.asset(
              //  height: 18,
              //  width: 18,
              //  "asset/svg/search svg.svg",
              //),
              const Icon(
                Icons.search,
                color: Colors.white,
              ),
              const SizedBox(
                width: 10,
              ),
              Text(
                "Search for category, title or date...",
                style: GoogleFonts.quicksand(fontSize: 14, color: Colors.grey),
              )
            ],
          ),
        ),
      ),
    );
  }
}
