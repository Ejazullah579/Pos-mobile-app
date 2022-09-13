import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MainButtons extends StatelessWidget {
  final buttontext;
  final Color borderColor;
  final Color buttonColor;
  final Color textColor;
  final Icon btnIcon;
  final Function onpress;
  final double borderRadius;
  const MainButtons({
    Key key,
    this.buttontext,
    this.onpress,
    this.btnIcon,
    this.borderColor,
    this.textColor,
    this.buttonColor,
    this.borderRadius,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 47,
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 0, vertical: 10),
      decoration: new BoxDecoration(
          color: buttonColor ?? Colors.transparent,
          borderRadius: BorderRadius.circular(borderRadius ?? 10),
          border: Border.all(
              color: borderColor != null ? borderColor : Colors.blue,
              width: 1)),
      child: TextButton(
          onPressed: onpress,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(buttontext,
                  style: GoogleFonts.inter(
                      color: textColor != null ? textColor : Colors.blue[600],
                      fontSize: 20,
                      fontWeight: FontWeight.w500)),
              SizedBox(
                width: 10,
              ),
              btnIcon ?? Container(),
            ],
          )),
    );
  }
}
