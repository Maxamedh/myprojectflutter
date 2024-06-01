import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hospital/screens/Doctors/doctorDashbord.dart';
import 'package:http/http.dart' as http;
import 'package:hospital/screens/Admin/patient_registration.dart';

import '../../lab/retrive_labtests.dart';

class DoctorProfileFormScreen extends StatefulWidget {
  final String dname;
  final String email;
  final String userId;
  final String password;
  final String username;

  DoctorProfileFormScreen({
    required this.dname,
    required this.email,
    required this.userId,
    required this.password,
    required this.username,
  });

  @override
  State<DoctorProfileFormScreen> createState() => _DoctorProfileScreenState();
}

class _DoctorProfileScreenState extends State<DoctorProfileFormScreen> {

  TextEditingController dname = new TextEditingController();
  TextEditingController email = new TextEditingController();
  TextEditingController userId = new TextEditingController();
  TextEditingController password = new TextEditingController();
  TextEditingController username = new TextEditingController();
 @override
  void initState() {
    // TODO: implement initState
   dname.text=widget.dname;
   email.text=widget.email;
   userId.text=widget.userId;
   password.text=widget.password;
   username.text=widget.username;
    super.initState();
  }

  Future<void> updateData() async {

      final data={
        'table': 'users',
        'data': {
          'username': username.text,
          'password':password.text,
          'email': email.text,

        },
        'updated_id':'user_no',
        'id':widget.userId
      };
      try {
        var response = await http.post(Uri.parse('http://192.168.43.239/hospital_api/All/update.php'),
            body: json.encode(data));
        print(response.body);


        if (response.statusCode == 200) {
          dname.clear();
          email.clear();
          password.clear();
          username.clear();
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Data Updated successfully')));

          print("Data Updated successfully");

        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Data failed response body  ${response.body}')));
          print("Failed to insert data");
          print("Status code: ${response.statusCode}");
          print("Response body: ${response.body}");
        }
      } catch (e) {
        print("There was an error: $e");
      }
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('Doctor Form'),
        backgroundColor: Color(0xFF1368A1),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child:  Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Top section for doctor's picture
              Container(
                height: 200.0,
                decoration: BoxDecoration(
                  color: Color(0xFF3AB14B),
                  image: DecorationImage(
                    image: AssetImage('assets/doctor.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(height: 20.0),
              // Form section
              Expanded(
                child: SingleChildScrollView(
                  child: Card(
                    color: Colors.white,
                    elevation: 4.0,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          TextFormField(
                            controller: dname,
                            decoration: InputDecoration(
                              labelText: 'Doctor Name',
                              border: OutlineInputBorder(),
                            ),
                          ),
                          SizedBox(height: 16.0),
                          TextFormField(
                            controller: email,
                            decoration: InputDecoration(
                              labelText: 'Email',
                              border: OutlineInputBorder(),
                            ),
                          ),
                         
                          SizedBox(height: 16.0),
                          TextFormField(
                            controller: password,
                            decoration: InputDecoration(
                              labelText: 'Password',
                              border: OutlineInputBorder(),
                            ),
                            obscureText: true,
                          ),
                          SizedBox(height: 16.0),
                          TextFormField(
                            controller: username,
                            decoration: InputDecoration(
                              labelText: 'Username',
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 20.0),
                          ElevatedButton(onPressed: (){
                            setState(() {
                              updateData();
                            });
                          }, child: const Text('Change Any Of These You Want'))
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
  }
}

