import 'package:flutter/material.dart';

class ActiveSwitch extends StatelessWidget {
  final void Function(bool value) _onChangeActive;
  final bool value;

  const ActiveSwitch({
    super.key,
    required void Function(bool value) onChangeActive,
    required this.value,
  }) : _onChangeActive = onChangeActive;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => _onChangeActive(!value),
        child: Row(
          children: [
            const Text('Notificação'),
            Transform.scale(
              scale: 0.69,
              child: Switch(
                value: value,
                // value: _waterReminder.active,
                onChanged: _onChangeActive,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
