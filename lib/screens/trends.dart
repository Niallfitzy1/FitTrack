import 'package:drift/drift.dart' as drift;
import 'package:fittrack/models/hydrated_entries.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../core/enums.dart';
import '../data/app_database.dart';

class Trends extends StatefulWidget {
  const Trends({super.key});

  @override
  State<Trends> createState() => _TrendsState();
}

class _TrendsState extends State<Trends> {
  @override
  Widget build(BuildContext context) {
    final db = context.read<AppDatabase>();
    return ListView(
      children: [
        StreamBuilder(
            stream: db.diaryEntriesDao
                .allDiaryEntries(order: drift.OrderingTerm.asc),
            builder: (context, snapshot) => AspectRatio(
                aspectRatio: 2,
                child: SfCartesianChart(
                    margin: const EdgeInsets.only(left: 25, right: 25, top: 25),
                    primaryXAxis: DateTimeAxis(
                        intervalType: DateTimeIntervalType.months,
                        labelPosition: ChartDataLabelPosition.outside,
                        labelAlignment: LabelAlignment.end),
                    legend: Legend(
                        isVisible: true, position: LegendPosition.bottom),
                    series: <AreaSeries<MapEntry<DateTime, int>, DateTime>>[
                      AreaSeries<MapEntry<DateTime, int>, DateTime>(
                          dataSource: (snapshot.data ?? [])
                              .fold(<DateTime, int>{}, (value, element) {
                                value[DateTime(element.createdAt.year,
                                    element.createdAt.month)] = (value[DateTime(
                                            element.createdAt.year,
                                            element.createdAt.month)] ??
                                        0) +
                                    1;
                                return value;
                              })
                              .entries
                              .toList(),
                          color:
                              Theme.of(context).colorScheme.tertiaryContainer,
                          xValueMapper: (it, _) => it.key,
                          yValueMapper: (it, _) => it.value,
                          xAxisName: 'Week',
                          name: 'Monthly Visits',
                          trendlines: [
                            Trendline(
                                type: TrendlineType.movingAverage,
                                color: Theme.of(context)
                                    .colorScheme
                                    .onTertiaryContainer,
                                width: 2,
                                backwardForecast: 1,
                                forwardForecast: 1,
                                name: 'Average visits')
                          ]),
                    ]))),
        StreamBuilder(
            stream: db.workoutsDao.countWorkoutTargets(),
            builder: (context, snapshot) {
              return AspectRatio(
                  aspectRatio: 2,
                  child: SfCircularChart(
                      margin: const EdgeInsets.symmetric(horizontal: 25),
                      legend: Legend(),
                      series: <DoughnutSeries<TargetAreaCounts, TargetArea>>[
                        DoughnutSeries(
                            dataLabelMapper: (TargetAreaCounts data, _) =>
                                data.target.toDisplay(),
                            dataLabelSettings: const DataLabelSettings(
                                isVisible: true,
                                labelPosition: ChartDataLabelPosition.outside),
                            pointColorMapper: (TargetAreaCounts data, _) =>
                                data.target.color,
                            radius: '60%',
                            dataSource: (snapshot.data ?? []),
                            xValueMapper: (it, _) => it.target,
                            yValueMapper: (it, index) => it.count)
                      ]));
            }),
        StreamBuilder(
            stream: db.workoutsDao.countWorkoutExercises(),
            builder: (context, snapshot) {
              return AspectRatio(
                  aspectRatio: 2,
                  child: SfCircularChart(
                      margin: const EdgeInsets.symmetric(horizontal: 25),
                      legend:
                          Legend(overflowMode: LegendItemOverflowMode.scroll),
                      series: <DoughnutSeries<ExerciseCounts, String>>[
                        DoughnutSeries(
                            dataLabelMapper: (ExerciseCounts data, _) =>
                                data.exercise,
                            dataLabelSettings: const DataLabelSettings(
                                isVisible: true,
                                labelPosition: ChartDataLabelPosition.outside,
                                labelIntersectAction:
                                    LabelIntersectAction.shift),
                            dataSource: (snapshot.data ?? []),
                            radius: '60%',
                            xValueMapper: (it, _) => it.exercise,
                            yValueMapper: (it, index) => it.count)
                      ]));
            })
      ],
    );
  }
}
