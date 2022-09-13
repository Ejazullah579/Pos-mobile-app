import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stacked_themes/stacked_themes.dart';

class Headings extends StatelessWidget {
  final String text;
  final Color color;
  const Headings({
    Key key,
    this.text,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.inter(
          color: color == null
              ? getThemeManager(context).isDarkMode
                  ? Colors.white70
                  : Colors.black54
              : color,
          fontSize: 18,
          decoration: TextDecoration.none,
          fontWeight: FontWeight.w700),
    );
  }
}
