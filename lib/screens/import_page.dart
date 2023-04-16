import 'dart:convert';
import 'dart:io';

import 'package:collection/collection.dart';
import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:fittrack/core/enums.dart';
import 'package:fittrack/data/app_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/dates.dart';
import '../models/hydrated_entries.dart';

class ImportPage extends StatefulWidget {
  const ImportPage({super.key, this.initialExerciseName});

  final String? initialExerciseName;

  @override
  ImportPageState createState() {
    return ImportPageState();
  }
}

class ImportPageState extends State<ImportPage> {
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

    return Container(
        margin: const EdgeInsets.all(25),
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: ListView(children: [
          Text(
            'Import data from another app',
            textAlign: TextAlign.center,
            style: theme.primaryTextTheme.headlineSmall,
          ),
          ElevatedButton(
            onPressed: () async {
              try {
                final FilePickerResult? result = await FilePicker.platform
                    .pickFiles(
                        withData: false,
                        allowedExtensions: ['txt', 'csv'],
                        type: FileType.custom);
                if (result != null) {
                  final message = messenger.showSnackBar(SnackBar(
                    backgroundColor: theme.colorScheme.tertiaryContainer,
                    content: Text('Processing file',
                        style: TextStyle(
                            color: theme.colorScheme.onTertiaryContainer)),
                  ));
                  PlatformFile file = result.files.first;
                  final input = File(file.path!).openRead();

                  final csv = await input
                      .transform(utf8.decoder)
                      .transform(const CsvToListConverter(eol: "\n"))
                      .toList();

                  final toCreate = csv.skip(1).mapIndexed((ix, it) {
                    final date = DateTime.parse(it[0]);
                    final exerciseName = (it[1] as String).trim();
                    final targetArea = db.exercises.targetArea.converter
                        .fromSql((it[2] as String).toLowerCase());
                    final weight = it[3] as double;
                    final reps = (it[4] as double).toInt();
                    return ImportRow(
                        date, exerciseName, targetArea, weight, reps);
                  });
                  setState(() {
                    _data = toCreate.toList();
                  });
                  message.close();
                }
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
                          backgroundColor: theme.colorScheme.tertiaryContainer,
                          content: Text('Creating Entries',
                              style: TextStyle(
                                  color:
                                      theme.colorScheme.onTertiaryContainer))));
                      await Future.wait(toCreate.map((row) => db.exercisesDao
                          .getOrAddExercise(row.exerciseName, row.targetArea)
                          .then((exercise) => db.setsDao.addSet(
                              row.day,
                              exercise.id,
                              SetStatus.complete,
                              row.weight,
                              row.reps))));
                      message.close();
                      messenger.showSnackBar(SnackBar(
                          backgroundColor: theme.colorScheme.tertiaryContainer,
                          content: Text(
                            'Data import successful',
                            style: TextStyle(
                                color: theme.colorScheme.onTertiaryContainer),
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
                  '${e.exerciseName}, ${e.targetArea}, ${formatAsDate(e.day)},  ${e.weight} kg x ${e.reps}'))
              .toList()),
        ]));
  }
}
