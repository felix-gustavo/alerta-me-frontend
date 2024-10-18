import 'package:flutter/material.dart';

class MyContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final AlignmentGeometry? alignment;

  const MyContainer({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(18),
    this.alignment = Alignment.center,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: alignment,
      decoration: BoxDecoration(
        border: Border.all(
          color: Theme.of(context).colorScheme.outlineVariant.withOpacity(.6),
        ),
        borderRadius: BorderRadius.circular(6),
      ),
      padding: padding,
      child: child,
    );
  }
}
