import 'package:drift/drift.dart';
import 'package:fittrack/core/enums.dart';
import 'package:fittrack/data/app_database.dart';

List<Insertable<Exercise>> defaultExercises = [
  ExercisesCompanion.insert(name: 'Deadlift', targetArea: TargetArea.back),
  ExercisesCompanion.insert(name: 'Low Row', targetArea: TargetArea.back),
  ExercisesCompanion.insert(
      name: 'Dumbbell Curl', targetArea: TargetArea.biceps),
  ExercisesCompanion.insert(
      name: 'Barbell Curl', targetArea: TargetArea.biceps),
  ExercisesCompanion.insert(name: 'Bicep Curl', targetArea: TargetArea.biceps),
  ExercisesCompanion.insert(
      name: "Flat Barbell Bench Press", targetArea: TargetArea.chest),
  ExercisesCompanion.insert(
      name: "Incline Barbell Bench Press", targetArea: TargetArea.chest),
  ExercisesCompanion.insert(
      name: "Pectoral Machine", targetArea: TargetArea.chest),
  ExercisesCompanion.insert(
      name: "Seated Machine Chest Press", targetArea: TargetArea.chest),
  ExercisesCompanion.insert(name: 'Incline Squat', targetArea: TargetArea.legs),
  ExercisesCompanion.insert(name: 'Leg Curl', targetArea: TargetArea.legs),
  ExercisesCompanion.insert(name: 'Leg Press', targetArea: TargetArea.legs),
  ExercisesCompanion.insert(name: 'Leg Extension', targetArea: TargetArea.legs),
  ExercisesCompanion.insert(
      name: 'Lying Leg Curl', targetArea: TargetArea.legs),
  ExercisesCompanion.insert(
      name: 'Seated Calf Raise', targetArea: TargetArea.legs),
  ExercisesCompanion.insert(
      name: 'Standing Calf Raise', targetArea: TargetArea.legs),
  ExercisesCompanion.insert(name: 'Squat', targetArea: TargetArea.legs),
  ExercisesCompanion.insert(
      name: 'Lat Pulldown', targetArea: TargetArea.shoulders),
  ExercisesCompanion.insert(
      name: 'Overhead Press', targetArea: TargetArea.shoulders),
  ExercisesCompanion.insert(
      name: 'Tricep Extension', targetArea: TargetArea.triceps),
];
