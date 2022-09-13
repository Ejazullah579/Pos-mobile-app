import 'package:firebase_remote_config/firebase_remote_config.dart';

const String _freeServices = 'free_services';

class RemoteConfigService {
  RemoteConfig _remoteConfig;
  bool get freeServices => _remoteConfig.getBool(_freeServices);

  final defaults = <String, dynamic>{
    _freeServices: false,
  };
  Future initialise() async {
    _remoteConfig = await RemoteConfig.instance;
    try {
      await _remoteConfig.setDefaults(defaults);
      await _fetchAndActivate();
      // print("here ${_remoteConfig.getBool(_freeServices)}");
    } on FetchThrottledException catch (exception) {
      // Fetch throttled.
      print('Remote config fetch throttled: $exception');
    } catch (exception) {
      print('Unable to fetch remote config. Cached or default values will be '
          'used');
    }
  }

  Future _fetchAndActivate() async {
    await _remoteConfig.fetch(expiration: Duration(seconds: 1));
    await _remoteConfig.activateFetched();
  }

  RemoteConfigService({RemoteConfig remoteConfig})
      : _remoteConfig = remoteConfig;
}
