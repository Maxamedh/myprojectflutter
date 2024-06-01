import 'package:flutter/material.dart';
import 'package:hospital/Reports/reports_functions.dart';
import 'package:hospital/lab/retrive_labtests.dart';

class StatementReport extends StatefulWidget {
  const StatementReport({super.key});

  @override
  State<StatementReport> createState() => _ReceiptsReportState();
}

class _ReceiptsReportState extends State<StatementReport> {
  String? dropDownspaValue;
  Widget Activeone = statements();

  void fetchStatementById(String id) {
    setState(() {
      Activeone = statementsById(id);
    });
  }

  void showStatement() {
    setState(() {
      Activeone = statements();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Statements Report'),
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
                        "SELECT pa.p_no,name from patient_table "
                            "pa join receipts r on pa.p_no=r.p_no join patient_charge pch on pch.p_no=pa.p_no"
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
                                value: staf['p_no'].toString(),
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
                                  fetchStatementById(dropDownspaValue!);
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
                    onPressed: showStatement,
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

