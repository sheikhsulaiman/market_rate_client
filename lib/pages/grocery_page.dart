import 'package:flutter/material.dart';

class GroceryPage extends StatelessWidget {
  final String groceryName;
  final String groceryId;
  final String groceryImageUrl;
  const GroceryPage(
      {super.key,
      required this.groceryName,
      required this.groceryId,
      required this.groceryImageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(groceryName),
      ),
      body: const Center(
        child: Text('Grocery Page'),
      ),
    );
  }
}
