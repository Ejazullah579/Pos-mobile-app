import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:pro1/ui/components/TextField2.dart';

// ignore: must_be_immutable
class Page3 extends StatelessWidget {
  Page3({
    Key key,
    @required this.formKey,
    this.focusNode,
    this.focusNode1,
    this.focusNode2,
    this.focusNode3,
    this.pageSize,
    this.model,
  }) : super(key: key);

  final GlobalKey<FormState> formKey;
  final FocusScopeNode focusNode;
  final model;
  double pageSize;

  final FocusNode focusNode1;
  final FocusNode focusNode2;
  final FocusNode focusNode3;

  @override
  Widget build(BuildContext context) {
    final currentFocus = FocusScope.of(context);
    return Container(
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // TextField2(
          //     hinttext: "User Name",
          //     autoValidate: true,
          //     onSaved: (String val) {
          //       model.userName = val;
          //     },
          //     textFieldIcon: Icon(Icons.person),
          //     onSave: "username",
          //     textInputAction: TextInputAction.next,
          //     focusnode: () {
          //       currentFocus.requestFocus(focusNode1);
          //     },
          //     validator: RequiredValidator(errorText: "User Name is required")),
          TextField2(
            focusNode: focusNode1,
            onSaved: (String val) {
              model.userEmail = val.trim(); //if any issues remove trim
            },
            hinttext: "Email Address",
            onSave: "email",
            textFieldIcon: Icon(Icons.email),
            autoValidate: true,
            textInputAction: TextInputAction.next,
            focusnode: () {
              currentFocus.requestFocus(focusNode2);
            },
            validator: MultiValidator([
              RequiredValidator(errorText: "Email Required"),
              PatternValidator(
                  r"^[a-zA-Z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?",
                  errorText: "Enter a valid Email address")
            ]),
          ),
          TextField2(
            focusNode: focusNode2,
            onSaved: (String val) {
              model.userPass = val;
            },
            hinttext: "Password",
            autoValidate: true,
            onSave: "password",
            textFieldIcon: Icon(Icons.lock),
            textInputAction: TextInputAction.next,
            focusnode: () {
              currentFocus.requestFocus(focusNode3);
            },
            validator: MultiValidator([
              RequiredValidator(
                errorText: "Password Required",
              ),
              MinLengthValidator(8, errorText: "Minimum 8 characters required"),
            ]),
          ),
          TextField2(
            focusNode: focusNode3,
            autoValidate: true,
            onSaved: (String val) {
              model.rePass = val;
            },
            textInputAction: TextInputAction.done,
            hinttext: "Re Enter Password",
            textFieldIcon: Icon(Icons.replay_circle_filled),
            onSave: "repass",
            validator: RequiredValidator(errorText: "Confirm Password"),
          ),
        ],
      ),
    );
  }
}
