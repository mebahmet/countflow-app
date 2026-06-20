import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/providers/counter_provider.dart';
import '../../../core/providers/settings_provider.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/theme/app_theme.dart';

class AddCounterSheet extends StatefulWidget {
  const AddCounterSheet({super.key});

  @override
  State<AddCounterSheet> createState() => _AddCounterSheetState();
}

class _AddCounterSheetState extends State<AddCounterSheet> {
  final _nameEnController = TextEditingController();
  final _nameTrController = TextEditingController();
  final _goalController = TextEditingController();
  final _stepController = TextEditingController(text: '1');

  CounterCategory _category = CounterCategory.general;
  String _emoji = '🔢';
  bool _isDhikrPreset = false;
  int _selectedDhikrIndex = 0;

  final List<String> _emojiOptions = [
    '🔢', '📿', '💊', '💧', '🏋️', '✅', '🎯', '⭐', '🔥', '📚',
    '🧘', '💼', '🎮', '🏃', '🌟', '❤️',
  ];

  @override
  void dispose() {
    _nameEnController.dispose();
    _nameTrController.dispose();
    _goalController.dispose();
    _stepController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppTheme.cardDarker : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.fromLTRB(
        20, 12, 20,
        MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle
            Center(
              child: Container(
                width: 36,
                height: 4,
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: AppTheme.midPurple.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),

            Text(l10n.newCounter,
                style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 20),

            // Category selector
            Text(l10n.category,
                style: Theme.of(context).textTheme.labelSmall),
            const SizedBox(height: 8),
            _CategorySelector(
              selected: _category,
              onChanged: (c) {
                setState(() {
                  _category = c;
                  _isDhikrPreset = c == CounterCategory.dhikr;
                  _emoji = CategoryColors.emoji[c] ?? '🔢';
                  if (_isDhikrPreset) {
                    _applyDhikrPreset(0);
                  }
                });
              },
            ),
            const SizedBox(height: 20),

            // Dhikr preset selector
            if (_isDhikrPreset) ...[
              Text(l10n.dhikrPreset,
                  style: Theme.of(context).textTheme.labelSmall),
              const SizedBox(height: 8),
              _DhikrPresetList(
                selectedIndex: _selectedDhikrIndex,
                onChanged: (i) {
                  setState(() {
                    _selectedDhikrIndex = i;
                    _applyDhikrPreset(i);
                  });
                },
              ),
              const SizedBox(height: 20),
            ],

            // Name fields
            Row(children: [
              Expanded(
                child: _Field(
                  controller: _nameEnController,
                  label: l10n.nameEn,
                  hint: 'Water intake',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _Field(
                  controller: _nameTrController,
                  label: l10n.nameTr,
                  hint: 'Su içimi',
                ),
              ),
            ]),
            const SizedBox(height: 16),

            // Goal + Step
            Row(children: [
              Expanded(
                child: _Field(
                  controller: _goalController,
                  label: l10n.goal,
                  hint: '100',
                  keyboardType: TextInputType.number,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _Field(
                  controller: _stepController,
                  label: l10n.step,
                  hint: '1',
                  keyboardType: TextInputType.number,
                ),
              ),
            ]),
            const SizedBox(height: 20),

            // Emoji picker
            Text(l10n.icon, style: Theme.of(context).textTheme.labelSmall),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _emojiOptions.map((e) {
                final sel = e == _emoji;
                return GestureDetector(
                  onTap: () => setState(() => _emoji = e),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: sel
                          ? AppTheme.brandPurple.withOpacity(0.2)
                          : AppTheme.midPurple.withOpacity(0.07),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: sel
                            ? AppTheme.brandPurple
                            : Colors.transparent,
                      ),
                    ),
                    child: Center(
                      child: Text(e, style: const TextStyle(fontSize: 22)),
                    ),
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 28),

            // Save button
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: AppTheme.brandPurple,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                onPressed: _save,
                child: Text(
                  l10n.save,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _applyDhikrPreset(int index) {
    final preset = AppConstants.dhikrPresets[index];
    final settings = context.read<SettingsProvider>();
    _nameEnController.text = preset['en'] ?? '';
    _nameTrController.text = preset['tr'] ?? '';
    _goalController.text = preset['goal'] ?? '';
  }

  Future<void> _save() async {
    final nameEn = _nameEnController.text.trim();
    final nameTr = _nameTrController.text.trim();
    if (nameEn.isEmpty && nameTr.isEmpty) return;

    final provider = context.read<CounterProvider>();
    final goal = int.tryParse(_goalController.text);
    final step = int.tryParse(_stepController.text) ?? 1;

    final dhikrText = _isDhikrPreset
        ? AppConstants.dhikrPresets[_selectedDhikrIndex]['ar']
        : null;

    await provider.addCounter(
      name: nameEn.isEmpty ? nameTr : nameEn,
      nameTr: nameTr.isEmpty ? nameEn : nameTr,
      goal: goal,
      step: step,
      category: _category,
      emoji: _emoji,
      dhikrText: dhikrText,
    );

    if (mounted) Navigator.pop(context);
  }
}

class _Field extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final TextInputType keyboardType;

  const _Field({
    required this.controller,
    required this.label,
    required this.hint,
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.labelSmall),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          style: const TextStyle(fontSize: 15),
          decoration: InputDecoration(
            hintText: hint,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide:
                  BorderSide(color: AppTheme.midPurple.withOpacity(0.3)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide:
                  BorderSide(color: AppTheme.midPurple.withOpacity(0.25)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppTheme.brandPurple),
            ),
          ),
        ),
      ],
    );
  }
}

class _CategorySelector extends StatelessWidget {
  final CounterCategory selected;
  final ValueChanged<CounterCategory> onChanged;

  const _CategorySelector({
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: CounterCategory.values.map((c) {
        final isSelected = c == selected;
        final color = CategoryColors.primary[c] ?? AppTheme.midPurple;
        final emoji = CategoryColors.emoji[c] ?? '🔢';
        final label = _categoryLabel(c, context);

        return GestureDetector(
          onTap: () => onChanged(c),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
            decoration: BoxDecoration(
              color: isSelected ? color.withOpacity(0.18) : Colors.transparent,
              borderRadius: BorderRadius.circular(99),
              border: Border.all(
                color: isSelected ? color : color.withOpacity(0.3),
                width: isSelected ? 1 : 0.5,
              ),
            ),
            child: Text(
              '$emoji $label',
              style: TextStyle(
                fontSize: 12,
                fontWeight:
                    isSelected ? FontWeight.w600 : FontWeight.w400,
                color: isSelected ? color : color.withOpacity(0.7),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  String _categoryLabel(CounterCategory c, BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    switch (c) {
      case CounterCategory.general: return l10n.catGeneral;
      case CounterCategory.dhikr: return l10n.catDhikr;
      case CounterCategory.health: return l10n.catHealth;
      case CounterCategory.sport: return l10n.catSport;
      case CounterCategory.work: return l10n.catWork;
      case CounterCategory.habit: return l10n.catHabit;
      case CounterCategory.score: return l10n.catScore;
    }
  }
}

class _DhikrPresetList extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onChanged;

  const _DhikrPresetList({
    required this.selectedIndex,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();
    return Column(
      children: AppConstants.dhikrPresets.asMap().entries.map((e) {
        final i = e.key;
        final preset = e.value;
        final isSelected = i == selectedIndex;
        return GestureDetector(
          onTap: () => onChanged(i),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            margin: const EdgeInsets.only(bottom: 6),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: isSelected
                  ? AppTheme.tealAccent.withOpacity(0.12)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected
                    ? AppTheme.tealAccent
                    : AppTheme.tealAccent.withOpacity(0.2),
                width: isSelected ? 1 : 0.5,
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        settings.isTurkish
                            ? (preset['tr'] ?? '')
                            : (preset['en'] ?? ''),
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        preset['ar'] ?? '',
                        style: TextStyle(
                          fontSize: 13,
                          color: AppTheme.tealAccent.withOpacity(0.8),
                          fontFamily: 'serif',
                        ),
                        textDirection: TextDirection.rtl,
                      ),
                    ],
                  ),
                ),
                Text(
                  '× ${preset['goal']}',
                  style: TextStyle(
                    fontSize: 13,
                    color: AppTheme.tealAccent.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
