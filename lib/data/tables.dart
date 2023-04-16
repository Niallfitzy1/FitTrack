import 'package:drift/drift.dart';

import '../core/enums.dart';

class Exercises extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get name => text().unique()();

  TextColumn get targetArea => textEnum<TargetArea>()();
}

@DataClassName('DiaryEntry')
class DiaryEntries extends Table {
  IntColumn get id => integer().autoIncrement()();

  DateTimeColumn get createdAt => dateTime().unique()();
}

class Workouts extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get exerciseId =>
      integer().references(Exercises, #id, onDelete: KeyAction.cascade)();

  IntColumn get diaryEntryId =>
      integer().references(DiaryEntries, #id, onDelete: KeyAction.cascade)();

  TextColumn get status => textEnum<WorkoutStatus>().nullable()();

  @override
  List<Set<Column>> get uniqueKeys => [
        {exerciseId, diaryEntryId}
      ];
}

class RepSets extends Table {
  IntColumn get id => integer().autoIncrement()();

  DateTimeColumn get createdAt => dateTime()();

  IntColumn get workoutId =>
      integer().references(Workouts, #id, onDelete: KeyAction.cascade)();

  TextColumn get status => textEnum<SetStatus>()();

  RealColumn get weight => real().nullable()();

  IntColumn get reps => integer().nullable()();
}
