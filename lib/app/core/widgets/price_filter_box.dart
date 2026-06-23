import 'package:flutter/material.dart';

class PriceFilterBox extends StatelessWidget {
  const PriceFilterBox({
    required this.controller,
    required this.label,
    required this.hint,
    super.key,
  });

  final TextEditingController controller;
  final String label;
  final String hint;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: const Icon(Icons.payments_outlined),
      ),
    );
  }
}
