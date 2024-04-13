import 'package:flutter/material.dart';

class Favorite extends StatelessWidget {
  final List<String> items;
  const Favorite({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemBuilder: (context, index) => ListTile(
            title: Text(items[index]),
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                // remove the item from the list
              },
            )));
  }
}
