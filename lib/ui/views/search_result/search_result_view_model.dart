import 'package:pro1/app/locator.dart';
import 'package:pro1/models/self_product.dart';
import 'package:pro1/services/global_service.dart';
import 'package:pro1/services/search_searvice.dart';
import 'package:stacked/stacked.dart';

class SearchResultViewModel extends ReactiveViewModel {
  final _searchService = locator<SearchService>();
  final globalService = locator<GlobalService>();
  // GlobalService get globalService => _globalService;
  SearchService get searchService => _searchService;
  List<SelfProduct> get products => _searchService.products;

  // drawData() {
  //   print("Draw called ");
  //   if (searchService.searchValue != null) {
  //     print("draw data called=" + searchService.searchValue);
  //     product.forEach((item) {
  //       if (item.name == _searchService.searchValue) {
  //         print("Found");
  //         products.add(item);
  //       }
  //     });
  //   } else {
  //     products = [];
  //   }
  //   notifyListeners();
  // }

  @override
  List<ReactiveServiceMixin> get reactiveServices => [_searchService];
}
