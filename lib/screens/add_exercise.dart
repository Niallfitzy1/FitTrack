import 'package:fittrack/data/app_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/enums.dart';

class AddExerciseForm extends StatefulWidget {
  const AddExerciseForm({super.key, this.initialExerciseName});
  final String? initialExerciseName;

  @override
  AddExerciseFormState createState() {
    return AddExerciseFormState();
  }
}

class AddExerciseFormState extends State<AddExerciseForm> {
  final _formKey = GlobalKey<FormState>();

  late String exercise;
  TargetArea area = TargetArea.chest;
  String? conflict;

  @override
  void initState() {
    super.initState();
    exercise = widget.initialExerciseName ?? '';
  }

  @override
  Widget build(BuildContext context) {
    final db = Provider.of<AppDatabase>(context);

    navigateBack(int id) => Navigator.of(context).maybePop(id);

    return Container(
        margin: const EdgeInsets.all(25),
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.disabled,
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Text(
                'Add an Exercise',
                style: Theme.of(context).primaryTextTheme.headlineMedium,
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  TextFormField(
                    decoration: const InputDecoration(
                        border: UnderlineInputBorder(),
                        hintText: 'Exercise name',
                        labelText: 'Exercise Name'),
                    onChanged: (String? value) {
                      if (value != null) {
                        setState(() {
                          exercise = value;
                          conflict = null;
                        });
                        _formKey.currentState?.validate();
                      }
                    },
                    keyboardType: TextInputType.text,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter exercise name';
                      }
                      return conflict;
                    },
                    initialValue: exercise,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  DropdownButtonFormField<TargetArea>(
                      decoration: const InputDecoration(
                          border: UnderlineInputBorder(),
                          hintText: 'Target area',
                          labelText: 'Target Area'),
                      onChanged: (TargetArea? value) {
                        if (value != null) {
                          setState(() {
                            area = value;
                          });
                        }
                      },
                      validator: (value) {
                        if (value == null) {
                          return 'Please enter a target area';
                        }
                        return null;
                      },
                      items: TargetArea.values
                          .map((e) => DropdownMenuItem(
                              value: e,
                              child: Text(
                                e.name[0].toUpperCase() +
                                    e.name.substring(1).toLowerCase(),
                              )))
                          .toList()),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState != null &&
                            _formKey.currentState!.validate()) {
                          _formKey.currentState?.save();

                          try {
                            final res = await db.exercisesDao
                                .addExercise(exercise, area);
                            _formKey.currentState?.reset();
                            navigateBack(res.id);
                          } catch (e) {
                            setState(() {
                              conflict =
                                  'An exercise with this name already exists';
                            });
                            _formKey.currentState?.validate();
                            return;
                          }
                        }
                      },
                      child: const Text('Submit'),
                    ),
                  ),
                ],
              ),
            ])));
  }
}
