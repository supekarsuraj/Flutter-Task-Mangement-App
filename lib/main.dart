import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:taskmangementapp/screens/home_screen.dart';
import 'package:taskmangementapp/services/hive_service.dart';
import 'package:taskmangementapp/theme.dart';
import 'package:taskmangementapp/blocs/task_bloc.dart';
import 'package:taskmangementapp/models/task.dart';
import 'package:taskmangementapp/models/task_adapter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(TaskAdapter());
  await Hive.openBox<Task>('tasks');

  final hiveService = HiveService();
  await hiveService.init();

  runApp(MyApp(hiveService: hiveService));
}

class MyApp extends StatefulWidget {
  final HiveService hiveService;

  const MyApp({super.key, required this.hiveService});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.system;

  void toggleTheme() {
    setState(() {
      _themeMode = _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TaskBloc(widget.hiveService)..add(LoadTasks()),
      child: MaterialApp(
        title: 'Todo App',
        theme: lightTheme,
        darkTheme: darkTheme,
        themeMode: _themeMode,
        home: HomeScreen(toggleTheme: toggleTheme),
      ),
    );
  }
}