import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hospital/lab/retrive_labtests.dart';
import 'package:http/http.dart' as http;

class RegisterPatientFormScreen extends StatefulWidget {
  const RegisterPatientFormScreen({super.key});

  @override
  State<RegisterPatientFormScreen> createState() =>_RegisterPatientFormScreenState();
}

class _RegisterPatientFormScreenState extends State<RegisterPatientFormScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController name = TextEditingController();
  final TextEditingController tell = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController birth_date = TextEditingController();
  final TextEditingController username = TextEditingController();
  String jinsiga = 'Male';
  List<String> jinsi = ['Male', 'Female'];

  String dropDownaddValue='';
  String last_id='';

  Future<void> _selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        birth_date.text = "${picked.toLocal()}".split(' ')[0];
      });
    }
  }
  Future<void> insertData() async {
    final isValid =_formKey.currentState!.validate();
    if(isValid){
      final data={
        'table': 'patient_table',
        'data': {
          'name': name.text,
          'tell': tell.text,
          'add_no': dropDownaddValue,
          'sex': jinsiga,
          'birth_date': birth_date.text,
        }
      };
      try {
        var response = await http.post(Uri.parse('http://192.168.43.239/hospital_api/All/insertion.php'),
            body: json.encode(data));
        print(response.body);
        setState(() {
          final data =  operationsLab.instance.fetch_Data(
              'SELECT MAX(p_no) AS last_id FROM patient_table');
          data.then((value) async{
            value.map((e) {
              last_id= e['last_id'];
              if (kDebugMode) {
                print(last_id);
              }
              //descrip=e['description'];

            } ).toList();
            final patient_user={
              'table': 'patient_account',
              'data': {
                'patient_id': last_id,
                'username': username.text,
                'password': password.text,
                'email': email.text,
              }
            };
            var result = await http.post(Uri.parse('http://192.168.43.239/hospital_api/All/insertion.php'),
                body: json.encode(patient_user));
            print(result.body);
          } );
        });
        if (response.statusCode == 200) {

          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Data inserted successfully')));

          print("Data inserted successfully");
          Navigator.pop(context);
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
        title: const Text('Patient Form'),
        backgroundColor: Color(0xFF1368A1),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
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
                    DropdownButtonFormField(
                      value: jinsiga,
                      icon: const Icon(Icons.keyboard_arrow_down),
                      items: jinsi.map((String jinsi) {
                        return DropdownMenuItem(
                          value: jinsi,
                          child: Row(
                            children: [
                              Icon(Icons.people),
                              SizedBox(width: 10),
                              Text(jinsi),
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
                        labelText: 'Gender',
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
                        if (_formKey.currentState!.validate()) {
                          insertData();
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
          );
        },
      ),
    );
  }
}
