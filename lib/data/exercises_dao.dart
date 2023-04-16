import 'package:drift/drift.dart';
import 'package:fittrack/data/app_database.dart';
import 'package:fittrack/data/tables.dart';
import 'package:rxdart/rxdart.dart';

import '../core/enums.dart';

part 'exercises_dao.g.dart';

@DriftAccessor(tables: [Exercises, RepSets])
class ExercisesDao extends DatabaseAccessor<AppDatabase>
    with _$ExercisesDaoMixin {
  ExercisesDao(AppDatabase db) : super(db);

  Stream<List<Exercise>> allExercises([TargetArea? area]) {
    if (area != null) {
      return (select(exercises)
            ..orderBy(
                [(it) => OrderingTerm.asc(it.name.collate(Collate.noCase))])
            ..where((it) => it.targetArea.equalsValue(area)))
          .watch();
    }
    return (select(exercises)
          ..orderBy(
              [(it) => OrderingTerm.asc(it.name.collate(Collate.noCase))]))
        .watch();
  }

  Stream<RepSet?> getMaxSetForExercise(int exerciseId) {
    return db.workoutsDao.getWorkoutsForExercise(exerciseId).switchMap((rows) {
      final ids = rows.map((r) => r.id);
      final query = db.select(db.repSets)
        ..orderBy([(it) => OrderingTerm.desc(it.weight)])
        ..limit(1)
        ..where((it) => it.workoutId.isIn(ids));

      return query.watchSingleOrNull();
    });
  }

  Stream<Exercise> getExercise(int exerciseId) {
    return (select(exercises)..where((tbl) => tbl.id.equals(exerciseId)))
        .watchSingle();
  }

  Future<int> deleteExercise(int exerciseId) {
    return (delete(exercises)..where((tbl) => tbl.id.equals(exerciseId))).go();
  }

  Future<Exercise> addExercise(String name, TargetArea area) => into(exercises)
      .insertReturning(ExercisesCompanion.insert(name: name, targetArea: area),
          mode: InsertMode.insert);

  Future<int> updateExercise(int id, {String? name, TargetArea? area}) =>
      (update(exercises)..where((tbl) => tbl.id.equals(id))).write(
          ExercisesCompanion(
              name: Value.ofNullable(name),
              targetArea: Value.ofNullable(area)));

  Future<Exercise> getOrAddExercise(String name, TargetArea area) =>
      into(exercises).insertReturning(
          ExercisesCompanion.insert(name: name, targetArea: area),
          mode: InsertMode.insertOrIgnore,
          onConflict: DoUpdate((it) => ExercisesCompanion.custom(name: it.name),
              target: [exercises.name]));
}
