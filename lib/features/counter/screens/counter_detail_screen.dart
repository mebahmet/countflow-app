import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../../core/models/counter_model.dart';
import '../../../core/providers/counter_provider.dart';
import '../../../core/providers/settings_provider.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/theme/app_theme.dart';

class CounterDetailScreen extends StatelessWidget {
  final String counterId;

  const CounterDetailScreen({super.key, required this.counterId});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CounterProvider>();
    final counter = provider.counters.firstWhere((c) => c.id == counterId);
    final settings = context.watch<SettingsProvider>();
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final primaryColor =
        CategoryColors.primary[counter.category] ?? AppTheme.midPurple;
    final name = settings.isTurkish ? counter.nameTr : counter.name;
    final entries = provider.getEntriesForCounter(counterId);
    final dailyTotals = provider.getDailyTotals(counterId, days: 14);

    return Scaffold(
      appBar: AppBar(
        title: Text(name),
        actions: [
          IconButton(
            icon: const Icon(Icons.ios_share_rounded),
            onPressed: () async {
              final csv = await provider.exportCsv(counterId);
              Share.share(csv, subject: '$name — CountFlow');
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline_rounded),
            onPressed: () => _confirmDelete(context, provider, l10n),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // Big number
          Center(
            child: Column(
              children: [
                Text(
                  counter.emoji,
                  style: const TextStyle(fontSize: 48),
                ),
                const SizedBox(height: 8),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  child: Text(
                    counter.value.toString(),
                    key: ValueKey(counter.value),
                    style: Theme.of(context).textTheme.displayLarge?.copyWith(
                          color: primaryColor,
                        ),
                  ),
                ),
                if (counter.goal != null)
                  Text(
                    '/ ${counter.goal}',
                    style: TextStyle(
                      fontSize: 20,
                      color: primaryColor.withOpacity(0.6),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Progress
          if (counter.goal != null) ...[
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: counter.progress,
                backgroundColor: primaryColor.withOpacity(0.15),
                valueColor: AlwaysStoppedAnimation(primaryColor),
                minHeight: 8,
              ),
            ),
            const SizedBox(height: 24),
          ],

          // Action buttons row
          Row(
            children: [
              Expanded(
                child: _BigButton(
                  icon: Icons.remove_rounded,
                  label: l10n.decrement,
                  color: primaryColor,
                  onPressed: () {
                    HapticFeedback.lightImpact();
                    provider.decrement(counterId);
                  },
                  isOutlined: true,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: _BigButton(
                  icon: Icons.add_rounded,
                  label: l10n.increment,
                  color: primaryColor,
                  onPressed: () {
                    HapticFeedback.lightImpact();
                    provider.increment(counterId);
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _BigButton(
                  icon: Icons.refresh_rounded,
                  label: l10n.reset,
                  color: primaryColor,
                  onPressed: () => provider.reset(counterId),
                  isOutlined: true,
                ),
              ),
            ],
          ),
          const SizedBox(height: 28),

          // Chart
          if (dailyTotals.isNotEmpty) ...[
            Text(l10n.last14Days,
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            SizedBox(
              height: 120,
              child: _DailyChart(
                dailyTotals: dailyTotals,
                color: primaryColor,
              ),
            ),
            const SizedBox(height: 28),
          ],

          // Recent entries
          if (entries.isNotEmpty) ...[
            Text(l10n.recentEntries,
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            ...entries.take(20).map((entry) {
              final time = TimeOfDay.fromDateTime(entry.timestamp);
              return Container(
                margin: const EdgeInsets.only(bottom: 6),
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: primaryColor.withOpacity(0.07),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: primaryColor.withOpacity(0.15),
                    width: 0.5,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      entry.delta > 0
                          ? Icons.arrow_upward_rounded
                          : Icons.arrow_downward_rounded,
                      size: 16,
                      color: entry.delta > 0
                          ? AppTheme.tealAccent
                          : AppTheme.redAccent,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${entry.delta > 0 ? '+' : ''}${entry.delta}',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: entry.delta > 0
                            ? AppTheme.tealAccent
                            : AppTheme.redAccent,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '→ ${entry.valueAfter}',
                      style: TextStyle(
                        color: primaryColor.withOpacity(0.7),
                      ),
                    ),
                    const Spacer(),
                    if (entry.note != null)
                      Flexible(
                        child: Text(
                          entry.note!,
                          style: TextStyle(
                            fontSize: 12,
                            color: primaryColor.withOpacity(0.6),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    const SizedBox(width: 8),
                    Text(
                      '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}',
                      style: TextStyle(
                        fontSize: 12,
                        color: primaryColor.withOpacity(0.5),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ],
      ),
    );
  }

  void _confirmDelete(
      BuildContext context, CounterProvider provider, AppLocalizations l10n) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.deleteCounter),
        content: Text(l10n.deleteConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () {
              provider.deleteCounter(counterId);
              Navigator.pop(ctx);
              Navigator.pop(context);
            },
            child: Text(l10n.delete,
                style: const TextStyle(color: AppTheme.redAccent)),
          ),
        ],
      ),
    );
  }
}

class _BigButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onPressed;
  final bool isOutlined;

  const _BigButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onPressed,
    this.isOutlined = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: isOutlined ? color.withOpacity(0.1) : color,
          borderRadius: BorderRadius.circular(16),
          border: isOutlined
              ? Border.all(color: color.withOpacity(0.4))
              : null,
        ),
        child: Column(
          children: [
            Icon(icon,
                color: isOutlined ? color : Colors.white, size: 22),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                color: isOutlined ? color : Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DailyChart extends StatelessWidget {
  final Map<DateTime, int> dailyTotals;
  final Color color;

  const _DailyChart({required this.dailyTotals, required this.color});

  @override
  Widget build(BuildContext context) {
    final sorted = dailyTotals.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));
    final bars = sorted.asMap().entries.map((e) {
      return BarChartGroupData(
        x: e.key,
        barRods: [
          BarChartRodData(
            toY: e.value.toDouble(),
            color: color.withOpacity(0.8),
            width: 10,
            borderRadius: BorderRadius.circular(4),
          ),
        ],
      );
    }).toList();

    return BarChart(
      BarChartData(
        barGroups: bars,
        gridData: const FlGridData(show: false),
        borderData: FlBorderData(show: false),
        titlesData: const FlTitlesData(
          left: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          right: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          top: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottom: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        barTouchData: BarTouchData(enabled: false),
      ),
    );
  }
}
