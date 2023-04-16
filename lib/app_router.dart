import 'package:drift_db_viewer/drift_db_viewer.dart';
import 'package:fittrack/screens/add_exercise.dart';
import 'package:fittrack/screens/add_workout.dart';
import 'package:fittrack/screens/all_exercises.dart';
import 'package:fittrack/screens/calendar.dart';
import 'package:fittrack/screens/import_page.dart';
import 'package:fittrack/screens/today_page.dart';
import 'package:fittrack/screens/trends.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/enums.dart';
import 'core/routes.dart';
import 'data/app_database.dart';
import 'main.dart';
import 'models/route_args.dart';

class ShortAnimationPageRoute extends MaterialPageRoute {
  @override
  Duration get transitionDuration => const Duration(milliseconds: 100);

  ShortAnimationPageRoute({builder, settings}) : super(builder: builder, settings: settings);
}

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    WidgetBuilder builder;
    int index = 2;
    bool showNav = true;
    bool showFab = true;
    bool showAppBar = true;
    String appBarTitle = 'FitTrack';

    final path = settings.name ?? '/';
    final route = RouteName.values.firstWhere((it) => path == it.path);
    switch (route) {
      case RouteName.addWorkout:
        AddWorkoutRouteArgs args = (settings.arguments ??
            AddWorkoutRouteArgs(null, null)) as AddWorkoutRouteArgs;
        builder = (BuildContext context) => AddWorkoutScreen(
            initialExerciseId: args.initialExerciseId,
            initialDate: args.initialDate);
        showFab = false;
        showNav = false;
        appBarTitle = 'Add Workout';
        break;
      case RouteName.exercises:
        TargetArea? area = settings.arguments != null
            ? settings.arguments as TargetArea
            : null;
        builder = (BuildContext context) => ExerciseListScreen(
              initialTargetArea: area,
            );
        index = 1;
        showAppBar = false;
        break;
      case RouteName.addExercise:
        var arg = settings.arguments as String?;
        builder = (BuildContext context) => AddExerciseForm(
              initialExerciseName: arg,
            );
        showFab = false;
        showNav = false;
        break;
      case RouteName.trends:
        builder = (BuildContext context) => const Trends();
        index = 3;
        appBarTitle = 'Trends';
        break;
      case RouteName.dbView:
        builder = (BuildContext context) =>
            DriftDbViewer(context.read<AppDatabase>());
        showFab = false;
        showNav = false;
        showAppBar = false;
        break;
      case RouteName.history:
        builder = (BuildContext context) => const CalendarPage();
        index = 0;
        appBarTitle = 'Past Workouts';
        break;
      case RouteName.import:
        appBarTitle = 'Import Data';
        builder = (BuildContext context) => const ImportPage();
        break;
      case RouteName.today:
        appBarTitle = 'Today\'s Workout';
        builder = (BuildContext context) => TodayPage();
        break;
    }

    return ShortAnimationPageRoute(
        builder: (context) => MainScreen(
            currentIndex: index,
            showFab: showFab,
            showNav: showNav,
            showAppBar: showAppBar,
            appBarTitle: appBarTitle,
            child: builder(context)),
       settings: settings);
  }
}
