import 'package:flutter/material.dart';

import 'confirm_dialog.dart';

class MyDialog extends StatelessWidget {
  final Widget child;
  final String title;
  final bool canPop;
  final bool? loading;
  final VoidCallback? action;

  const MyDialog({
    Key? key,
    required this.child,
    required this.title,
    this.canPop = false,
  })  : loading = null,
        action = null,
        super(key: key);

  const MyDialog.confirm({
    Key? key,
    required this.child,
    required this.loading,
    required this.action,
    required this.title,
  })  : canPop = true,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: canPop,
      onPopInvoked: (didPop) async {
        if (didPop) return;

        final navigator = Navigator.of(context);
        final shouldPop = await showDialog(
          context: context,
          builder: (_) => ConfirmDialog.pop(
            onPostivePressed: () async => Navigator.of(context).pop(true),
          ),
        );

        if (shouldPop ?? false) navigator.pop();
      },
      child: Dialog(
        clipBehavior: Clip.hardEdge,
        insetPadding: const EdgeInsets.all(21),
        child: IntrinsicWidth(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(12),
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              Flexible(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(12),
                  child: Visibility(
                    visible: loading != null && action != null,
                    replacement: child,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(12),
                          child: child,
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: const Text('Não'),
                            ),
                            const SizedBox(width: 6),
                            loading == true
                                ? const CircularProgressIndicator()
                                : TextButton(
                                    onPressed: action,
                                    child: const Text('Sim'),
                                  ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
