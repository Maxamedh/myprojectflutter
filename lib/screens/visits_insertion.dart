import 'package:flutter/material.dart';
import 'package:hospital/models/visits_model.dart';
import 'package:hospital/screens/visits.dart';
import 'package:http/http.dart' as http;
import 'package:date_time_picker_widget/date_time_picker_widget.dart';

import '../models/patient_model.dart';

var jinsiga = 'Male';
var jinsi = ['Male', 'Female'];
TextEditingController patient = new TextEditingController();
TextEditingController doctor = new TextEditingController();
TextEditingController v_date = new TextEditingController();

class InsertVisitRecordScreen extends StatefulWidget {
  const InsertVisitRecordScreen({super.key});

  @override
  State<InsertVisitRecordScreen> createState() =>
      _InsertVisitRecordScreenState();
}

class _InsertVisitRecordScreenState extends State<InsertVisitRecordScreen> {
  @override
  void initState() {
    // TODO: implement initState
    operations.instance.fetchDoctor();
    operations.instance.Patient_info();
    super.initState();
  }

  final _formKey = GlobalKey<FormState>();
  var dropDowndocValue;
  var dropDownpaValue;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        v_date.text = picked.toString().substring(0, 10);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    int a = 0;

    Future<void> _submit() async {
      final isValid = _formKey.currentState!.validate();

      if (isValid) {
        final result = await operationsvisits.instance.add_Visit(Visit(
            vNo: a.toString(),
            name: dropDownpaValue,
            staffName: dropDowndocValue,
            vDate: v_date.text));
        setState(() {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text("${result}")));
          operations.instance.fetchVisits();
          Navigator.push(context, MaterialPageRoute(builder: (context) => VisitScreen()));
          a++;
        });
      } else {
        print('not validate');
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Update the Patient')),
        backgroundColor: Color(0xFF3AB14B),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(30),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                FutureBuilder(
                  future: operations.instance.Patient_info(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      List<dynamic> pa = snapshot.data!;

                      return DropdownButtonFormField(
                        value: null,
                        icon: const Icon(Icons.keyboard_arrow_down),
                        items: pa.map((pat) {
                          return DropdownMenuItem(
                            value: pat['p_no'].toString(),
                            child: Row(
                              children: [
                                Icon(Icons.people),
                                SizedBox(width: 10),
                                Text(pat['name'].toString()),
                              ],
                            ),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            dropDownpaValue = value;
                            print(dropDownpaValue);
                          });
                        },
                        decoration: InputDecoration(
                          hintText: dropDownpaValue != null
                              ? dropDownpaValue
                              : 'Select a patient', // Hint text based on selected value
                          border: OutlineInputBorder(),
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
                  },
                ),
                SizedBox(height: 10),
                FutureBuilder(
                  future: operations.instance.fetchDoctor(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      List<dynamic> data = snapshot.data!;

                      return DropdownButtonFormField(
                        value: null,
                        icon: const Icon(Icons.keyboard_arrow_down),
                        items: data.map((doct) {
                          return DropdownMenuItem(
                            value: doct['doctor_no'].toString(),
                            child: Row(
                              children: [
                                Icon(Icons.people),
                                SizedBox(width: 10),
                                Text(doct['staff_name'].toString()),
                              ],
                            ),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            dropDowndocValue = value;
                            print(value);
                          });
                        },
                        decoration: InputDecoration(
                          hintText: dropDowndocValue != null
                              ? dropDowndocValue
                              : 'Select a doctor', // Hint text based on selected value
                          border: OutlineInputBorder(),
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
                  },
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: v_date,
                  decoration: InputDecoration(
                    labelText: 'Visit Date',
                    suffixIcon: IconButton(
                      icon: Icon(Icons.calendar_today),
                      onPressed: () => _selectDate(context),
                    ),
                    border: OutlineInputBorder(),
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
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: _submit,
                  child: Text('Save',style: TextStyle(color: Colors.white),),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF1368A1),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
