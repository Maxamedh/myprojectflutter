import 'dart:convert';
import 'dart:io';
import 'package:hospital/lab/retrive_labtests.dart';
import 'package:hospital/screens/Admin/update_patient.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:hospital/models/patient_model.dart';

import '../patients/patient_registration Screen.dart';

var jinsiga = 'Male';
var jinsi = ['Male','Female'];

class PatientRegistrationScreen extends StatefulWidget {
  const PatientRegistrationScreen({super.key});

  @override
  State<PatientRegistrationScreen> createState() => _PatientRegistrationScreenState();
}
class _PatientRegistrationScreenState extends State<PatientRegistrationScreen> {
  final _form = GlobalKey<FormState>();
  final  address = operations.instance.address_info();

  var dropDownValue;
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        birth_date.text = picked.toString().substring(0,
            10);
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    operations.instance.Patient_info();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {


    Future<void> delete_record(var id) async{

      final response = await http.post(Uri.parse('http://192.168.43.239/hospital_api/patient_oper/delete_patient.php'),
        body: {
          'id':id,
        },
      );
      print(response.body);
      if(response.statusCode==200){
        Map<String,dynamic> data =json.decode(response.body);
        print(data);
        setState(() {
          if(data['success']){
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('data deleted successfully')));
            operations.instance.Patient_info();
          }else{
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Data Not Deleted Successfully  ${data}')));
          }
        });

      }

    }

    final List<Map<String, dynamic>> data  =[];

     //List<dynamic> patients =[];
    final patients=  operations.instance.Patient_info();



    return Scaffold(
      appBar: AppBar(
        title: const Center(child:  Text('Patient registration'),),
      ),
      body: ListView(
        children: [
          TextButton.icon(onPressed: (){
             Navigator.push(context, MaterialPageRoute(builder: (context)=>RegisterPatientFormScreen()));
          }, icon: const Icon(Icons.add), label: const Text('Add Patient',style:
           TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
             color: Colors.blue
          ),
          )
          ),
          SizedBox(height: 20,),
           SingleChildScrollView(
             scrollDirection: Axis.horizontal,
              child: FutureBuilder(
                  future: operationsLab.instance.fetch_Data("SELECT * FROM patient_account join patient_table on patient_account.patient_id=patient_table.p_no"),
                  builder: (context, snapshot){
                    if(snapshot.hasData){
                      List<dynamic> data =snapshot.data!;

                      return SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Card(

                          child: DataTable(
                            columnSpacing: (MediaQuery.of(context).size.width / 10) * 0.5,
                            dataRowHeight: 80,
                            columns:  const <DataColumn>[

                              DataColumn(
                                label: Text(
                                  'ID',
                                  style: TextStyle(fontStyle: FontStyle.italic),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'Name',
                                  style: TextStyle(fontStyle: FontStyle.italic),
                                ),

                              ),
                              DataColumn(
                                label: Text(
                                  'Tell',
                                  style: TextStyle(fontStyle: FontStyle.italic),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'sex',
                                  style: TextStyle(fontStyle: FontStyle.italic),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'Email',
                                  style: TextStyle(fontStyle: FontStyle.italic),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'password',
                                  style: TextStyle(fontStyle: FontStyle.italic),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'Username',
                                  style: TextStyle(fontStyle: FontStyle.italic),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'address',
                                  style: TextStyle(fontStyle: FontStyle.italic),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'Birth_date',
                                  style: TextStyle(fontStyle: FontStyle.italic),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'reg_date',
                                  style: TextStyle(fontStyle: FontStyle.italic),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'Action',
                                  style: TextStyle(fontStyle: FontStyle.italic),
                                ),
                              ),
                            ],
                            rows: data
                                .map((patient) => DataRow(
                              cells: <DataCell>[
                                DataCell(Text(patient['p_no'].toString())),
                                DataCell(Text(patient['name'].toString())),
                                DataCell(Text(patient['tell'].toString())),
                                DataCell(Text(patient['sex'].toString())),
                                DataCell(Text(patient['email'].toString())),
                                DataCell(Text(patient['username'].toString())),
                                DataCell(Text(patient['password'].toString())),
                                DataCell(Text(patient['add_no'].toString())),
                                DataCell(Text(patient['birth_date'].toString())),
                                DataCell(Text(patient['reg_date'].toString())),
                                DataCell(Row(children: [
                                  IconButton(onPressed: (){
                                    Navigator.push(context, MaterialPageRoute(builder: (context)=> Update_record_screen(
                                      id: patient['p_no'].toString(),
                                      name: patient['name'].toString(),
                                      tell: patient['tell'].toString(),
                                      username: patient['username'].toString(),
                                      password: patient['password'].toString(),
                                      email: patient['email'].toString(),
                                      sex: patient['sex'].toString(),
                                      address: patient['district'].toString(),
                                      acc_id: patient['p_acc'].toString(),
                                      birth_date: patient['birth_date'],
                                    )));
                                  },icon:
                                  Icon(Icons.edit),color: Colors.blue,

                                  ),
                          SizedBox(width: 5,),
                          IconButton(onPressed: (){
                            delete_record(patient['p_no']);
                          },icon: Icon(Icons.delete),color: Colors.red,

                          ),

                                ],)),

                              ],
                            ))
                                .toList(),



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

          )
        ],
      ),
    );
  }
}
