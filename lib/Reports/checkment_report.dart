import 'package:flutter/material.dart';
import 'package:hospital/Reports/reports_functions.dart';
import 'package:hospital/lab/retrive_labtests.dart';

class CheckmentReport extends StatefulWidget {
  const CheckmentReport({super.key});

  @override
  State<CheckmentReport> createState() => _CheckmentReportState();
}

class _CheckmentReportState extends State<CheckmentReport> {
  String? dropDownspaValue;
  Widget Activeone = checkments();

  void fetchCheckmentById(String id) {
    setState(() {
      Activeone = checkmentById(id);
    });
  }

  void showCheckments() {
    setState(() {
      Activeone = checkments();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkments Report'),
        backgroundColor: Colors.blueAccent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select a Patient',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Flexible(
                  flex: 2,
                  child: FutureBuilder(
                    future: operationsLab.instance.fetch_Data(
                        "SELECT lab_results.result_id, name  FROM patient_table,lab_samples,lab_results WHERE patient_table.p_no=lab_samples.patient_id and lab_samples.sample_id=lab_results.sample_id"
                    ),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        List<dynamic> staff = snapshot.data!;
                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 2),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.grey),
                          ),
                          child: DropdownButtonFormField<String>(
                            value: dropDownspaValue,
                            icon: const Icon(Icons.keyboard_arrow_down),
                            items: staff.map<DropdownMenuItem<String>>((dynamic staf) {
                              return DropdownMenuItem<String>(
                                value: staf['result_id'].toString(),
                                child: Row(
                                  children: [
                                    const Icon(Icons.people, color: Colors.blueAccent),
                                    const SizedBox(width: 10),
                                    Text(staf['name'].toString()),
                                  ],
                                ),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              setState(() {
                                dropDownspaValue = newValue;
                                if (dropDownspaValue != null) {
                                  fetchCheckmentById(dropDownspaValue!);
                                }
                              });
                            },
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(vertical: 10),
                            ),
                          ),
                        );
                      } else if (snapshot.hasError) {
                        return Center(
                          child: Text("${snapshot.error}"),
                        );
                      }
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Flexible(
                  child: ElevatedButton(
                    onPressed: showCheckments,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('Show All', style: TextStyle(fontSize: 16)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Activeone,
          ],
        ),
      ),
    );
  }
}

