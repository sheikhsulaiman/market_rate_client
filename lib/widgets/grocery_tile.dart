import 'package:flutter/material.dart';
import 'package:market_rate/utils/capitalize.dart';

class GroceryTile extends StatelessWidget {
  final String groceryName;
  final String bigMarketName;
  final double price;
  final String groceryImageUrl;

  const GroceryTile({
    super.key,
    required this.groceryName,
    required this.bigMarketName,
    required this.price,
    required this.groceryImageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(bottom: 8),
            decoration: BoxDecoration(
                border: Border(
              bottom: BorderSide(color: Colors.grey.shade300, width: 1),
            )),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(capitalize(groceryName),
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold)),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                  ),
                  clipBehavior: Clip.hardEdge,
                  child: Image.network(
                    groceryImageUrl,
                    width: 50,
                    height: 30,
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            ),
          ),
          Text("৳ $price"),
        ],
      ),
    );
  }
}
