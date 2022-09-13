import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stacked_themes/stacked_themes.dart';

class DiscountInfo extends StatelessWidget {
  final String headingText;
  final String fieldAbout;
  final GlobalKey<FormState> formKey;
  final Function validator;
  final Function onEditingComplete;
  final Icon textFieldIcon;
  final bool autoValidate;
  final bool isPasswordField;
  final Function onSave;
  final TextInputAction textInputAction;
  final Function focusnode;
  final FocusNode focusNode;
  final hinttext;
  final TextEditingController controller;
  final textInputType;
  const DiscountInfo({
    Key key,
    @required this.headingText,
    this.fieldAbout,
    this.formKey,
    this.validator,
    this.textFieldIcon,
    this.autoValidate,
    this.isPasswordField,
    this.onSave,
    this.textInputAction,
    this.focusnode,
    this.focusNode,
    this.hinttext,
    this.textInputType,
    this.controller,
    this.onEditingComplete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeManager = getThemeManager(context).isDarkMode;
    return Container(
      height: 55,
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.symmetric(horizontal: 20),
      // color: Colors.black,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            headingText,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.inter(
                color: themeManager ? Colors.white : Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.w400,
                decoration: TextDecoration.none),
          ),
          Container(
            width: 100,
            height: 40,
            decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(30)),
            child: Material(
              elevation: 2,
              shadowColor: Colors.white,
              borderRadius: BorderRadius.circular(35),
              color: getThemeManager(context).isDarkMode
                  ? Colors.black54
                  : Colors.white,
              child: Padding(
                padding: const EdgeInsets.only(top: 0),
                child: TextFormField(
                  onSaved: onSave,
                  controller: controller,
                  onEditingComplete: onEditingComplete,
                  enableSuggestions: true,
                  keyboardType: TextInputType.number,
                  style: TextStyle(
                      color: getThemeManager(context).isDarkMode
                          ? Colors.white
                          : Colors.black),
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      hintText: "  Value",
                      hintStyle: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: getThemeManager(context).isDarkMode
                              ? Colors.white54
                              : Colors.black54)),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
