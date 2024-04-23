import 'package:flutter/material.dart';

import '../../shared/extensions/colors_app_extension.dart';

class LabeledCheckbox extends StatelessWidget {
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  const LabeledCheckbox({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () => onChanged(!value),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      minLeadingWidth: 6,
      title: Text(
        label,
        style: Theme.of(context)
            .textTheme
            .bodyMedium!
            .copyWith(color: context.colors.grey),
      ),
      leading: Icon(
        value ? Icons.check_box : Icons.check_box_outline_blank,
        color: value ? context.colors.secondary : context.colors.grey,
        size: 21,
      ),
    );
  }
}
