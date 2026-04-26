import 'package:flutter/material.dart';

class Stars extends StatelessWidget {
  final int rate;

  const Stars({required this.rate});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(5, (index) {
        return Icon(
          index < rate ? Icons.star : Icons.star,
          size: 13,
          color: index < rate ? const Color(0xFFFF9900) : const Color(0xFFD1D1D1),
        );
      }),
    );
  }
}
