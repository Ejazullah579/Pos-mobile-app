import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SettingsHeading extends StatelessWidget {
  final String text;
  const SettingsHeading({
    Key key,
    @required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 0, left: 20),
      child: Text(
        text,
        style: GoogleFonts.inter(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.tealAccent[700]),
      ),
    );
  }
}
