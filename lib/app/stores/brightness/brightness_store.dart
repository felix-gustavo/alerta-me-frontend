import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:shared_preferences/shared_preferences.dart';
part 'brightness_store.g.dart';

class BrightnessStore = BrightnessStoreBase with _$BrightnessStore;

abstract class BrightnessStoreBase with Store {
  @observable
  String brightnessMode = Brightness.light.name;

  @action
  Future<void> init() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    const key = String.fromEnvironment('BRIGHTNESS_LOCAL_KEY');
    final brightnessLocal = prefs.getString(key);
    if (brightnessLocal != null) {
      brightnessMode = brightnessLocal;
    }
  }

  @action
  Future<void> changeBrightness() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    const key = String.fromEnvironment('BRIGHTNESS_LOCAL_KEY');

    final brightness = brightnessMode == Brightness.light.name
        ? Brightness.dark.name
        : Brightness.light.name;

    await prefs.setString(key, brightness);
    brightnessMode = brightness;
  }
}
