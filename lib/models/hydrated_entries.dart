import 'package:fittrack/data/app_database.dart';

import '../core/enums.dart';

class TargetAreaCounts {
  TargetAreaCounts(this.target, this.count);

  final TargetArea target;
  final int count;
}

class ExerciseCounts {
  ExerciseCounts(this.exercise, this.count);

  final String exercise;
  final int count;
}

class ExerciseWithMax {
  ExerciseWithMax(this.exercise, this.max);

  final String exercise;
  final double max;
}

class DiaryEntryWithWorkouts {
  DiaryEntryWithWorkouts(this.entry, this.workouts);

  final DiaryEntry entry;
  final List<WorkoutWithExercise> workouts;
}

class ImportRow {
  ImportRow(this.day, this.exerciseName, this.targetArea, this.weight,
      this.reps);

  final DateTime day;
  final String exerciseName;
  final TargetArea targetArea;
  final double weight;
  final int reps;
}

class WorkoutWithExercise {
  WorkoutWithExercise(this.workout, this.exercise);

  final Workout workout;
  final Exercise exercise;
}

class WorkoutWithExerciseAndSets extends WorkoutWithExercise {
  WorkoutWithExerciseAndSets(workout, exercise, this.sets)
      : super(workout, exercise);

  final List<RepSet> sets;

  String toJson() {
    return sets.map((e) => e.id).join(',');
  }
}
