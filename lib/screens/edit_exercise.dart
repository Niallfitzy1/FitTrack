import 'package:fittrack/data/app_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/enums.dart';

class EditExerciseForm extends StatefulWidget {
  const EditExerciseForm({super.key, required this.exerciseId});
  final int exerciseId;

  @override
  EditExerciseFormState createState() {
    return EditExerciseFormState();
  }
}

class EditExerciseFormState extends State<EditExerciseForm> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final db = Provider.of<AppDatabase>(context);

    String? conflict;
    String? newName;
    TargetArea? newArea;
    final nav = Navigator.of(context);

    return Container(
        margin: const EdgeInsets.all(25),
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: StreamBuilder(
            stream: db.exercisesDao.getExercise(widget.exerciseId),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              return Form(
                  key: _formKey,
                  autovalidateMode: AutovalidateMode.disabled,
                  child: Column(mainAxisSize: MainAxisSize.min, children: [
                    Text(
                      'Edit Exercise',
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
                                newName = value;
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
                          initialValue: snapshot.data?.name,
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
                                  newArea = value;
                                });
                              }
                            },
                            validator: (value) {
                              if (value == null) {
                                return 'Please enter a target area';
                              }
                              return null;
                            },
                            value: snapshot.data?.targetArea,
                            items: TargetArea.values
                                .map((e) => DropdownMenuItem(
                                    value: e,
                                    child: Text(
                                      e.name[0].toUpperCase() +
                                          e.name.substring(1).toLowerCase(),
                                    )))
                                .toList()),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ElevatedButton(
                                onPressed: () async {
                                  if (_formKey.currentState != null &&
                                      _formKey.currentState!.validate()) {
                                    _formKey.currentState?.save();

                                    try {
                                      await db.exercisesDao.updateExercise(
                                          widget.exerciseId,
                                          name: newName,
                                          area: newArea);
                                      _formKey.currentState?.reset();
                                      nav.maybePop();
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
                              ElevatedButton(
                                onPressed: () async {
                                  await db.exercisesDao
                                      .deleteExercise(widget.exerciseId);
                                  _formKey.currentState?.reset();
                                  nav.maybePop();
                                },
                                child: const Text('Delete'),
                              ),
                            ]),
                      ],
                    ),
                  ]));
            }));
  }
}
