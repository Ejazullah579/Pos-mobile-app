import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:pro1/app/locator.dart';
import 'package:pro1/services/global_service.dart';
import 'package:pro1/ui/components/TextField2.dart';

// ignore: must_be_immutable
class Page1 extends StatelessWidget {
  Page1({
    Key key,
    @required this.formKey,
    this.focusNode1,
    this.focusNode2,
    this.focusNode,
    this.pageSize,
    this.model,
  }) : super(key: key);

  final GlobalKey<FormState> formKey;
  final FocusScopeNode focusNode;
  double pageSize;
  final FocusNode focusNode1;
  final FocusNode focusNode2;
  final model;
  final GlobalService globalService = locator<GlobalService>();
  @override
  Widget build(BuildContext context) {
    final currentFocus = FocusScope.of(context);

    return Container(
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextField2(
              textInputAction: TextInputAction.next,
              hinttext: "First Name",
              onSaved: (val) {
                model.firstName = val;
              },
              autoValidate: true,
              textFieldIcon: Icon(Icons.person),
              onSave: "firstname",
              focusnode: () {
                currentFocus.requestFocus(focusNode1);
              },
              validator: RequiredValidator(errorText: "Field Required")),
          TextField2(
            textInputAction: TextInputAction.next,
            focusNode: focusNode1,
            onSaved: (val) {
              model.lastName = val;
            },
            hinttext: "Last Name",
            onSave: "lastname",
            textFieldIcon: Icon(Icons.person),
            autoValidate: true,
            focusnode: () {
              currentFocus.requestFocus(focusNode2);
            },
            validator: MultiValidator([
              RequiredValidator(errorText: "Field Required"),
            ]),
          ),
          TextField2(
            textInputAction: TextInputAction.next,
            focusNode: focusNode2,
            onSaved: (val) {
              model.phoneNumber = val;
            },
            hinttext: "Phone Number",
            autoValidate: true,
            onSave: "phonenumber",
            textInputType: TextInputType.number,
            textFieldIcon: Icon(Icons.phone),
            focusnode: () {
              currentFocus.requestFocus(new FocusNode());
            },
            validator: MultiValidator([
              RequiredValidator(
                errorText: "Number Required",
              ),
              PatternValidator(r'(^(?:[+0]9)?[0-9]{10,12}$)',
                  errorText: "Enter a valid phone number")
            ]),
          ),
          TextField2(
            con: globalService.con,
            ontap: () async {
              DateTime date = DateTime(1900);

              FocusScope.of(context).requestFocus(new FocusNode());

              date = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(1950),
                lastDate: DateTime.now(),
              );
              globalService.con..text = date.toIso8601String().substring(0, 10);
            },
            onSaved: (val) {
              model.dateOfBirth = val;
            },
            textInputAction: TextInputAction.done,
            hinttext: "Date of Birth",
            textFieldIcon: Icon(Icons.date_range),
            textInputType: TextInputType.datetime,
            onSave: "dateofbirth",
            validator: MultiValidator([
              RequiredValidator(errorText: "Please Enter Date of Birth"),
            ]),
          ),
        ],
      ),
    );
  }
}
