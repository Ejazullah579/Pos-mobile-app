import 'package:flutter/material.dart';
import 'package:stacked_themes/stacked_themes.dart';

class TextField2 extends StatelessWidget {
  final Function validator;
  final Function ontap;
  final enableField;
  final Function(String value) onChange;
  final TextEditingController con;
  final Function onSaved;
  final Icon textFieldIcon;
  final bool autoValidate;
  final String onSave;
  final hinttext;
  final TextInputAction textInputAction;
  final Function focusnode;
  final FocusNode focusNode;
  final textInputType;
  TextField2({
    Key key,
    this.hinttext,
    this.onSaved,
    this.textInputAction,
    this.textInputType,
    this.onSave,
    this.focusNode,
    this.textFieldIcon,
    this.focusnode,
    this.validator,
    this.autoValidate,
    this.con,
    this.ontap,
    this.onChange,
    this.enableField,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeManager = getThemeManager(context);
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Material(
        elevation: 10,
        borderRadius: BorderRadius.circular(15),
        textStyle: TextStyle(),
        color: themeManager.isDarkMode ? Colors.white10 : Colors.white,
        child: Row(
          children: [
            textFieldIcon != null
                ? SizedBox(
                    width: 20,
                    child: Container(
                        padding: EdgeInsets.all(10),
                        child: Icon(
                          textFieldIcon.icon,
                          color: themeManager.isDarkMode
                              ? Colors.white60
                              : Colors.black45,
                        )),
                  )
                : Container(),
            Expanded(
              child: Container(
                margin: EdgeInsets.only(
                  left: 20,
                ),
                decoration: BoxDecoration(
                    border: Border(
                  left: BorderSide(
                      color: Colors.black26,
                      width: textFieldIcon != null ? 2 : 0),
                )),
                child: TextFormField(
                  focusNode: focusNode,
                  enabled: enableField ?? true,
                  onTap: () {
                    if (ontap != null) {
                      ontap();
                    }
                  },
                  controller: con,
                  onSaved: (val) {
                    onSaved(val);
                  },
                  onEditingComplete: focusnode,
                  textInputAction: textInputAction,
                  keyboardType: textInputType != null
                      ? textInputType
                      : TextInputType.text,
                  autovalidateMode: autoValidate == true
                      ? AutovalidateMode.onUserInteraction
                      : AutovalidateMode.disabled,
                  validator: validator,
                  toolbarOptions: ToolbarOptions(paste: true),
                  enableSuggestions: true,
                  style: TextStyle(
                      color: themeManager.isDarkMode
                          ? Colors.white
                          : Colors.black),
                  decoration: InputDecoration(
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 25, vertical: 15),
                    hintText: hinttext,
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
