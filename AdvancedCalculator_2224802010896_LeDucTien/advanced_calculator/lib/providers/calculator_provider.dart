import 'dart:math' as math;
import 'package:flutter/material.dart';

import '../models/calculator_mode.dart';
import '../models/calculator_settings.dart';
import '../services/storage_service.dart';
import '../utils/calculator_logic.dart';

class CalculatorProvider extends ChangeNotifier {
  final StorageService _storageService;

  CalculatorProvider(this._storageService);

  String _expression = '';
  String _displayInput = '';
  String _result = '';
  String _previousResult = '';
  String _errorMessage = '';
  double _memoryValue = 0;
  CalculatorMode _mode = CalculatorMode.basic;
  CalculatorSettings _settings = CalculatorSettings.defaultSettings();
  bool _isTyping = false;
  bool _hasEvaluated = false;

  int _programmerBase = 10;
  int? _programmerStoredValue;
  String? _programmerPendingOperator;

  String get expression => _expression;
  String get displayInput => _displayInput;
  String get result => _result;
  String get previousResult => _previousResult;
  String get errorMessage => _errorMessage;
  double get memoryValue => _memoryValue;
  CalculatorMode get mode => _mode;
  CalculatorSettings get settings => _settings;
  bool get hasMemory => _memoryValue != 0;
  bool get isTyping => _isTyping;
  bool get hasEvaluated => _hasEvaluated;

  String get displayExpression => _displayInput;

  static String formatExpressionForDisplay(String expression) {
    if (expression.isEmpty) return '';

    var formatted = expression
        .replaceAll('pi', 'π')
        .replaceAll('*', '×')
        .replaceAll('/', '÷')
        .replaceAll('^2', '²')
        .replaceAll('^3', '³');

    formatted = formatted.replaceAllMapped(
      RegExp(r'sqrt\(([^)]+)\)'),
      (match) => '√${match[1]}',
    );

    formatted = formatted
        .replaceAll('sqrt(', '√')
        .replaceAll('sin(', 'sin(')
        .replaceAll('cos(', 'cos(')
        .replaceAll('tan(', 'tan(')
        .replaceAll('log(', 'log(')
        .replaceAll('ln(', 'ln(');

    return formatted;
  }

  Future<void> loadSettings() async {
    _settings = _storageService.loadSettings();
    _mode = _storageService.loadCalculatorMode();
    _memoryValue = _storageService.loadMemoryValue();
    notifyListeners();
  }

  Future<void> saveSettings() async {
    await _storageService.saveSettings(_settings);
    await _storageService.saveCalculatorMode(_mode);
    await _storageService.saveMemoryValue(_memoryValue);
  }

  void setExpression(String rawExpression) {
    _expression = rawExpression;
    _displayInput = formatExpressionForDisplay(rawExpression);
    _result = '';
    _errorMessage = '';
    _isTyping = true;
    _hasEvaluated = false;

    if (_mode == CalculatorMode.programmer) {
      _programmerStoredValue = null;
      _programmerPendingOperator = null;
    }

    notifyListeners();
  }

  void appendValue(String value) {
    if (_mode == CalculatorMode.programmer) {
      _appendProgrammerValue(value);
      return;
    }

    _errorMessage = '';
    _isTyping = true;
    _hasEvaluated = false;

    String rawValue = value;
    String shownValue = value;

    switch (value) {
      case 'π':
        rawValue = 'pi';
        shownValue = 'π';
        break;
      case 'e':
        rawValue = 'e';
        shownValue = 'e';
        break;
      case '×':
        rawValue = '*';
        shownValue = '×';
        break;
      case '÷':
        rawValue = '/';
        shownValue = '÷';
        break;
      case '−':
        rawValue = '-';
        shownValue = '−';
        break;
      case '√':
        rawValue = 'sqrt(';
        shownValue = '√';
        break;
      case 'x²':
        rawValue = '^2';
        shownValue = '²';
        break;
      case 'x³':
        rawValue = '^3';
        shownValue = '³';
        break;
      case 'xʸ':
        rawValue = '^';
        shownValue = '^';
        break;
      case 'ln':
        rawValue = 'ln(';
        shownValue = 'ln(';
        break;
      case 'log':
        rawValue = 'log(';
        shownValue = 'log(';
        break;
      case 'sin':
        rawValue = 'sin(';
        shownValue = 'sin(';
        break;
      case 'cos':
        rawValue = 'cos(';
        shownValue = 'cos(';
        break;
      case 'tan':
        rawValue = 'tan(';
        shownValue = 'tan(';
        break;
      case 'mod':
        rawValue = '%';
        shownValue = 'mod';
        break;
      default:
        rawValue = value;
        shownValue = value;
    }

    _expression += rawValue;
    _displayInput += shownValue;
    _result = '';
    notifyListeners();
  }

  void _appendProgrammerValue(String value) {
    _errorMessage = '';

    if (_hasEvaluated && _programmerPendingOperator == null) {
      _expression = '';
      _displayInput = '';
      _result = '';
      _hasEvaluated = false;
    }

    final upper = value.toUpperCase();

    if (!_isAllowedInCurrentBase(upper)) return;

    _expression += upper;

    if (_programmerPendingOperator != null) {
      final firstText = _programmerStoredValue != null
          ? _formatValueWithBase(_programmerStoredValue!)
          : '';
      final secondText = _formatRawProgrammerInput(_expression);
      _displayInput = '$firstText ${_programmerPendingOperator!} $secondText';
    } else {
      _displayInput = _formatRawProgrammerInput(_expression);
    }

    _result = '';
    _isTyping = true;
    _hasEvaluated = false;
    notifyListeners();
  }

  bool _isAllowedInCurrentBase(String value) {
    const hexLetters = ['A', 'B', 'C', 'D', 'E', 'F'];

    if (RegExp(r'^\d$').hasMatch(value)) {
      return int.parse(value) < _programmerBase;
    }

    if (hexLetters.contains(value)) {
      return _programmerBase == 16;
    }

    return false;
  }

  void clearAll() {
    _expression = '';
    _displayInput = '';
    _result = '';
    _previousResult = '';
    _errorMessage = '';
    _isTyping = false;
    _hasEvaluated = false;
    _programmerStoredValue = null;
    _programmerPendingOperator = null;
    notifyListeners();
  }

  void clearEntry() {
    _expression = '';
    _displayInput = '';
    _errorMessage = '';
    _result = '';
    _isTyping = false;
    _hasEvaluated = false;

    if (_mode == CalculatorMode.programmer) {
      _programmerStoredValue = null;
      _programmerPendingOperator = null;
    }

    notifyListeners();
  }

  void clearEntryAndMemory() {
    _expression = '';
    _displayInput = '';
    _result = '';
    _previousResult = '';
    _errorMessage = '';
    _memoryValue = 0;
    _isTyping = false;
    _hasEvaluated = false;
    _programmerStoredValue = null;
    _programmerPendingOperator = null;
    saveSettings();
    notifyListeners();
  }

  void deleteLast() {
    if (_mode == CalculatorMode.programmer) {
      _deleteLastProgrammer();
      return;
    }

    if (_displayInput.isEmpty) return;

    final complexTokens = <Map<String, String>>[
      {'display': ' M+', 'raw': ''},
      {'display': ' M-', 'raw': ''},
      {'display': ' MR', 'raw': ''},
      {'display': ' MC', 'raw': ''},
      {'display': 'sin(', 'raw': 'sin('},
      {'display': 'cos(', 'raw': 'cos('},
      {'display': 'tan(', 'raw': 'tan('},
      {'display': 'log(', 'raw': 'log('},
      {'display': 'ln(', 'raw': 'ln('},
      {'display': '√', 'raw': 'sqrt('},
      {'display': '²', 'raw': '^2'},
      {'display': '³', 'raw': '^3'},
      {'display': 'π', 'raw': 'pi'},
      {'display': 'mod', 'raw': '%'},
      {'display': '×', 'raw': '*'},
      {'display': '÷', 'raw': '/'},
      {'display': '−', 'raw': '-'},
    ];

    for (final token in complexTokens) {
      final displayToken = token['display']!;
      final rawToken = token['raw']!;

      if (_displayInput.endsWith(displayToken)) {
        _displayInput = _displayInput.substring(
          0,
          _displayInput.length - displayToken.length,
        );

        if (rawToken.isNotEmpty && _expression.endsWith(rawToken)) {
          _expression = _expression.substring(
            0,
            _expression.length - rawToken.length,
          );
        } else if (rawToken.isEmpty && _expression.isNotEmpty) {
          _expression = _expression.substring(0, _expression.length - 1);
        }

        if (_displayInput.isEmpty) {
          _result = '';
          _isTyping = false;
        }

        _errorMessage = '';
        _hasEvaluated = false;
        notifyListeners();
        return;
      }
    }

    _displayInput = _displayInput.substring(0, _displayInput.length - 1);

    if (_expression.isNotEmpty) {
      _expression = _expression.substring(0, _expression.length - 1);
    }

    if (_displayInput.isEmpty) {
      _result = '';
      _isTyping = false;
    }

    _errorMessage = '';
    _hasEvaluated = false;
    notifyListeners();
  }

  void _deleteLastProgrammer() {
    if (_programmerPendingOperator != null) {
      if (_expression.isNotEmpty) {
        _expression = _expression.substring(0, _expression.length - 1);

        final firstText = _programmerStoredValue != null
            ? _formatValueWithBase(_programmerStoredValue!)
            : '';
        final secondText = _formatRawProgrammerInput(_expression);

        if (_expression.isEmpty) {
          _displayInput = '$firstText ${_programmerPendingOperator!} ';
          _result = '';
          _isTyping = true;
        } else {
          _displayInput = '$firstText ${_programmerPendingOperator!} $secondText';
        }
      } else {
        _programmerPendingOperator = null;
        if (_programmerStoredValue != null) {
          _expression = _programmerStoredValue!.toRadixString(_programmerBase).toUpperCase();
          _displayInput = _formatRawProgrammerInput(_expression);
        } else {
          _expression = '';
          _displayInput = '';
        }
      }

      _errorMessage = '';
      _hasEvaluated = false;
      notifyListeners();
      return;
    }

    if (_expression.isEmpty) return;

    _expression = _expression.substring(0, _expression.length - 1);
    _displayInput = _formatRawProgrammerInput(_expression);

    if (_expression.isEmpty) {
      _result = '';
      _isTyping = false;
    }

    _errorMessage = '';
    _hasEvaluated = false;
    notifyListeners();
  }

  void toggleSign() {
    if (_mode == CalculatorMode.programmer) return;
    if (_expression.isEmpty) return;

    if (_expression.startsWith('-')) {
      _expression = _expression.substring(1);

      if (_displayInput.startsWith('-')) {
        _displayInput = _displayInput.substring(1);
      } else if (_displayInput.startsWith('−')) {
        _displayInput = _displayInput.substring(1);
      }
    } else {
      _expression = '-$_expression';
      _displayInput = '−$_displayInput';
    }

    _hasEvaluated = false;
    notifyListeners();
  }

  String evaluateExpression() {
    if (_mode == CalculatorMode.programmer) {
      return _evaluateProgrammerExpression();
    }

    try {
      _errorMessage = '';

      final evaluated = CalculatorLogic.evaluate(
        _expression,
        isDegreeMode: _settings.isDegreeMode,
        precision: _settings.decimalPrecision,
      );

      _result = evaluated;
      _previousResult = _result;
      _isTyping = false;
      _hasEvaluated = true;
      notifyListeners();
      return _result;
    } catch (_) {
      _errorMessage = 'Lỗi biểu thức';
      _hasEvaluated = false;
      notifyListeners();
      return _result;
    }
  }

  String _evaluateProgrammerExpression() {
    try {
      _errorMessage = '';

      if (_programmerPendingOperator == null) {
        if (_expression.isEmpty) return _result;

        final value = _parseProgrammerValue(_expression);
        _result = _formatProgrammerValue(value);
        _previousResult = _result;
        _hasEvaluated = true;
        _isTyping = false;
        notifyListeners();
        return _result;
      }

      if (_programmerStoredValue == null || _expression.isEmpty) {
        _errorMessage = 'Thiếu toán hạng';
        notifyListeners();
        return _result;
      }

      final secondValue = _parseProgrammerValue(_expression);
      final firstValue = _programmerStoredValue!;
      int resultValue = 0;

      switch (_programmerPendingOperator) {
        case 'AND':
          resultValue = firstValue & secondValue;
          break;
        case 'OR':
          resultValue = firstValue | secondValue;
          break;
        case 'XOR':
          resultValue = firstValue ^ secondValue;
          break;
        default:
          throw Exception('Toán tử không hỗ trợ');
      }

      final operator = _programmerPendingOperator!;
      final firstText = _formatValueWithBase(firstValue);
      final secondText = _formatValueWithBase(secondValue);

      _result = _formatProgrammerValue(resultValue);
      _previousResult = _result;
      _displayInput = '$firstText $operator $secondText =';

      _expression = resultValue.toRadixString(_programmerBase).toUpperCase();
      _programmerStoredValue = null;
      _programmerPendingOperator = null;
      _hasEvaluated = true;
      _isTyping = false;
      notifyListeners();
      return _result;
    } catch (_) {
      _errorMessage = 'Lỗi chế độ lập trình';
      notifyListeners();
      return _result;
    }
  }

  void useResultInExpression() {
    _expression = _result;
    _displayInput = _result;
    _errorMessage = '';
    _hasEvaluated = false;
    notifyListeners();
  }

  void setMode(CalculatorMode newMode) {
    _mode = newMode;
    _programmerStoredValue = null;
    _programmerPendingOperator = null;
    _expression = '';
    _displayInput = '';
    _result = '';
    _errorMessage = '';
    _hasEvaluated = false;
    _isTyping = false;
    saveSettings();
    notifyListeners();
  }

  void setDecimalPrecision(int precision) {
    _settings = _settings.copyWith(decimalPrecision: precision);
    saveSettings();
    notifyListeners();
  }

  void setAngleMode(bool isDegree) {
    _settings = _settings.copyWith(isDegreeMode: isDegree);
    saveSettings();
    notifyListeners();
  }

  void setHapticFeedback(bool value) {
    _settings = _settings.copyWith(hapticFeedback: value);
    saveSettings();
    notifyListeners();
  }

  void setSoundEffects(bool value) {
    _settings = _settings.copyWith(soundEffects: value);
    saveSettings();
    notifyListeners();
  }

  void setHistorySize(int size) {
    _settings = _settings.copyWith(historySize: size);
    saveSettings();
    notifyListeners();
  }

  void setFontScale(double scale) {
    _settings = _settings.copyWith(fontScale: scale.clamp(0.8, 1.8));
    saveSettings();
    notifyListeners();
  }

  void memoryClear() {
    _memoryValue = 0;

    if (_displayInput.isEmpty) {
      _displayInput = 'MC';
    } else {
      _displayInput += ' MC';
    }

    _result = '';
    _errorMessage = '';
    _isTyping = true;
    _hasEvaluated = false;

    saveSettings();
    notifyListeners();
  }

  void memoryRecall() {
    final memoryText = _formatMemoryValue(_memoryValue);

    _expression += memoryText;

    if (_displayInput.isEmpty) {
      _displayInput = 'MR';
    } else {
      _displayInput += ' MR';
    }

    _result = '';
    _errorMessage = '';
    _isTyping = true;
    _hasEvaluated = false;
    notifyListeners();
  }

  void memoryAdd() {
    try {
      final value = double.tryParse(
            _result.isNotEmpty
                ? _result
                : (_expression.isNotEmpty ? evaluateExpression() : '0'),
          ) ??
          0;

      _memoryValue += value;

      if (_displayInput.isEmpty) {
        _displayInput = 'M+';
      } else {
        _displayInput += ' M+';
      }

      saveSettings();

      _expression = '';
      _result = '';
      _errorMessage = '';
      _isTyping = true;
      _hasEvaluated = false;

      notifyListeners();
    } catch (_) {}
  }

  void memorySubtract() {
    try {
      final value = double.tryParse(
            _result.isNotEmpty
                ? _result
                : (_expression.isNotEmpty ? evaluateExpression() : '0'),
          ) ??
          0;

      _memoryValue -= value;

      if (_displayInput.isEmpty) {
        _displayInput = 'M-';
      } else {
        _displayInput += ' M-';
      }

      saveSettings();

      _expression = '';
      _result = '';
      _errorMessage = '';
      _isTyping = true;
      _hasEvaluated = false;

      notifyListeners();
    } catch (_) {}
  }

  void applyScientificShortcut(String key) {
    switch (key) {
      case '1/x':
        _expression = '1/($_expression)';
        _displayInput = '1/($_displayInput)';
        break;
      case 'n!':
        _expression = 'factorial($_expression)';
        _displayInput = 'n!($_displayInput)';
        break;
      default:
        appendValue(key);
        return;
    }
    _hasEvaluated = false;
    notifyListeners();
  }

  void applyProgrammerOperation(String op) {
    try {
      _errorMessage = '';

      if (['BIN', 'OCT', 'DEC', 'HEX'].contains(op)) {
        _changeProgrammerBase(op);
        return;
      }

      final currentValue = _getCurrentProgrammerValue();

      switch (op) {
        case 'NOT':
          if (currentValue == null) return;
          final resultValue = ~currentValue;
          _result = _formatProgrammerValue(resultValue);
          _displayInput = 'NOT ${_formatValueWithBase(currentValue)}';
          _expression = resultValue.toRadixString(_programmerBase).toUpperCase();
          _previousResult = _result;
          _hasEvaluated = true;
          _isTyping = false;
          notifyListeners();
          return;

        case '<<1':
          if (currentValue == null) return;
          final resultValue = currentValue << 1;
          _result = _formatProgrammerValue(resultValue);
          _displayInput = '${_formatValueWithBase(currentValue)} <<1';
          _expression = resultValue.toRadixString(_programmerBase).toUpperCase();
          _previousResult = _result;
          _hasEvaluated = true;
          _isTyping = false;
          notifyListeners();
          return;

        case '>>1':
          if (currentValue == null) return;
          final resultValue = currentValue >> 1;
          _result = _formatProgrammerValue(resultValue);
          _displayInput = '${_formatValueWithBase(currentValue)} >>1';
          _expression = resultValue.toRadixString(_programmerBase).toUpperCase();
          _previousResult = _result;
          _hasEvaluated = true;
          _isTyping = false;
          notifyListeners();
          return;

        case 'AND':
        case 'OR':
        case 'XOR':
          if (currentValue == null) return;
          _programmerStoredValue = currentValue;
          _programmerPendingOperator = op;
          _displayInput = '${_formatValueWithBase(currentValue)} $op ';
          _expression = '';
          _result = '';
          _hasEvaluated = false;
          _isTyping = true;
          notifyListeners();
          return;
      }
    } catch (_) {
      _errorMessage = 'Lỗi chế độ lập trình';
      notifyListeners();
    }
  }

  void _changeProgrammerBase(String op) {
    int newBase = 10;

    switch (op) {
      case 'BIN':
        newBase = 2;
        break;
      case 'OCT':
        newBase = 8;
        break;
      case 'DEC':
        newBase = 10;
        break;
      case 'HEX':
        newBase = 16;
        break;
    }

    if (_expression.isEmpty && _result.isEmpty) {
      _programmerBase = newBase;
      notifyListeners();
      return;
    }

    int? currentValue;

    try {
      if (_expression.isNotEmpty) {
        currentValue = _parseWithAnySupportedBase(_expression, _programmerBase);
      } else if (_result.isNotEmpty) {
        currentValue = _parseWithAnySupportedBase(_result, _programmerBase);
      }
    } catch (_) {
      currentValue = null;
    }

    _programmerBase = newBase;

    if (currentValue != null) {
      final convertedRaw = currentValue.toRadixString(_programmerBase).toUpperCase();
      _expression = convertedRaw;
      _displayInput = _formatRawProgrammerInput(convertedRaw);
      _result = '';
    }

    _errorMessage = '';
    _hasEvaluated = false;
    notifyListeners();
  }

  int _parseWithAnySupportedBase(String text, int fallbackBase) {
    final cleaned = text.trim().toUpperCase();

    if (cleaned.startsWith('0X')) {
      return int.parse(cleaned.substring(2), radix: 16);
    }
    if (cleaned.startsWith('0B')) {
      return int.parse(cleaned.substring(2), radix: 2);
    }
    if (cleaned.startsWith('0O')) {
      return int.parse(cleaned.substring(2), radix: 8);
    }

    return int.parse(cleaned, radix: fallbackBase);
  }

  int? _getCurrentProgrammerValue() {
    if (_expression.isNotEmpty) {
      return _parseProgrammerValue(_expression);
    }
    if (_result.isNotEmpty) {
      return _parseProgrammerValue(_result);
    }
    return null;
  }

  int _parseProgrammerValue(String text) {
    final cleaned = text.trim().toUpperCase();

    if (cleaned.startsWith('0X')) {
      return int.parse(cleaned.substring(2), radix: 16);
    }
    if (cleaned.startsWith('0B')) {
      return int.parse(cleaned.substring(2), radix: 2);
    }
    if (cleaned.startsWith('0O')) {
      return int.parse(cleaned.substring(2), radix: 8);
    }

    return int.parse(cleaned, radix: _programmerBase);
  }

  String _formatProgrammerValue(int value) {
    switch (_programmerBase) {
      case 2:
        String text = value.toRadixString(2).toUpperCase();
        if (text.length < 4) {
          text = text.padLeft(4, '0');
        }
        return '0b$text';

      case 8:
        String text = value.toRadixString(8).toUpperCase();
        if (text.length < 2) {
          text = text.padLeft(2, '0');
        }
        return '0o$text';

      case 16:
        String text = value.toRadixString(16).toUpperCase();
        if (text.length < 2) {
          text = text.padLeft(2, '0');
        }
        return '0x$text';

      default:
        return value.toString();
    }
  }

  String _formatValueWithBase(int value) {
    switch (_programmerBase) {
      case 2:
        String text = value.toRadixString(2).toUpperCase();
        if (text.length < 4) {
          text = text.padLeft(4, '0');
        }
        return '0b$text';

      case 8:
        String text = value.toRadixString(8).toUpperCase();
        if (text.length < 2) {
          text = text.padLeft(2, '0');
        }
        return '0o$text';

      case 16:
        String text = value.toRadixString(16).toUpperCase();
        if (text.length < 2) {
          text = text.padLeft(2, '0');
        }
        return '0x$text';

      default:
        return value.toString();
    }
  }

  String _formatRawProgrammerInput(String raw) {
    if (raw.isEmpty) return '';

    switch (_programmerBase) {
      case 2:
        return '0b$raw';
      case 8:
        return '0o$raw';
      case 16:
        return '0x$raw';
      default:
        return raw;
    }
  }

  void applyBinaryOperation(String op, String secondValue) {
    try {
      final a = int.tryParse(_expression) ?? 0;
      final b = int.tryParse(secondValue) ?? 0;
      int resultValue = 0;

      switch (op) {
        case 'AND':
          resultValue = a & b;
          break;
        case 'OR':
          resultValue = a | b;
          break;
        case 'XOR':
          resultValue = a ^ b;
          break;
      }

      _result = resultValue.toString();
      _displayInput += _displayInput.isEmpty ? op : ' $op';
      _hasEvaluated = false;
      notifyListeners();
    } catch (_) {
      _errorMessage = 'Lỗi phép toán bit';
      notifyListeners();
    }
  }

  String _formatMemoryValue(double value) {
    if (value == value.toInt()) {
      return value.toInt().toString();
    }
    return value.toStringAsFixed(
      math.min(_settings.decimalPrecision, 10),
    );
  }
}