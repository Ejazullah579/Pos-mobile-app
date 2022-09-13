import 'package:auto_route/auto_route_annotations.dart';
import 'package:pro1/ui/views/Settings/settings_view.dart';
import 'package:pro1/ui/views/get_items/get_items_view.dart';
import 'package:pro1/ui/views/greetings/main_greeting_view.dart';
import 'package:pro1/ui/views/home/home_view.dart';
import 'package:pro1/ui/views/home/full_bottom_navbar.dart';
import 'package:pro1/ui/views/login/login_view.dart';
import 'package:pro1/ui/views/notification/notification_center_view.dart';
import 'package:pro1/ui/views/offline/offline.dart';
import 'package:pro1/ui/views/search_result/search_result_view.dart';
import 'package:pro1/ui/views/sign_up/sign_up_view.dart';
import 'package:pro1/ui/views/login/forget_password_view.dart';
import 'package:pro1/ui/views/startup/startup_view.dart';
import 'package:pro1/ui/views/user_profile/user_profile_view.dart';

@MaterialAutoRouter(
  routes: <AutoRoute>[
    // initial route is named "/"
    MaterialRoute(page: HomeView, path: '/home'),
    MaterialRoute(page: LoginView, path: '/login'),
    MaterialRoute(page: StartupView, initial: true),
    MaterialRoute(page: SignupView, path: '/signup'),
    MaterialRoute(page: GetItemsView, path: '/getItems'),
    MaterialRoute(page: SettingsView, path: '/settings'),
    MaterialRoute(page: FullBottomNavbar, path: '/mainHomePage'),
    MaterialRoute(page: UserProfileView, path: '/userprofile'),
    MaterialRoute(page: ForgetPasswordView, path: '/forgetpassword'),
    MaterialRoute(page: SearchResultView, path: '/searchResult'),
    MaterialRoute(page: OfflineView, path: '/offline'),
    MaterialRoute(page: MainGreetingsPage, path: '/greetingsview'),
    MaterialRoute(page: NotificationCenterView, path: '/notificationcenter'),
  ],
)
class $Router {}
