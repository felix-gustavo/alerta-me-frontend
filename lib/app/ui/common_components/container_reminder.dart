import 'package:flutter/material.dart';

class ContainerReminder extends StatelessWidget {
  final Widget page;
  final String title;
  final void Function()? onPressed;

  const ContainerReminder({
    super.key,
    required this.onPressed,
    required this.page,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: Theme.of(context)
                  .textTheme
                  .titleMedium!
                  .copyWith(color: colorScheme.primary),
            ),
            IconButton(
              onPressed: onPressed,
              color: colorScheme.primary,
              tooltip:
                  onPressed == null ? 'Vincule-se a uma pessoa idosa' : null,
              icon: const Icon(Icons.edit_note_rounded),
            ),
          ],
        ),
        const SizedBox(height: 6),
        page,
      ],
    );
  }
}
