import 'package:flutter/material.dart';

class UnorderedListItem extends StatelessWidget {
  final String text;
  const UnorderedListItem({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Text("\u2022", style: TextStyle(fontSize: 24)),
        const SizedBox(width: 10),
        Expanded(child: Text(text)),
      ],
    );
  }
}
