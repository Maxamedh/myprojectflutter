import 'dart:convert';
import 'dart:io';
import 'package:hospital/lab/lab_results.dart';
import 'package:hospital/lab/retrive_labtests.dart';
import 'package:hospital/screens/Doctors/prescription.dart';

import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';

import '../../models/patient_model.dart';


TextEditingController result_date =new TextEditingController();
TextEditingController result =new TextEditingController();


class Update_Prescription_record_screen extends StatefulWidget {
  const Update_Prescription_record_screen({super.key,
    required this.pres_id,required this.v_no,
    required this.pr_date, required this.pr_name,
    required this.usages, required this.description
  });
  final String pres_id;
  final String v_no;
  final String pr_date;
  final String pr_name;
  final String usages;
  final String description;
  @override
  State<Update_Prescription_record_screen> createState() => _Update_Prescription__record_screenState();
}

class _Update_Prescription__record_screenState extends State<Update_Prescription_record_screen> {


  @override
  void initState() {
    // TODO: implement initState
    dropDownpaValue =widget.v_no;
    prDateController.text =widget.pr_date;
    prNameController.text =widget.pr_name;
    usagesController.text =widget.usages;
    descriptionController.text =widget.description;
    super.initState();
  }
  final _form = GlobalKey<FormState>();
  //final List<Map<String, dynamic>> data  =[];
  final List<Map<String, dynamic>> doctor_data  =[];
  var dropDownpaValue;
  final TextEditingController vNoController = TextEditingController();
  final TextEditingController prDateController = TextEditingController();
  final TextEditingController prNameController = TextEditingController();
  final TextEditingController usagesController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController searchController = TextEditingController();


  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        prDateController.text = picked.toString().substring(0,
            10);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    int a=0;
    Future<void> updateData() async {
      final isValid =_form.currentState!.validate();
      if(isValid){
        final data={
          'table': 'prescription',
          'data': {
            'v_no': dropDownpaValue,
            'pr_date': prDateController.text,
            'pr_name': prNameController.text,
            'usages': usagesController.text,
            'description': descriptionController.text,
          },
          'updated_id':'pr_no',
          'id':widget.pres_id
        };
        try {
          var response = await http.post(Uri.parse('http://192.168.43.239/hospital_api/All/update.php'),
              body: json.encode(data));
          print(response.body);
          setState(() {
            operationsLab.instance.fetch_Data('select * from lab_tests');
          });
          if (response.statusCode == 200) {

            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Data Updated successfully')));

            print("Data Updated successfully");
            Navigator.push(context, MaterialPageRoute(builder: (context)=>PrescriptionScreen()));
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

    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Add Results'),),
      ),
      body: Column(
        children: [
          Container(
            child: Form(
              key: _form,
              child: Column(
                children: [
                  FutureBuilder(
                      future: operations.instance.Patient_info(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          List<dynamic> pa = snapshot.data!;

                          return SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: DropdownButtonFormField(
                              value: null,
                              icon: const Icon(Icons.keyboard_arrow_down),
                              items: pa.map((pat) {
                                return DropdownMenuItem(
                                  value: pat['p_no'].toString(),
                                  child: Row(
                                    children: [
                                      Icon(Icons.people),
                                      SizedBox(width: 10,),
                                      Text(pat['name'].toString())
                                    ],
                                  ),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  dropDownpaValue = value!;
                                  print(dropDownpaValue);
                                });
                              },
                              decoration: InputDecoration(
                                hintText: dropDownpaValue ?? 'Select a patient', // Hint text based on selected value
                                border: OutlineInputBorder(),
                              ),
                            ),
                          );
                        } else if (snapshot.hasError) {
                          return Center(
                            child: Text("${snapshot.error}"),
                          );
                        }
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                  ),
                  TextFormField(
                    controller: prDateController,
                    decoration: InputDecoration(
                      label: Text('Prescription Date'),
                      suffixIcon: IconButton(
                        icon: Icon(Icons.calendar_today),
                        onPressed: () => _selectDate(context),
                      ),
                    ),
                    keyboardType: TextInputType.text,
                    autocorrect: false,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter a Date';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: prNameController,
                    decoration: InputDecoration(labelText: 'Prescription name'),
                  ),
                  TextFormField(
                    controller: usagesController,
                    decoration: InputDecoration(labelText: 'Usages'),
                  ),
                  TextFormField(
                    controller: descriptionController,
                    decoration: InputDecoration(labelText: 'Description'),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: blueColor),
                    onPressed: () {
                      updateData();
                    },
                    child: Text('Update', style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            ),

          ),


        ],
      ),
    );
  }
}
