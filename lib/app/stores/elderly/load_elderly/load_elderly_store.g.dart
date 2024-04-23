// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'load_elderly_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$LoadElderlyStore on LoadElderlyBase, Store {
  Computed<bool>? _$loadingComputed;

  @override
  bool get loading => (_$loadingComputed ??=
          Computed<bool>(() => super.loading, name: 'LoadElderlyBase.loading'))
      .value;

  late final _$elderlyAtom =
      Atom(name: 'LoadElderlyBase.elderly', context: context);

  @override
  Users? get elderly {
    _$elderlyAtom.reportRead();
    return super.elderly;
  }

  @override
  set elderly(Users? value) {
    _$elderlyAtom.reportWrite(value, super.elderly, () {
      super.elderly = value;
    });
  }

  late final _$errorMessageAtom =
      Atom(name: 'LoadElderlyBase.errorMessage', context: context);

  @override
  String? get errorMessage {
    _$errorMessageAtom.reportRead();
    return super.errorMessage;
  }

  @override
  set errorMessage(String? value) {
    _$errorMessageAtom.reportWrite(value, super.errorMessage, () {
      super.errorMessage = value;
    });
  }

  late final _$runAsyncAction =
      AsyncAction('LoadElderlyBase.run', context: context);

  @override
  Future<void> run() {
    return _$runAsyncAction.run(() => super.run());
  }

  late final _$LoadElderlyBaseActionController =
      ActionController(name: 'LoadElderlyBase', context: context);

  @override
  void clear() {
    final _$actionInfo = _$LoadElderlyBaseActionController.startAction(
        name: 'LoadElderlyBase.clear');
    try {
      return super.clear();
    } finally {
      _$LoadElderlyBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
elderly: ${elderly},
errorMessage: ${errorMessage},
loading: ${loading}
    ''';
  }
}
