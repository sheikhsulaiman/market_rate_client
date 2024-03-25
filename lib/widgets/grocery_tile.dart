import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:market_rate/utils/capitalize.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class GroceryTile extends StatefulWidget {
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
  State<GroceryTile> createState() => _GroceryTileState();
}

class _GroceryTileState extends State<GroceryTile> {
  double _avgPrice = 0.0;
  @override
  Widget build(BuildContext context) {
    final _future = Supabase.instance.client.from('prices').select('''
          *,
          groceries:grocery_id(*),
          big_markets:bigmarkets(*)
        ''').eq("grocery_id", widget.id);

    _future.then((value) {
      final data = value as List<dynamic>;
      final double sumPrice = data.fold(
          0, (previousValue, element) => previousValue + element['price']);

      _avgPrice = sumPrice / data.length;
    });
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
            future: _future,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                final data = snapshot.data as List<dynamic>;
                final double sumPrice = data.fold(
                    0,
                    (previousValue, element) =>
                        previousValue + element['price']);

                final double avaragePrice = sumPrice / data.length;

                return Row(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: data.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              color: Theme.of(context)
                                  .colorScheme
                                  .primary
                                  .withOpacity(.1),
                            ),
                            margin: const EdgeInsets.only(top: 8),
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Column(
                      children: [
                        Text("average",
                            style: TextStyle(
                                fontSize: 12,
                                color: Theme.of(context)
                                    .colorScheme
                                    .secondary
                                    .withOpacity(.5))),
                        const SizedBox(height: 4),
                        Container(
                          width: 50,
                          alignment: const Alignment(0, 0),
                          decoration: BoxDecoration(
                            color: Theme.of(context)
                                .colorScheme
                                .primary
                                .withOpacity(.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            avaragePrice.toString(),
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
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
