import 'package:flutter/material.dart';

class MyContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final AlignmentGeometry? alignment;
  final bool? withBorder;

  const MyContainer({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(18),
    this.alignment = Alignment.center,
    this.withBorder = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: alignment,
      decoration: BoxDecoration(
        border: withBorder == true
            ? Border.all(
                color: Theme.of(context)
                    .colorScheme
                    .outlineVariant
                    .withOpacity(.6),
              )
            : null,
        color: Theme.of(context).colorScheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(6),
      ),
      padding: padding,
      child: child,
    );

    // return Card(
    //   color: Theme.of(context).colorScheme.surfaceContainerLowest,
    //   child: Padding(
    //     padding: padding ?? EdgeInsets.zero,
    //     child: child,
    //   ),
    // );
  }
}
