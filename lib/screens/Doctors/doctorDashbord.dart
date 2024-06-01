import 'package:flutter/material.dart';
import 'package:hospital/lab/retrive_labtests.dart';
import 'package:hospital/screens/Doctors/prescription.dart';
import 'package:hospital/screens/tabs.dart';

import '../patients/ApointmentScreen.dart';
import '../patients/LabResult_Screen.dart';
import '../patients/chat_screen.dart';
import 'Checkment_results.dart';
import 'Doctor_chatScreen.dart';
import 'Doctor_profile.dart';
import 'MyVisitors.dart';
import 'appointments.dart';

final List<IconData> icons = [
  Icons.medical_services,
  Icons.book,
  Icons.check,
  Icons.accessibility_new,
  Icons.payments_rounded,
  Icons.receipt,
];

const Color greenColor = Color(0xFF3AB14B);
const Color blueColor = Color(0xFF1368A1);

class Doctordashbord extends StatefulWidget {
  const Doctordashbord({Key? key, required this.email});

  final String email;

  @override
  State<Doctordashbord> createState() => _DoctordashbordState();
}

class _DoctordashbordState extends State<Doctordashbord> {
  late Future<List> doctor;
  String dname = '';
  String email = '';
  String user_id = '';
  String password = '';
  String username = '';
  String doctor_no = '';
  String NoOfVisits = '';
  String NoApp = '';
  String staff = '';

  late Future<List> visits;
  late Future<List> patientcount;

  @override
  void initState() {
    super.initState();
    doctor = operationsLab.instance.fetch_Data("SELECT * from staff,doctor,users,jobs where staff.staff_no=doctor.staff_no and staff.staff_no=users.emp_no and staff.Job_name=jobs.j_no and users.email='${widget.email}' ");
    doctor.then((value) {
      setState(() {
        dname = value.isNotEmpty ? value[0]['staff_name'] : '';
        email = value.isNotEmpty ? value[0]['email'] : '';
        username = value.isNotEmpty ? value[0]['username'] : '';
        password = value.isNotEmpty ? value[0]['password'] : '';
        doctor_no = value.isNotEmpty ? value[0]['emp_no'] : '';
        staff = value.isNotEmpty ? value[0]['doctor_no'] : '';
        user_id = value.isNotEmpty ? value[0]['user_no'] : '';
        print(doctor_no);
      });
    });

  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      visits = operationsLab.instance.fetch_Data("SELECT count(patient)visits from visits where doctor_no='$staff'");
      visits.then((value) {
        NoOfVisits = value.isNotEmpty ? value[0]['visits'] : '';
        print(NoOfVisits);
      });
    });
    setState(() {
      patientcount = operationsLab.instance.fetch_Data("SELECT count(patient_no)patients from appointment where doctor_no='$staff' and status='Active'");
      patientcount.then((value) {
        NoApp = value.isNotEmpty ? value[0]['patients'] : '';
        print(NoApp);
      });
    });


    var patient_Dashbord = ['VISITS', 'APPOINTMENT', 'CHECKMENT RESULT', 'MY DOCTOR', 'PAYMENT', 'INVOICE'];

    return FutureBuilder(
      future: doctor,
      builder: (context, AsyncSnapshot<List> snapshot) {
        return Scaffold(
          drawer: Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                DrawerHeader(
                  decoration: BoxDecoration(
                    color: blueColor,
                  ),
                  child: Text(
                    'Welcome, $dname',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                    ),
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.medical_services),
                  title: Text('PRESCRIPTION'),
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>PrescriptionScreen()));
                  },
                ),
                ListTile(
                  leading: Icon(Icons.book),
                  title: Text('APPOINTMENTS'),
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>
                        AppointmentsScreen(doctor_no: staff,)));
                  },
                ),
                ListTile(
                  leading: Icon(Icons.check),
                  title: Text('CHECKMENT RESULTS'),
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>Checkment_Results_Doctor(doctor_id: staff,)));
                  },
                ),
                ListTile(
                  leading: Icon(Icons.check),
                  title: const Text('VISITS'),
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>MyVisitorssScreen(doctor_no: staff,)));
                  },
                ),
                ListTile(
                  leading: Icon(Icons.check),
                  title: const Text('MY PROFILE'),
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>DoctorProfileFormScreen(dname: '$dname', email: '$email', userId: '$user_id', password: '$password', username: '$username',)));
                  },
                ),

              ],
            ),
          ),
          appBar: AppBar(
            backgroundColor: greenColor,
            title: Center(
              child: Text(
                '${dname} Dashboard',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          body: Center(
            child: Column(
              children: [
                SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.2,
                  color: blueColor,
                  child: Center(
                    child: Text(
                      'HOSPITAL SYSTEM',
                      style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'SECTIONS OF MANAGEMENT',
                  style: TextStyle(color: blueColor, fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Card(
                      color: blueColor,
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Expanded(
                                  child: Card(
                                    color: Colors.white,
                                    child: Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            'VISITS',
                                            style: TextStyle(color: blueColor, fontSize: 14, fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            NoOfVisits,
                                            style: TextStyle(color: blueColor, fontSize: 14, fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 10),
                                Expanded(
                                  child: Card(
                                    color: Colors.white,
                                    child: Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            'APPOINTMENTS',
                                            style: TextStyle(color: blueColor, fontSize: 14, fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            NoApp,
                                            style: TextStyle(color: blueColor, fontSize: 14, fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
