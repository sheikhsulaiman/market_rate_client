import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({super.key});

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  @override
  Widget build(BuildContext context) {
    var favoriteMarketsBox = Hive.openBox('favorite_markets_box');
    var favoriteGroceriesBox = Hive.openBox('favorite_groceries_box');
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          const TabBar(
            tabs: [
              Tab(
                child: Text('Markets'),
              ),
              Tab(
                child: Text('Groceries'),
              ),
            ],
          ),
          Expanded(
            child: TabBarView(
              children: [
                FutureBuilder(
                  future: favoriteMarketsBox,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      final data = snapshot.data;

                      return ListView.builder(
                          itemCount: data!.keys.length,
                          itemBuilder: (context, index) {
                            final key = data.keyAt(index);
                            final value = data.get(key);

                            return ListTile(
                              title: Text(value),
                              trailing: IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () {
                                  data.delete(key);
                                  setState(() {});
                                },
                              ),
                            );
                          });
                    }
                  },
                ),
                Center(
                  child: Text('Groceries'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
