import 'package:flutter/material.dart';

enum TargetArea { back, biceps, chest, legs, shoulders, triceps }

enum SetStatus { complete, failed, warmUp }

enum WorkoutStatus {
  improvement,
  personalBest,
}

extension ColorExtension on TargetArea {
  Color get color {
    switch (this) {
      case TargetArea.triceps:
        return Colors.orange.shade100;
      case TargetArea.chest:
        return Colors.lime.shade100;
      case TargetArea.shoulders:
        return Colors.red.shade100;
      case TargetArea.back:
        return Colors.green.shade100;
      case TargetArea.biceps:
        return Colors.purple.shade100;
      case TargetArea.legs:
        return Colors.teal.shade100;
    }
  }

  String toDisplay() {
    return name[0].toUpperCase() + name.substring(1).toLowerCase();
  }
}

extension ColorAndIconExtension on SetStatus {
  get color {
    switch (this) {
      case SetStatus.complete:
        return Colors.green.shade300;
      case SetStatus.warmUp:
        return Colors.orange.shade300;
      case SetStatus.failed:
        return Colors.red.shade300;
    }
  }

  get icon {
    switch (this) {
      case SetStatus.complete:
        return Icons.done;
      case SetStatus.warmUp:
        return Icons.thermostat;
      case SetStatus.failed:
        return Icons.not_interested;
    }
  }

  String toDisplay() {
    return name[0].toUpperCase() + name.substring(1).toLowerCase();
  }
}
