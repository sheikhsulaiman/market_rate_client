import 'package:flutter/material.dart';

class MarketsPage extends StatefulWidget {
  const MarketsPage({super.key});

  @override
  State<MarketsPage> createState() => _MarketsPageState();
}

class _MarketsPageState extends State<MarketsPage> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text("Market page"),
    );
  }
}
