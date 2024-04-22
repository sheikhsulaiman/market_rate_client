import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:market_rate/providers/date_provider.dart';
import 'package:market_rate/providers/divisions_provider.dart';
import 'package:market_rate/providers/favorite_market_provider.dart';
import 'package:market_rate/utils/capitalize.dart';
import 'package:market_rate/widgets/skeletons/grocery_sub_tile_skeleton.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MarketTile extends ConsumerStatefulWidget {
  final int id;
  final String marketName;
  const MarketTile({super.key, required this.marketName, required this.id});

  @override
  ConsumerState<MarketTile> createState() => _MarketTileState();
}

class _MarketTileState extends ConsumerState<MarketTile> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final selectedDate = ref.watch(dateProvider);
    final selectedDivisions = ref.watch(divisionsProvider);
    final favoriteMarkets = ref.watch(favoriteMarketsProvider);

    String formattedDate = selectedDate.toString().substring(0, 10);
    final future = isExpanded
        ? Supabase.instance.client.from('prices').select('''
          price,local_price,
          groceries:grocery_id(name,unit),
          big_markets:bigmarkets(name,division)
        ''').eq("bigmarket_id", widget.id).eq('date', formattedDate)
        : Supabase.instance.client.from('prices').select('''
          price,local_price,
          groceries:grocery_id(name,unit),
          big_markets:bigmarkets(name,division)
        ''').eq("bigmarket_id", widget.id).eq('date', formattedDate).limit(5);

    return Container(
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: isExpanded
                ? Theme.of(context).colorScheme.primary.withOpacity(.5)
                : Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 900),
            padding: const EdgeInsets.only(bottom: 8),
            decoration: BoxDecoration(
                border: Border(
              bottom: BorderSide(
                  color: isExpanded
                      ? Theme.of(context).colorScheme.primary
                      : Colors.grey.shade300,
                  width: 1),
            )),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(capitalize(widget.marketName),
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary)),
                ),
                Row(
                  children: [
                    IconButton(
                        onPressed: () {
                          if (favoriteMarkets.containsKey(widget.id)) {
                            setState(() {
                              ref
                                  .read(favoriteMarketsProvider.notifier)
                                  .removeFavorite(widget.id);
                            });
                          } else {
                            setState(() {
                              ref
                                  .read(favoriteMarketsProvider.notifier)
                                  .addFavorite(widget.id, widget.marketName);
                            });
                          }
                        },
                        icon: Icon(
                          favoriteMarkets.containsKey(widget.id)
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: Theme.of(context).colorScheme.primary,
                        )),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          isExpanded = !isExpanded;
                        });
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                            Theme.of(context)
                                .colorScheme
                                .primaryContainer
                                .withOpacity(.5)),
                        overlayColor:
                            MaterialStateProperty.all(Colors.transparent),
                        padding: MaterialStateProperty.all(
                            const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 0)),
                      ),
                      child: Text(
                        isExpanded ? 'Show Less' : 'Show More',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          FutureBuilder(
            future: future,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const GrocerySubTileSkeleton();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                final data = snapshot.data as List<dynamic>;
                final filteredData = data
                    .where((element) => selectedDivisions
                        .contains(element['big_markets']['division']))
                    .toList();

                if (filteredData.isEmpty) {
                  return Container(
                    margin: const EdgeInsets.only(top: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        color: Theme.of(context).colorScheme.errorContainer),
                    child: Text(
                      'No data found for "${DateFormat().add_yMMMEd().format(selectedDate).toString()}" !',
                      style:
                          TextStyle(color: Theme.of(context).colorScheme.error),
                    ),
                  );
                }

                return Row(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: isExpanded
                            ? filteredData.length
                            : filteredData.length > 5
                                ? 5
                                : filteredData.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Container(
                                  margin: const EdgeInsets.only(top: 8),
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 8),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4),
                                    color: Theme.of(context)
                                        .colorScheme
                                        .primary
                                        .withOpacity(.1),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Flexible(
                                        child: Text(
                                          capitalize(filteredData[index]
                                                  ['groceries']['name']
                                              .toString()),
                                          style: const TextStyle(
                                            overflow: TextOverflow.clip,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        "${filteredData[index]['price'].toString()} 	৳ / ${filteredData[index]['groceries']['unit']}",
                                        style: TextStyle(
                                            overflow: TextOverflow.clip,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .secondary),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                margin: const EdgeInsets.only(top: 8),
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4),
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurface),
                                child: Text(
                                  filteredData[index]['local_price'].toString(),
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
  }
}
