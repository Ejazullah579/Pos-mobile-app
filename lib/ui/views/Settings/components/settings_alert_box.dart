import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pro1/app/locator.dart';
import 'package:pro1/enums/bottom_sheet_type.dart';

import 'package:stacked_services/stacked_services.dart';
import 'package:stacked_themes/stacked_themes.dart';

class SettingsAlertBox extends StatelessWidget {
  final Icon icon;
  final String mainHeading;
  final String subHeading;
  final String contentMainHeading;
  final String contentFirstRadiotext;
  final String contentSecondRadiotext;
  final String contentType;
  final Function onPress;
  final double maxheight;
  SettingsAlertBox({
    Key key,
    @required this.maxheight,
    this.icon,
    this.mainHeading,
    this.subHeading,
    this.contentMainHeading,
    this.contentFirstRadiotext,
    this.contentSecondRadiotext,
    this.contentType,
    this.onPress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeManager = getThemeManager(context).isDarkMode;
    final BottomSheetService _bottomSheetService =
        locator<BottomSheetService>();
    return GestureDetector(
      onTap: () async {
        if (contentType == "theme") {
          await _bottomSheetService.showCustomSheet(
            variant: BottomSheetType.themeChange,
            title: mainHeading,
            mainButtonTitle: contentFirstRadiotext,
            secondaryButtonTitle: contentSecondRadiotext,
          );
          onPress();
        }
      },
      child: Container(
        padding: EdgeInsets.only(top: 20, left: 20),
        color: Colors.transparent,
        height: 75,
        child: Row(
          children: [
            ///// Main Icon
            Icon(
              icon.icon,
              size: 30,
              color: Colors.tealAccent[700],
            ),
            SizedBox(
              width: 20,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //// Icon main heading
                Text(
                  mainHeading,
                  style: GoogleFonts.inter(
                      fontSize: 20,
                      color: themeManager ? Colors.white : Colors.black),
                ),
                //// Icon sub heading
                Text(
                  subHeading,
                  style: GoogleFonts.inter(
                      fontSize: 15,
                      color: themeManager ? Colors.white : Colors.black),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
