import 'package:flutter/material.dart';
import 'package:pro1/app/locator.dart';
import 'package:pro1/services/global_service.dart';
import 'package:pro1/ui/views/Settings/settings_view.dart';
import 'package:pro1/ui/views/get_items/get_items_view.dart';
import 'package:pro1/ui/views/home/home_view.dart';
import 'package:pro1/ui/views/search_result/search_result_view.dart';

class MainScreeen extends StatefulWidget {
  MainScreeen({Key key}) : super(key: key);

  @override
  _MainScreeenState createState() => _MainScreeenState();
}

class _MainScreeenState extends State<MainScreeen> {
  GlobalService _globalService = locator<GlobalService>();
  int currentPage = 0;
  final Widget home = HomeView();
  final Widget scanner = GetItemsView();

  @override
  void initState() {
    super.initState();
    _globalService.setPage = setPage;
  }

  setPage(int pageNumber) {
    setState(() {
      currentPage = pageNumber;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // onTap: () => _globalService.drawerController.close(),
      onHorizontalDragUpdate: (details) {
        // print(details.primaryDelta);
        if (details.primaryDelta > 2) _globalService.drawerController.open();
        if (details.primaryDelta < 2) _globalService.drawerController.close();
      },
      child: IndexedStack(
        index: currentPage,
        children: [
          HomeView(),
          GetItemsView(),
          SearchResultView(),
          SettingsView()
        ],
      ),
    );
  }
}

Widget getPage({@required int index, home, scanner}) {
  ;
}
