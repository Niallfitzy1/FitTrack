import 'package:flutter/material.dart';

import '../core/enums.dart';
import '../core/routes.dart';

class TargetAreaChip extends StatelessWidget {
  const TargetAreaChip({super.key, required this.targetArea});

  final TargetArea targetArea;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final nav = Navigator.of(context);

    return GestureDetector(
        onTap: () {
          nav.pushNamed(RouteName.exercises.path, arguments: targetArea);
        },
        child: Chip(
            side: BorderSide.none,
            backgroundColor: targetArea.color,
            label: Text(
              targetArea.toDisplay(),
              style: TextStyle(color: theme.colorScheme.onSecondary),
            )));
  }
}
