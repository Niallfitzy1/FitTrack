import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:fittrack/core/default_exercises.dart';
import 'package:fittrack/data/diaryentries_dao.dart';
import 'package:fittrack/data/exercises_dao.dart';
import 'package:fittrack/data/repsets_dao.dart';
import 'package:fittrack/data/tables.dart';
import 'package:fittrack/data/workouts_dao.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../core/enums.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [
  Exercises,
  Workouts,
  RepSets
], daos: [
  DiaryEntriesDao,
  ExercisesDao,
  SetsDao,
  WorkoutsDao,
])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(onCreate: (m) async {
      await m.createAll(); // create all tables
      await Future.wait(defaultExercises
          .map((e) => into(exercises).insert(e))); // insert on first run.
    }, beforeOpen: (openingDetails) async {
      if (kDebugMode /* or some other flag */) {
        final m = Migrator(this);
        for (final table in allTables) {
          await m.deleteTable(table.actualTableName);
          await m.createTable(table);
        }
      }
    });
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
