import 'dart:io';
import 'package:flutter/material.dart';
import 'package:pdf/widgets.dart' as pdfLib;
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Attendance App',
      home: AttendanceScreen(),
    );
  }
}

class Student {
  final String name;

  Student(this.name);
}

class AttendanceScreen extends StatefulWidget {
  @override
  _AttendanceScreenState createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  List<Student> students = [
    Student('Alice'),
    Student('Bob'),
    Student('Charlie'),
    Student('David'),
  ];

  DateTime _selectedDate = DateTime(2023, 7, 1);
  Map<Student, bool> studentAttendance = {};

  @override
  void initState() {
    super.initState();
    for (var student in students) {
      studentAttendance[student] = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Attendance'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Selected Date: ${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              _selectDate(context);
            },
            child: Text('Change Date'),
          ),
          ElevatedButton(
            onPressed: () {
              _downloadPdf();
            },
            child: Text('Download PDF'),
          ),
          _buildAttendanceTable(),
        ],
      ),
    );
  }

  Widget _buildAttendanceTable() {
    return DataTable(
      columns: [
        DataColumn(label: Text('Student Name')),
        DataColumn(label: Text('Present')),
      ],
      rows: _buildAttendanceRows(),
    );
  }

  List<DataRow> _buildAttendanceRows() {
    List<DataRow> rows = [];
    students.forEach((student) {
      rows.add(DataRow(
        cells: [
          DataCell(Text(student.name)),
          DataCell(
            Checkbox(
              value: studentAttendance[student] ?? false,
              onChanged: (bool? value) {
                if (value != null) {
                  setState(() {
                    studentAttendance[student] = value;
                  });
                }
              },
            ),
          ),
        ],
      ));
    });
    return rows;
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2023, 7, 1),
      lastDate: DateTime(2023, 7, 10),
    );
    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  pdfLib.Document generatePdf() {
    final pdf = pdfLib.Document();

    pdf.addPage(
      pdfLib.MultiPage(
        build: (context) => [
          pdfLib.Table.fromTextArray(
            context: context,
            data: <List<String>>[
              <String>['Student Name', 'Attendance'],
              for (var student in students)
                [
                  student.name,
                  studentAttendance[student] == true ? 'Present' : 'Absent'
                ],
            ],
          ),
        ],
      ),
    );

    return pdf;
  }

  void _downloadPdf() async {
    final pdf = generatePdf();
    final String dir = (await getApplicationDocumentsDirectory()).path;
    final String path = '$dir/attendance_report.pdf';
    final File file = File(path);

    final List<int> bytes = await pdf.save();
    await file.writeAsBytes(bytes);

    OpenFile.open(path);
  }
}
