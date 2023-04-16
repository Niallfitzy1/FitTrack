import 'package:flutter/material.dart';

import '../core/routes.dart';

class BottomNavEntry {
  BottomNavEntry(this.icon, this.name, this.index, this.route);

  final IconData icon;
  final String name;
  final int index;
  final RouteName route;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['icon'] = icon.toString();
    data['index'] = index;
    data['path'] = route;
    return data;
  }
}

final List<BottomNavEntry> navEntries = [
  BottomNavEntry(Icons.calendar_month, 'History', 0, RouteName.history),
  BottomNavEntry(Icons.fitness_center, 'Exercises', 1, RouteName.exercises),
  BottomNavEntry(Icons.calendar_today, 'Today', 2, RouteName.today),
  BottomNavEntry(Icons.analytics, 'Trends', 3, RouteName.trends)
];

class BuildAppNavigation extends StatelessWidget {
  const BuildAppNavigation({super.key, required this.currentIndex});

  final int currentIndex;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final nav = Navigator.of(context);

    return BottomAppBar(
      clipBehavior: Clip.antiAlias,
      notchMargin: 5,
      shape: const CircularNotchedRectangle(),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: navEntries
            .map((it) => GestureDetector(
                onTap: () =>
                    nav.pushNamedAndRemoveUntil(it.route.path, (_) => false),
                child: Column(
                  children: [
                    Icon(it.icon,
                        color: currentIndex == it.index
                            ? theme.colorScheme.onSurface
                            : theme.disabledColor),
                    Text(it.name),
                  ],
                )))
            .toList(),
      ),
    );
  }
}
