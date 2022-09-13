import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AlertBoxContent extends StatefulWidget {
  final String contentMainHeading;
  final String contentFirstRadiotext;
  final String contentSecondRadiotext;
  final String contentType;
  final Function getValue;
  final Function setValue;
  AlertBoxContent({
    Key key,
    this.contentMainHeading,
    this.contentFirstRadiotext,
    this.contentSecondRadiotext,
    this.contentType,
    this.getValue,
    this.setValue,
  }) : super(key: key);

  @override
  _AlertBoxContentState createState() => _AlertBoxContentState();
}

class _AlertBoxContentState extends State<AlertBoxContent> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 500,
      height: 150,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.contentMainHeading,
            style: GoogleFonts.inter(
                fontSize: 25, fontWeight: FontWeight.w600, color: Colors.black),
          ),
          SizedBox(
            height: 15,
          ),
          GestureDetector(
            onTap: widget.setValue(false),
            child: Container(
              width: MediaQuery.of(context).size.width,
              child: Row(
                children: [
                  Radio(
                      value: 1,
                      activeColor: Colors.tealAccent[700],
                      groupValue: widget.getValue() == "false" ? 1 : 0,
                      onChanged: (value) {}),
                  SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: Text(
                      widget.contentFirstRadiotext,
                      style: GoogleFonts.inter(
                          fontSize: 22,
                          fontWeight: FontWeight.w500,
                          color: Colors.black),
                    ),
                  ),
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: widget.setValue(true),
            child: Container(
              width: MediaQuery.of(context).size.width,
              child: Row(
                children: [
                  Radio(
                      value: 1,
                      activeColor: Colors.tealAccent[700],
                      groupValue: widget.getValue() == "false" ? 0 : 1,
                      onChanged: (value) {}),
                  SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: Text(
                      widget.contentSecondRadiotext,
                      style: GoogleFonts.inter(
                          fontSize: 22,
                          fontWeight: FontWeight.w500,
                          color: Colors.black),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
