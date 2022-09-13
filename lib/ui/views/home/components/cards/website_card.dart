import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:stacked_themes/stacked_themes.dart';
import 'package:url_launcher/url_launcher.dart';

class WebsiteCard extends StatelessWidget {
  const WebsiteCard({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final maxwidth = MediaQuery.of(context).size.width;
    final themeManager = getThemeManager(context).isDarkMode;

    return Container(
      child: GestureDetector(
        onTap: () async {
          print("here");
          const url = 'https://Google.com';
          if (await canLaunch(url)) {
            await launch(url);
          } else {
            await BottomSheetService()
                .showBottomSheet(title: "Sorry Could not launch site");
          }
        },
        child: Stack(
          children: [
            // Positioned(
            //   bottom: -22,
            //   right: 10,
            //   child: Material(
            //     shadowColor: Colors.white,
            //     elevation: 5,
            //     child: Container(
            //         width: 70,
            //         height: 25,
            //         color: themeManager ? Colors.black : Colors.white,
            //         alignment: Alignment.center,
            //         child: FlatButton(
            //           onPressed: () {},
            //           color: themeManager ? Colors.black : Colors.white,
            //           child: Text(
            //             "Visit",
            //             style: TextStyle(
            //                 color: !themeManager ? Colors.black : Colors.white,
            //                 fontWeight: FontWeight.w500),
            //           ),
            //         )),
            //   ),
            // ),
            Container(
              height: 199,
              margin: EdgeInsets.only(right: 10),
              width: MediaQuery.of(context).orientation == Orientation.portrait
                  ? maxwidth / 1.1
                  : maxwidth * 0.45,
              decoration: BoxDecoration(
                color: Colors.black26,
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(30),
                    bottomLeft: Radius.circular(30)),
              ),
              child: Image.asset("assets/images/fire.png"),
            ),
            Positioned(
              bottom: 0,
              child: Container(
                width:
                    MediaQuery.of(context).orientation == Orientation.portrait
                        ? maxwidth / 1.1
                        : maxwidth * 0.45,
                height: 50,
                color: Colors.black12,
                padding: EdgeInsets.only(left: 30),
                alignment: Alignment.centerLeft,
                child: Text(
                  "Boota Brothers",
                  style: GoogleFonts.inter(
                      color: Colors.white, fontWeight: FontWeight.w500),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
