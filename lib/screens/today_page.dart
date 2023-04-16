import 'package:fittrack/core/dates.dart';
import 'package:fittrack/core/enums.dart';
import 'package:fittrack/core/weight.dart';
import 'package:fittrack/models/route_args.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/routes.dart';
import '../data/app_database.dart';
import '../models/hydrated_entries.dart';

class TodayPage extends StatelessWidget {
  TodayPage({super.key});
  final today = getAsDate(DateTime.now());

  @override
  Widget build(BuildContext context) {
    final db = context.read<AppDatabase>();
    final theme = Theme.of(context);

    return Scaffold(
      body: StreamBuilder<List<WorkoutWithExerciseAndSets>>(
        stream: db.workoutsDao.hydratedWorkouts(today),
        builder: (BuildContext context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return ListView(
              padding: const EdgeInsets.symmetric(vertical: 8),
              children: snapshot.data!.map((e) {
                return GestureDetector(
                    onTap: () => Navigator.of(context).pushNamed(
                        RouteName.addWorkout.path,
                        arguments: AddWorkoutRouteArgs(e.exercise.id, today)),
                    child: Card(
                        margin: const EdgeInsets.all(10),
                        child: Column(children: [
                          Padding(
                              padding: const EdgeInsets.all(10),
                              child: Row(children: [
                                Text(
                                  e.exercise.name,
                                  style:
                                      Theme.of(context).textTheme.headlineSmall,
                                )
                              ])),
                          Column(
                              children: ListTile.divideTiles(
                            context: context,
                            tiles: e.sets.map((w) => Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 2.5),
                                child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        formatWeight(w.weight),
                                        style:
                                            theme.primaryTextTheme.titleMedium,
                                      ),
                                      Text(
                                        '${w.reps} reps',
                                        style:
                                            theme.primaryTextTheme.titleMedium,
                                      ),
                                      Icon(w.status.icon, color: w.status.color)
                                    ]))),
                          ).toList())
                        ])));
              }).toList(),
            );
          }
        },
      ),
    );
  }
}
