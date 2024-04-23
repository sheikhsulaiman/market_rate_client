import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:market_rate/pages/home_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<void> main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  await Future.delayed(const Duration(milliseconds: 5));

  FlutterNativeSplash.remove();

  await Supabase.initialize(
    url: 'https://nzruerpjcirgttvgefua.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im56cnVlcnBqY2lyZ3R0dmdlZnVhIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MTEyNzg4NTAsImV4cCI6MjAyNjg1NDg1MH0.Yh8tvRfU5MFSBvx_rpCcFDLv0c0VrdWEFY_SEYlaFNw',
  );

  //initialize hive
  await Hive.initFlutter();

  //open the box
  await Hive.openBox('favorite_markets_box');
  await Hive.openBox('favorite_groceries_box');

  runApp(
    // Adding ProviderScope enables Riverpod for the entire project
    const ProviderScope(child: MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Market Rate App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}
