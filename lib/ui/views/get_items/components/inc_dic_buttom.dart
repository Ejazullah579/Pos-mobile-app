import 'package:flutter/material.dart';

class IncDicButton extends StatelessWidget {
  final Function ontap;
  final Icon icon;
  const IncDicButton({
    Key key,
    this.ontap,
    this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ontap,
      child: Container(
        height: 25,
        width: 25,
        decoration: BoxDecoration(color: Colors.blue, shape: BoxShape.circle),
        child: Icon(
          icon.icon,
          color: Colors.white,
        ),
      ),
    );
  }
}
