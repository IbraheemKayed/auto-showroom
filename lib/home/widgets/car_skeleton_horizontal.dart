import 'package:flutter/material.dart';

class CarSkeletonHorizontal extends StatelessWidget {
  const CarSkeletonHorizontal({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 220,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(16),
      ),
    );
  }
}
