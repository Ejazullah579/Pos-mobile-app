import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pro1/app/locator.dart';
import 'package:pro1/services/global_service.dart';
import 'package:pro1/services/test_data.dart';
import 'package:pro1/ui/components/heading_text.dart';
import 'package:pro1/ui/views/drawer/model.dart';
import 'package:stacked/stacked.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder.reactive(
      viewModelBuilder: () => DrawerModel(),
      builder: (context, model, child) => Scaffold(
        body: Container(
          alignment: Alignment.centerLeft,
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.only(left: 10),
          decoration: BoxDecoration(
              gradient: LinearGradient(
            // stops: [0, 0.9],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: ([Colors.black, Colors.grey[800]]),
          )),
          child: Stack(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    UserProfileInfo(model: model),
                    Container(
                      width: 120,
                      alignment: Alignment.center,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: HeadingText(
                          text: model.currentUser.currentUser.firstName[0] +
                              " : " +
                              model.currentUser.currentUser.lastName
                                  .toUpperCase(),
                          fontFamily: "openSans",
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    SelectableText(
                      "@" + model.currentUser.currentUser.id.substring(0, 10),
                      style: GoogleFonts.openSans(
                        color: Colors.grey,
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                      ),
                    ),
                    SizedBox(height: 20),
                    Container(
                      width: 120,
                      child: ListView(
                        shrinkWrap: true,
                        children: List.generate(
                            menuItemList.length,
                            (index) => MenuItem(
                                  index: index,
                                )),
                      ),
                    ),
                  ],
                ),
              ),
              LogoutButton(model: model),
            ],
          ),
        ),
      ),
    );
  }
}

class UserProfileInfo extends StatelessWidget {
  const UserProfileInfo({
    Key key,
    @required this.model,
  }) : super(key: key);

  final DrawerModel model;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 105,
      width: 105,
      margin: EdgeInsets.only(left: 10, bottom: 20),
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(shape: BoxShape.circle, boxShadow: [
        BoxShadow(
            color: Colors.white10.withOpacity(0.2),
            blurRadius: 5,
            spreadRadius: 2)
      ]),
      child: model.currentUser.currentUser.imageUrl == null ||
              model.currentUser.currentUser.imageUrl == "" ||
              model.currentUser.currentUser.imageUrl == "null"
          ? Center(
              child: HeadingText(
                text: model.currentUser.currentUser.firstName[0].toUpperCase() +
                    model.currentUser.currentUser.lastName[0].toUpperCase(),
                fontFamily: "openSans",
                color: Colors.white,
                fontSize: 35,
                fontWeight: FontWeight.w700,
              ),
            )
          : model.currentUser.isBusy
              ? Container(
                  padding: EdgeInsets.all(3),
                  alignment: Alignment.center,
                  child: CircularProgressIndicator(strokeWidth: 5),
                )
              : CachedNetworkImage(
                  imageUrl: model.currentUser.currentUser.imageUrl,
                  placeholder: (context, url) => Container(
                    height: 100,
                    alignment: Alignment.center,
                    child: Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 6,
                      ),
                    ),
                  ),
                  imageBuilder: (context, imageProvider) => Container(
                    width: 100,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            fit: BoxFit.cover,
                            alignment: Alignment.center,
                            image: imageProvider)),
                  ),
                ),
    );
  }
}

class LogoutButton extends StatelessWidget {
  const LogoutButton({
    Key key,
    @required this.model,
  }) : super(key: key);

  final DrawerModel model;

  @override
  Widget build(BuildContext context) {
    final bool isPortraitMode =
        MediaQuery.of(context).orientation == Orientation.portrait;
    return Align(
      alignment: Alignment.bottomLeft,
      child: Container(
        alignment: Alignment.center,
        width: 110,
        height: 40,
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        margin: EdgeInsets.only(
            bottom: isPortraitMode ? 50 : 20, left: isPortraitMode ? 10 : 160),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
        ),
        child: model.isBusy
            ? Container(
                width: 35, height: 35, child: CircularProgressIndicator())
            : GestureDetector(
                onTap: () => model.signOut(),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.logout,
                      color: Colors.grey,
                    ),
                    SizedBox(width: 10),
                    Text(
                      "Logout",
                      style: GoogleFonts.openSans(
                        color: Colors.black,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}

class MenuItem extends StatelessWidget {
  MenuItem({
    Key key,
    @required this.index,
  }) : super(key: key);
  final int index;
  final GlobalService _globalService = locator<GlobalService>();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _globalService.currentPage = index;
        _globalService.drawerController.close();
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        width: 120,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
            color: index == 0 ? Colors.grey : Colors.transparent,
            borderRadius: BorderRadius.circular(5)),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              menuItemList[index].icon,
              color: Colors.white,
            ),
            SizedBox(width: 10),
            HeadingText(
              text: menuItemList[index].title,
              fontSize: 15,
              color: Colors.white,
              fontWeight: FontWeight.w600,
            )
          ],
        ),
      ),
    );
  }
}
