import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pro1/services/test_data.dart';
import 'package:stacked_themes/stacked_themes.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({
    Key key,
    @required this.maxheight,
    this.index,
  }) : super(key: key);

  final double maxheight;
  final int index;

  @override
  Widget build(BuildContext context) {
    final maxwidth = MediaQuery.of(context).size.width;
    return Container(
      height: 184,
      margin: EdgeInsets.only(right: 10),
      width: MediaQuery.of(context).orientation == Orientation.portrait
          ? maxwidth / 1.1
          : maxwidth * 0.45,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(30), bottomLeft: Radius.circular(30)),
          color: getThemeManager(context).isDarkMode
              ? background2[index]
              : background[index]),
      child: Stack(
        children: [
          Positioned(
            top: -20,
            left: -20,
            child: Container(
              height: 90,
              width: 90,
              decoration: BoxDecoration(
                color: circle1[index],
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            bottom: 10,
            right: -40,
            child: Container(
              height: 180,
              width: 180,
              decoration: BoxDecoration(
                color: circle1[index],
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            left: 49,
            top: 65,
            child: Text(
              "Catagory",
              style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Colors.white),
            ),
          ),
          Positioned(
            left: 49,
            top: 85,
            child: Text(
              "Super biscuit",
              style: GoogleFonts.inter(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.white),
            ),
          ),
          Positioned(
              left: 49,
              top: 110,
              child: RichText(
                text: new TextSpan(
                  style: GoogleFonts.inter(
                      fontWeight: FontWeight.w700,
                      fontSize: 25,
                      color: Colors.white),
                  children: <TextSpan>[
                    new TextSpan(
                        text: '108',
                        style: GoogleFonts.inter(
                            fontSize: 45, fontWeight: FontWeight.w700)),
                    new TextSpan(
                        text: '\$',
                        style: new TextStyle(
                          color: Colors.amber,
                          fontSize: 20,
                        )),
                  ],
                ),
              )),
          Positioned(
            right: 0,
            top: maxheight * 0.065,
            child: Container(
              width: 140,
              height: 110,
              child: Center(
                child: new Image.asset(
                  'assets/images/glass.png',
                  height: 110,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
