import 'package:flutter/material.dart';

class MyOutlinedButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String text;
  final Color? color;

  const MyOutlinedButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        foregroundColor: color,
        side: color != null ? BorderSide(color: color!) : null,
      ),
      child: Text(
        text,
        style: color != null
            ? Theme.of(context).textTheme.bodyMedium!.copyWith(color: color)
            : null,
      ),
    );
  }
}
