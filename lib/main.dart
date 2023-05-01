import 'package:fittrack/data/app_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import 'app_router.dart';
import 'color_scheme.dart';
import 'components/bottom_nav.dart';
import 'core/routes.dart';

void main() {
  runApp(Provider<AppDatabase>(
    create: (context) => AppDatabase(),
    child: const FitTrackApp(),
    dispose: (context, db) => db.close(),
  ));
}

class FitTrackApp extends StatelessWidget {
  const FitTrackApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FitTrack',
      theme: ThemeData(useMaterial3: true, colorScheme: lightColorScheme),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: darkColorScheme,
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: RouteName.today.path,
      onGenerateRoute: AppRouter.generateRoute,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale.fromSubtags(languageCode: 'en', countryCode: 'US'),
        Locale.fromSubtags(languageCode: 'en', countryCode: 'IE'),
        Locale.fromSubtags(languageCode: 'en', countryCode: 'UK'),
      ],
    );
  }
}

class MainScreen extends StatelessWidget {
  const MainScreen({
    super.key,
    required this.currentIndex,
    this.showFab = true,
    this.showNav = true,
    this.showAppBar = true,
    this.appBarTitle = 'FitTrack',
    required this.child,
  });

  final bool showFab;
  final bool showNav;
  final bool showAppBar;
  final int currentIndex;
  final String appBarTitle;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: showAppBar
          ? AppBar(
              scrolledUnderElevation: 3,
              title: Text(appBarTitle),
              actions: kDebugMode
                  ? [
                      IconButton(
                        icon: const Icon(Icons.dataset),
                        tooltip: 'Show Db Viewer',
                        onPressed: () {
                          Navigator.of(context)
                              .pushNamed(RouteName.dbView.path);
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.import_export),
                        tooltip: 'Import data',
                        onPressed: () {
                          Navigator.of(context)
                              .pushNamed(RouteName.import.path);
                        },
                      ),
                    ]
                  : [
                      IconButton(
                        icon: const Icon(Icons.import_export),
                        tooltip: 'Import data',
                        onPressed: () {
                          Navigator.of(context)
                              .pushNamed(RouteName.import.path);
                        },
                      )
                    ])
          : null,
      body: child,
      bottomNavigationBar: showNav
          ? BuildAppNavigation(
              currentIndex: currentIndex,
            )
          : null,
      floatingActionButton: showFab
          ? FloatingActionButton(
              onPressed: () {
                Navigator.of(context).pushNamed(RouteName.addWorkout.path);
              },
              elevation: 2.0,
              tooltip: 'Start a workout',
              shape: const CircleBorder(),
              child: const Icon(Icons.add),
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
