import 'package:flutter/material.dart';
import 'package:pro1/ui/custom_route_transitions/hero_dialog_route.dart';
import 'package:stacked_themes/stacked_themes.dart';

infoBox({context, text, heroTag}) {
  var themeManager = getThemeManager(context).isDarkMode;
  var maxwidth = MediaQuery.of(context).size.width;
  return Navigator.push(
      context,
      HeroDialogRoute(
        builder: (context) => Container(
          alignment: Alignment.center,
          child: Hero(
            tag: heroTag,
            child: Container(
                width: maxwidth * 0.9,
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                decoration: BoxDecoration(
                    color: themeManager ? Colors.black : Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: !themeManager ? Colors.black12 : Colors.white24,
                        blurRadius: 5,
                        spreadRadius: 5,
                        offset: Offset(0, 0),
                      )
                    ]),
                child: RichText(
                    textAlign: TextAlign.justify,
                    text: TextSpan(children: [
                      if (text is String)
                        TextSpan(
                            text: text,
                            style: TextStyle(
                              color:
                                  !themeManager ? Colors.black : Colors.white,
                            ))
                      else
                        for (int i = 0; i < text.length; i++)
                          TextSpan(
                              text: "${i + 1}. ${text[i]} \n\n",
                              style: TextStyle(
                                height: 1.2,
                                color:
                                    !themeManager ? Colors.black : Colors.white,
                              ))
                    ]))),
          ),
        ),
      ));
}
