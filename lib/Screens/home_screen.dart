import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'chat.dart';
import 'attendence.dart';
import 'assignment.dart';




class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Homepage'),
        actions: [
          TextButton.icon(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                // Navigate to the login screen or any other screen after logging out
                Navigator.of(context).pushReplacementNamed('/LoginScreen');
              },
              icon: const Icon(Icons.logout),
              label: const Text('log Out'))
        ],
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const HeaderSection(),
                    const SizedBox(height: 20),
                    BodySection(),
                  ],
                ),
              ),
            ),
            const FooterSection(),
          ],
        ),
      ),
    );
  }
}

class HeaderSection extends StatelessWidget {
  const HeaderSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: const Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundImage: AssetImage(''),
          ),
          SizedBox(width: 16),
          Text(
            'Admin',
            style: TextStyle(fontSize: 20),
          ),
        ],
      ),
    );
  }
}

class BodySection extends StatelessWidget {
  final List<String> daysOfWeek = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday'
  ];

  final List<List<String>> routine = [
    ['8:00 AM', 'Numerical Method'],
    ['10:00 AM', 'DBMS'],
    ['12:00 PM', 'Os'],
  ];

  final List<String> events = [
    'Event 1',
    'Event 2',
    'Event 3',
  ];

  BodySection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Routine',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Table(
              border: TableBorder.all(),
              defaultColumnWidth: const IntrinsicColumnWidth(),
              children: [
                const TableRow(
                  children: [
                    TableCell(
                      child: Center(
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text('Time'),
                        ),
                      ),
                    ),
                    TableCell(
                      child: Center(
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text('Subject'),
                        ),
                      ),
                    ),
                  ],
                ),
                for (var row in routine)
                  TableRow(
                    children: [
                      TableCell(
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(row[0]),
                          ),
                        ),
                      ),
                      TableCell(
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(row[1]),
                          ),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Events',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Container(
            decoration: BoxDecoration(
              border: Border.all(),
              borderRadius: BorderRadius.circular(8),
              color: Colors.grey[200],
            ),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: events.length,
              itemBuilder: (context, index) {
                final event = events[index];
                return Container(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Colors.grey[300] ?? Colors.grey,
                      ),
                    ),
                  ),
                  child: ListTile(
                    title: Text(
                      event,
                      style: const TextStyle(fontSize: 18),
                    ),
                    subtitle: Text(
                      'Event details for $event',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class FooterSection extends StatelessWidget {
  const FooterSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      color: Colors.grey[200],
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HomeScreen()),
              );
            },
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const HomeScreen()),
                );
              },
              child: const Icon(Icons.home),
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const GroupChatApp()),
              );
            },
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const GroupChatApp()),
                );
              },
              child: const Icon(Icons.message),
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const AssignmentScreen()),
              );
            },
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const AssignmentScreen()),
                );
              },
              child: const Icon(Icons.assignment),
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const AttendanceScreen()),
              );
            },
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const AttendanceScreen()),
                );
              },
              child: const Icon(Icons.check),
            ),
          ),
        ],
      ),
    );
  }
}
