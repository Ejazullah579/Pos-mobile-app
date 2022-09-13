import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pro1/models/bottom_sheet_bodies/payment_service/purchase_subscription_viewModel.dart';
import 'package:pro1/ui/components/MainButtons.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class PurchaseSubscription extends StatefulWidget {
  PurchaseSubscription({Key key, this.request, this.completer})
      : super(key: key);

  final SheetRequest request;
  final Function(SheetResponse) completer;

  @override
  _PurchaseSubscriptionState createState() => _PurchaseSubscriptionState();
}

class _PurchaseSubscriptionState extends State<PurchaseSubscription> {
  CrossFadeState crossFadeState;

  @override
  void initState() {
    super.initState();
    crossFadeState = CrossFadeState.showFirst;
  }

  setCrossFadeState(CrossFadeState state) {
    setState(() {
      crossFadeState = state;
    });
  }

  @override
  Widget build(BuildContext context) {
    final maxWidth = MediaQuery.of(context).size.width;
    // final isCurrentThemeDark = getThemeManager(context).isDarkMode;
    return ViewModelBuilder<PurchaseSubscriptionViewModel>.reactive(
      viewModelBuilder: () => PurchaseSubscriptionViewModel(),
      builder: (context, model, child) => Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
        ),
        clipBehavior: Clip.hardEdge,
        padding: EdgeInsets.only(top: 0, bottom: 0),
        child: ListView(
          shrinkWrap: true,
          physics: ClampingScrollPhysics(),
          children: [
            MainHeading(maxWidth: maxWidth),
            AnimatedCrossFade(
              firstChild: FirstChild(
                maxWidth: maxWidth,
                model: model,
                setCrossFadeState: setCrossFadeState,
              ),
              secondChild: SecondChild(
                model: model,
              ),
              crossFadeState: crossFadeState,
              duration: Duration(milliseconds: 600),
            ),
          ],
        ),
      ),
    );
  }
}

class SubHeading extends StatelessWidget {
  const SubHeading({
    Key key,
    this.text,
  }) : super(key: key);

  final text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: 20),
      alignment: Alignment.center,
      child: Text(
        text,
        style: GoogleFonts.inter(
            color: Colors.black87, fontSize: 18, fontWeight: FontWeight.w500),
      ),
    );
  }
}

class SecondChild extends StatelessWidget {
  const SecondChild({Key key, @required this.model}) : super(key: key);
  final model;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SubHeading(
          text: "Select payment method",
        ),
        PayButton(
          text: "Google Pay",
          faIcon: FaIcon(FontAwesomeIcons.googlePay),
          isBusy: model.isBusyGooglePayIndicator,
          onPress: !model.isBusyJazzCashIndicator
              ? () => model.payWithGooglePay()
              : () => SnackbarService().showSnackbar(
                  title: "Please wait",
                  message: "untill previous action is processed"),
        ),
        PayButton(
          text: "Jazz Cash",
          faIcon: FaIcon(FontAwesomeIcons.cashRegister),
          isBusy: model.isBusyJazzCashIndicator,
          onPress: !model.isBusyGooglePayIndicator
              ? () => model.payWithJazzCash()
              : () => SnackbarService().showSnackbar(
                  title: "Please wait",
                  message: "untill previous action is processed"),
        )
      ],
    );
  }
}

class PayButton extends StatelessWidget {
  const PayButton({
    Key key,
    this.text,
    this.faIcon,
    this.onPress,
    this.isBusy,
  }) : super(key: key);

  final String text;
  final FaIcon faIcon;
  final Function onPress;
  final bool isBusy;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 2.5),
      child: isBusy
          ? Container(
              alignment: Alignment.center,
              height: 30,
              width: 30,
              margin: EdgeInsets.only(bottom: 10, top: 8),
              child: CircularProgressIndicator())
          : ElevatedButton(
              style: ButtonStyle(),
              onPressed: onPress,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  faIcon,
                  Text(text),
                  SizedBox(
                    width: 20,
                  )
                ],
              ),
            ),
    );
  }
}

class FirstChild extends StatefulWidget {
  const FirstChild(
      {Key key,
      @required this.maxWidth,
      @required this.model,
      @required this.setCrossFadeState})
      : super(key: key);

  final double maxWidth;
  final model;
  final Function setCrossFadeState;

  @override
  _FirstChildState createState() => _FirstChildState();
}

class _FirstChildState extends State<FirstChild> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SubHeading(
          text: "Select subscription time",
        ),
        Container(
          width: widget.maxWidth * 0.8,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              SubscriptionTime(
                index: 1,
                price: widget.model.prices[0],
                selectedIndex: widget.model.selectedIndex,
                text: "1 month",
                onTap: () {
                  setState(() {
                    widget.model.selectedIndex = 1;
                  });
                },
              ),
              SubscriptionTime(
                index: 2,
                price: widget.model.prices[1],
                selectedIndex: widget.model.selectedIndex,
                text: "3 month",
                onTap: () {
                  setState(() {
                    widget.model.selectedIndex = 2;
                  });
                },
              ),
              SubscriptionTime(
                index: 3,
                price: widget.model.prices[2],
                selectedIndex: widget.model.selectedIndex,
                text: "6 month",
                onTap: () {
                  setState(() {
                    widget.model.selectedIndex = 3;
                  });
                },
              ),
            ],
          ),
        ),
        Padding(
            padding: EdgeInsets.symmetric(horizontal: 45, vertical: 10),
            child: MainButtons(
              buttontext: "Next",
              buttonColor: Colors.blue,
              textColor: Colors.white,
              borderRadius: 10,
              onpress: () {
                widget.setCrossFadeState(CrossFadeState.showSecond);
              },
            ))
      ],
    );
  }
}

class MainHeading extends StatelessWidget {
  const MainHeading({
    Key key,
    @required this.maxWidth,
  }) : super(key: key);

  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      color: Colors.blue,
      margin: EdgeInsets.only(bottom: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: 60,
          ),
          Text(
            "Subscription",
            style: GoogleFonts.inter(
                color: Colors.white, fontSize: 18, fontWeight: FontWeight.w500),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 5),
            child: TextButton(
              child: Text(
                "cancel",
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class SubscriptionTime extends StatelessWidget {
  const SubscriptionTime({
    Key key,
    this.text,
    this.onTap,
    this.index,
    this.price,
    this.selectedIndex,
  }) : super(key: key);
  final String text;
  final Function onTap;
  final index;
  final int selectedIndex;
  final int price;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          AnimatedContainer(
            height: 100,
            duration: Duration.zero,
            curve: Curves.easeInOut,
            width: 70,
            clipBehavior: Clip.hardEdge,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: selectedIndex == index
                    ? Colors.blue
                    : Colors.blue.withOpacity(0.2),
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: [
                      0,
                      selectedIndex == index ? 0.5 : 0.45,
                      selectedIndex == index ? 1 : 0.3
                    ],
                    colors: [
                      Colors.blue,
                      Colors.blue,
                      Colors.blue.withOpacity(0.2)
                    ]),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black26,
                      blurRadius: 2,
                      spreadRadius: 2,
                      offset: Offset(0, 0))
                ]),
            child: Column(
              children: [
                Container(
                  height: 50,
                  width: 75,
                  decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(10)),
                  alignment: Alignment.center,
                  child: Text(
                    price.toString() + " Rs",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w500),
                  ),
                ),
                AnimatedContainer(
                  height: 50,
                  alignment: Alignment.center,
                  duration: Duration(milliseconds: 200),
                  curve: Curves.easeInOut,
                  decoration: BoxDecoration(
                      color: selectedIndex == index
                          ? Colors.white
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(10)),
                  child: Text(
                    text,
                    style: TextStyle(
                        color: selectedIndex == index
                            ? Colors.black
                            : Colors.white,
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
          ),
          selectedIndex == index
              ? Positioned(
                  top: -1,
                  right: 3,
                  child: Icon(
                    Icons.turned_in,
                    size: 20,
                    color: Colors.white,
                  ))
              : Container(),
        ],
      ),
    );
  }
}
