import 'package:flutter/material.dart';
import 'package:market_rate/widgets/grocery_tile.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class GroceriesPage extends StatefulWidget {
  const GroceriesPage({super.key});

  @override
  State<GroceriesPage> createState() => _GroceriesPageState();
}

class _GroceriesPageState extends State<GroceriesPage> {
  final _future = Supabase.instance.client.from('prices').select('''
    price,created_at,bigmarkets(name),groceries(name,image_url)
    
  ''');

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
                  groceryName: data[index]['groceries']['name'].toString(),
                  bigMarketName: data[index]['bigmarkets']['name'].toString(),
                  price: data[index]['price'].toDouble(),
                  groceryImageUrl:
                      data[index]['groceries']['image_url'].toString(),
                );
              },
            );
          }
        },
      ),
    );
  }
}
