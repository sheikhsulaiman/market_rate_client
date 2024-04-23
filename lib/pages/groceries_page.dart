import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:market_rate/providers/divisions_provider.dart';
import 'package:market_rate/widgets/grocery_tile.dart';
import 'package:market_rate/widgets/skeletons/grocery_tile_skeleton.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:chips_choice/chips_choice.dart';

class GroceriesPage extends ConsumerStatefulWidget {
  const GroceriesPage({super.key});

  @override
  ConsumerState<GroceriesPage> createState() => _GroceriesPageState();
}

class _GroceriesPageState extends ConsumerState<GroceriesPage> {
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

    // multiple choice value
    List<String> tags = ref.watch(divisionsProvider);

    // list of string options
    List<String> options = [
      'dhaka',
      'mymenshingh',
      'khulna',
      'rajshahi',
      'rangpur',
      'syhlet',
      'chattogram',
      'barishal',
    ];

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
          Container(
            color:
                Theme.of(context).colorScheme.primaryContainer.withOpacity(.2),
            child: ChipsChoice<String>.multiple(
              padding:
                  const EdgeInsets.symmetric(vertical: 2.0, horizontal: 8.0),
              value: tags,
              onChanged: (val) => setState(() {
                tags = val;
                ref.read(divisionsProvider.notifier).setDivisions(val);
              }),
              choiceItems: C2Choice.listFrom<String, String>(
                source: options,
                value: (i, v) => v,
                label: (i, v) => v,
                tooltip: (i, v) => v,
              ),
              choiceCheckmark: true,
              choiceStyle: C2ChipStyle.outlined(),
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
                    return const Text('Network error! Please try again later.');
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
