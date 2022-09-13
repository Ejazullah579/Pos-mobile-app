import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:pro1/ui/views/login/login_viewmodel.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_themes/stacked_themes.dart';

class TextField1 extends ViewModelWidget<LoginViewModel> {
  final Function validator;
  final Icon textFieldIcon;
  final bool autoValidate;
  final bool isPasswordField;
  final String onSave;
  final TextInputAction textInputAction;
  final Function focusnode;
  final FocusNode focusNode;
  final hinttext;
  final textInputType;
  bool showPassword = true;
  TextField1({
    Key key,
    this.textInputAction,
    this.focusNode,
    this.isPasswordField,
    this.hinttext,
    this.textFieldIcon,
    this.onSave,
    this.focusnode,
    this.validator,
    this.autoValidate,
    this.textInputType,
  }) : super(key: key, reactive: true);

  @override
  Widget build(BuildContext context, LoginViewModel model) {
    final themeManager = getThemeManager(context);
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
      child: Material(
        elevation: 10,
        borderRadius: BorderRadius.circular(15),
        color: themeManager.isDarkMode ? Colors.white10 : Colors.white,
        textStyle: TextStyle(),
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
                              : Colors.black54,
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
                  onSaved: (val) {
                    if (onSave == "username") {
                      return model.setUserName = val;
                    }
                    if (onSave == "userpass") {
                      return model.setPass = val;
                    }
                  },
                  focusNode: focusNode,
                  onEditingComplete: focusnode,
                  autovalidateMode: autoValidate == true
                      ? AutovalidateMode.onUserInteraction
                      : AutovalidateMode.disabled,
                  validator: validator,
                  textInputAction: textInputAction,
                  keyboardType: textInputType != null
                      ? textInputType
                      : TextInputType.text,
                  obscureText: model.showPassword
                      ? isPasswordField != null
                          ? isPasswordField
                          : false
                      : false,
                  enableSuggestions: true,
                  style: TextStyle(
                      color: themeManager.isDarkMode
                          ? Colors.white
                          : Colors.black),
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                      hintText: hinttext,
                      hintStyle: TextStyle(
                          color: themeManager.isDarkMode
                              ? Colors.white70
                              : Colors.black87)),
                ),
              ),
            ),
            isPasswordField ?? false
                ? Padding(
                    padding: EdgeInsets.only(right: 11),
                    child: IconButton(
                      visualDensity: VisualDensity.compact,
                      padding: EdgeInsets.zero,
                      icon: Icon(
                        !model.showPassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                      color: themeManager.isDarkMode
                          ? Colors.white54
                          : Colors.black54,
                      onPressed: () {
                        model.showPassword = !model.showPassword;
                      },
                    ),
                  )
                : Container()
          ],
        ),
      ),
    );
  }
}
