import 'package:flutter/material.dart';
import 'package:frontend_assignment/provider/product_provider.dart';
import 'package:frontend_assignment/screens/homepage.dart';
import 'package:frontend_assignment/theme.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => ProductProvider())],
      child: MaterialApp(
        theme: appTheme,
        home: const HomePage(),
      ),
    );
  }
}
