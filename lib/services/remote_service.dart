import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';

class RemoteService{
  // remote config
  static final remoteConfig = FirebaseRemoteConfig.instance;
  static final Map<String, dynamic> availableBackgroundColors = {
    "red": Colors.red,
    "yellow": Colors.yellow,
    "blue": Colors.blue,
    "green": Colors.green,
    "white": Colors.white,
    'teal' : Colors.teal
  };
  static String background_color = 'teal';

  static Map<bool,dynamic> avaibleOptions = {
    true : Icons.light_mode,
    false : Icons.dark_mode
  } ;
  static bool isSpecialDay = false;

  static Future<void> initConfig() async {
    await remoteConfig.setConfigSettings(RemoteConfigSettings(
      fetchTimeout: const Duration(seconds: 10), // a fetch will wait up to 10 seconds before timing out
      minimumFetchInterval: const Duration(seconds: 10), // fetch parameters will be cached for a maximum of 1 hour
    ));

    await remoteConfig.setDefaults(const {
      "background_color": "teal",
      "isSpecialDay" : false,
    });
    await fetchConfig();
  }

  static Future<void> fetchConfig() async {
    await remoteConfig.fetchAndActivate().then((value) => {
      background_color = remoteConfig.getString('background_color').isNotEmpty
          ? remoteConfig.getString('background_color')
          : "white",

      isSpecialDay =
      remoteConfig.getBool('isSpecialDay')
          ? remoteConfig.getBool('isSpecialDay')
          : false,

      debugPrint(value.toString())
    });
  }
}