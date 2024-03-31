import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:market_rate/utils/skeleton.dart';

class GrocerySubTileSkeleton extends StatelessWidget {
  const GrocerySubTileSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.all(8),
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Skeleton(height: 20, width: 200),
                SizedBox(height: 8),
                Skeleton(height: 20, width: 200),
              ],
            ),
            SizedBox(width: 8),
            Column(
              children: [
                Skeleton(height: 8, width: 60),
                SizedBox(height: 8),
                Skeleton(height: 20, width: 60),
              ],
            ),
          ],
        ));
  }
}
