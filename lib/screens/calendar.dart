import 'package:fittrack/core/dates.dart';
import 'package:fittrack/core/weight.dart';
import 'package:fittrack/data/app_database.dart';
import 'package:fittrack/models/hydrated_entries.dart';
import 'package:fittrack/models/route_args.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

import '../components/enum_chips.dart';
import '../core/routes.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  CalendarFormat _calendarFormat = CalendarFormat.twoWeeks;
  DateTime _focusedDay = DateTime.now();
  late DateTime _selectedDay;

  @override
  void initState() {
    super.initState();

    _selectedDay = _focusedDay;
  }

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context);
    final db = context.read<AppDatabase>();
    final theme = Theme.of(context);

    return Column(children: [
      StreamBuilder(
          stream: db.diaryEntriesDao.allDiaryEntries(),
          builder: (context, snapshot) => TableCalendar(
                calendarStyle: CalendarStyle(
                  todayDecoration: BoxDecoration(
                    color: theme.colorScheme.surfaceVariant,
                    shape: BoxShape.circle,
                  ),
                  selectedDecoration: BoxDecoration(
                    color: theme.colorScheme.primary,
                    shape: BoxShape.circle,
                  ),
                  markerSize: 10,
                  markerDecoration: BoxDecoration(
                    color: theme.colorScheme.onSurface,
                    shape: BoxShape.circle,
                  ),
                ),
                locale: locale.toString(),
                startingDayOfWeek: StartingDayOfWeek.monday,
                firstDay: firstDate,
                lastDay: lastDate,
                focusedDay: _focusedDay,
                calendarFormat: _calendarFormat,
                rangeSelectionMode: RangeSelectionMode.disabled,
                onDaySelected: (DateTime selectedDay, DateTime focusedDay) {
                  if (!isSameDay(_selectedDay, selectedDay)) {
                    setState(() {
                      _selectedDay = selectedDay;
                      _focusedDay = focusedDay;
                    });
                  }
                },
                selectedDayPredicate: (day) {
                  return isSameDay(_selectedDay, day);
                },
                eventLoader: (day) {
                  return snapshot.data
                          ?.where(
                              (element) => isSameDay(element.createdAt, day))
                          .toList() ??
                      [];
                },
                onFormatChanged: (format) {
                  if (_calendarFormat != format) {
                    setState(() {
                      _calendarFormat = format;
                    });
                  }
                },
                onPageChanged: (focusedDay) {
                  _focusedDay = focusedDay;
                },
              )),
      StreamBuilder<List<WorkoutWithExerciseAndSets>>(
        stream: db.workoutsDao.hydratedWorkouts(getAsDate(_selectedDay)),
        builder: (BuildContext context,
            AsyncSnapshot<List<WorkoutWithExerciseAndSets>> snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return Flexible(
                child: ListView(
              children: snapshot.data!
                  .map((e) => ListTile(
                      onTap: () => Navigator.of(context).pushNamed(
                          RouteName.addWorkout.path,
                          arguments: AddWorkoutRouteArgs(
                              e.exercise.id, getAsDate(_selectedDay))),
                      trailing:
                          TargetAreaChip(targetArea: e.exercise.targetArea),
                      leading: StreamBuilder(
                        stream:
                            db.exercisesDao.getMaxSetForExercise(e.exercise.id),
                        builder: (context, snapshot) {
                          final weights = e.sets.map((e) => e.weight).toList();
                          if (snapshot.hasData &&
                              snapshot.data != null &&
                              weights.contains(snapshot.data!.weight ?? 0)) {
                            return const Icon(Icons.local_fire_department,
                                color: Colors.red);
                          }
                          return const Text('');
                        },
                      ),
                      subtitle: Text(e.sets
                          .fold(<double, int>{}, (value, element) {
                            final weight = element.weight ?? 0;
                            value[weight] =
                                (value[weight] ?? 0) + (element.reps ?? 0);
                            return value;
                          })
                          .entries
                          .map((element) =>
                              '(${formatWeight(element.key)} X ${element.value})')
                          .join(', ')),
                      title: Text(e.exercise.name)))
                  .toList(),
            ));
          }
        },
      )
    ]);
  }
}
