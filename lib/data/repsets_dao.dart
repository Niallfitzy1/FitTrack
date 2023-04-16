import 'package:drift/drift.dart';
import 'package:fittrack/core/enums.dart';
import 'package:fittrack/data/app_database.dart';
import 'package:fittrack/data/tables.dart';
import 'package:rxdart/rxdart.dart';

part 'repsets_dao.g.dart';

@DriftAccessor(tables: [RepSets])
class SetsDao extends DatabaseAccessor<AppDatabase> with _$SetsDaoMixin {
  SetsDao(AppDatabase db) : super(db);

  Future<RepSet> _addSet(
          int workoutId, SetStatus status, double weight, int reps) =>
      into(repSets).insertReturning(
        RepSetsCompanion.insert(
            workoutId: workoutId,
            createdAt: DateTime.now(),
            status: status,
            weight: Value(weight),
            reps: Value(reps)),
      );

  Future<void> _deleteSet(int id) =>
      (delete(repSets)..where((it) => it.id.equals(id))).go();

  Future<RepSet> addSet(DateTime day, int exerciseId, SetStatus status,
      double weight, int reps) async {
    final diaryEntry = await db.diaryEntriesDao.addEntry(day);
    final workout = await db.workoutsDao.addWorkout(exerciseId, diaryEntry.id);
    return _addSet(workout.id, status, weight, reps);
  }

  Future<int> countSetsForWorkout(int workoutId) => (selectOnly(repSets)
        ..where(repSets.workoutId.equals(workoutId))
        ..addColumns([repSets.id.count()]))
      .map((row) => row.read(repSets.id.count()) ?? 0)
      .getSingle();

  Future<void> deleteSet(int id, int workoutId) async {
    await _deleteSet(id);
    final hasMore = (await countSetsForWorkout(workoutId)) > 0;
    if (!hasMore) {
      db.workoutsDao.deleteWorkout(workoutId);
    }
  }

  Stream<List<RepSet>> getSetsForWorkout(DateTime start, int? exerciseId) {
    if (exerciseId == null) {
      return Stream.value([]);
    }
    final diaryQuery = db.diaryEntriesDao.diaryEntryForDay(start);

    return diaryQuery.switchMap((diaryEntry) {
      if (diaryEntry == null) {
        return Stream.value([]);
      }
      final workoutQuery = db.workoutsDao.getWorkout(diaryEntry.id, exerciseId);

      return workoutQuery.switchMap((workout) {
        if (workout == null) {
          return Stream.value([]);
        }

        return (select(repSets)
              ..where((it) => it.workoutId.equals(workout.id))
              ..orderBy([(it) => OrderingTerm.asc(it.createdAt)]))
            .watch();
      });
    });
  }

  Stream<List<RepSet>> setsForWorkout(int workoutId) =>
      (select(repSets)..where((it) => it.workoutId.equals(workoutId))).watch();

  Stream<List<RepSet>> setsForWorkouts(List<int> workoutIds) =>
      (select(repSets)..where((it) => it.workoutId.isIn(workoutIds))).watch();
}
