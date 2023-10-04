import 'package:flutter/material.dart';

import '../../shared/extensions/colors_app_extension.dart';

class LabeledCheckbox extends StatelessWidget {
  final String label;
  final EdgeInsets padding;
  final bool value;
  final ValueChanged<bool> onChanged;

  const LabeledCheckbox({
    super.key,
    required this.label,
    required this.padding,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onChanged(!value),
      child: Padding(
        padding: padding,
        child: Row(
          children: <Widget>[
            Expanded(
              child: Text(
                label,
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: context.colors.grey,
                    ),
              ),
            ),
            Transform.scale(
              scale: 0.9,
              child: Checkbox(
                value: value,
                onChanged: (bool? newValue) => onChanged(newValue!),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
