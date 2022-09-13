import 'package:pro1/app/locator.dart';
import 'package:pro1/enums/bottom_sheet_type.dart';
import 'package:pro1/models/bottom_sheet_bodies/theme_change.dart';
import 'package:pro1/models/bottom_sheet_bodies/payment_service/purchase_subscription.dart';
import 'package:stacked_services/stacked_services.dart';
import 'bottom_sheet_bodies/phoneVerification.dart';
import 'bottom_sheet_bodies/recipt.dart';
import 'bottom_sheet_bodies/loading.dart';

void setupBottomSheetUi() {
  final bottomSheetService = locator<BottomSheetService>();

  final builders = {
    BottomSheetType.recipt: (context, sheetRequest, completer) =>
        FloatingBoxBottomSheet(
          request: sheetRequest,
          completer: completer,
        ),
    BottomSheetType.themeChange: (context, sheetRequest, completer) =>
        ThemeChange(
          request: sheetRequest,
          completer: completer,
        ),
    BottomSheetType.loading: (context, sheetRequest, completer) => Loading(
          request: sheetRequest,
          completer: completer,
        ),
    BottomSheetType.subscription: (context, sheetRequest, completer) =>
        PurchaseSubscription(
          request: sheetRequest,
          completer: completer,
        ),
    BottomSheetType.verification: (context, sheetRequest, completer) =>
        PhoneVerification(
          request: sheetRequest,
          completer: completer,
        )
  };

  bottomSheetService.setCustomSheetBuilders(builders);
}
