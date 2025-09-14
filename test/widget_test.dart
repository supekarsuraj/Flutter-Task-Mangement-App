import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:taskmangementapp/main.dart';
import 'package:taskmangementapp/models/task_adapter.dart';
import 'package:taskmangementapp/services/hive_service.dart';
import 'package:mockito/mockito.dart'; // Add mockito for mocking HiveService
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

// Mock class for HiveService
class MockHiveService extends Mock implements HiveService {}

void main() {
  // Set up test environment
  setUp(() async {
    // Initialize Hive for testing
    await Hive.initFlutter();
    Hive.registerAdapter(TaskAdapter()); // Ensure TaskAdapter is registered
  });

  tearDown(() async {
    // Clean up Hive after each test
    await Hive.deleteFromDisk();
  });

  testWidgets('HomeScreen displays initial state', (WidgetTester tester) async {
    // Create a mock HiveService
    final mockHiveService = MockHiveService();

    // Stub the getTasks method to return an empty list
    when(mockHiveService.getTasks()).thenReturn([]);

    // Build our app with the mock HiveService and trigger a frame
    await tester.pumpWidget(MyApp(hiveService: mockHiveService));

    // Verify that the initial state shows "No tasks yet"
    expect(find.text('No tasks yet'), findsOneWidget);

    // Verify the FloatingActionButton is present
    expect(find.byIcon(Icons.add), findsOneWidget);

    // Tap the '+' icon to open the Add Task dialog
    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle(); // Wait for the dialog to appear

    // Verify the dialog is displayed
    expect(find.text('Add Task'), findsOneWidget);
  });
}