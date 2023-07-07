import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Assignment App',
      home: AttendanceScreen(),
    );
  }
}

class AttendanceScreen extends StatefulWidget {
  @override
  _AttendanceScreenState createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  Map<DateTime, List<String>> attendanceData = {
    DateTime(2023, 7, 1): ['Math', 'Science'],
    DateTime(2023, 7, 5): ['Math', 'English'],
    DateTime(2023, 7, 8): ['Science'],
    DateTime(2023, 7, 10): ['Math', 'Science', 'English'],
  };

  DateTime _selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Attendance'),
      ),
      body: Column(
        children: [
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              _showDatePicker(context);
            },
            child: Text('Select Date'),
          ),
          SizedBox(height: 16),
          Text(
            'Attendance for ${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}:',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Expanded(
            child: ListView.builder(
              itemCount: attendanceData[_selectedDate]?.length ?? 0,
              itemBuilder: (context, index) {
                String? subject = attendanceData[_selectedDate]?[index];
                return ListTile(
                  leading: Icon(Icons.check_circle, color: Colors.green),
                  title: Text(subject ?? ''),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showDatePicker(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2023, 7, 1),
      lastDate: DateTime(2023, 7, 10),
    );
    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }
}
