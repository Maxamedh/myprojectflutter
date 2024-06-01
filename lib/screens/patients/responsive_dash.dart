import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class response extends StatelessWidget {
  const response({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => DashboardProvider(),
      child: MaterialApp(
        title: 'Hospital Management System',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: DashboardScreen(),
      ),
    );
  }
}

class DashboardProvider with ChangeNotifier {
  // Add your data fetching and state management here
}

class DashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hospital Management Dashboard'),
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            DrawerHeader(
              child: Text('Navigation'),
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
            ),
            ListTile(
              title: Text('Dashboard'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('Patients'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('Appointments'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('Doctors'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text(
                'Overview',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  SummaryCard(
                    color: Colors.blue,
                    icon: Icons.local_hospital,
                    title: 'Total Patients',
                    value: '150',
                  ),
                  SummaryCard(
                    color: Colors.green,
                    icon: Icons.event_available,
                    title: 'Appointments',
                    value: '35',
                  ),
                  SummaryCard(
                    color: Colors.red,
                    icon: Icons.person,
                    title: 'Doctors',
                    value: '10',
                  ),
                ],
              ),
              SizedBox(height: 16),
              Text(
                'Patient Records',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              PatientDataTable(),
            ],
          ),
        ),
      ),
    );
  }
}

class SummaryCard extends StatelessWidget {
  final Color color;
  final IconData icon;
  final String title;
  final String value;

  SummaryCard({
    required this.color,
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color,
      child: Container(
        width: 100,
        padding: EdgeInsets.all(16),
        child: Column(
          children: <Widget>[
            Icon(icon, size: 40, color: Colors.white),
            SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            Text(
              value,
              style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}

class PatientDataTable extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Replace with your data fetching logic
    final List<Map<String, String>> patientData = [
      {'ID': '1', 'Name': 'John Doe', 'Age': '30', 'Condition': 'Flu'},
      {'ID': '2', 'Name': 'Jane Smith', 'Age': '25', 'Condition': 'Cold'},
      {'ID': '3', 'Name': 'Sam Wilson', 'Age': '40', 'Condition': 'Asthma'},
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columns: [
          DataColumn(label: Text('ID')),
          DataColumn(label: Text('Name')),
          DataColumn(label: Text('Age')),
          DataColumn(label: Text('Condition')),
        ],
        rows: patientData.map((patient) {
          return DataRow(cells: [
            DataCell(Text(patient['ID']!)),
            DataCell(Text(patient['Name']!)),
            DataCell(Text(patient['Age']!)),
            DataCell(Text(patient['Condition']!)),
          ]);
        }).toList(),
      ),
    );
  }
}
