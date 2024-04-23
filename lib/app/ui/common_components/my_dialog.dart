import 'package:flutter/material.dart';

import '../../shared/extensions/colors_app_extension.dart';
import 'confirm_dialog.dart';

class MyDialog extends StatelessWidget {
  final Widget child;
  final String? title;
  final bool confirmPop;

  const MyDialog({
    Key? key,
    required this.child,
    this.title,
    this.confirmPop = true,
  }) : super(key: key);

  Dialog _buildDialog(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: title != null
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Text(
                    title!,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                Flexible(
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(color: context.colors.lightGrey),
                      ),
                    ),
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: child,
                      ),
                    ),
                  ),
                ),
              ],
            )
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: child,
              ),
            ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return confirmPop
        ? WillPopScope(
            onWillPop: () async {
              final shouldPop = await showDialog<bool>(
                context: context,
                builder: (context) {
                  return ConfirmDialog.pop(
                    onPostivePressed: () async => Navigator.pop(context, true),
                  );
                },
              );
              return shouldPop ?? false;
            },
            child: _buildDialog(context),
          )
        : _buildDialog(context);
  }
}
