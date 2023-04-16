import 'package:drift/drift.dart';
import 'package:fittrack/data/app_database.dart';
import 'package:fittrack/data/tables.dart';
import 'package:rxdart/rxdart.dart';

import '../models/hydrated_entries.dart';

part 'workouts_dao.g.dart';

@DriftAccessor(tables: [Workouts])
class WorkoutsDao extends DatabaseAccessor<AppDatabase>
    with _$WorkoutsDaoMixin {
  WorkoutsDao(AppDatabase db) : super(db);

  Future<Workout> addWorkout(int exerciseId, int diaryEntryId) =>
      into(workouts).insertReturning(
          WorkoutsCompanion.insert(
              exerciseId: exerciseId, diaryEntryId: diaryEntryId),
          mode: InsertMode.insertOrIgnore,
          onConflict: DoUpdate(
              (it) => WorkoutsCompanion.custom(diaryEntryId: it.diaryEntryId),
              target: [workouts.diaryEntryId, workouts.exerciseId]));

  Stream<Workout?> getWorkout(int diaryEntryId, int exerciseId) =>
      (select(workouts)
            ..where((t) => t.diaryEntryId.equals(diaryEntryId))
            ..where((t) => t.exerciseId.equals(exerciseId)))
          .watchSingleOrNull();

  Stream<List<Workout>> getWorkoutsForExercise(int exerciseId) =>
      (select(workouts)..where((t) => t.exerciseId.equals(exerciseId))).watch();

  Stream<List<WorkoutWithExerciseAndSets>> hydratedWorkouts(DateTime dateTime) {
    final diaryEntryStream = db.diaryEntriesDao.diaryEntryForDay(dateTime);

    return diaryEntryStream.switchMap((diaryEntry) {
      if (diaryEntry == null) {
        return Stream.value([]);
      }

      final workoutsStreamQuery = select(workouts).join(
          [innerJoin(exercises, exercises.id.equalsExp(workouts.exerciseId))])
        ..where(workouts.diaryEntryId.equals(diaryEntry.id));

      final transformed = workoutsStreamQuery.map((row) => WorkoutWithExercise(
          row.readTable(workouts), row.readTable(exercises)));

      return transformed.watch().switchMap((entries) {
        final idToEntry = {for (var entry in entries) entry.workout.id: entry};
        final ids = idToEntry.keys.toList();

        return db.setsDao.setsForWorkouts(ids).map((rows) {
          final idToItems = <int, List<RepSet>>{};

          for (final row in rows) {
            idToItems.putIfAbsent(row.workoutId, () => []).add(row);
          }

          return [
            for (var id in ids)
              WorkoutWithExerciseAndSets(
                  idToEntry[id]!.workout,
                  idToEntry[id]!.exercise,
                  idToItems[idToEntry[id]!.workout.id] ?? [])
          ];
        });
      });
    });
  }

  Stream<List<TargetAreaCounts>> countWorkoutTargets() {
    final query = select(workouts).join(
        [innerJoin(exercises, exercises.id.equalsExp(workouts.exerciseId))]);

    query
      ..addColumns([workouts.id.count()])
      ..groupBy([exercises.targetArea]);

    return query.watch().map((rows) {
      return [
        for (var row in rows)
          TargetAreaCounts(row.readTable(exercises).targetArea,
              row.read(workouts.id.count()) ?? 0),
      ];
    });
  }

  Stream<List<ExerciseCounts>> countWorkoutExercises() {
    final query = select(workouts).join(
        [innerJoin(exercises, exercises.id.equalsExp(workouts.exerciseId))]);

    query
      ..addColumns([workouts.id.count()])
      ..groupBy([exercises.name]);

    return query.watch().map((rows) {
      return [
        for (var row in rows)
          ExerciseCounts(row.readTable(exercises).name,
              row.read(workouts.id.count()) ?? 0),
      ];
    });
  }

  Future<int> countWorkoutsForDiaryEntry(int diaryEntryId) =>
      (selectOnly(workouts)
            ..where(workouts.diaryEntryId.equals(diaryEntryId))
            ..addColumns([workouts.id.count()]))
          .map((row) => row.read(workouts.id.count()) ?? 0)
          .getSingle();

  Future<void> deleteWorkout(int workoutId) async {
    Workout workout = await (select(workouts)
          ..where((it) => it.id.equals(workoutId)))
        .getSingle();
    await (delete(workouts)..where((it) => it.id.equals(workoutId))).go();
    final hasMore =
        (await countWorkoutsForDiaryEntry(workout.diaryEntryId)) > 0;
    if (!hasMore) {
      db.diaryEntriesDao.deleteEntry(workout.diaryEntryId);
    }
  }
}
