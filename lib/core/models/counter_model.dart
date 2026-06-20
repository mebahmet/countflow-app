import 'package:hive/hive.dart';

part 'counter_model.g.dart';

@HiveType(typeId: 0)
class CounterModel extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  String nameTr;

  @HiveField(3)
  int value;

  @HiveField(4)
  int? goal;

  @HiveField(5)
  int step;

  @HiveField(6)
  int resetValue;

  @HiveField(7)
  CounterCategory category;

  @HiveField(8)
  String emoji;

  @HiveField(9)
  DateTime createdAt;

  @HiveField(10)
  DateTime? lastModified;

  @HiveField(11)
  bool isSilent;

  @HiveField(12)
  bool hasVibration;

  @HiveField(13)
  int sortOrder;

  @HiveField(14)
  bool autoResetEnabled;

  @HiveField(15)
  String? autoResetCron; // e.g. "00:00" daily, "MON 00:00" weekly

  @HiveField(16)
  String? dhikrText; // Arabic text for dhikr mode

  CounterModel({
    required this.id,
    required this.name,
    required this.nameTr,
    this.value = 0,
    this.goal,
    this.step = 1,
    this.resetValue = 0,
    this.category = CounterCategory.general,
    this.emoji = '🔢',
    required this.createdAt,
    this.lastModified,
    this.isSilent = false,
    this.hasVibration = true,
    this.sortOrder = 0,
    this.autoResetEnabled = false,
    this.autoResetCron,
    this.dhikrText,
  });

  double get progress => goal != null && goal! > 0 ? (value / goal!).clamp(0.0, 1.0) : 0;
  bool get isCompleted => goal != null && value >= goal!;
  bool get isDhikr => category == CounterCategory.dhikr;

  CounterModel copyWith({
    String? name,
    String? nameTr,
    int? value,
    int? goal,
    int? step,
    int? resetValue,
    CounterCategory? category,
    String? emoji,
    bool? isSilent,
    bool? hasVibration,
    bool? autoResetEnabled,
    String? autoResetCron,
    String? dhikrText,
  }) {
    return CounterModel(
      id: id,
      name: name ?? this.name,
      nameTr: nameTr ?? this.nameTr,
      value: value ?? this.value,
      goal: goal ?? this.goal,
      step: step ?? this.step,
      resetValue: resetValue ?? this.resetValue,
      category: category ?? this.category,
      emoji: emoji ?? this.emoji,
      createdAt: createdAt,
      lastModified: DateTime.now(),
      isSilent: isSilent ?? this.isSilent,
      hasVibration: hasVibration ?? this.hasVibration,
      sortOrder: sortOrder,
      autoResetEnabled: autoResetEnabled ?? this.autoResetEnabled,
      autoResetCron: autoResetCron ?? this.autoResetCron,
      dhikrText: dhikrText ?? this.dhikrText,
    );
  }
}

@HiveType(typeId: 2)
enum CounterCategory {
  @HiveField(0) general,
  @HiveField(1) dhikr,
  @HiveField(2) health,
  @HiveField(3) sport,
  @HiveField(4) work,
  @HiveField(5) habit,
  @HiveField(6) score,
}
