import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stacked_themes/stacked_themes.dart';
import 'package:intl/intl.dart';
import 'headings.dart';

class TransactionTile extends StatelessWidget {
  const TransactionTile({
    Key key,
    @required this.themeManager,
    @required this.maxwidth,
    this.data,
  }) : super(key: key);

  final ThemeManager themeManager;
  final double maxwidth;
  final data;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 13),
      padding: EdgeInsets.only(left: 8, right: 8, top: 12, bottom: 12),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: themeManager.isDarkMode ? Colors.white12 : Colors.white,
          boxShadow: [
            BoxShadow(
                color: Colors.black12,
                blurRadius: 10,
                spreadRadius: 2,
                offset: Offset(8.0, 8.0))
          ]),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                height: 57,
                width: 50,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        image: AssetImage("assets/images/login1.png"))),
              ),
              SizedBox(
                width: 8,
              ),
              Container(
                width: maxwidth * 0.415,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Headings(text: DateFormat().add_EEEE().format(data.date)),
                    SizedBox(height: 5),
                    Text(
                      DateFormat('hh:mm a d')
                          .add_MMM()
                          .add_E()
                          .format(data.date),
                      style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: themeManager.isDarkMode
                              ? Colors.white70
                              : Colors.black54),
                    )
                  ],
                ),
              )
            ],
          ),
          Column(
            children: [
              Tooltip(
                message: "Products Soled",
                preferBelow: false,
                child: Text(
                  (data.totalProductsSoled).toString(),
                  style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: themeManager.isDarkMode
                          ? Colors.white
                          : Colors.black87),
                ),
              ),
              Tooltip(
                message: "Amount Soled",
                preferBelow: false,
                child: Text(
                  (data.amount).toInt().toString(),
                  style: GoogleFonts.montserrat(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Colors.blue[900]),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
