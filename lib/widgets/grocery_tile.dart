import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:market_rate/providers/date_provider.dart';
import 'package:market_rate/utils/capitalize.dart';
import 'package:market_rate/widgets/skeletons/grocery_sub_tile_skeleton.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class GroceryTile extends ConsumerStatefulWidget {
  final String groceryName;

  final String id;
  final String unit;
  final String groceryImageUrl;

  const GroceryTile({
    super.key,
    required this.id,
    required this.groceryName,
    required this.unit,
    required this.groceryImageUrl,
  });

  @override
  ConsumerState<GroceryTile> createState() => _GroceryTileState();
}

class _GroceryTileState extends ConsumerState<GroceryTile> {
  @override
  Widget build(BuildContext context) {
    final selectedDate = ref.watch(dateProvider);

    String formattedDate = selectedDate.toString().substring(0, 10);
    final future = Supabase.instance.client.from('prices').select('''
          price,local_price,
          groceries:grocery_id(name,unit),
          big_markets:bigmarkets(name)
        ''').eq("grocery_id", widget.id).eq('date', formattedDate);

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
                Text(capitalize(widget.groceryName),
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary)),
                const SizedBox(width: 8),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                  ),
                  clipBehavior: Clip.hardEdge,
                  child: Image.network(
                    widget.groceryImageUrl,
                    width: 50,
                    height: 30,
                    fit: BoxFit.cover,
                  ),
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

                if (data.isEmpty) {
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

                // final double sumPrice = data.fold(
                //     0,
                //     (previousValue, element) =>
                //         previousValue + element['price']);

                // final double avaragePrice = sumPrice / data.length;

                return Row(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: data.length > 5 ? 5 : data.length,
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
                                      Text(capitalize(data[index]['big_markets']
                                              ['name']
                                          .toString())),
                                      const SizedBox(width: 8),
                                      Text(
                                        "${data[index]['price'].toString()} 	৳ / ${data[index]['groceries']['unit']}",
                                        style: TextStyle(
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
                                  data[index]['local_price'].toString(),
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
                    // const SizedBox(width: 16),
                    // Column(
                    //   children: [
                    //     Text("average",
                    //         style: TextStyle(
                    //             fontSize: 12,
                    //             color: Theme.of(context)
                    //                 .colorScheme
                    //                 .secondary
                    //                 .withOpacity(.5))),
                    //     const SizedBox(height: 4),
                    //     Container(
                    //       width: 50,
                    //       alignment: const Alignment(0, 0),
                    //       decoration: BoxDecoration(
                    //         color: Theme.of(context)
                    //             .colorScheme
                    //             .primary
                    //             .withOpacity(.1),
                    //         borderRadius: BorderRadius.circular(4),
                    //       ),
                    //       child: Text(
                    //         avaragePrice.toStringAsPrecision(4),
                    //         style: TextStyle(
                    //           color: Theme.of(context).colorScheme.primary,
                    //           fontSize: 16,
                    //         ),
                    //       ),
                    //     ),
                    //   ],
                    // ),
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
