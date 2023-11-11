import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox<double>('budgetBox');
  var expenseBox = await Hive.openBox('expense_database');
  await expenseBox.clear();

  runApp(MyApp());
}

class Budget {
  double amount;

  Budget({required this.amount});
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    initializeNotifications();
    checkWeeklyBudget();
  }

  void initializeNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');
    final InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> checkWeeklyBudget() async {
    var budgetBox = await Hive.openBox<Budget>('budgetBox');
    double weeklyBudget =
        budgetBox.get('budget', defaultValue: Budget(amount: 0.0))!.amount;

    double totalExpenses =
        calculateWeeklyExpenses(); // Implement this based on your logic

    if (totalExpenses > weeklyBudget) {
      showNotification();
    }
  }

  double calculateWeeklyExpenses() {
    // Implement your logic to calculate weekly expenses
    // For example, you can sum up expenses within the current week
    return 0.0; // Replace with the actual calculated value
  }

  void showNotification() async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'learn_basic.weekly_budget_channel', // Actual channel ID
      'Weekly Budget Notifications', // Actual channel name
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
    );

    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      0, // Notification ID
      'Weekly Budget Exceeded', // Notification title
      'You have exceeded your weekly budget!', // Notification body
      platformChannelSpecifics,
    );
  }

  @override
  Widget build(BuildContext context) {
    // Your existing UI code here
    return Scaffold(
      appBar: AppBar(
        title: Text('Budget App'),
      ),
      body: Center(
        child: Text('Your Budget App Content'),
      ),
    );
  }
}
