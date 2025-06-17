import 'package:flutter/material.dart';

class SimpleCalc extends StatefulWidget {
  final VoidCallback onPlus; // tambahkan callback
  const SimpleCalc({super.key, required this.onPlus});

  @override
  State<SimpleCalc> createState() => _SimpleCalcState();
}

class _SimpleCalcState extends State<SimpleCalc> {
  String _display = '';

  void _onButtonPressed(String value) {
    setState(() {
      if (value == 'C') {
        _display = '';
      } else if (value == '+') {
        // Jika sudah ada angka, tambahkan '+'
        if (_display.isNotEmpty) {
          // Panggil callback onPlus agar MainDashboard tahu tombol '+' ditekan
          widget.onPlus();
          _display = '';
        }
      } else {
        // Angka 0-9
        _display += value;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Tombol angka + C + +
    final buttons = [
      '1',
      '2',
      '3',
      '4',
      '5',
      '6',
      '7',
      '8',
      '9',
      'C',
      '0',
      '+',
    ];

    final displayText = 'Rp ${_display.isEmpty ? '0' : _display}';

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Display
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              displayText,
              style: const TextStyle(fontSize: 24),
              textAlign: TextAlign.right,
            ),
          ),
          const SizedBox(height: 16),
          // Grid tombol
          Expanded(
            child: GridView.builder(
              itemCount: buttons.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 1.5,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemBuilder: (context, idx) {
                final label = buttons[idx];
                return ElevatedButton(
                  onPressed: () => _onButtonPressed(label),
                  child: Text(label, style: const TextStyle(fontSize: 20)),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
