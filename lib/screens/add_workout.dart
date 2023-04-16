import 'package:collection/collection.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:fittrack/core/dates.dart';
import 'package:fittrack/core/weight.dart';
import 'package:fittrack/data/app_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinbox/flutter_spinbox.dart';
import 'package:provider/provider.dart';

import '../core/enums.dart';
import 'add_exercise.dart';

class AddWorkoutScreen extends StatefulWidget {
  const AddWorkoutScreen({super.key, this.initialExerciseId, this.initialDate});

  final int? initialExerciseId;
  final DateTime? initialDate;

  @override
  AddWorkoutScreenState createState() {
    return AddWorkoutScreenState();
  }
}

class AddWorkoutScreenState extends State<AddWorkoutScreen> {
  final _exerciseDropdownKey = GlobalKey<DropdownSearchState<Exercise>>();

  final _formKey = GlobalKey<FormState>();
  late DateTime selectedWorkoutDay = DateTime.now();
  int? exerciseId;
  int? workoutId;
  double weight = 10;
  int reps = 10;
  SetStatus setStatus = SetStatus.complete;

  @override
  void initState() {
    super.initState();
    selectedWorkoutDay = widget.initialDate ?? getAsDate(DateTime.now());
    exerciseId = widget.initialExerciseId;
  }

  @override
  Widget build(BuildContext context) {
    final db = Provider.of<AppDatabase>(context);
    addAnExerciseButton(String? text) => ElevatedButton(
        onPressed: () async {
          _exerciseDropdownKey.currentState?.closeDropDownSearch();
          final info = await showModalBottomSheet(
            useSafeArea: true,
            isScrollControlled: true,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
            context: context,
            builder: (context) => AddExerciseForm(
              initialExerciseName: text,
            ),
          );
          setState(() {
            exerciseId = info;
          });
          _formKey.currentState?.validate();
        },
        child: const Text('Add new Exercise'));

    return Container(
        margin: const EdgeInsets.symmetric(horizontal: 25),
        child: Column(children: [
          Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                InkWell(
                  child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Text(
                        formatAsDate(selectedWorkoutDay),
                        style: Theme.of(context).textTheme.titleLarge,
                      )),
                  onTap: () async {
                    final DateTime? newDate = await showDatePicker(
                        context: context,
                        initialDate: selectedWorkoutDay,
                        firstDate: firstDate,
                        lastDate: lastDate,
                        initialDatePickerMode: DatePickerMode.day);
                    if (newDate != null && newDate != selectedWorkoutDay) {
                      setState(() {
                        selectedWorkoutDay = newDate;
                      });
                    }
                  },
                ),
                StreamBuilder<List<Exercise>>(
                  stream: db.exercisesDao.allExercises(),
                  builder: (BuildContext context,
                      AsyncSnapshot<List<Exercise>> snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else {
                      return DropdownSearch<Exercise>(
                          key: _exerciseDropdownKey,
                          onChanged: (Exercise? value) {
                            if (value != null) {
                              setState(() {
                                exerciseId = value.id;
                              });
                            }
                          },
                          dropdownDecoratorProps: const DropDownDecoratorProps(
                              dropdownSearchDecoration: InputDecoration(
                                  hintText: 'Choose an exercise',
                                  labelText: 'Exercise',
                                  border: UnderlineInputBorder())),
                          itemAsString: (Exercise exercise) => exercise.name,
                          popupProps: PopupProps.bottomSheet(
                              emptyBuilder:
                                  (BuildContext context, String text) {
                                return Center(
                                    child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text('No exercise named $text found'),
                                    addAnExerciseButton(text)
                                  ],
                                ));
                              },
                              itemBuilder: (BuildContext context,
                                  Exercise exercise, bool isSelected) {
                                return ListTile(
                                    selected: isSelected,
                                    title: Text(exercise.name),
                                    subtitle: Text(exercise.targetArea.name),
                                    leading: CircleAvatar(
                                      child: Text(exercise.name[0]),
                                    ));
                              },
                              containerBuilder: (context, body) {
                                return Padding(
                                    padding: const EdgeInsets.only(top: 10),
                                    child: Column(
                                      children: [
                                        Text(
                                          'Choose An Exercise',
                                          style: Theme.of(context)
                                              .primaryTextTheme
                                              .headlineMedium,
                                        ),
                                        Expanded(child: body),
                                        addAnExerciseButton(null)
                                      ],
                                    ));
                              },
                              showSearchBox: true,
                              searchFieldProps: const TextFieldProps(
                                  decoration: InputDecoration(
                                      border: UnderlineInputBorder(),
                                      hintText: 'Search for an exercise')),
                              bottomSheetProps: BottomSheetProps(
                                  backgroundColor:
                                      Theme.of(context).colorScheme.surface)),
                          validator: (value) {
                            if (value == null) {
                              return 'Please enter a target area';
                            }
                            return null;
                          },
                          selectedItem: (snapshot.data ?? []).firstWhereOrNull(
                              (element) => element.id == exerciseId),
                          items: snapshot.data!);
                    }
                  },
                ),
                const SizedBox(height: 10),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Flexible(
                        flex: 1,
                        child: DropdownButtonFormField<SetStatus>(
                          onChanged: (SetStatus? value) {
                            if (value != null) {
                              setState(() {
                                setStatus = value;
                              });
                            }
                          },
                          decoration:
                              const InputDecoration(labelText: 'Status'),
                          validator: (value) {
                            if (value == null) {
                              return 'Please enter a set status';
                            }
                            return null;
                          },
                          value: setStatus,
                          items: SetStatus.values
                              .map((e) => DropdownMenuItem(
                                  value: e, child: Center(child: Icon(e.icon))))
                              .toList(),
                        ),
                      ),
                      Flexible(
                          flex: 3,
                          child: SpinBox(
                            onChanged: (double? value) {
                              if (value != null) {
                                setState(() {
                                  weight = value;
                                });
                              }
                            },
                            decimals: 1,
                            min: 0,
                            max: 1000,
                            step: 0.5,
                            acceleration: 0.5,
                            decoration: const InputDecoration(
                                labelText: 'Weight',
                                border: UnderlineInputBorder()),
                            validator: (value) {
                              if (value == null ||
                                  value.isEmpty ||
                                  (double.tryParse(value) != null &&
                                      double.tryParse(value)! < 0.5)) {
                                return 'Please enter weight';
                              }
                              return null;
                            },
                            value: weight,
                          )),
                      Flexible(
                          flex: 3,
                          child: SpinBox(
                            onChanged: (double? value) {
                              if (value != null) {
                                setState(() {
                                  reps = value.toInt();
                                });
                              }
                            },
                            decimals: 0,
                            min: 0,
                            max: 100,
                            step: 1,
                            acceleration: 0.5,
                            decoration: const InputDecoration(
                                labelText: 'Reps',
                                border: UnderlineInputBorder()),
                            validator: (value) {
                              if (value == null ||
                                  value.isEmpty ||
                                  int.tryParse(value) == 0) {
                                return 'Please enter reps';
                              }
                              return null;
                            },
                            value: reps.toDouble(),
                          ))
                    ]),
                const SizedBox(height: 10),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState != null &&
                              _formKey.currentState!.validate()) {
                            _formKey.currentState!.save();

                            final selectedExerciseId = exerciseId;
                            if (selectedExerciseId == null) {
                              return;
                            }

                            await db.setsDao.addSet(selectedWorkoutDay,
                                selectedExerciseId, setStatus, weight, reps);
                            _formKey.currentState!.reset();
                            setState(() {
                              setStatus = SetStatus.complete;
                            });
                          }
                        },
                        child: const Text('Add Set'),
                      ),
                    ])
              ],
            ),
          ),
          StreamBuilder<List<RepSet>>(
            stream:
                db.setsDao.getSetsForWorkout(selectedWorkoutDay, exerciseId),
            builder:
                (BuildContext context, AsyncSnapshot<List<RepSet>?> snapshot) {
              if (!snapshot.hasData) {
                return const Padding(
                    padding: EdgeInsets.all(10),
                    child: Center(
                      child: Text('No  sets added yet'),
                    ));
              } else {
                final data = snapshot.data!;
                return Flexible(
                    child: ListView(
                  clipBehavior: Clip.hardEdge,
                  children: data
                      .map((e) => Dismissible(
                          background: Container(color: Colors.red),
                          key: ObjectKey(e),
                          onDismissed: (direction) =>
                              db.setsDao.deleteSet(e.id, e.workoutId),
                          child: ListTile(
                            shape: const RoundedRectangleBorder(),
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text(formatWeight(e.weight)),
                                Text('${e.reps.toString()} reps'),
                              ],
                            ),
                            leading: CircleAvatar(
                              backgroundColor: e.status.color,
                              child: Icon(
                                e.status.icon,
                              ),
                            ),
                          )))
                      .toList(),
                ));
              }
            },
          )
        ]));
  }
}
