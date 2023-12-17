import 'package:flutter/material.dart';


class AssignmentScreen extends StatefulWidget {
  const AssignmentScreen({Key? key}) : super(key: key);

  @override
  _AssignmentScreenState createState() => _AssignmentScreenState();
}

class _AssignmentScreenState extends State<AssignmentScreen> {
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
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: BorderSide(color: Colors.grey[300]!),
            ),
            child: ListTile(
              title: Text(
                assignment['title'],
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              subtitle: Text(
                'Deadline: ${assignment['deadline']}',
                style: const TextStyle(
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _addAssignment();
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _addAssignment() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String newTitle = '';
        String newDeadline = '';

        return AlertDialog(
          title: const Text('Add Assignment'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                onChanged: (value) {
                  newTitle = value;
                },
                decoration: const InputDecoration(labelText: 'Title'),
              ),
              TextField(
                onChanged: (value) {
                  newDeadline = value;
                },
                decoration: const InputDecoration(labelText: 'Deadline'),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Add'),
              onPressed: () {
                if (newTitle.isNotEmpty && newDeadline.isNotEmpty) {
                  setState(() {
                    assignments.add({
                      'title': newTitle,
                      'deadline': newDeadline,
                    });
                  });
                }
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
