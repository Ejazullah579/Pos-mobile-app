import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stacked/stacked.dart';

import '../get_item_viewmodel.dart';

class GenerateRecipt extends ViewModelWidget<GetItemViewModel> {
  final Icon icon;
  final String mainHeading;
  final String subHeading;
  final String contentMainHeading;
  final String contentFirstRadiotext;
  final String contentSecondRadiotext;
  final String contentType;
  final double maxheight;
  GenerateRecipt({
    Key key,
    this.maxheight,
    this.icon,
    this.mainHeading,
    this.subHeading,
    this.contentMainHeading,
    this.contentFirstRadiotext,
    this.contentSecondRadiotext,
    this.contentType,
  }) : super(key: key, reactive: true);

  @override
  Widget build(BuildContext context, GetItemViewModel model) {
    return GestureDetector(
      onTap: () async {
        final bool res = await showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                elevation: 5,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                content: Container(
                  width: 500,
                  height: 150,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        contentMainHeading,
                        style: GoogleFonts.inter(
                            fontSize: 25,
                            fontWeight: FontWeight.w600,
                            color: Colors.black),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Container(
                        height: 300,
                        child: ListView.builder(
                          scrollDirection: Axis.vertical,
                          itemCount: model.productList.length,
                          itemBuilder: (context, index) {
                            return Container(
                              height: 80,
                              color: Colors.black,
                              margin: EdgeInsets.only(bottom: 10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(model.productList[index].name),
                                  Text(
                                    model.productList[index].price *
                                        model.productList[index].counter,
                                    style: GoogleFonts.inter(
                                        fontWeight: FontWeight.w700,
                                        color: Colors.blue),
                                  )
                                ],
                              ),
                            );
                          },
                        ),
                      )
                    ],
                  ),
                ),
              );
            });
        return res;
      },
      child: Container(
        padding: EdgeInsets.only(top: 20, left: 30),
        color: Colors.transparent,
        height: maxheight / 12,
        child: Row(
          children: [
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
                Text(
                  mainHeading,
                  style: GoogleFonts.inter(fontSize: 20, color: Colors.black),
                ),
                Text(
                  subHeading,
                  style: GoogleFonts.inter(fontSize: 15, color: Colors.black),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
