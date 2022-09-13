import 'package:flutter/material.dart';

class LoginPageText extends StatelessWidget {
  final mainText;
  final subText;
  const LoginPageText({
    Key key,
    @required this.mainText,
    @required this.subText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Padding(
        padding: EdgeInsets.only(left: 30),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            mainText,
            style: TextStyle(
                color: Colors.white,
                fontFamily: 'Helvetica',
                decoration: TextDecoration.none,
                fontWeight: FontWeight.w400),
          ),
        ),
      ),
      Padding(
        padding: EdgeInsets.only(left: 30, top: 5, bottom: 40),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            subText,
            style: TextStyle(
                color: Colors.white,
                fontFamily: 'Helvetica',
                decoration: TextDecoration.none,
                fontSize: 22,
                fontWeight: FontWeight.w400),
          ),
        ),
      ),
    ]);
  }
}
