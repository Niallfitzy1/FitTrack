import 'package:fittrack/core/dates.dart';
import 'package:fittrack/core/routes.dart';
import 'package:fittrack/core/weight.dart';
import 'package:fittrack/screens/add_exercise.dart';
import 'package:fittrack/screens/edit_exercise.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../components/enum_chips.dart';
import '../core/enums.dart';
import '../data/app_database.dart';
import '../models/route_args.dart';

class ExerciseListScreen extends StatefulWidget {
  const ExerciseListScreen({this.initialTargetArea, super.key});

  final TargetArea? initialTargetArea;

  @override
  State<StatefulWidget> createState() => _ExerciseListScreenState();
}

class _ExerciseListScreenState extends State<ExerciseListScreen> {
  TargetArea? targetArea;

  @override
  void initState() {
    super.initState();
    targetArea = widget.initialTargetArea;
  }

  @override
  Widget build(BuildContext context) {
    final db = context.read<AppDatabase>();

    return Scaffold(
        appBar: AppBar(
          title: const Text('Exercises'),
          actions: [
            IconButton(
                onPressed: () => showModalBottomSheet(
                      useSafeArea: true,
                      isScrollControlled: true,
                      shape: const RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(20))),
                      context: context,
                      builder: (context) => const AddExerciseForm(),
                    ),
                icon: const Icon(Icons.add_circle)),
          ],
        ),
        body: Column(children: [
          Wrap(
            spacing: 2,
            children: TargetArea.values
                .map((e) => FilterChip(
                      labelPadding: EdgeInsets.zero,
                      label: Text(
                        e.toDisplay(),
                        style: const TextStyle(color: Colors.black87),
                      ),
                      onSelected: (bool value) => setState(() {
                        targetArea = value ? e : null;
                      }),
                      backgroundColor: e.color,
                      selected: e == targetArea,
                    ))
                .toList(),
          ),
          StreamBuilder<List<Exercise>>(
            stream: db.exercisesDao.allExercises(targetArea),
            builder:
                (BuildContext context, AsyncSnapshot<List<Exercise>> snapshot) {
              if (!snapshot.hasData) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                return Expanded(
                    child: ListView(
                  children: snapshot.data!
                      .map((e) => ListTile(
                            title: Text(e.name),
                            onTap: () => Navigator.of(context).pushNamed(
                                RouteName.addWorkout.path,
                                arguments: AddWorkoutRouteArgs(
                                    e.id, getAsDate(DateTime.now()))),
                            onLongPress: () => showModalBottomSheet(
                                context: context,
                                builder: (context) =>
                                    EditExerciseForm(exerciseId: e.id)),
                            trailing: TargetAreaChip(targetArea: e.targetArea),
                            subtitle: StreamBuilder(
                              stream:
                                  db.exercisesDao.getMaxSetForExercise(e.id),
                              builder: (context, snapshot) {
                                if (!snapshot.hasData) {
                                  return const Text('No PB set yet');
                                }
                                final data = snapshot.data!;
                                return Wrap(children: [
                                  const Icon(
                                    Icons.emoji_events,
                                  ),
                                  Text(
                                      '${formatWeight(data.weight)} x ${data.reps} reps')
                                ]);
                              },
                            ),
                          ))
                      .toList(),
                ));
              }
            },
          )
        ]));
  }
}
