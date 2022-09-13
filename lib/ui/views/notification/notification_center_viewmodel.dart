import 'package:pro1/services/test_data.dart';
import 'package:stacked/stacked.dart';

class NotificationCenterViewModel extends BaseViewModel {
  List<Notification> notifications = notification;
  removeAt(index) {
    notifications.removeAt(index);
    notifyListeners();
  }
}
