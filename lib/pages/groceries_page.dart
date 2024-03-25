import 'package:flutter/material.dart';
import 'package:market_rate/widgets/grocery_tile.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class GroceriesPage extends StatefulWidget {
  const GroceriesPage({super.key});

  @override
  State<GroceriesPage> createState() => _GroceriesPageState();
}

class _GroceriesPageState extends State<GroceriesPage> {
  final _future = Supabase.instance.client.from('groceries').select("*");

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FutureBuilder(
        future: _future,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            final data = snapshot.data as List<dynamic>;
            return ListView.builder(
              itemCount: data.length,
              itemBuilder: (BuildContext context, int index) {
                return GroceryTile(
                  groceryName: data[index]['name'].toString(),
                  id: data[index]['id'].toString(),
                  unit: data[index]['unit'].toString(),
                  groceryImageUrl: data[index]['image_url'].toString(),
                );
              },
            );
          }
        },
      ),
    );
  }
}
