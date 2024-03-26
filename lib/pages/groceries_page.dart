import 'package:flutter/material.dart';
import 'package:market_rate/widgets/grocery_tile.dart';
import 'package:market_rate/widgets/skeletons/grocery_tile_skeleton.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class GroceriesPage extends StatefulWidget {
  const GroceriesPage({super.key});

  @override
  State<GroceriesPage> createState() => _GroceriesPageState();
}

class _GroceriesPageState extends State<GroceriesPage> {
  String searchText = '';
  final TextEditingController _searchController = TextEditingController();

  void _onSearchTextChanged() {
    setState(() {
      searchText = _searchController.text;
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final future = Supabase.instance.client
        .from('groceries')
        .select("id, name, unit, image_url")
        .ilike('name', '%$searchText%');
    return Center(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              onChanged: (_) => _onSearchTextChanged(),
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.all(0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
                hintText: 'Search for groceries',
                prefixIcon: const Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: FutureBuilder(
                future: future,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return ListView.builder(
                      itemCount: 5,
                      itemBuilder: (context, index) {
                        return const GroceryTileSkeleton();
                      },
                    );
                  }

                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  }

                  final data = snapshot.data as List<dynamic>;

                  return ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      final item = data[index];
                      return GroceryTile(
                        id: item['id'],
                        groceryName: item['name'],
                        unit: item['unit'],
                        groceryImageUrl: item['image_url'],
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
