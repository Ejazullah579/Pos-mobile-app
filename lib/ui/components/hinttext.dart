import 'package:flutter/material.dart';

class HintText extends StatelessWidget {
  const HintText({
    Key key,
    @required this.themeManager,
    this.text,
  }) : super(key: key);

  final bool themeManager;
  final String text;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 17),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
            fontSize: 14.9,
            decoration: TextDecoration.none,
            color: themeManager ? Colors.white54 : Colors.black87),
      ),
    );
  }
}
