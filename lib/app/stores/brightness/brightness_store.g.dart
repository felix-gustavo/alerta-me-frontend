// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'brightness_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$BrightnessStore on BrightnessStoreBase, Store {
  late final _$brightnessModeAtom =
      Atom(name: 'BrightnessStoreBase.brightnessMode', context: context);

  @override
  String get brightnessMode {
    _$brightnessModeAtom.reportRead();
    return super.brightnessMode;
  }

  @override
  set brightnessMode(String value) {
    _$brightnessModeAtom.reportWrite(value, super.brightnessMode, () {
      super.brightnessMode = value;
    });
  }

  late final _$initAsyncAction =
      AsyncAction('BrightnessStoreBase.init', context: context);

  @override
  Future<void> init() {
    return _$initAsyncAction.run(() => super.init());
  }

  late final _$changeBrightnessAsyncAction =
      AsyncAction('BrightnessStoreBase.changeBrightness', context: context);

  @override
  Future<void> changeBrightness() {
    return _$changeBrightnessAsyncAction.run(() => super.changeBrightness());
  }

  @override
  String toString() {
    return '''
brightnessMode: ${brightnessMode}
    ''';
  }
}
