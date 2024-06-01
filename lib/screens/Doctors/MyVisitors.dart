import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as  http;
import '../../lab/retrive_labtests.dart';
import 'package:hospital/screens/Doctors/Doctor_chatScreen.dart';

TextEditingController searchController = new TextEditingController();
class MyVisitorssScreen extends StatefulWidget {
  const MyVisitorssScreen({super.key,required this.doctor_no});

  final doctor_no;

  @override
  State<MyVisitorssScreen> createState() => _MyVisitorsScreenState();
}

class _MyVisitorsScreenState extends State<MyVisitorssScreen> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1368A1),
        title: const Center(child: Text('Visitors Screen',style: TextStyle(color: Colors.white),),),
      ),
      body:  Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: searchController,
              decoration: const InputDecoration(labelText: 'Search by name'),
            ),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: FutureBuilder(
                    future: operationsLab.instance.fetch_Data(""
                        "select visits.v_no,name,patient,doctor.doctor_no,staff_name,v_date from "
                        "staff,doctor,visits,patient_table where "
                        "staff.staff_no=doctor.staff_no and doctor.doctor_no=visits.doctor_no and patient_table.p_no=visits.patient and doctor.doctor_no='${widget.doctor_no}'"),
                    builder: (context, snapshot){
                      if(snapshot.hasData){
                        List<dynamic> data =snapshot.data!;

                        return SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: Card(

                            child: DataTable(
                              columnSpacing: (MediaQuery.of(context).size.width / 10) * 0.5,
                              dataRowHeight: 80,
                              columns: const  <DataColumn>[

                                DataColumn(
                                  label: Text(
                                    'ID',
                                    style: TextStyle(fontStyle: FontStyle.italic),
                                  ),
                                ),
                                DataColumn(
                                  label: Text(
                                    'Patient Name',
                                    style: TextStyle(fontStyle: FontStyle.italic),
                                  ),

                                ),

                                DataColumn(
                                  label: Text(
                                    'appointment Date',
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
                                  .map((visit) => DataRow(
                                cells: <DataCell>[
                                  DataCell(Text(visit['v_no'].toString())),
                                  DataCell(Text(visit['name'].toString())),
                                  DataCell(Text(visit['v_date'].toString())),
                                  DataCell(Row(children: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.push(context, MaterialPageRoute(builder: (context)=>
                                            DoctorChatScreen(doctor_no: visit['doctor_no'].toString())));
                                      },
                                      style: TextButton.styleFrom(
                                        foregroundColor: Colors.white, backgroundColor: Color(0xFF1368A1),
                                      ),
                                      child: const Text('Chat'),
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}
