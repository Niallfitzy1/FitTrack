import 'package:drift/drift.dart';
import 'package:fittrack/data/app_database.dart';
import 'package:fittrack/data/tables.dart';

part 'diaryentries_dao.g.dart';

@DriftAccessor(tables: [DiaryEntries])
class DiaryEntriesDao extends DatabaseAccessor<AppDatabase>
    with _$DiaryEntriesDaoMixin {
  DiaryEntriesDao(AppDatabase db) : super(db);

  Stream<DiaryEntry?> diaryEntryForDay(DateTime day) =>
      (select(diaryEntries)..where((t) => t.createdAt.equals(day)))
          .watchSingleOrNull();

  Stream<List<DiaryEntry>> allDiaryEntries({order = OrderingTerm.desc}) =>
      (select(diaryEntries)
            ..orderBy([
              (it) => order(it.createdAt),
              (it) => OrderingTerm.desc(it.id)
            ]))
          .watch();

  Future<DiaryEntry> addEntry(DateTime day) => into(diaryEntries)
      .insertReturning(DiaryEntriesCompanion.insert(createdAt: day),
          mode: InsertMode.insertOrIgnore,
          onConflict: DoUpdate(
              (it) => DiaryEntriesCompanion.custom(createdAt: it.createdAt),
              target: [
                diaryEntries.createdAt,
              ]));

  Future<void> deleteEntry(int id) =>
      (delete(diaryEntries)..where((it) => it.id.equals(id))).go();
}
