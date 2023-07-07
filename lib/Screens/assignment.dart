import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Assignment App',
      home: AssignmentScreen(),
    );
  }
}

class AssignmentScreen extends StatelessWidget {
  final List<Map<String, dynamic>> assignments = [
    {
      'title': 'Math Assignment',
      'deadline': '2023-06-20',
    },
    {
      'title': 'Science Experiment',
      'deadline': '2023-06-25',
    },
    {
      'title': 'English Essay',
      'deadline': '2023-06-30',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Assignments'),
      ),
      body: ListView.builder(
        itemCount: assignments.length,
        itemBuilder: (context, index) {
          final assignment = assignments[index];

          return Card(
            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: BorderSide(color: Colors.grey[300]!),
            ),
            child: ListTile(
              title: Text(
                assignment['title'],
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              subtitle: Text(
                'Deadline: ${assignment['deadline']}',
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
