import 'package:flutter/material.dart';

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
    return IntrinsicWidth(
      child: ListTile(
        onTap: () => onChanged(!value),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9)),
        minLeadingWidth: 6,
        visualDensity: VisualDensity.compact,
        title: Text(label),
        leading: Icon(
          value ? Icons.check_box : Icons.check_box_outline_blank,
          color: value ? Theme.of(context).colorScheme.secondary : null,
          size: 21,
        ),
      ),
    );
  }
}
