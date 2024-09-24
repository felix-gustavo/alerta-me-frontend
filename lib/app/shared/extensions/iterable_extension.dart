import 'package:flutter/material.dart';

extension IterableExtension on Iterable<Widget> {
  List<Widget> separator(Widget e) {
    return expand((widget) => [widget, e]).toList()..removeLast();
  }
}
