import 'package:flutter/material.dart';

void main() => runApp(const CalculatorApp());

class CalculatorApp extends StatelessWidget {
  const CalculatorApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Calculator LAB-01',
        theme: ThemeData(
          brightness: Brightness.dark,
          scaffoldBackgroundColor: const Color(0xFF282828), 
        ),
        home: const CalculatorScreen(),
      );
}

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String _display = '0';
  String _equation = '';
  double _num1 = 0;
  double _num2 = 0;
  String _operation = '';
  bool _shouldClearDisplay = false;

  final List<String> buttons = [
    'C', 'CE', '%', '÷',
    '7', '8', '9', '×',
    '4', '5', '6', '-',
    '1', '2', '3', '+',
    '+/-', '0', '.', '=',
  ];

  // Hàm phụ để hiển thị số đẹp hơn (xóa .0 ở đuôi nếu là số nguyên)
  String _formatNumber(double num) {
    String res = num.toString();
    if (res.endsWith('.0')) {
      return res.substring(0, res.length - 2);
    }
    return res;
  }

  // Hàm tính toán logic
  double _performCalculation(double n1, double n2, String op) {
    switch (op) {
      case '+': return n1 + n2;
      case '-': return n1 - n2;
      case '×': return n1 * n2;
      case '÷': return n2 == 0 ? double.nan : n1 / n2;
      default: return n1;
    }
  }

  void _onButtonPressed(String text) {
    setState(() {
      // 1. Reset (C)
      if (text == 'C') {
        _display = '0';
        _equation = '';
        _num1 = 0;
        _num2 = 0;
        _operation = '';
        return;
      }

      // 2. Xóa ký tự cuối (CE)
      if (text == 'CE') {
        if (_display != 'Error' && !_shouldClearDisplay) {
          if (_display.length > 1) {
            _display = _display.substring(0, _display.length - 1);
            if (_display == '-' || _display == '-0') _display = '0';
          } else {
            _display = '0';
          }
        }
        return;
      }

      // 3. Dấu Bằng (=)
      if (text == '=') {
        if (_operation.isNotEmpty && _display != 'Error') {
          _num2 = double.parse(_display);
          // Giữ nguyên chuỗi phép tính trên màn hình, thêm số thứ 2 và dấu =
          _equation = '$_equation ${_formatNumber(_num2)} =';
          
          double result = _performCalculation(_num1, _num2, _operation);
          
          if (result.isNaN) {
            _display = 'Error';
          } else {
            _display = _formatNumber(result);
          }
          
          _operation = '';
          _shouldClearDisplay = true;
        }
        return;
      }

      // 4. Số âm/dương (+/-)
      if (text == '+/-') {
        if (_display != '0' && _display != 'Error') {
          _display = _display.startsWith('-') ? _display.substring(1) : '-$_display';
        }
        return;
      }

      // 5. Phần trăm (%)
      if (text == '%') {
        if (_display != 'Error') {
          _display = _formatNumber(double.parse(_display) / 100);
          _shouldClearDisplay = true;
        }
        return;
      }

      // 6. Các phép toán (+, -, ×, ÷)
      if (text == '+' || text == '-' || text == '×' || text == '÷') {
        if (_display == 'Error') return;

        if (_operation.isEmpty) {
          // Lần đầu tiên bấm phép toán
          _num1 = double.parse(_display);
          _equation = '${_formatNumber(_num1)} $text';
        } else {
          if (!_shouldClearDisplay) {
            // Đã có phép toán chờ, và người dùng vừa nhập thêm số mới -> Tính gộp ngầm
            _num2 = double.parse(_display);
            
            // Cập nhật chuỗi hiển thị nối tiếp
            _equation = '$_equation ${_formatNumber(_num2)} $text';
            
            // Tính ngầm kết quả nhét vào _num1 để chờ tính tiếp
            _num1 = _performCalculation(_num1, _num2, _operation);
          } else {
            // Trường hợp người dùng đổi ý, bấm liền 2 dấu phép toán (VD: đang + đổi thành x)
            _equation = '${_equation.substring(0, _equation.length - 1)}$text';
          }
        }
        
        _operation = text;
        _shouldClearDisplay = true;
        return;
      }

      // 7. Nhập phím số & dấu chấm (.)
      if (_shouldClearDisplay) {
        _display = text == '.' ? '0.' : text;
        _shouldClearDisplay = false;
      } else {
        if (text == '.') {
          if (!_display.contains('.')) _display += '.';
        } else {
          _display = _display == '0' ? text : _display + text;
        }
      }
    });
  }

  // Phối màu cho nút
  Color _getBackgroundColor(String text) {
    if (text == 'C') return const Color(0xFFA64444);
    if (text == 'CE' || text == '%') return const Color(0xFF333333);
    if (text == '÷' || text == '×' || text == '-' || text == '+') return const Color(0xFF4A5D44);
    if (text == '=') return const Color(0xFF1E6B4B);
    return const Color(0xFF202020); 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              flex: 2,
              child: Container(
                alignment: Alignment.bottomRight,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    // Màn hình phụ: Hiện cả chuỗi phép tính chưa hoàn thành
                    Text(
                      _equation,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w400,
                        color: Colors.white54, 
                      ),
                      maxLines: 2, // Cho phép xuống dòng nếu phép tính quá dài
                    ),
                    const SizedBox(height: 8),
                    // Màn hình chính: Hiện số hiện tại đang nhập hoặc Kết quả
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        _display == '0' && _equation.isEmpty ? '0000' : _display, 
                        style: const TextStyle(
                          fontSize: 56,
                          fontWeight: FontWeight.w300,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 5,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: buttons.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    childAspectRatio: 1.0,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemBuilder: (context, index) {
                    final text = buttons[index];
                    return ElevatedButton(
                      onPressed: () => _onButtonPressed(text),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _getBackgroundColor(text),
                        foregroundColor: Colors.white,
                        shape: const CircleBorder(),
                        padding: const EdgeInsets.all(16),
                        elevation: 0, 
                      ),
                      child: Text(
                        text,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}