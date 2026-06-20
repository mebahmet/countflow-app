import 'package:hive/hive.dart';

part 'tally_entry_model.g.dart';

@HiveType(typeId: 1)
class TallyEntryModel extends HiveObject {
  @HiveField(0)
  String counterId;

  @HiveField(1)
  int delta; // +1, -1, or step value

  @HiveField(2)
  DateTime timestamp;

  @HiveField(3)
  String? note;

  @HiveField(4)
  int valueAfter;

  TallyEntryModel({
    required this.counterId,
    required this.delta,
    required this.timestamp,
    this.note,
    required this.valueAfter,
  });
}
