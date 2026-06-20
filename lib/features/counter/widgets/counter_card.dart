import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';

import '../../../core/models/counter_model.dart';
import '../../../core/providers/counter_provider.dart';
import '../../../core/providers/settings_provider.dart';
import '../../../shared/theme/app_theme.dart';
import '../screens/counter_detail_screen.dart';

class CounterCard extends StatefulWidget {
  final CounterModel counter;

  const CounterCard({super.key, required this.counter});

  @override
  State<CounterCard> createState() => _CounterCardState();
}

class _CounterCardState extends State<CounterCard>
    with SingleTickerProviderStateMixin {
  bool _pressed = false;
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  Color get _primaryColor =>
      CategoryColors.primary[widget.counter.category] ?? AppTheme.midPurple;

  Color get _bgColor {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    if (isDark) return _primaryColor.withOpacity(0.15);
    return CategoryColors.light[widget.counter.category] ?? AppTheme.palePurple;
  }

  @override
  Widget build(BuildContext context) {
    final counter = widget.counter;
    final provider = context.read<CounterProvider>();
    final settings = context.watch<SettingsProvider>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final name = settings.isTurkish ? counter.nameTr : counter.name;
    final hasGoal = counter.goal != null;

    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => CounterDetailScreen(counterId: counter.id),
        ),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: _bgColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: _primaryColor.withOpacity(isDark ? 0.35 : 0.2),
            width: 0.5,
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
              child: Row(
                children: [
                  // Emoji
                  Text(
                    counter.emoji,
                    style: const TextStyle(fontSize: 22),
                  ),
                  const SizedBox(width: 10),

                  // Name + category
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(color: _primaryColor),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (counter.isDhikr && counter.dhikrText != null)
                          Text(
                            counter.dhikrText!,
                            style: TextStyle(
                              fontSize: 13,
                              color: _primaryColor.withOpacity(0.7),
                              fontFamily: 'serif',
                            ),
                            textDirection: TextDirection.rtl,
                          ),
                      ],
                    ),
                  ),

                  // Value display
                  _CounterValue(
                    value: counter.value,
                    color: _primaryColor,
                    isDhikr: counter.isDhikr,
                  ),
                ],
              ),
            ),

            // Progress bar
            if (hasGoal)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: counter.progress,
                        backgroundColor: _primaryColor.withOpacity(0.15),
                        valueColor: AlwaysStoppedAnimation(_primaryColor),
                        minHeight: 4,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      '${counter.value} / ${counter.goal}',
                      style: TextStyle(
                        fontSize: 11,
                        color: _primaryColor.withOpacity(0.7),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),

            // Action buttons
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 4, 12, 12),
              child: Row(
                children: [
                  // Decrement
                  _ActionButton(
                    icon: Icons.remove_rounded,
                    color: _primaryColor,
                    onPressed: () => _doDecrement(provider, settings),
                  ),
                  const Spacer(),
                  // Increment (big)
                  _IncrementButton(
                    color: _primaryColor,
                    isCompleted: counter.isCompleted,
                    onPressed: () => _doIncrement(provider, settings),
                  ),
                  const Spacer(),
                  // Reset
                  _ActionButton(
                    icon: Icons.refresh_rounded,
                    color: _primaryColor,
                    onPressed: () => _doReset(provider),
                    isSubtle: true,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _doIncrement(CounterProvider provider, SettingsProvider settings) {
    _feedback(settings);
    provider.increment(widget.counter.id);
    _pulseController.forward(from: 0);
  }

  void _doDecrement(CounterProvider provider, SettingsProvider settings) {
    _feedback(settings);
    provider.decrement(widget.counter.id);
  }

  void _doReset(CounterProvider provider) {
    provider.reset(widget.counter.id);
  }

  void _feedback(SettingsProvider settings) {
    if (settings.globalVibration && widget.counter.hasVibration) {
      HapticFeedback.lightImpact();
    }
  }
}

class _CounterValue extends StatelessWidget {
  final int value;
  final Color color;
  final bool isDhikr;

  const _CounterValue({
    required this.value,
    required this.color,
    required this.isDhikr,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 120),
      transitionBuilder: (child, animation) => ScaleTransition(
        scale: animation,
        child: child,
      ),
      child: Text(
        value.toString(),
        key: ValueKey(value),
        style: TextStyle(
          fontSize: isDhikr ? 36 : 32,
          fontWeight: FontWeight.w500,
          color: color,
          fontFeatures: const [FontFeature.tabularFigures()],
          height: 1,
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onPressed;
  final bool isSubtle;

  const _ActionButton({
    required this.icon,
    required this.color,
    required this.onPressed,
    this.isSubtle = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: color.withOpacity(isSubtle ? 0.06 : 0.12),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          icon,
          color: color.withOpacity(isSubtle ? 0.5 : 0.85),
          size: 20,
        ),
      ),
    );
  }
}

class _IncrementButton extends StatelessWidget {
  final Color color;
  final bool isCompleted;
  final VoidCallback onPressed;

  const _IncrementButton({
    required this.color,
    required this.isCompleted,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 80,
        height: 52,
        decoration: BoxDecoration(
          color: isCompleted ? AppTheme.tealAccent : color,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Icon(
          isCompleted ? Icons.check_rounded : Icons.add_rounded,
          color: Colors.white,
          size: 28,
        ),
      ),
    );
  }
}
