import 'package:flutter/material.dart';

import 'info_box.dart';

class PopUpInfo extends StatelessWidget {
  const PopUpInfo({
    Key key,
    @required this.iconColor,
    @required this.text,
    @required this.heroTag,
  }) : super(key: key);
  final Color iconColor;
  final text;
  final String heroTag;

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: heroTag,
      child: Container(
        padding: EdgeInsets.all(2),
        alignment: Alignment.center,
        child: TextButton(
          child: Icon(
            Icons.info,
            color: iconColor,
          ),
          onPressed: () {
            infoBox(context: context, text: text, heroTag: heroTag);
          },
        ),
      ),
    );
  }
}
