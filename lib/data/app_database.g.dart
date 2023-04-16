// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $ExercisesTable extends Exercises
    with TableInfo<$ExercisesTable, Exercise> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ExercisesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  static const VerificationMeta _targetAreaMeta =
      const VerificationMeta('targetArea');
  @override
  late final GeneratedColumnWithTypeConverter<TargetArea, String> targetArea =
      GeneratedColumn<String>('target_area', aliasedName, false,
              type: DriftSqlType.string, requiredDuringInsert: true)
          .withConverter<TargetArea>($ExercisesTable.$convertertargetArea);
  @override
  List<GeneratedColumn> get $columns => [id, name, targetArea];
  @override
  String get aliasedName => _alias ?? 'exercises';
  @override
  String get actualTableName => 'exercises';
  @override
  VerificationContext validateIntegrity(Insertable<Exercise> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    context.handle(_targetAreaMeta, const VerificationResult.success());
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Exercise map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Exercise(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      targetArea: $ExercisesTable.$convertertargetArea.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}target_area'])!),
    );
  }

  @override
  $ExercisesTable createAlias(String alias) {
    return $ExercisesTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<TargetArea, String, String> $convertertargetArea =
      const EnumNameConverter<TargetArea>(TargetArea.values);
}

class Exercise extends DataClass implements Insertable<Exercise> {
  final int id;
  final String name;
  final TargetArea targetArea;
  const Exercise(
      {required this.id, required this.name, required this.targetArea});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    {
      final converter = $ExercisesTable.$convertertargetArea;
      map['target_area'] = Variable<String>(converter.toSql(targetArea));
    }
    return map;
  }

  ExercisesCompanion toCompanion(bool nullToAbsent) {
    return ExercisesCompanion(
      id: Value(id),
      name: Value(name),
      targetArea: Value(targetArea),
    );
  }

  factory Exercise.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Exercise(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      targetArea: $ExercisesTable.$convertertargetArea
          .fromJson(serializer.fromJson<String>(json['targetArea'])),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'targetArea': serializer.toJson<String>(
          $ExercisesTable.$convertertargetArea.toJson(targetArea)),
    };
  }

  Exercise copyWith({int? id, String? name, TargetArea? targetArea}) =>
      Exercise(
        id: id ?? this.id,
        name: name ?? this.name,
        targetArea: targetArea ?? this.targetArea,
      );
  @override
  String toString() {
    return (StringBuffer('Exercise(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('targetArea: $targetArea')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, targetArea);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Exercise &&
          other.id == this.id &&
          other.name == this.name &&
          other.targetArea == this.targetArea);
}

class ExercisesCompanion extends UpdateCompanion<Exercise> {
  final Value<int> id;
  final Value<String> name;
  final Value<TargetArea> targetArea;
  const ExercisesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.targetArea = const Value.absent(),
  });
  ExercisesCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required TargetArea targetArea,
  })  : name = Value(name),
        targetArea = Value(targetArea);
  static Insertable<Exercise> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? targetArea,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (targetArea != null) 'target_area': targetArea,
    });
  }

  ExercisesCompanion copyWith(
      {Value<int>? id, Value<String>? name, Value<TargetArea>? targetArea}) {
    return ExercisesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      targetArea: targetArea ?? this.targetArea,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (targetArea.present) {
      final converter = $ExercisesTable.$convertertargetArea;
      map['target_area'] = Variable<String>(converter.toSql(targetArea.value));
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ExercisesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('targetArea: $targetArea')
          ..write(')'))
        .toString();
  }
}

class $DiaryEntriesTable extends DiaryEntries
    with TableInfo<$DiaryEntriesTable, DiaryEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DiaryEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  @override
  List<GeneratedColumn> get $columns => [id, createdAt];
  @override
  String get aliasedName => _alias ?? 'diary_entries';
  @override
  String get actualTableName => 'diary_entries';
  @override
  VerificationContext validateIntegrity(Insertable<DiaryEntry> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DiaryEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DiaryEntry(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $DiaryEntriesTable createAlias(String alias) {
    return $DiaryEntriesTable(attachedDatabase, alias);
  }
}

class DiaryEntry extends DataClass implements Insertable<DiaryEntry> {
  final int id;
  final DateTime createdAt;
  const DiaryEntry({required this.id, required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  DiaryEntriesCompanion toCompanion(bool nullToAbsent) {
    return DiaryEntriesCompanion(
      id: Value(id),
      createdAt: Value(createdAt),
    );
  }

  factory DiaryEntry.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DiaryEntry(
      id: serializer.fromJson<int>(json['id']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  DiaryEntry copyWith({int? id, DateTime? createdAt}) => DiaryEntry(
        id: id ?? this.id,
        createdAt: createdAt ?? this.createdAt,
      );
  @override
  String toString() {
    return (StringBuffer('DiaryEntry(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DiaryEntry &&
          other.id == this.id &&
          other.createdAt == this.createdAt);
}

class DiaryEntriesCompanion extends UpdateCompanion<DiaryEntry> {
  final Value<int> id;
  final Value<DateTime> createdAt;
  const DiaryEntriesCompanion({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  DiaryEntriesCompanion.insert({
    this.id = const Value.absent(),
    required DateTime createdAt,
  }) : createdAt = Value(createdAt);
  static Insertable<DiaryEntry> custom({
    Expression<int>? id,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  DiaryEntriesCompanion copyWith({Value<int>? id, Value<DateTime>? createdAt}) {
    return DiaryEntriesCompanion(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DiaryEntriesCompanion(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $WorkoutsTable extends Workouts with TableInfo<$WorkoutsTable, Workout> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WorkoutsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _exerciseIdMeta =
      const VerificationMeta('exerciseId');
  @override
  late final GeneratedColumn<int> exerciseId = GeneratedColumn<int>(
      'exercise_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES exercises (id) ON DELETE CASCADE'));
  static const VerificationMeta _diaryEntryIdMeta =
      const VerificationMeta('diaryEntryId');
  @override
  late final GeneratedColumn<int> diaryEntryId = GeneratedColumn<int>(
      'diary_entry_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES diary_entries (id) ON DELETE CASCADE'));
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumnWithTypeConverter<WorkoutStatus?, String> status =
      GeneratedColumn<String>('status', aliasedName, true,
              type: DriftSqlType.string, requiredDuringInsert: false)
          .withConverter<WorkoutStatus?>($WorkoutsTable.$converterstatusn);
  @override
  List<GeneratedColumn> get $columns => [id, exerciseId, diaryEntryId, status];
  @override
  String get aliasedName => _alias ?? 'workouts';
  @override
  String get actualTableName => 'workouts';
  @override
  VerificationContext validateIntegrity(Insertable<Workout> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('exercise_id')) {
      context.handle(
          _exerciseIdMeta,
          exerciseId.isAcceptableOrUnknown(
              data['exercise_id']!, _exerciseIdMeta));
    } else if (isInserting) {
      context.missing(_exerciseIdMeta);
    }
    if (data.containsKey('diary_entry_id')) {
      context.handle(
          _diaryEntryIdMeta,
          diaryEntryId.isAcceptableOrUnknown(
              data['diary_entry_id']!, _diaryEntryIdMeta));
    } else if (isInserting) {
      context.missing(_diaryEntryIdMeta);
    }
    context.handle(_statusMeta, const VerificationResult.success());
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
        {exerciseId, diaryEntryId},
      ];
  @override
  Workout map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Workout(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      exerciseId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}exercise_id'])!,
      diaryEntryId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}diary_entry_id'])!,
      status: $WorkoutsTable.$converterstatusn.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])),
    );
  }

  @override
  $WorkoutsTable createAlias(String alias) {
    return $WorkoutsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<WorkoutStatus, String, String> $converterstatus =
      const EnumNameConverter<WorkoutStatus>(WorkoutStatus.values);
  static JsonTypeConverter2<WorkoutStatus?, String?, String?>
      $converterstatusn = JsonTypeConverter2.asNullable($converterstatus);
}

class Workout extends DataClass implements Insertable<Workout> {
  final int id;
  final int exerciseId;
  final int diaryEntryId;
  final WorkoutStatus? status;
  const Workout(
      {required this.id,
      required this.exerciseId,
      required this.diaryEntryId,
      this.status});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['exercise_id'] = Variable<int>(exerciseId);
    map['diary_entry_id'] = Variable<int>(diaryEntryId);
    if (!nullToAbsent || status != null) {
      final converter = $WorkoutsTable.$converterstatusn;
      map['status'] = Variable<String>(converter.toSql(status));
    }
    return map;
  }

  WorkoutsCompanion toCompanion(bool nullToAbsent) {
    return WorkoutsCompanion(
      id: Value(id),
      exerciseId: Value(exerciseId),
      diaryEntryId: Value(diaryEntryId),
      status:
          status == null && nullToAbsent ? const Value.absent() : Value(status),
    );
  }

  factory Workout.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Workout(
      id: serializer.fromJson<int>(json['id']),
      exerciseId: serializer.fromJson<int>(json['exerciseId']),
      diaryEntryId: serializer.fromJson<int>(json['diaryEntryId']),
      status: $WorkoutsTable.$converterstatusn
          .fromJson(serializer.fromJson<String?>(json['status'])),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'exerciseId': serializer.toJson<int>(exerciseId),
      'diaryEntryId': serializer.toJson<int>(diaryEntryId),
      'status': serializer
          .toJson<String?>($WorkoutsTable.$converterstatusn.toJson(status)),
    };
  }

  Workout copyWith(
          {int? id,
          int? exerciseId,
          int? diaryEntryId,
          Value<WorkoutStatus?> status = const Value.absent()}) =>
      Workout(
        id: id ?? this.id,
        exerciseId: exerciseId ?? this.exerciseId,
        diaryEntryId: diaryEntryId ?? this.diaryEntryId,
        status: status.present ? status.value : this.status,
      );
  @override
  String toString() {
    return (StringBuffer('Workout(')
          ..write('id: $id, ')
          ..write('exerciseId: $exerciseId, ')
          ..write('diaryEntryId: $diaryEntryId, ')
          ..write('status: $status')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, exerciseId, diaryEntryId, status);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Workout &&
          other.id == this.id &&
          other.exerciseId == this.exerciseId &&
          other.diaryEntryId == this.diaryEntryId &&
          other.status == this.status);
}

class WorkoutsCompanion extends UpdateCompanion<Workout> {
  final Value<int> id;
  final Value<int> exerciseId;
  final Value<int> diaryEntryId;
  final Value<WorkoutStatus?> status;
  const WorkoutsCompanion({
    this.id = const Value.absent(),
    this.exerciseId = const Value.absent(),
    this.diaryEntryId = const Value.absent(),
    this.status = const Value.absent(),
  });
  WorkoutsCompanion.insert({
    this.id = const Value.absent(),
    required int exerciseId,
    required int diaryEntryId,
    this.status = const Value.absent(),
  })  : exerciseId = Value(exerciseId),
        diaryEntryId = Value(diaryEntryId);
  static Insertable<Workout> custom({
    Expression<int>? id,
    Expression<int>? exerciseId,
    Expression<int>? diaryEntryId,
    Expression<String>? status,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (exerciseId != null) 'exercise_id': exerciseId,
      if (diaryEntryId != null) 'diary_entry_id': diaryEntryId,
      if (status != null) 'status': status,
    });
  }

  WorkoutsCompanion copyWith(
      {Value<int>? id,
      Value<int>? exerciseId,
      Value<int>? diaryEntryId,
      Value<WorkoutStatus?>? status}) {
    return WorkoutsCompanion(
      id: id ?? this.id,
      exerciseId: exerciseId ?? this.exerciseId,
      diaryEntryId: diaryEntryId ?? this.diaryEntryId,
      status: status ?? this.status,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (exerciseId.present) {
      map['exercise_id'] = Variable<int>(exerciseId.value);
    }
    if (diaryEntryId.present) {
      map['diary_entry_id'] = Variable<int>(diaryEntryId.value);
    }
    if (status.present) {
      final converter = $WorkoutsTable.$converterstatusn;
      map['status'] = Variable<String>(converter.toSql(status.value));
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WorkoutsCompanion(')
          ..write('id: $id, ')
          ..write('exerciseId: $exerciseId, ')
          ..write('diaryEntryId: $diaryEntryId, ')
          ..write('status: $status')
          ..write(')'))
        .toString();
  }
}

class $RepSetsTable extends RepSets with TableInfo<$RepSetsTable, RepSet> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RepSetsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _workoutIdMeta =
      const VerificationMeta('workoutId');
  @override
  late final GeneratedColumn<int> workoutId = GeneratedColumn<int>(
      'workout_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES workouts (id) ON DELETE CASCADE'));
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumnWithTypeConverter<SetStatus, String> status =
      GeneratedColumn<String>('status', aliasedName, false,
              type: DriftSqlType.string, requiredDuringInsert: true)
          .withConverter<SetStatus>($RepSetsTable.$converterstatus);
  static const VerificationMeta _weightMeta = const VerificationMeta('weight');
  @override
  late final GeneratedColumn<double> weight = GeneratedColumn<double>(
      'weight', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _repsMeta = const VerificationMeta('reps');
  @override
  late final GeneratedColumn<int> reps = GeneratedColumn<int>(
      'reps', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [id, createdAt, workoutId, status, weight, reps];
  @override
  String get aliasedName => _alias ?? 'rep_sets';
  @override
  String get actualTableName => 'rep_sets';
  @override
  VerificationContext validateIntegrity(Insertable<RepSet> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('workout_id')) {
      context.handle(_workoutIdMeta,
          workoutId.isAcceptableOrUnknown(data['workout_id']!, _workoutIdMeta));
    } else if (isInserting) {
      context.missing(_workoutIdMeta);
    }
    context.handle(_statusMeta, const VerificationResult.success());
    if (data.containsKey('weight')) {
      context.handle(_weightMeta,
          weight.isAcceptableOrUnknown(data['weight']!, _weightMeta));
    }
    if (data.containsKey('reps')) {
      context.handle(
          _repsMeta, reps.isAcceptableOrUnknown(data['reps']!, _repsMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  RepSet map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RepSet(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      workoutId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}workout_id'])!,
      status: $RepSetsTable.$converterstatus.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!),
      weight: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}weight']),
      reps: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}reps']),
    );
  }

  @override
  $RepSetsTable createAlias(String alias) {
    return $RepSetsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<SetStatus, String, String> $converterstatus =
      const EnumNameConverter<SetStatus>(SetStatus.values);
}

class RepSet extends DataClass implements Insertable<RepSet> {
  final int id;
  final DateTime createdAt;
  final int workoutId;
  final SetStatus status;
  final double? weight;
  final int? reps;
  const RepSet(
      {required this.id,
      required this.createdAt,
      required this.workoutId,
      required this.status,
      this.weight,
      this.reps});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['workout_id'] = Variable<int>(workoutId);
    {
      final converter = $RepSetsTable.$converterstatus;
      map['status'] = Variable<String>(converter.toSql(status));
    }
    if (!nullToAbsent || weight != null) {
      map['weight'] = Variable<double>(weight);
    }
    if (!nullToAbsent || reps != null) {
      map['reps'] = Variable<int>(reps);
    }
    return map;
  }

  RepSetsCompanion toCompanion(bool nullToAbsent) {
    return RepSetsCompanion(
      id: Value(id),
      createdAt: Value(createdAt),
      workoutId: Value(workoutId),
      status: Value(status),
      weight:
          weight == null && nullToAbsent ? const Value.absent() : Value(weight),
      reps: reps == null && nullToAbsent ? const Value.absent() : Value(reps),
    );
  }

  factory RepSet.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RepSet(
      id: serializer.fromJson<int>(json['id']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      workoutId: serializer.fromJson<int>(json['workoutId']),
      status: $RepSetsTable.$converterstatus
          .fromJson(serializer.fromJson<String>(json['status'])),
      weight: serializer.fromJson<double?>(json['weight']),
      reps: serializer.fromJson<int?>(json['reps']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'workoutId': serializer.toJson<int>(workoutId),
      'status': serializer
          .toJson<String>($RepSetsTable.$converterstatus.toJson(status)),
      'weight': serializer.toJson<double?>(weight),
      'reps': serializer.toJson<int?>(reps),
    };
  }

  RepSet copyWith(
          {int? id,
          DateTime? createdAt,
          int? workoutId,
          SetStatus? status,
          Value<double?> weight = const Value.absent(),
          Value<int?> reps = const Value.absent()}) =>
      RepSet(
        id: id ?? this.id,
        createdAt: createdAt ?? this.createdAt,
        workoutId: workoutId ?? this.workoutId,
        status: status ?? this.status,
        weight: weight.present ? weight.value : this.weight,
        reps: reps.present ? reps.value : this.reps,
      );
  @override
  String toString() {
    return (StringBuffer('RepSet(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('workoutId: $workoutId, ')
          ..write('status: $status, ')
          ..write('weight: $weight, ')
          ..write('reps: $reps')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, createdAt, workoutId, status, weight, reps);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RepSet &&
          other.id == this.id &&
          other.createdAt == this.createdAt &&
          other.workoutId == this.workoutId &&
          other.status == this.status &&
          other.weight == this.weight &&
          other.reps == this.reps);
}

class RepSetsCompanion extends UpdateCompanion<RepSet> {
  final Value<int> id;
  final Value<DateTime> createdAt;
  final Value<int> workoutId;
  final Value<SetStatus> status;
  final Value<double?> weight;
  final Value<int?> reps;
  const RepSetsCompanion({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.workoutId = const Value.absent(),
    this.status = const Value.absent(),
    this.weight = const Value.absent(),
    this.reps = const Value.absent(),
  });
  RepSetsCompanion.insert({
    this.id = const Value.absent(),
    required DateTime createdAt,
    required int workoutId,
    required SetStatus status,
    this.weight = const Value.absent(),
    this.reps = const Value.absent(),
  })  : createdAt = Value(createdAt),
        workoutId = Value(workoutId),
        status = Value(status);
  static Insertable<RepSet> custom({
    Expression<int>? id,
    Expression<DateTime>? createdAt,
    Expression<int>? workoutId,
    Expression<String>? status,
    Expression<double>? weight,
    Expression<int>? reps,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt,
      if (workoutId != null) 'workout_id': workoutId,
      if (status != null) 'status': status,
      if (weight != null) 'weight': weight,
      if (reps != null) 'reps': reps,
    });
  }

  RepSetsCompanion copyWith(
      {Value<int>? id,
      Value<DateTime>? createdAt,
      Value<int>? workoutId,
      Value<SetStatus>? status,
      Value<double?>? weight,
      Value<int?>? reps}) {
    return RepSetsCompanion(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      workoutId: workoutId ?? this.workoutId,
      status: status ?? this.status,
      weight: weight ?? this.weight,
      reps: reps ?? this.reps,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (workoutId.present) {
      map['workout_id'] = Variable<int>(workoutId.value);
    }
    if (status.present) {
      final converter = $RepSetsTable.$converterstatus;
      map['status'] = Variable<String>(converter.toSql(status.value));
    }
    if (weight.present) {
      map['weight'] = Variable<double>(weight.value);
    }
    if (reps.present) {
      map['reps'] = Variable<int>(reps.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RepSetsCompanion(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('workoutId: $workoutId, ')
          ..write('status: $status, ')
          ..write('weight: $weight, ')
          ..write('reps: $reps')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  late final $ExercisesTable exercises = $ExercisesTable(this);
  late final $DiaryEntriesTable diaryEntries = $DiaryEntriesTable(this);
  late final $WorkoutsTable workouts = $WorkoutsTable(this);
  late final $RepSetsTable repSets = $RepSetsTable(this);
  late final DiaryEntriesDao diaryEntriesDao =
      DiaryEntriesDao(this as AppDatabase);
  late final ExercisesDao exercisesDao = ExercisesDao(this as AppDatabase);
  late final SetsDao setsDao = SetsDao(this as AppDatabase);
  late final WorkoutsDao workoutsDao = WorkoutsDao(this as AppDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [exercises, diaryEntries, workouts, repSets];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules(
        [
          WritePropagation(
            on: TableUpdateQuery.onTableName('exercises',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('workouts', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('diary_entries',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('workouts', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('workouts',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('rep_sets', kind: UpdateKind.delete),
            ],
          ),
        ],
      );
}
