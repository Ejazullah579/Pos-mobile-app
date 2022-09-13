import 'package:pro1/app/locator.dart';
import 'package:pro1/services/global_service.dart';
import 'package:pro1/services/search_searvice.dart';
import 'package:stacked/stacked.dart';

class NavBarViewModel extends ReactiveViewModel {
  final GlobalService globalService = locator<GlobalService>();
  // GlobalService get globalService => _globalService;
  final SearchService _searchService = locator<SearchService>();
  SearchService get searchService => _searchService;

  setApplyDiscount(value) {
    globalService.setApplyDiscount(value);
    notifyListeners();
  }

  bool isFirstTime = true;
  @override
  List<ReactiveServiceMixin> get reactiveServices => [_searchService];
}
