import 'dart:convert';
import 'dart:io';

import 'package:collection/collection.dart';
import 'package:csv/csv.dart';
import 'package:fittrack/core/csv_parsing.dart';
import 'package:fittrack/core/enums.dart';
import 'package:fittrack/data/app_database.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pick_or_save/pick_or_save.dart';
import 'package:provider/provider.dart';

import '../core/dates.dart';
import '../models/hydrated_entries.dart';

class ImportExportPage extends StatefulWidget {
  const ImportExportPage({super.key, this.initialExerciseName});

  final String? initialExerciseName;

  @override
  ImportExportPageState createState() {
    return ImportExportPageState();
  }
}

class ImportExportPageState extends State<ImportExportPage> {
  List<ImportRow>? _data;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final db = Provider.of<AppDatabase>(context);
    final nav = Navigator.of(context);
    final theme = Theme.of(context);
    final messenger = ScaffoldMessenger.of(context);

    return DefaultTabController(
        length: 2,
        child: Scaffold(
            appBar: const TabBar(tabs: [
              Tab(icon: Icon(Icons.add_to_photos)),
              Tab(icon: Icon(Icons.output))
            ]),
            body: TabBarView(children: [
              Container(
                  margin: const EdgeInsets.all(25),
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom),
                  child: ListView(children: [
                    Text(
                      'Import data from another app',
                      textAlign: TextAlign.center,
                      style: theme.primaryTextTheme.headlineSmall,
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        try {
                          List<String>? result = await PickOrSave().filePicker(
                            params: FilePickerParams(
                                getCachedFilePath: true,
                                mimeTypesFilter: ['text/csv'],
                                allowedExtensions: ['.txt', '.csv']),
                          );
                          String? filePath = result?[0];

                          if (filePath == null) {
                            messenger.showSnackBar(SnackBar(
                                backgroundColor:
                                    theme.colorScheme.tertiaryContainer,
                                content: Text('No file selected',
                                    style: TextStyle(
                                        color: theme.colorScheme
                                            .onTertiaryContainer))));
                            return;
                          }

                          final input = File(filePath).openRead();
                          final message = messenger.showSnackBar(SnackBar(
                            backgroundColor:
                                theme.colorScheme.tertiaryContainer,
                            content: Text('Processing file',
                                style: TextStyle(
                                    color:
                                        theme.colorScheme.onTertiaryContainer)),
                          ));

                          final csv = await input
                              .transform(utf8.decoder)
                              .transform(const CsvToListConverter(eol: "\n"))
                              .toList();

                          final toCreate = csv.skip(1).mapIndexed((ix, it) {
                            final date = DateTime.parse(it[0]);
                            final exerciseName = (it[1] as String).trim();
                            final targetArea = db.exercises.targetArea.converter
                                .fromSql((it[2] as String).toLowerCase());
                            final weight = parseAsDouble(it[3]);
                            final reps = parseAsInt(it[4]);
                            return ImportRow(
                                date, exerciseName, targetArea, weight, reps);
                          });
                          setState(() {
                            _data = toCreate.toList();
                          });
                          message.close();
                        } catch (e) {
                          return;
                        }
                      },
                      child: const Text('Select file'),
                    ),
                    ElevatedButton(
                      onPressed: _data != null
                          ? () async {
                              final toCreate = _data;
                              if (toCreate != null) {
                                final message = messenger.showSnackBar(SnackBar(
                                    backgroundColor:
                                        theme.colorScheme.tertiaryContainer,
                                    content: Text('Creating Entries',
                                        style: TextStyle(
                                            color: theme.colorScheme
                                                .onTertiaryContainer))));
                                await Future.wait(toCreate.map((row) => db
                                    .exercisesDao
                                    .getOrAddExercise(
                                        row.exerciseName, row.targetArea)
                                    .then((exercise) => db.setsDao.addSet(
                                        row.day,
                                        exercise.id,
                                        SetStatus.complete,
                                        row.weight,
                                        row.reps))));
                                message.close();
                                messenger.showSnackBar(SnackBar(
                                    backgroundColor:
                                        theme.colorScheme.tertiaryContainer,
                                    content: Text(
                                      'Data import successful',
                                      style: TextStyle(
                                          color: theme
                                              .colorScheme.onTertiaryContainer),
                                    )));
                                nav.maybePop();
                              }
                            }
                          : null,
                      child: const Text('Create data'),
                    ),
                    _data != null
                        ? Center(
                            child: Text(
                            'Preview',
                            style: theme.primaryTextTheme.headlineSmall,
                          ))
                        : Container(),
                    ...((_data ?? [])
                        .map((e) => Text(
                            '${e.exerciseName}, ${e.targetArea.name}, ${formatAsDate(e.day)},  ${e.weight} kg x ${e.reps}'))
                        .toList()),
                  ])),
              Container(
                  margin: const EdgeInsets.all(25),
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom),
                  child: ListView(children: [
                    Text(
                      'Export data',
                      textAlign: TextAlign.center,
                      style: theme.primaryTextTheme.headlineSmall,
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        try {
                          String fileName =
                              'fittrack_export_${DateTime.now().toIso8601String()}.csv';
                          Directory cacheDirectory =
                              await getTemporaryDirectory();
                          File tempExportFile =
                              File('${cacheDirectory.path}/$fileName');

                          List<DiaryEntry> diaryEntries =
                              await db.diaryEntriesDao.allDiaryEntriesFuture();

                          List<dynamic> result =
                              (await Future.wait(diaryEntries.map((it) async {
                            List<WorkoutWithExerciseAndSets> existingWorkouts =
                                await db.workoutsDao
                                    .hydratedWorkouts(it.createdAt)
                                    .first;
                            List<Object> asRow = existingWorkouts
                                .expand((hydratedEntry) =>
                                    hydratedEntry.sets.map((set) => [
                                          it.createdAt,
                                          hydratedEntry.exercise.name,
                                          hydratedEntry
                                              .exercise.targetArea.name,
                                          set.weight,
                                          set.reps
                                        ]))
                                .toList();
                            return asRow;
                          })))
                                  .expand((element) => element)
                                  .toList();

                          String csvData = const ListToCsvConverter().convert([
                            [
                              'Date',
                              'Exercise',
                              'Category',
                              'Weight (kg)',
                              'Reps',
                            ],
                            ...result
                          ]);
                          await tempExportFile.writeAsString(csvData);
                          await PickOrSave().fileSaver(
                              params: FileSaverParams(
                            saveFiles: [
                              SaveFileInfo(
                                  filePath: tempExportFile.path,
                                  fileName: fileName)
                            ],
                          ));
                          messenger.showSnackBar(SnackBar(
                            backgroundColor:
                                theme.colorScheme.tertiaryContainer,
                            content: Text('Data exported successfully',
                                style: TextStyle(
                                    color:
                                        theme.colorScheme.onTertiaryContainer)),
                          ));
                          await tempExportFile.delete();
                        } catch (e) {
                          messenger.showSnackBar(SnackBar(
                              backgroundColor:
                                  theme.colorScheme.tertiaryContainer,
                              content: Text('Failed to export data',
                                  style: TextStyle(
                                      color: theme
                                          .colorScheme.onTertiaryContainer))));
                          return;
                        }
                      },
                      child: const Text('Export data to csv file'),
                    ),
                  ])),
            ])));
  }
}
