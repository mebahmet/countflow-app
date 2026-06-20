import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/providers/settings_provider.dart';
import '../../l10n/app_localizations.dart';
import '../../shared/theme/app_theme.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settings)),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _SectionTitle(l10n.language),
          _SegmentRow(
            options: const ['TR', 'EN'],
            selected: settings.isTurkish ? 0 : 1,
            onChanged: (i) => settings.setLocale(i == 0 ? 'tr' : 'en'),
          ),
          const SizedBox(height: 24),

          _SectionTitle(l10n.theme),
          _SegmentRow(
            options: [l10n.themeDark, l10n.themeLight, l10n.themeSystem],
            selected: settings.themeMode == ThemeMode.dark
                ? 0
                : settings.themeMode == ThemeMode.light
                    ? 1
                    : 2,
            onChanged: (i) => settings.setThemeMode(
              [ThemeMode.dark, ThemeMode.light, ThemeMode.system][i],
            ),
          ),
          const SizedBox(height: 24),

          _SectionTitle(l10n.feedback),
          _SwitchTile(
            label: l10n.vibration,
            value: settings.globalVibration,
            onChanged: settings.setGlobalVibration,
          ),
          _SwitchTile(
            label: l10n.silentMode,
            value: settings.globalSilent,
            onChanged: settings.setGlobalSilent,
          ),
          const SizedBox(height: 32),

          // About
          Center(
            child: Column(
              children: [
                Text(
                  settings.isTurkish ? 'SAY' : 'CountFlow',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: AppTheme.midPurple,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  'v1.0.0',
                  style: TextStyle(
                    fontSize: 13,
                    color: AppTheme.midPurple.withOpacity(0.5),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle(this.title);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        title.toUpperCase(),
        style: Theme.of(context).textTheme.labelSmall,
      ),
    );
  }
}

class _SegmentRow extends StatelessWidget {
  final List<String> options;
  final int selected;
  final ValueChanged<int> onChanged;

  const _SegmentRow({
    required this.options,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppTheme.midPurple.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: options.asMap().entries.map((e) {
          final isSelected = e.key == selected;
          return Expanded(
            child: GestureDetector(
              onTap: () => onChanged(e.key),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected ? AppTheme.brandPurple : Colors.transparent,
                  borderRadius: BorderRadius.circular(9),
                ),
                child: Text(
                  e.value,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: isSelected
                        ? Colors.white
                        : AppTheme.midPurple.withOpacity(0.6),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _SwitchTile extends StatelessWidget {
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _SwitchTile({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: AppTheme.midPurple.withOpacity(0.06),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w400)),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: AppTheme.brandPurple,
          ),
        ],
      ),
    );
  }
}
