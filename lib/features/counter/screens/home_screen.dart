import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';

import '../../../core/providers/counter_provider.dart';
import '../../../core/providers/settings_provider.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/theme/app_theme.dart';
import '../widgets/counter_card.dart';
import '../widgets/add_counter_sheet.dart';
import '../../settings/settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedTab = 0; // 0=all, 1=dhikr, 2=stats

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final settings = context.watch<SettingsProvider>();
    final provider = context.watch<CounterProvider>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final allCounters = provider.counters;
    final dhikrCounters = provider.dhikrCounters;
    final displayCounters = _selectedTab == 1 ? dhikrCounters : allCounters;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          settings.isTurkish ? 'SAY' : 'CountFlow',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        actions: [
          if (provider.canUndo)
            IconButton(
              icon: const Icon(Icons.undo_rounded),
              tooltip: l10n.undo,
              onPressed: () => provider.undo(),
            ),
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SettingsScreen()),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Tab bar
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
            child: Row(
              children: [
                _TabChip(
                  label: l10n.all,
                  selected: _selectedTab == 0,
                  onTap: () => setState(() => _selectedTab = 0),
                ),
                const SizedBox(width: 8),
                _TabChip(
                  label: l10n.dhikr,
                  selected: _selectedTab == 1,
                  onTap: () => setState(() => _selectedTab = 1),
                ),
              ],
            ),
          ),

          // Counter grid
          Expanded(
            child: displayCounters.isEmpty
                ? _EmptyState(
                    isDhikr: _selectedTab == 1,
                    onAdd: () => _showAddSheet(context),
                  )
                : ReorderableListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
                    itemCount: displayCounters.length,
                    onReorder: (oldIndex, newIndex) {
                      if (newIndex > oldIndex) newIndex -= 1;
                      provider.reorderCounters(oldIndex, newIndex);
                    },
                    itemBuilder: (context, index) {
                      final counter = displayCounters[index];
                      return CounterCard(
                        key: ValueKey(counter.id),
                        counter: counter,
                      ).animate().fadeIn(
                            duration: 200.ms,
                            delay: (index * 40).ms,
                          );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddSheet(context),
        icon: const Icon(Icons.add_rounded),
        label: Text(l10n.addCounter),
      ),
    );
  }

  void _showAddSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const AddCounterSheet(),
    );
  }
}

class _TabChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _TabChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: 200.ms,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
        decoration: BoxDecoration(
          color: selected ? color.withOpacity(0.18) : Colors.transparent,
          borderRadius: BorderRadius.circular(99),
          border: Border.all(
            color: selected ? color : color.withOpacity(0.3),
            width: selected ? 1 : 0.5,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
            color: selected ? color : color.withOpacity(0.6),
          ),
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final bool isDhikr;
  final VoidCallback onAdd;

  const _EmptyState({required this.isDhikr, required this.onAdd});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            isDhikr ? '📿' : '🔢',
            style: const TextStyle(fontSize: 56),
          ),
          const SizedBox(height: 16),
          Text(
            isDhikr ? l10n.emptyDhikr : l10n.emptyCounters,
            style: Theme.of(context).textTheme.titleMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: onAdd,
            icon: const Icon(Icons.add_rounded),
            label: Text(l10n.addCounter),
          ),
        ],
      ),
    );
  }
}
