import 'package:flutter/material.dart';
import '../../lab/retrive_labtests.dart';

class Checkment_Results_Doctor extends StatefulWidget {
  const Checkment_Results_Doctor({super.key, required this.doctor_id});

  final String doctor_id;

  @override
  _Checkment_Results_DoctorState createState() => _Checkment_Results_DoctorState();
}

class _Checkment_Results_DoctorState extends State<Checkment_Results_Doctor> {
  final TextEditingController searchController = TextEditingController();
  List<dynamic> data = [];
  List<dynamic> filteredData = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchData();
    searchController.addListener(() {
      filterData();
    });
  }

  Future<void> fetchData() async {
    try {
      final fetchedData = await operationsLab.instance.fetch_Data(
          "SELECT result_id, name, ds_name, test_name, cost, result, date_result_received "
              "FROM lab_results, lab_samples, lab_tests, deseases, patient_table "
              "WHERE lab_tests.test_id = lab_samples.test_no "
              "AND lab_samples.sample_id = lab_results.sample_id "
              "AND deseases.ds_no = lab_results.ds_no "
              "AND patient_table.p_no = lab_samples.patient_id "
              "AND lab_samples.doctor_id = '${widget.doctor_id}'"
      );

      setState(() {
        data = fetchedData;
        filteredData = fetchedData;
        isLoading = false;
      });
    } catch (error) {
      setState(() {
        isLoading = false;
      });
      print("Error fetching data: $error");
    }
  }

  void filterData() {
    final query = searchController.text.toLowerCase();
    setState(() {
      filteredData = data.where((item) {
        final name = item['name'].toString().toLowerCase();
        return name.contains(query);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1368A1),
      appBar: AppBar(
        title:const Center(child: Text('Appointment Screen',style: TextStyle(color: Colors.white),),),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: searchController,
              decoration: InputDecoration(
                labelText: 'Search by patient name',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            isLoading
                ? Center(child: CircularProgressIndicator())
                : Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Card(
                    child: DataTable(
                      columnSpacing: (MediaQuery.of(context).size.width / 10) * 0.5,
                      dataRowHeight: 80,
                      columns: const <DataColumn>[
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
                            'Disease Name',
                            style: TextStyle(fontStyle: FontStyle.italic),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Test Name',
                            style: TextStyle(fontStyle: FontStyle.italic),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Result',
                            style: TextStyle(fontStyle: FontStyle.italic),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Checkment Date',
                            style: TextStyle(fontStyle: FontStyle.italic),
                          ),
                        ),
                      ],
                      rows: filteredData
                          .map((resu) => DataRow(
                        cells: <DataCell>[
                          DataCell(Text(resu['result_id'].toString())),
                          DataCell(Text(resu['name'].toString())),
                          DataCell(Text(resu['ds_name'].toString())),
                          DataCell(Text(resu['test_name'].toString())),
                          DataCell(Text(resu['result'].toString())),
                          DataCell(Text(resu['date_result_received'].toString())),
                        ],
                      ))
                          .toList(),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
