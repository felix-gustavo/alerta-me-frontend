import 'package:flutter/material.dart';

class ConfirmDialog extends StatelessWidget {
  final String title;
  final String? content;

  final String positiveBtnText;
  final String negativeBtnText;
  final Future<void> Function() onPostivePressed;
  final Future<void> Function()? onNegativePressed;

  const ConfirmDialog({
    super.key,
    required this.title,
    this.content,
    required this.positiveBtnText,
    required this.negativeBtnText,
    required this.onPostivePressed,
    this.onNegativePressed,
  });

  const ConfirmDialog.pop({
    super.key,
    required this.onPostivePressed,
    this.onNegativePressed,
  })  : positiveBtnText = 'Sim',
        negativeBtnText = 'Não',
        title = 'Os dados serão descartados',
        content = 'Deseja continuar e fechar a janela?';

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return AlertDialog(
      title: Text(title, style: textTheme.titleMedium),
      titlePadding: const EdgeInsets.all(21),
      contentPadding: const EdgeInsets.symmetric(horizontal: 21),
      actionsPadding: const EdgeInsets.fromLTRB(21, 33, 15, 21),
      buttonPadding: const EdgeInsets.symmetric(horizontal: 12),
      content: content != null && content!.isNotEmpty
          ? SizedBox(
              width: 333,
              child: Text(
                content!,
                style: textTheme.bodyMedium!.copyWith(
                  // color: context.colors.grey,
                  fontStyle: FontStyle.italic,
                ),
              ),
            )
          : null,
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context, false);
            if (onNegativePressed != null) onNegativePressed!();
          },
          child: Text(negativeBtnText),
        ),
        TextButton(
          onPressed: onPostivePressed,
          child: Text(positiveBtnText),
        ),
      ],
    );
  }
}
