import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:learn_basic/data/expense_data.dart';
import 'package:provider/provider.dart';
import 'pages/home_page.dart';
import 'dart:ui' as ui;

void main() async {
  // Initialize Hive
  await Hive.initFlutter();

  // Open the Hive box for expenses only once
  await Hive.openBox("expense_database");

  // Use bootstrapEngine instead of webOnlyWarmupEngine

  // Initialize Hive for budget
  await openHiveBox();

  runApp(const MyApp());
}

Future<void> openHiveBox() async {
  // Open the Hive box for budget if it's not already open
  if (!Hive.isBoxOpen('budgetBox')) {
    await Hive.openBox<double>('budgetBox');
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ExpenseData(),
      builder: (context, child) => const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: HomePage(),
      ),
    );
  }
}
