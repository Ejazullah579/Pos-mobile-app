import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HeadingText extends StatelessWidget {
  const HeadingText({
    Key key,
    @required this.text,
    this.fontSize = 20,
    this.color = Colors.black87,
    this.fontWeight = FontWeight.normal,
    this.fontFamily = "openSans",
    this.textAlign = TextAlign.left,
  }) : super(key: key);
  final String text;
  final double fontSize;
  final Color color;
  final FontWeight fontWeight;
  final String fontFamily;
  final TextAlign textAlign;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      style: fontFamily == "poppins"
          ? GoogleFonts.poppins(
              fontWeight: fontWeight, color: color, fontSize: fontSize)
          : fontFamily == "inter"
              ? GoogleFonts.inter(
                  fontWeight: fontWeight, color: color, fontSize: fontSize)
              : fontFamily == "openSans"
                  ? GoogleFonts.openSans(
                      fontWeight: fontWeight, color: color, fontSize: fontSize)
                  : GoogleFonts.poppins(
                      fontWeight: fontWeight, color: color, fontSize: fontSize),
    );
  }
}
