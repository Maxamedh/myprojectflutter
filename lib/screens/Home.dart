import 'package:flutter/material.dart';
import 'package:hospital/screens/patients/login.dart';
import 'package:hospital/screens/admin/login.dart';
import 'package:hospital/screens/doctors/login.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF1368A1),
        title: const Text('Our Home', textAlign: TextAlign.center),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 150,
              child: Image.asset('assets/logohoshospital.png'),
            ),
            const SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildCard(context, 'Patients', Icons.people, Colors.blue),
                _buildCard(context, 'Doctors', Icons.medical_services, Colors.green),
                _buildCard(context, 'Admin', Icons.admin_panel_settings, Colors.red),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          height: 50,
          color: const Color(0xFF3AB14B),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.location_on, color: Colors.white),
              SizedBox(width: 8),
              Text('The Location: ', style: TextStyle(fontSize: 16, color: Colors.white)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCard(BuildContext context, String title, IconData icon, Color color) {
    return GestureDetector(
      onTap: () {
        if (title == 'Patients') {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginPatientScreen()));
        } else if (title == 'Doctors') {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginDoctorScreen()));
        } else if (title == 'Admin') {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginAdminScreen()));
        }
      },
      child: Container(
        width: 130,
        height: 130,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 7,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 70, color: Colors.white),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
