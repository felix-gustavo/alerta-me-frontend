import 'package:flutter/material.dart';

import '../../../../../shared/extensions/app_styles_extension.dart';
import '../../../../common_components/my_container.dart';

class CardInfo extends StatelessWidget {
  final String label;
  final String value;
  final String? unit;

  const CardInfo({
    super.key,
    required this.label,
    required this.value,
    this.unit,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final width = context.screenWidth * .069;

    return SizedBox(
      width: context.isTablet
          ? 114
          : width < 132
              ? 132
              : width,
      child: AspectRatio(
        aspectRatio: 7 / 5,
        child: MyContainer(
          padding: EdgeInsets.zero,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: value,
                      style: textTheme.headlineSmall!.copyWith(
                        color: colorScheme.primary,
                      ),
                    ),
                    if (unit != null)
                      TextSpan(
                        text: unit,
                        style: textTheme.titleLarge!.copyWith(
                          color: colorScheme.primary,
                        ),
                      )
                  ],
                ),
                textAlign: TextAlign.center,
              ),
              Text(
                label,
                style: textTheme.bodyMedium!.copyWith(
                  color: colorScheme.outline,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
