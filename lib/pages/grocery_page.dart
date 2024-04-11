import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:market_rate/providers/date_provider.dart';
import 'package:market_rate/utils/capitalize.dart';
import 'package:market_rate/widgets/skeletons/grocery_sub_tile_skeleton.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class GroceryPage extends ConsumerStatefulWidget {
  final String groceryName;
  final String groceryId;
  final String groceryImageUrl;
  const GroceryPage(
      {super.key,
      required this.groceryName,
      required this.groceryId,
      required this.groceryImageUrl});

  @override
  ConsumerState<GroceryPage> createState() => _GroceryPageState();
}

class _GroceryPageState extends ConsumerState<GroceryPage> {
  @override
  Widget build(BuildContext context) {
    final selectedDate = ref.watch(dateProvider);
    var favoriteGroceriesBox = Hive.openBox('favorite_groceries_box');

    String formattedDate = selectedDate.toString().substring(0, 10);

    // list of string options
    List<String> allDivisions = [
      'dhaka',
      'mymenshingh',
      'khulna',
      'rajshahi',
      'rangpur',
      'syhlet',
      'chattogram',
      'barishal',
    ];

    final future = Supabase.instance.client
        .from('prices')
        .select('''
          price,local_price,
          groceries:grocery_id(name,unit),
          big_markets:bigmarkets(name,division)
        ''')
        .eq("grocery_id", widget.groceryId)
        .eq('date', formattedDate)
        .order('price', ascending: true);

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(capitalize(widget.groceryName),
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary)),
          actions: [
            IconButton(
              onPressed: () async {
                await favoriteGroceriesBox.then((value) {
                  if (value.containsKey(widget.groceryId)) {
                    setState(() {
                      value.delete(widget.groceryId);
                    });
                  } else {
                    setState(() {
                      value.put(widget.groceryId, widget.groceryName);
                    });
                  }
                });
              },
              icon: FutureBuilder(
                future: favoriteGroceriesBox,
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Icon(Icons.favorite_border);
                  } else if (snapshot.hasError) {
                    return const Icon(Icons.favorite_border);
                  } else {
                    final data = snapshot.data as Box<dynamic>;
                    if (data.containsKey(widget.groceryId)) {
                      return const Icon(Icons.favorite, color: Colors.red);
                    } else {
                      return const Icon(Icons.favorite_border);
                    }
                  }
                },
              ),
            ),
          ],
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Hero(
              tag: widget.groceryId,
              child: Image.network(
                widget.groceryImageUrl,
                width: double.infinity,
                height: 150,
                fit: BoxFit.cover,
              ),
            ),
            Expanded(
              child: ListView.builder(
                  itemCount: allDivisions.length,
                  itemBuilder: (ctx, index) {
                    final division = allDivisions[index];
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
                          Text(capitalize(division),
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color:
                                      Theme.of(context).colorScheme.primary)),
                          FutureBuilder(
                            future: future,
                            builder:
                                (BuildContext context, AsyncSnapshot snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const GrocerySubTileSkeleton();
                              } else if (snapshot.hasError) {
                                return Text(
                                    textAlign: TextAlign.center,
                                    'You are offline. Please check your internet connection.',
                                    style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .error));
                              } else {
                                final data = snapshot.data as List<dynamic>;
                                final filteredData = data
                                    .where((element) => division.contains(
                                        element['big_markets']['division']))
                                    .toList();

                                if (filteredData.isEmpty) {
                                  return Container(
                                    margin: const EdgeInsets.only(top: 8),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(4),
                                        color: Theme.of(context)
                                            .colorScheme
                                            .errorContainer),
                                    child: Text(
                                      'No data found for "${DateFormat().add_yMMMEd().format(selectedDate).toString()}" !',
                                      style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .error),
                                    ),
                                  );
                                }

                                return Row(
                                  children: [
                                    Expanded(
                                      child: ListView.builder(
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        itemCount: filteredData.length,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          return Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Expanded(
                                                child: Container(
                                                  margin: const EdgeInsets.only(
                                                      top: 8),
                                                  padding: const EdgeInsets
                                                      .symmetric(horizontal: 8),
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            4),
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .primary
                                                        .withOpacity(.1),
                                                  ),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Flexible(
                                                        child: Text(
                                                          capitalize(filteredData[
                                                                          index]
                                                                      [
                                                                      'big_markets']
                                                                  ['name']
                                                              .toString()),
                                                          style:
                                                              const TextStyle(
                                                            overflow:
                                                                TextOverflow
                                                                    .clip,
                                                          ),
                                                        ),
                                                      ),
                                                      const SizedBox(width: 8),
                                                      Text(
                                                        "${filteredData[index]['price'].toString()} 	৳ / ${filteredData[index]['groceries']['unit']}",
                                                        style: TextStyle(
                                                            overflow:
                                                                TextOverflow
                                                                    .clip,
                                                            color: Theme.of(
                                                                    context)
                                                                .colorScheme
                                                                .secondary),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 8),
                                              Container(
                                                margin: const EdgeInsets.only(
                                                    top: 8),
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 8),
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            4),
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .onSurface),
                                                child: Text(
                                                  filteredData[index]
                                                          ['local_price']
                                                      .toString(),
                                                  style: TextStyle(
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .onSecondary),
                                                ),
                                              ),
                                            ],
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                );
                              }
                            },
                          ),
                        ],
                      ),
                    );
                  }),
            )
          ],
        ));
  }
}
