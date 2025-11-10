import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/project_task_provider.dart';
import 'providers/time_entry_provider.dart';
import 'home_screen.dart';
import 'add_time_entry_screen.dart';
import 'project_task_management_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProjectTaskProvider()),
        ChangeNotifierProvider(create: (_) => TimeEntryProvider()),
      ],
      child: const TimeTrackerApp(),
    ),
  );
}

class TimeTrackerApp extends StatelessWidget {
  const TimeTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Time Tracker',
      theme: ThemeData(useMaterial3: false, primarySwatch: Colors.indigo),
      initialRoute: '/',
      routes: {
        '/': (_) => HomeScreen(),
        '/add': (_) => AddTimeEntryScreen(),
        '/manage': (_) => ProjectTaskManagementScreen(),
      },
    );
  }
}

