import 'package:flutter/material.dart';
import 'package:hospital/Reports/reports_functions.dart';
import 'package:hospital/lab/retrive_labtests.dart';

class VisitsReport extends StatefulWidget {
  const VisitsReport({super.key});

  @override
  State<VisitsReport> createState() => _VisitsReportState();
}

class _VisitsReportState extends State<VisitsReport> {
  String? dropDownspaValue;
  Widget Activeone = visits();

  void fetchVisitById(String id) {
    setState(() {
      Activeone = visitsById(id);
    });
  }

  void showVisits() {
    setState(() {
      Activeone = visits();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Visits Report'),
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
                Expanded(
                  child: FutureBuilder(
                    future: operationsLab.instance.fetch_Data(
                        "SELECT visits.v_no, name FROM visits, patient_table WHERE patient_table.p_no = visits.patient"
                    ),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        List<dynamic> staff = snapshot.data!;
                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.grey),
                          ),
                          child: DropdownButtonFormField<String>(
                            value: dropDownspaValue,
                            icon: const Icon(Icons.keyboard_arrow_down),
                            items: staff.map<DropdownMenuItem<String>>((dynamic staf) {
                              return DropdownMenuItem<String>(
                                value: staf['v_no'].toString(),
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
                                  fetchVisitById(dropDownspaValue!);
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
                ElevatedButton(
                  onPressed: showVisits,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Show All Visits', style: TextStyle(fontSize: 16)),
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


