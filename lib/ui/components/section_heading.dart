import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stacked_themes/stacked_themes.dart';

class SectionHeading extends StatelessWidget {
  const SectionHeading({
    Key key,
    this.text,
  }) : super(key: key);
  final String text;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Container(
              margin: EdgeInsets.symmetric(horizontal: 10),
              height: 2,
              color: getThemeManager(context).isDarkMode
                  ? Colors.white24
                  : Colors.black26),
        ),
        Container(
            margin: EdgeInsets.symmetric(vertical: 10),
            padding: EdgeInsets.symmetric(vertical: 6, horizontal: 10),
            decoration: BoxDecoration(
                color: Colors.blue, borderRadius: BorderRadius.circular(30)),
            child: Text(
              text,
              style: GoogleFonts.inter(
                  color: Colors.white, fontWeight: FontWeight.w600),
            )),
        Expanded(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 10),
            height: 2,
            color: getThemeManager(context).isDarkMode
                ? Colors.white24
                : Colors.black26,
          ),
        ),
      ],
    );
  }
}
