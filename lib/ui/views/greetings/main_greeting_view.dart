import "package:flutter/material.dart";
import 'package:pro1/app/router.gr.dart';
import 'package:pro1/services/shared_prefrences_service.dart';
import 'package:pro1/ui/views/greetings/end_page.dart';
import 'package:pro1/ui/views/greetings/page.dart';
import 'package:pro1/ui/views/greetings/start_page.dart';
import 'package:pro1/ui/views/login/login_view.dart';
import 'package:stacked_services/stacked_services.dart';

class MainGreetingsPage extends StatefulWidget {
  MainGreetingsPage({Key key}) : super(key: key);

  @override
  _MainGreetingsPageState createState() => _MainGreetingsPageState();
}

class _MainGreetingsPageState extends State<MainGreetingsPage> {
  final PageController _pageController = PageController(initialPage: 0);
  var current = 0;

  List<T> map<T>(List list, Function handler) {
    List<T> result = [];
    for (var i = 0; i < list.length; i++) {
      result.add(handler(i, list[i]));
    }
    return result;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        Align(
          alignment: Alignment.topCenter,
          child: PageView(
            controller: _pageController,
            onPageChanged: (value) {
              setState(() {
                current = value;
              });
            },
            children: [
              StartPage(
                mainHeadingText: "Hello",
                contentText:
                    "and Welcome to Shopify. Lets go through on what to expect from this app",
              ),
              Pages(
                mainHeadingText: "Easy to Use",
                image: "assets/lottie/usability.json",
                paragraphText:
                    "A Friendly mobile app that let you get comfortable while working in your shop.",
              ),
              Pages(
                mainHeadingText: "Better Service",
                image: "assets/lottie/analytics.json",
                paragraphText:
                    "We offer services that our customers need the most. They are fast and reliable that letd you work effortlessly",
              ),
              Pages(
                mainHeadingText: "Transactions Records",
                image: "assets/lottie/save-transaction.json",
                paragraphText:
                    "Don't worry about your daily transactions. We generate reports based on Monthly, Weekly and also Daily bases.",
              ),
              EndPage(
                mainHeadingText: "So Lets Get Started",
                contentText:
                    "If this is your first time installing the App Do Sign up first to use the App. You will also need to have a reliable internet connection",
              )
            ],
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
              height: 50,
              width: 75,
              padding: const EdgeInsets.only(bottom: 10),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 5,
                itemBuilder: (context, index) {
                  return Center(
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 400),
                      alignment: Alignment.centerLeft,
                      height: 9,
                      width: current == index ? 15 : 9,
                      margin: EdgeInsets.only(right: 5),
                      decoration: BoxDecoration(
                          // shape: current == index
                          //     ? BoxShape.rectangle
                          //     : BoxShape.circle,
                          borderRadius: BorderRadius.circular(100),
                          color: current == index
                              ? Colors.blue
                              : Colors.blue.withOpacity(0.3)),
                    ),
                  );
                },
              )),
        ),
        Positioned(
          right: 10,
          top: 20,
          child: Container(
            height: 35,
            width: 70,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: Colors.blue, borderRadius: BorderRadius.circular(30)),
            child: TextButton(
              onPressed: () {
                SharedPrefrencesService().setIsFirstTime();
                NavigationService().replaceWithTransition(
                  LoginView(),
                  duration: Duration(milliseconds: 1000),
                  transition: NavigationTransition.Rotate,
                );
              },
              child: Text(
                "skip",
                style: TextStyle(
                    color: Colors.white,
                    decoration: TextDecoration.none,
                    fontSize: 15),
              ),
            ),
          ),
        ),
      ]),
    );
  }
}
