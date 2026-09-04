import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculator de reducere',
      home: const DiscountPage(),
    );
  }
}

class DiscountPage extends StatefulWidget {
  const DiscountPage({super.key});

  @override
  State<DiscountPage> createState() => _DiscountPageState();
}

class _DiscountPageState extends State<DiscountPage> {
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _percentController = TextEditingController();

  String _currency = 'MDL';
  bool _round = false;

  String _discountText = '';
  String _finalText = '';

  void _calculate() {
    final double price = double.tryParse(_priceController.text) ?? 0;
    final double percent = double.tryParse(_percentController.text) ?? 0;

    final double discount = price * percent / 100;
    final double finalPrice = price - discount;

    setState(() {
      if (_round) {
        _discountText = '${discount.round()} $_currency';
        _finalText = '${finalPrice.round()} $_currency';
      } else {
        _discountText = '${discount.toStringAsFixed(2)} $_currency';
        _finalText = '${finalPrice.toStringAsFixed(2)} $_currency';
      }
    });
  }

  @override
  void dispose() {
    _priceController.dispose();
    _percentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Calculator de reducere')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _priceController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Preț inițial'),
            ),
            TextField(
              controller: _percentController,
              keyboardType: TextInputType.number,
              decoration:
              const InputDecoration(labelText: 'Procent reducere (%)'),
            ),
            const SizedBox(height: 16),
            DropdownButton<String>(
              value: _currency,
              items: const [
                DropdownMenuItem(value: 'MDL', child: Text('MDL')),
                DropdownMenuItem(value: 'RON', child: Text('RON')),
                DropdownMenuItem(value: 'USD', child: Text('USD')),
                DropdownMenuItem(value: 'EUR', child: Text('EUR')),
              ],
              onChanged: (String? value) {
                if (value == null) return;
                setState(() => _currency = value);
              },
            ),
            RadioListTile<bool>(
              value: false,
              groupValue: _round,
              title: const Text('Fără rotunjire'),
              onChanged: (bool? value) => setState(() => _round = false),
            ),
            RadioListTile<bool>(
              value: true,
              groupValue: _round,
              title: const Text('Rotunjire la întreg'),
              onChanged: (bool? value) => setState(() => _round = true),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: _calculate,
              child: const Text('Calculează'),
            ),
            const SizedBox(height: 16),
            Text('Valoarea reducerii: $_discountText'),
            Text('Preț final: $_finalText'),
          ],
        ),
      ),
    );
  }
}
