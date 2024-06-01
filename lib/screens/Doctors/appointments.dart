import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as  http;
import '../../lab/retrive_labtests.dart';

TextEditingController searchController = new TextEditingController();
class AppointmentsScreen extends StatefulWidget {
  const AppointmentsScreen({super.key,required this.doctor_no});

  final doctor_no;

  @override
  State<AppointmentsScreen> createState() => _AppointmentsScreenState();
}

class _AppointmentsScreenState extends State<AppointmentsScreen> {
  String startTime='';
  String endTime='';
  String room_name='';

  void approve_appoinment(String appId,timeDuration,patient_id,appdate) async{

    List<String>? parts = timeDuration?.split(' -');

    startTime = parts![0];
    endTime = parts[1];
    print("Start Time: $startTime");
    print("End Time: $endTime");
  setState(() {
    operationsLab.instance.fetch_Data("UPDATE doctor_availability set status='Active' WHERE start_time='$startTime'  and end_time='$endTime'");
    operationsLab.instance.fetch_Data("UPDATE appointment set status='Approved' WHERE app_no='$appId'");
  });
    final data={
      'table': 'visits',
      'data': {
        'patient': patient_id,
        'doctor_no': widget.doctor_no,
        'v_date': appdate,

      }
    };
    try {
      var response = await http.post(Uri.parse('http://192.168.43.239/hospital_api/All/insertion.php'),
          body: json.encode(data));
      print(response.body);

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Appointment is Approved successfully')));

        print("Data Approved successfully");

      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Data failed response body  ${response.body}')));
        print("Failed to Approved data");
        print("Status code: ${response.statusCode}");
        print("Response body: ${response.body}");
      }
   }
    catch (e) {
      print("There was an error: $e");
    }


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1368A1),
        title: const Center(child: Text('Appointment Screen',style: TextStyle(color: Colors.white),),),
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
                    future: operationsLab.instance.fetch_Data("SELECT app_no,p_no,name,staff_name,app_date,app_time_with_duration,status from staff st join doctor d on st.staff_no=d.staff_no join appointment ap on ap.doctor_no=d.doctor_no join patient_table p on p.p_no=ap.patient_no where status='Active' and d.doctor_no='${widget.doctor_no}'"),
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
                                    'Duration',
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
                                  .map((appo) => DataRow(
                                cells: <DataCell>[
                                  DataCell(Text(appo['app_no'].toString())),
                                  DataCell(Text(appo['name'].toString())),
                                  DataCell(Text(appo['app_date'].toString())),
                                  DataCell(Text(appo['app_time_with_duration'].toString())),
                                  DataCell(Row(children: [
                                    TextButton(
                                      onPressed: () {
                                          setState(() {
                                            approve_appoinment(appo['app_no'].toString(),
                                                appo['app_time_with_duration'].toString(),appo['p_no'].toString(),
                                                appo['app_date'].toString());
                                          });
                                      },
                                      style: TextButton.styleFrom(
                                        foregroundColor: Colors.white, backgroundColor: Color(0xFF1368A1),
                                      ),
                                      child: const Text('Approve'),
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
