import 'dart:io';
import 'package:flutter/material.dart';
import 'package:pdf/widgets.dart' as pdfLib;
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';

import 'student_list.dart';
import 'utilis/pdf/pdf_dd.dart';


class Student {
  final String name;
  bool isPrsent;
  Student(this.name, {this.isPrsent = false});
}

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({Key? key}) : super(key: key);

  @override
  _AttendanceScreenState createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
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
        title: const Text('Attendance'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Selected Date: ${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              _selectDate(context);
            },
            child: const Text('Change Date'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute<void>(
                builder: (BuildContext context) => PdfPreviewPage(
                    title: const ["Name", "Attendance"],
                    ledgerData: students
                        .map((e) => [e.name, e.isPrsent ? "Present" : "Absent"])
                        .toList()
                    //  [
                    //   ["Anish", "Present"],
                    //   ["Anish", "Present"],
                    //   ["Anish", "Present"],
                    //   ["Anish", "Present"],
                    //   ["Anish", "Present"],
                    // ],
                    ),
              ));
              _downloadPdf();
            },
            child: const Text('Download PDF'),
          ),
          _buildAttendanceTable(),
        ],
      ),
    );
  }

  Widget _buildAttendanceTable() {
    return DataTable(
      columns: const [
        DataColumn(label: Text('Student Name')),
        DataColumn(label: Text('Present')),
      ],
      rows: _buildAttendanceRows(),
    );
  }

  List<DataRow> _buildAttendanceRows() {
    List<DataRow> rows = [];
    for (var student in students) {
      rows.add(DataRow(
        cells: [
          DataCell(Text(student.name)),
          DataCell(
            Checkbox(
              value: studentAttendance[student] ?? false,
              onChanged: (bool? value) {
                if (value != null) {
                  setState(() {
                    student.isPrsent = value;
                  });
                }
              },
            ),
          ),
        ],
      ));
    }
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
