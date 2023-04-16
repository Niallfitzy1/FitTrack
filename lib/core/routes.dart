enum RouteName {
  today,
  import,
  history,
  exercises,
  addExercise,
  addWorkout,
  trends,
  dbView
}

extension PathExtension on RouteName {
  String get path {
    switch (this) {
      case RouteName.today:
        return '/';
      case RouteName.import:
        return '/import';
      case RouteName.history:
        return '/history';
      case RouteName.exercises:
        return '/exercises';
      case RouteName.addExercise:
        return '/exercises/add';
      case RouteName.addWorkout:
        return '/exercises/workouts/add';
      case RouteName.trends:
        return '/trends';
      case RouteName.dbView:
        return '/db-view';
    }
  }
}
