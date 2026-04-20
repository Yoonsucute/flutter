import 'package:flutter/material.dart';

import '../models/calculator_mode.dart';
import '../utils/constants.dart';
import 'calculator_button.dart';

class ButtonGrid extends StatelessWidget {
  final CalculatorMode mode;
  final ValueChanged<String> onButtonPressed;
  final VoidCallback onLongClearHistory;

  const ButtonGrid({
    super.key,
    required this.mode,
    required this.onButtonPressed,
    required this.onLongClearHistory,
  });

  @override
  Widget build(BuildContext context) {
    final buttons = AppConstants.getButtonsForMode(mode);

    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        itemCount: buttons.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: _crossAxisCount(mode),
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: _childAspectRatio(mode),
        ),
        itemBuilder: (context, index) {
          final label = buttons[index];

          if (label.isEmpty) {
            return const SizedBox.shrink();
          }

          final isClear = label == 'C' || label == '⌫';

          return CalculatorButton(
            label: label,
            onPressed: () => onButtonPressed(label),
            onLongPress: isClear ? onLongClearHistory : null,
          );
        },
      ),
    );
  }

  int _crossAxisCount(CalculatorMode mode) {
    switch (mode) {
      case CalculatorMode.basic:
        return 4;
      case CalculatorMode.scientific:
        return 6;
      case CalculatorMode.programmer:
        return 5;
    }
  }

  double _childAspectRatio(CalculatorMode mode) {
    switch (mode) {
      case CalculatorMode.basic:
        return 1.18;
      case CalculatorMode.scientific:
        return 1.08;
      case CalculatorMode.programmer:
        return 1.20;
    }
  }
}