import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';

import '../constants/app_constants.dart';
import '../models/counter_model.dart';
import '../models/tally_entry_model.dart';
import '../../shared/theme/app_theme.dart';

class CounterProvider extends ChangeNotifier {
  late Box<CounterModel> _countersBox;
  late Box<TallyEntryModel> _entriesBox;
  final _uuid = const Uuid();

  CounterModel? _undoCounter;
  int? _undoValue;
  TallyEntryModel? _undoEntry;

  List<CounterModel> get counters {
    return _countersBox.values.toList()
      ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
  }

  List<CounterModel> get dhikrCounters =>
      counters.where((c) => c.category == CounterCategory.dhikr).toList();

  CounterProvider() {
    _countersBox = Hive.box<CounterModel>(AppConstants.countersBox);
    _entriesBox = Hive.box<TallyEntryModel>(AppConstants.entriesBox);
    _countersBox.listenable().addListener(notifyListeners);
  }

  Future<CounterModel> addCounter({
    required String name,
    required String nameTr,
    int? goal,
    int step = 1,
    CounterCategory category = CounterCategory.general,
    String emoji = '🔢',
    String? dhikrText,
    bool autoResetEnabled = false,
  }) async {
    final counter = CounterModel(
      id: _uuid.v4(),
      name: name,
      nameTr: nameTr,
      goal: goal,
      step: step,
      category: category,
      emoji: emoji,
      dhikrText: dhikrText,
      createdAt: DateTime.now(),
      sortOrder: counters.length,
      autoResetEnabled: autoResetEnabled,
    );
    await _countersBox.put(counter.id, counter);
    notifyListeners();
    return counter;
  }

  Future<void> increment(String id, {String? note}) async {
    final counter = _countersBox.get(id);
    if (counter == null) return;
    if (counter.value >= AppConstants.maxCounterValue) return;

    final newValue = counter.value + counter.step;
    _saveUndo(counter, note);

    counter.value = newValue;
    counter.lastModified = DateTime.now();
    await counter.save();

    await _logEntry(id, counter.step, newValue, note);
    notifyListeners();
  }

  Future<void> decrement(String id, {String? note}) async {
    final counter = _countersBox.get(id);
    if (counter == null) return;
    if (counter.value <= AppConstants.minCounterValue) return;

    final newValue = counter.value - counter.step;
    _saveUndo(counter, note);

    counter.value = newValue;
    counter.lastModified = DateTime.now();
    await counter.save();

    await _logEntry(id, -counter.step, newValue, note);
    notifyListeners();
  }

  Future<void> reset(String id) async {
    final counter = _countersBox.get(id);
    if (counter == null) return;
    _saveUndo(counter, null);

    counter.value = counter.resetValue;
    counter.lastModified = DateTime.now();
    await counter.save();
    notifyListeners();
  }

  Future<void> undo() async {
    if (_undoCounter == null) return;
    final counter = _countersBox.get(_undoCounter!.id);
    if (counter == null) return;

    counter.value = _undoValue!;
    await counter.save();

    if (_undoEntry != null) {
      await _undoEntry!.delete();
    }
    _undoCounter = null;
    _undoValue = null;
    _undoEntry = null;
    notifyListeners();
  }

  bool get canUndo => _undoCounter != null;

  Future<void> updateCounter(CounterModel updated) async {
    final counter = _countersBox.get(updated.id);
    if (counter == null) return;

    counter.name = updated.name;
    counter.nameTr = updated.nameTr;
    counter.goal = updated.goal;
    counter.step = updated.step;
    counter.resetValue = updated.resetValue;
    counter.category = updated.category;
    counter.emoji = updated.emoji;
    counter.dhikrText = updated.dhikrText;
    counter.isSilent = updated.isSilent;
    counter.hasVibration = updated.hasVibration;
    counter.autoResetEnabled = updated.autoResetEnabled;
    counter.autoResetCron = updated.autoResetCron;
    counter.lastModified = DateTime.now();
    await counter.save();
    notifyListeners();
  }

  Future<void> deleteCounter(String id) async {
    await _countersBox.delete(id);
    // Also delete all entries for this counter
    final toDelete = _entriesBox.values
        .where((e) => e.counterId == id)
        .toList();
    for (final e in toDelete) {
      await e.delete();
    }
    notifyListeners();
  }

  Future<void> reorderCounters(int oldIndex, int newIndex) async {
    final list = counters;
    final item = list.removeAt(oldIndex);
    list.insert(newIndex, item);
    for (int i = 0; i < list.length; i++) {
      list[i].sortOrder = i;
      await list[i].save();
    }
    notifyListeners();
  }

  List<TallyEntryModel> getEntriesForCounter(String id) {
    return _entriesBox.values
        .where((e) => e.counterId == id)
        .toList()
      ..sort((a, b) => b.timestamp.compareTo(a.timestamp));
  }

  List<TallyEntryModel> getEntriesForDate(String id, DateTime date) {
    return getEntriesForCounter(id)
        .where((e) =>
            e.timestamp.year == date.year &&
            e.timestamp.month == date.month &&
            e.timestamp.day == date.day)
        .toList();
  }

  Map<DateTime, int> getDailyTotals(String id, {int days = 30}) {
    final now = DateTime.now();
    final result = <DateTime, int>{};
    for (int i = 0; i < days; i++) {
      final date = DateTime(now.year, now.month, now.day - i);
      final entries = getEntriesForDate(id, date);
      result[date] = entries.fold(0, (sum, e) => sum + e.delta.abs());
    }
    return result;
  }

  Future<String> exportCsv(String id) async {
    final counter = _countersBox.get(id);
    if (counter == null) return '';
    final entries = getEntriesForCounter(id);

    final rows = [
      ['timestamp', 'delta', 'value_after', 'note'],
      ...entries.map((e) => [
            e.timestamp.toIso8601String(),
            e.delta.toString(),
            e.valueAfter.toString(),
            e.note ?? '',
          ]),
    ];
    return rows.map((r) => r.join(',')).join('\n');
  }

  void _saveUndo(CounterModel counter, String? note) {
    _undoCounter = counter;
    _undoValue = counter.value;
  }

  Future<void> _logEntry(
      String counterId, int delta, int valueAfter, String? note) async {
    final entry = TallyEntryModel(
      counterId: counterId,
      delta: delta,
      timestamp: DateTime.now(),
      note: note,
      valueAfter: valueAfter,
    );
    await _entriesBox.add(entry);
    _undoEntry = entry;
  }
}
