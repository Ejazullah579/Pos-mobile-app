import 'package:flutter/material.dart';
import 'package:pro1/ui/custom_route_transitions/hero_dialog_route.dart';
import 'package:pro1/ui/views/services/add_product/add_product_view.dart';

heroRoutePusher({BuildContext context, String productId}) {
  return Navigator.push(
      context,
      HeroDialogRoute(
        builder: (context) => Container(
          alignment: Alignment.center,
          child: Container(
              width: MediaQuery.of(context).size.width * 0.95,
              height: MediaQuery.of(context).size.height * 0.8,
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
              decoration: BoxDecoration(
                  color: Colors.grey, borderRadius: BorderRadius.circular(10)),
              child: AddProductView()),
        ),
      ));
}
