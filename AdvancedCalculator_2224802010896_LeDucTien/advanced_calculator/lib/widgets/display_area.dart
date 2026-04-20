import 'package:flutter/material.dart';

import '../models/calculation_history.dart';

class DisplayArea extends StatelessWidget {
  final String expression;
  final String result;
  final String previousResult;
  final String errorMessage;
  final double fontScale;
  final List<CalculationHistory> histories;
  final ValueChanged<CalculationHistory> onHistoryTap;
  final bool hasEvaluated;

  const DisplayArea({
    super.key,
    required this.expression,
    required this.result,
    required this.previousResult,
    required this.errorMessage,
    required this.fontScale,
    required this.histories,
    required this.onHistoryTap,
    required this.hasEvaluated,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.secondary.withOpacity(0.12),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (histories.isNotEmpty)
            SizedBox(
              height: 72,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                reverse: true,
                itemCount: histories.length,
                itemBuilder: (context, index) {
                  final item = histories[index];
                  return GestureDetector(
                    onTap: () => onHistoryTap(item),
                    child: Container(
                      width: 150,
                      margin: const EdgeInsets.only(left: 8),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: theme.cardColor,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            item.expression,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 12 * fontScale,
                              color: theme.textTheme.bodySmall?.color,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            item.result,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 16 * fontScale,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          if (histories.isNotEmpty) const SizedBox(height: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (errorMessage.isNotEmpty)
                  Text(
                    errorMessage,
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      color: theme.colorScheme.error,
                      fontSize: 24 * fontScale,
                      fontWeight: FontWeight.w600,
                    ),
                  )
                else ...[
                  if (expression.isNotEmpty)
                    Flexible(
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.centerRight,
                        child: Text(
                          expression,
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            color: theme.textTheme.bodyMedium?.color,
                            fontSize: 24 * fontScale,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  if (hasEvaluated && result.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerRight,
                      child: Text(
                        'Ans: $result',
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          color: theme.colorScheme.tertiary,
                          fontSize: 38 * fontScale,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}