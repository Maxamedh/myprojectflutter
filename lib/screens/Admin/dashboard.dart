import 'package:flutter/material.dart';
import 'package:hospital/screens/Admin/finance%20Dashboard.dart';
import 'package:hospital/screens/Admin/labdhashbord.dart';
import 'package:hospital/screens/Admin/patient_management.dart';
import 'package:hospital/screens/Admin/staff_drawer.dart';
import 'package:hospital/screens/Admin/staff_managment.dart';

import '../../lab/retrive_labtests.dart';

var list = [
  'PATIENTS',
  'DOCTORS',
  'RECEIPTS',
  'EXPENSES',
];
var icons = [
  Icons.person,
  Icons.people,
  Icons.receipt,
  Icons.money_off,
];

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late Future<String> patientCount;
  late Future<String> doctorCount;
  late Future<String> receiptSum;
  late Future<String> expenseSum;

  @override
  void initState() {
    super.initState();
    fetch_data();
  }

  void fetch_data() {
    setState(() {
      patientCount = operationsLab.instance
          .fetch_Data("SELECT count(p_no) as numberOfPatients from patient_table")
          .then((value) => value.isNotEmpty ? value[0]['numberOfPatients'] : '0');

      doctorCount = operationsLab.instance
          .fetch_Data("SELECT count(doctor_no) as numberOfDoctors from doctor")
          .then((value) => value.isNotEmpty ? value[0]['numberOfDoctors'] : '0');

      receiptSum = operationsLab.instance
          .fetch_Data("SELECT sum(amount) as receptedAmount from receipts")
          .then((value) => value.isNotEmpty ? value[0]['receptedAmount'] : '0');

      expenseSum = operationsLab.instance
          .fetch_Data("SELECT sum(amount) as expenseAmount from expense_payment")
          .then((value) => value.isNotEmpty ? value[0]['expenseAmount'] : '0');
    });
  }

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = Color(0xFF1368A1);
    final Color secondaryColor = Color(0xFF3AB14B);

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Center(
          child: Text(
            'Admin Dashboard',
            style: TextStyle(color: Colors.white),
          ),
        ),
        backgroundColor: primaryColor,
      ),
      drawer: MyDrawer(),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: [
          Container(
            padding: EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: primaryColor,
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Center(
              child: Text(
                'HOSPITAL SYSTEM',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          SizedBox(height: 20),
          Text(
            'SECTIONS OF MANAGEMENT',
            style: TextStyle(
              color: secondaryColor,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20),
          GridView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: MediaQuery.of(context).size.width > 600 ? 4 : 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 0.8,
            ),
            itemCount: list.length,
            itemBuilder: (BuildContext context, int index) {
              return FutureBuilder<String>(
                future: index == 0
                    ? patientCount
                    : index == 1
                    ? doctorCount
                    : index == 2
                    ? receiptSum
                    : expenseSum,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return _buildCard(
                      primaryColor,
                      Icons.hourglass_empty,
                      'Loading...',
                      '',
                      secondaryColor,
                    );
                  } else if (snapshot.hasError) {
                    return _buildCard(
                      primaryColor,
                      Icons.error,
                      'Error',
                      '',
                      secondaryColor,
                    );
                  } else {
                    return _buildCard(
                      primaryColor,
                      icons[index],
                      list[index],
                      snapshot.data ?? '0',
                      secondaryColor,
                    );
                  }
                },
              );
            },
          ),
          SizedBox(height: 20),
          Footer(),
        ],
      ),
    );
  }

  Widget _buildCard(Color color, IconData icon, String title, String data, Color iconColor) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      color: color,
      child: InkWell(
        onTap: () {},
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 50, color: iconColor),
                SizedBox(height: 10),
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                Text(
                  data,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class Footer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Color(0xFF1368A1),
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          Text(
            '© 2024 Hospital System. All rights reserved.',
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 5),
          Text(
            'Privacy Policy | Terms of Service',
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
