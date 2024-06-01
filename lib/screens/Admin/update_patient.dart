import 'dart:convert';
import 'dart:io';
import 'package:hospital/screens/Admin/patient_registration.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:hospital/models/patient_model.dart';

import '../../lab/retrive_labtests.dart';

var jinsiga='';
var jinsi = ['Male', 'Female'];
TextEditingController name = TextEditingController();
TextEditingController tell = TextEditingController();
TextEditingController email = TextEditingController();
TextEditingController password = TextEditingController();
TextEditingController birth_date = TextEditingController();
TextEditingController username = TextEditingController();

class Update_record_screen extends StatefulWidget {
  const Update_record_screen({
    super.key,
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.username,
    required this.tell,
    required this.sex,
    required this.address,
    required this.birth_date,
    required this.acc_id
  });

  final String id;
  final String acc_id;
  final String name;
  final String tell;
  final String email;
  final String username;
  final String password;
  final String sex;
  final String address;
  final String birth_date;

  @override
  State<Update_record_screen> createState() => _Update_record_screenState();
}

class _Update_record_screenState extends State<Update_record_screen> {
  final _form = GlobalKey<FormState>();
  final List<Map<String, dynamic>> data = [];
  var dropDownValue;
  var dropDownaddValue;
  @override
  void initState() {
    super.initState();
    name.text = widget.name;
    tell.text = widget.tell;
    email.text = widget.email;
    username.text = widget.username;
    password.text = widget.password;
    jinsiga = widget.sex;
    dropDownValue = widget.address;
    birth_date.text = widget.birth_date;
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        birth_date.text = "${picked.toLocal()}".split(' ')[0];
      });
    }
  }

  Future<void> updateData() async {
    final isValid =_form.currentState!.validate();
    if(isValid){
      final data={
        'table': 'patient_table',
        'data': {
          'name': name.text,
          'tell': tell.text,
          'add_no': dropDownaddValue,
          'sex': jinsiga,
          'birth_date': birth_date.text,
        },
        'updated_id':'p_no',
        'id':widget.id
      };
      try {
        var response = await http.post(Uri.parse('http://192.168.43.239/hospital_api/All/update.php'),
            body: json.encode(data));
        final patuser_data={
          'table': 'patient_account',
          'data': {
            'patient_id': widget.id,
            'username': username.text,
            'password': password.text,
            'email': email.text,
          },
          'updated_id':'p_acc',
          'id':widget.acc_id
        };
        var response2 = await http.post(Uri.parse('http://192.168.43.239/hospital_api/All/update.php'),
            body: json.encode(patuser_data));
        print(response2.body);
        setState(() {

        });
        if (response.statusCode== 200 && response2.statusCode==200) {

          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Data Updated successfully')));

          print("Data Updated successfully");
          Navigator.push(context, MaterialPageRoute(builder: (context)=>PatientRegistrationScreen()));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Data failed response body  ${response.body}')));
          print("Failed to insert data");
          print("Status code: ${response.statusCode}");
          print("Response body: ${response.body}");
        }
      } catch (e) {
        print("There was an error: $e");
      }
    }else{
      print('not valid');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update the Patient'),
        backgroundColor: const Color(0xFF1368A1),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _form,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: name,
                  decoration: InputDecoration(
                    labelText: 'Name',
                    hintText: 'Enter Name',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.text,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter a name';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: tell,
                  decoration: InputDecoration(
                    labelText: 'Tell',
                    hintText: 'Enter tell',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.trim().length < 10) {
                      return 'Please enter a valid number';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: null,
                  icon: const Icon(Icons.keyboard_arrow_down),
                  items: jinsi.map((String jinsi){
                    return DropdownMenuItem(
                      value: jinsi,
                      child: Row(
                        children: [
                          Icon(Icons.people),
                          SizedBox(width: 10,),
                          Text(jinsi)
                        ],
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      jinsiga = value!;
                    });
                  },
                  decoration: InputDecoration(
                    hintText: jinsiga != null ? jinsiga: 'Select a sex',
                    border: OutlineInputBorder(),
                  ),
                ),

                SizedBox(height: 16),
                TextFormField(
                  controller: email,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    hintText: 'Enter Email',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null ||
                        value.trim().isEmpty ||
                        !value.contains('@')) {
                      return 'Please enter a valid email address';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: username,
                  decoration: InputDecoration(
                    labelText: 'Username',
                    hintText: 'Enter Username',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.text,
                  validator: (value) {
                    if (value == null ||
                        value.trim().isEmpty) {
                      return 'Please enter  username';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: password,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(),
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.trim().length < 2) {
                      return 'Password must be at least 2 characters long';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                FutureBuilder(
                    future:  operationsLab.instance.fetch_Data('SELECT * FROM address'),
                    builder: (context, snapshot){
                      if(snapshot.hasData){
                        List<dynamic> adddress =snapshot.data!;

                        return SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: DropdownButtonFormField(
                            value: null,
                            icon: const Icon(Icons.keyboard_arrow_down),
                            items: adddress.map((add) {
                              return DropdownMenuItem(
                                value: add['add_no'].toString(),
                                child: Row(
                                  children: [
                                    Icon(Icons.people),
                                    SizedBox(width: 10,),
                                    Text(add['district'].toString())
                                  ],
                                ),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                dropDownaddValue=value!;
                                print(dropDownaddValue);
                              });
                            },
                            decoration: InputDecoration(
                              hintText: dropDownaddValue != null ? dropDownaddValue: 'Select a address', // Hint text based on selected value
                              border: OutlineInputBorder(),
                            ),
                          ),
                        );
                      }else if (snapshot.hasError) {
                        return Center(
                          child: Text("${snapshot.error}"),
                        );
                      }
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: birth_date,
                  decoration: InputDecoration(
                    labelText: 'Birth Date',
                    border: OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: Icon(Icons.calendar_today),
                      onPressed: () => _selectDate(context),
                    ),
                  ),
                  keyboardType: TextInputType.text,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter a date';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    if (_form.currentState!.validate()) {
                    setState(() {
                      updateData();
                    });
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF3AB14B),
                  ),
                  child: Text('Submit'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
