// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

import 'package:firebase_remote_config/firebase_remote_config.dart' as _i17;
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;
import 'package:sqflite_migration_service/sqflite_migration_service.dart'
    as _i8;
import 'package:stacked_services/stacked_services.dart' as _i5;

import '../services/api.dart' as _i3;
import '../services/authetication_service.dart' as _i4;
import '../services/cloud_storage_service.dart' as _i6;
import '../services/connectivity_service.dart' as _i7;
import '../services/firestore_service.dart' as _i9;
import '../services/global_service.dart' as _i10;
import '../services/local_database_service.dart' as _i11;
import '../services/logined_user.dart' as _i12;
import '../services/remote_config_service.dart' as _i13;
import '../services/search_searvice.dart' as _i14;
import '../services/shared_prefrences_service.dart' as _i15;
import '../services/third_party_services_module.dart'
    as _i16; // ignore_for_file: unnecessary_lambdas

// ignore_for_file: lines_longer_than_80_chars
/// initializes the registration of provided dependencies inside of [GetIt]
_i1.GetIt $initGetIt(_i1.GetIt get,
    {String environment, _i2.EnvironmentFilter environmentFilter}) {
  final gh = _i2.GetItHelper(get, environment, environmentFilter);
  final thirdPartyServicesModule = _$ThirdPartyServicesModule(get);
  gh.lazySingleton<_i3.Api>(() => thirdPartyServicesModule.api);
  gh.lazySingleton<_i4.AuthenticationService>(
      () => thirdPartyServicesModule.authenticationservice);
  gh.lazySingleton<_i5.BottomSheetService>(
      () => thirdPartyServicesModule.bottomSheetService);
  gh.lazySingleton<_i6.CloudStorageService>(
      () => thirdPartyServicesModule.cloudstorage);
  gh.lazySingleton<_i7.ConnectivityService>(
      () => thirdPartyServicesModule.connectivityService);
  gh.lazySingleton<_i8.DatabaseMigrationService>(
      () => thirdPartyServicesModule.databaseMigrationService);
  gh.lazySingleton<_i5.DialogService>(
      () => thirdPartyServicesModule.dialogservice);
  gh.lazySingleton<_i9.FirestoreService>(
      () => thirdPartyServicesModule.firestoreservice);
  gh.lazySingleton<_i10.GlobalService>(
      () => thirdPartyServicesModule.globalservice);
  gh.lazySingleton<_i11.LocalDatabaseService>(
      () => thirdPartyServicesModule.localDatabaseService);
  gh.lazySingleton<_i12.LoginedUser>(() => thirdPartyServicesModule.user);
  gh.lazySingleton<_i5.NavigationService>(
      () => thirdPartyServicesModule.navigationservice);
  gh.lazySingleton<_i13.RemoteConfigService>(
      () => thirdPartyServicesModule.remoteConfigService);
  gh.lazySingleton<_i14.SearchService>(
      () => thirdPartyServicesModule.searchservice);
  gh.lazySingleton<_i15.SharedPrefrencesService>(
      () => thirdPartyServicesModule.sharedPrefrencesService);
  gh.lazySingleton<_i5.SnackbarService>(
      () => thirdPartyServicesModule.snackbarService);
  return get;
}

class _$ThirdPartyServicesModule extends _i16.ThirdPartyServicesModule {
  _$ThirdPartyServicesModule(this._getIt);

  final _i1.GetIt _getIt;

  @override
  _i3.Api get api => _i3.Api();
  @override
  _i4.AuthenticationService get authenticationservice =>
      _i4.AuthenticationService();
  @override
  _i5.BottomSheetService get bottomSheetService => _i5.BottomSheetService();
  @override
  _i6.CloudStorageService get cloudstorage => _i6.CloudStorageService();
  @override
  _i7.ConnectivityService get connectivityService => _i7.ConnectivityService();
  @override
  _i8.DatabaseMigrationService get databaseMigrationService =>
      _i8.DatabaseMigrationService();
  @override
  _i5.DialogService get dialogservice => _i5.DialogService();
  @override
  _i9.FirestoreService get firestoreservice => _i9.FirestoreService();
  @override
  _i10.GlobalService get globalservice => _i10.GlobalService();
  @override
  _i11.LocalDatabaseService get localDatabaseService =>
      _i11.LocalDatabaseService();
  @override
  _i12.LoginedUser get user => _i12.LoginedUser();
  @override
  _i5.NavigationService get navigationservice => _i5.NavigationService();
  @override
  _i13.RemoteConfigService get remoteConfigService =>
      _i13.RemoteConfigService();
  @override
  _i14.SearchService get searchservice => _i14.SearchService();
  @override
  _i15.SharedPrefrencesService get sharedPrefrencesService =>
      _i15.SharedPrefrencesService();
  @override
  _i5.SnackbarService get snackbarService => _i5.SnackbarService();
}
