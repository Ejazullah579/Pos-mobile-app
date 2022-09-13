import 'package:injectable/injectable.dart';
import 'package:pro1/services/api.dart';
import 'package:pro1/services/authetication_service.dart';
import 'package:pro1/services/cloud_storage_service.dart';
import 'package:pro1/services/connectivity_service.dart';
import 'package:pro1/services/logined_user.dart';
import 'package:pro1/services/firestore_service.dart';
import 'package:pro1/services/global_service.dart';
import 'package:pro1/services/local_database_service.dart';
import 'package:pro1/services/remote_config_service.dart';
import 'package:pro1/services/search_searvice.dart';
import 'package:pro1/services/shared_prefrences_service.dart';
import 'package:sqflite_migration_service/sqflite_migration_service.dart';
import 'package:stacked_services/stacked_services.dart';

@module
abstract class ThirdPartyServicesModule {
  @lazySingleton
  NavigationService get navigationservice;
  @lazySingleton
  DialogService get dialogservice;
  @lazySingleton
  BottomSheetService get bottomSheetService;
  @lazySingleton
  AuthenticationService get authenticationservice;
  @lazySingleton
  FirestoreService get firestoreservice;
  @lazySingleton
  CloudStorageService get cloudstorage;
  @lazySingleton
  RemoteConfigService get remoteConfigService;
  @lazySingleton
  SharedPrefrencesService get sharedPrefrencesService;
  @lazySingleton
  LocalDatabaseService get localDatabaseService;
  @lazySingleton
  SnackbarService get snackbarService;
  @lazySingleton
  DatabaseMigrationService get databaseMigrationService;
  @lazySingleton
  LoginedUser get user;
  @lazySingleton
  Api get api;
  @lazySingleton
  SearchService get searchservice;
  @lazySingleton
  GlobalService get globalservice;
  @lazySingleton
  ConnectivityService get connectivityService;
}
