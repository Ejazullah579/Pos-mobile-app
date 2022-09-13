import 'package:stacked/stacked.dart';

class MainGrettingViewModel extends BaseViewModel {
  double _currentPage;
  double get currentPage => _currentPage;
  set setCurrentPage(double val) {
    _currentPage = val;
  }
}
