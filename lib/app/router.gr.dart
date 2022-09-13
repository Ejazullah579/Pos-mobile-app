// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

// ignore_for_file: public_member_api_docs

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../ui/views/Settings/settings_view.dart';
import '../ui/views/get_items/get_items_view.dart';
import '../ui/views/greetings/main_greeting_view.dart';
import '../ui/views/home/full_bottom_navbar.dart';
import '../ui/views/home/home_view.dart';
import '../ui/views/login/forget_password_view.dart';
import '../ui/views/login/login_view.dart';
import '../ui/views/notification/notification_center_view.dart';
import '../ui/views/offline/offline.dart';
import '../ui/views/search_result/search_result_view.dart';
import '../ui/views/sign_up/sign_up_view.dart';
import '../ui/views/startup/startup_view.dart';
import '../ui/views/user_profile/user_profile_view.dart';

class Routes {
  static const String homeView = '/home';
  static const String loginView = '/login';
  static const String startupView = '/';
  static const String signupView = '/signup';
  static const String getItemsView = '/getItems';
  static const String settingsView = '/settings';
  static const String fullBottomNavbar = '/mainHomePage';
  static const String userProfileView = '/userprofile';
  static const String forgetPasswordView = '/forgetpassword';
  static const String searchResultView = '/searchResult';
  static const String offlineView = '/offline';
  static const String mainGreetingsPage = '/greetingsview';
  static const String notificationCenterView = '/notificationcenter';
  static const all = <String>{
    homeView,
    loginView,
    startupView,
    signupView,
    getItemsView,
    settingsView,
    fullBottomNavbar,
    userProfileView,
    forgetPasswordView,
    searchResultView,
    offlineView,
    mainGreetingsPage,
    notificationCenterView,
  };
}

class Router extends RouterBase {
  @override
  List<RouteDef> get routes => _routes;
  final _routes = <RouteDef>[
    RouteDef(Routes.homeView, page: HomeView),
    RouteDef(Routes.loginView, page: LoginView),
    RouteDef(Routes.startupView, page: StartupView),
    RouteDef(Routes.signupView, page: SignupView),
    RouteDef(Routes.getItemsView, page: GetItemsView),
    RouteDef(Routes.settingsView, page: SettingsView),
    RouteDef(Routes.fullBottomNavbar, page: FullBottomNavbar),
    RouteDef(Routes.userProfileView, page: UserProfileView),
    RouteDef(Routes.forgetPasswordView, page: ForgetPasswordView),
    RouteDef(Routes.searchResultView, page: SearchResultView),
    RouteDef(Routes.offlineView, page: OfflineView),
    RouteDef(Routes.mainGreetingsPage, page: MainGreetingsPage),
    RouteDef(Routes.notificationCenterView, page: NotificationCenterView),
  ];
  @override
  Map<Type, AutoRouteFactory> get pagesMap => _pagesMap;
  final _pagesMap = <Type, AutoRouteFactory>{
    HomeView: (data) {
      final args = data.getArgs<HomeViewArguments>(
        orElse: () => HomeViewArguments(),
      );
      return MaterialPageRoute<dynamic>(
        builder: (context) => HomeView(key: args.key),
        settings: data,
      );
    },
    LoginView: (data) {
      final args = data.getArgs<LoginViewArguments>(
        orElse: () => LoginViewArguments(),
      );
      return MaterialPageRoute<dynamic>(
        builder: (context) => LoginView(key: args.key),
        settings: data,
      );
    },
    StartupView: (data) {
      final args = data.getArgs<StartupViewArguments>(
        orElse: () => StartupViewArguments(),
      );
      return MaterialPageRoute<dynamic>(
        builder: (context) => StartupView(key: args.key),
        settings: data,
      );
    },
    SignupView: (data) {
      final args = data.getArgs<SignupViewArguments>(
        orElse: () => SignupViewArguments(),
      );
      return MaterialPageRoute<dynamic>(
        builder: (context) => SignupView(key: args.key),
        settings: data,
      );
    },
    GetItemsView: (data) {
      final args = data.getArgs<GetItemsViewArguments>(
        orElse: () => GetItemsViewArguments(),
      );
      return MaterialPageRoute<dynamic>(
        builder: (context) => GetItemsView(key: args.key),
        settings: data,
      );
    },
    SettingsView: (data) {
      final args = data.getArgs<SettingsViewArguments>(
        orElse: () => SettingsViewArguments(),
      );
      return MaterialPageRoute<dynamic>(
        builder: (context) => SettingsView(key: args.key),
        settings: data,
      );
    },
    FullBottomNavbar: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => const FullBottomNavbar(),
        settings: data,
      );
    },
    UserProfileView: (data) {
      final args = data.getArgs<UserProfileViewArguments>(
        orElse: () => UserProfileViewArguments(),
      );
      return MaterialPageRoute<dynamic>(
        builder: (context) => UserProfileView(key: args.key),
        settings: data,
      );
    },
    ForgetPasswordView: (data) {
      final args = data.getArgs<ForgetPasswordViewArguments>(
        orElse: () => ForgetPasswordViewArguments(),
      );
      return MaterialPageRoute<dynamic>(
        builder: (context) => ForgetPasswordView(key: args.key),
        settings: data,
      );
    },
    SearchResultView: (data) {
      final args = data.getArgs<SearchResultViewArguments>(
        orElse: () => SearchResultViewArguments(),
      );
      return MaterialPageRoute<dynamic>(
        builder: (context) => SearchResultView(key: args.key),
        settings: data,
      );
    },
    OfflineView: (data) {
      final args = data.getArgs<OfflineViewArguments>(
        orElse: () => OfflineViewArguments(),
      );
      return MaterialPageRoute<dynamic>(
        builder: (context) => OfflineView(key: args.key),
        settings: data,
      );
    },
    MainGreetingsPage: (data) {
      final args = data.getArgs<MainGreetingsPageArguments>(
        orElse: () => MainGreetingsPageArguments(),
      );
      return MaterialPageRoute<dynamic>(
        builder: (context) => MainGreetingsPage(key: args.key),
        settings: data,
      );
    },
    NotificationCenterView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => const NotificationCenterView(),
        settings: data,
      );
    },
  };
}

/// ************************************************************************
/// Arguments holder classes
/// *************************************************************************

/// HomeView arguments holder class
class HomeViewArguments {
  final Key key;
  HomeViewArguments({this.key});
}

/// LoginView arguments holder class
class LoginViewArguments {
  final Key key;
  LoginViewArguments({this.key});
}

/// StartupView arguments holder class
class StartupViewArguments {
  final Key key;
  StartupViewArguments({this.key});
}

/// SignupView arguments holder class
class SignupViewArguments {
  final Key key;
  SignupViewArguments({this.key});
}

/// GetItemsView arguments holder class
class GetItemsViewArguments {
  final Key key;
  GetItemsViewArguments({this.key});
}

/// SettingsView arguments holder class
class SettingsViewArguments {
  final Key key;
  SettingsViewArguments({this.key});
}

/// UserProfileView arguments holder class
class UserProfileViewArguments {
  final Key key;
  UserProfileViewArguments({this.key});
}

/// ForgetPasswordView arguments holder class
class ForgetPasswordViewArguments {
  final Key key;
  ForgetPasswordViewArguments({this.key});
}

/// SearchResultView arguments holder class
class SearchResultViewArguments {
  final Key key;
  SearchResultViewArguments({this.key});
}

/// OfflineView arguments holder class
class OfflineViewArguments {
  final Key key;
  OfflineViewArguments({this.key});
}

/// MainGreetingsPage arguments holder class
class MainGreetingsPageArguments {
  final Key key;
  MainGreetingsPageArguments({this.key});
}
