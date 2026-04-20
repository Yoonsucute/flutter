import 'package:flutter_test/flutter_test.dart';
import 'package:advancedcalculator/providers/calculator_provider.dart';
import 'package:advancedcalculator/services/storage_service.dart';

void main() {
  group('CalculatorProvider display formatting', () {
    late CalculatorProvider provider;

    setUp(() {
      provider = CalculatorProvider(StorageService());
    });

    test('formats sqrt(9) as √9 in displayExpression', () {
      provider.appendValue('√');
      provider.appendValue('9');
      provider.appendValue(')');

      expect(provider.expression, 'sqrt(9)');
      expect(provider.displayExpression, '√9');
    });

    test('typing 5 updates result immediately instead of keeping previous result', () {
      provider.appendValue('5');

      expect(provider.expression, '5');
      expect(provider.result, '5');
    });

    test('formats 2*pi*sqrt(9) as 2×π×√9', () {
      provider.appendValue('2');
      provider.appendValue('×');
      provider.appendValue('π');
      provider.appendValue('×');
      provider.appendValue('√');
      provider.appendValue('9');
      provider.appendValue(')');

      expect(provider.expression, '2*pi*sqrt(9)');
      expect(provider.displayExpression, '2×π×√9');
    });

    test('memory add (M+) updates memory and result display', () {
      provider.appendValue('5');
      provider.appendValue('+');
      provider.appendValue('3');
      provider.evaluateExpression();

      provider.memoryAdd();

      expect(provider.hasMemory, isTrue);
      expect(provider.memoryValue, equals(8));
      expect(provider.result, equals('8'));
      expect(provider.previousResult, equals('8'));
    });

    test('memory recall (MR) appends stored value to expression', () {
      provider.appendValue('7');
      provider.evaluateExpression();
      provider.memoryAdd();
      provider.clearEntry();

      provider.memoryRecall();

      expect(provider.expression, '7');
      expect(provider.displayExpression, '7');
    });
  });
}