import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pro1/ui/components/headings.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_themes/stacked_themes.dart';
import 'notification_center_viewmodel.dart';

class NotificationCenterView extends StatelessWidget {
  const NotificationCenterView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeManager = getThemeManager(context).isDarkMode;
    return ViewModelBuilder.reactive(
      viewModelBuilder: () => NotificationCenterViewModel(),
      builder: (context, model, child) => Scaffold(
        backgroundColor: Theme.of(context).accentColor,
        appBar: AppBar(
          centerTitle: true,
          elevation: 0,
          title: Text("Notification Center"),
        ),
        body: Container(
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
              color: themeManager ? Colors.black : Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30), topRight: Radius.circular(30))),
          child: ListView.builder(
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 12),
            itemCount: model.notifications.length,
            itemBuilder: (context, index) {
              return Container(
                margin: EdgeInsets.only(bottom: 15),
                child: Column(
                  children: [
                    Material(
                      elevation: themeManager ? 2 : 10,
                      type: MaterialType.card,
                      color: themeManager ? Colors.black : Colors.white,
                      shadowColor: themeManager ? Colors.white30 : Colors.black,
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                              width: 2,
                              color: themeManager
                                  ? Colors.yellow.withOpacity(0.4)
                                  : Colors.transparent),
                        ),
                        child: Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  GestureDetector(
                                      onTap: () => model.removeAt(index),
                                      child: Icon(Icons.cancel)),
                                ],
                              ),
                              Headings(
                                text: "Dear Costumer",
                              ),
                              SizedBox(height: 10),
                              Text(
                                model.notifications[index].message,
                                textAlign: TextAlign.justify,
                                style: GoogleFonts.inter(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w400,
                                    color: themeManager
                                        ? Colors.white54
                                        : Colors.black54),
                              ),
                              model.notifications[index].messageType != "none"
                                  ? Padding(
                                      padding: const EdgeInsets.only(
                                          top: 20, right: 8),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          model.notifications[index]
                                                      .messageType !=
                                                  "aggrement"
                                              ? Text(
                                                  "Cancel",
                                                  style: GoogleFonts.inter(
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      color: Colors.red),
                                                )
                                              : Container(),
                                          SizedBox(width: 20),
                                          GestureDetector(
                                            onTap: () {
                                              model.removeAt(index);
                                            },
                                            child: Text(
                                              "Ok",
                                              style: GoogleFonts.inter(
                                                  fontWeight: FontWeight.w700,
                                                  color: Colors.green),
                                            ),
                                          )
                                        ],
                                      ),
                                    )
                                  : Container()
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
