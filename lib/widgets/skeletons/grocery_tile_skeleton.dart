import 'package:flutter/material.dart';
import 'package:market_rate/utils/skeleton.dart';

class GroceryTileSkeleton extends StatelessWidget {
  const GroceryTileSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: const Skeleton(
        height: 120,
        width: double.infinity,
      ),
    );
  }
}
