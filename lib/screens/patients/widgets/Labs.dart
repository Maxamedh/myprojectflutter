import 'package:flutter/material.dart';
import 'package:hospital/lab/retrive_labtests.dart';

class LabsResult extends StatelessWidget {
  const LabsResult({Key? key, required this.patient_id}) : super(key: key);

  final patient_id;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: operationsLab.instance.fetch_Data(
          'SELECT result_id,ds_name,test_name,cost,result,date_result_received FROM lab_results,lab_samples,lab_tests,deseases WHERE lab_tests.test_id=lab_samples.test_no and lab_samples.sample_id=lab_results.sample_id and deseases.ds_no=lab_results.ds_no and lab_samples.patient_id=${patient_id}'),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<dynamic> data = snapshot.data!;

          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Card(
                elevation: 0,
                margin: EdgeInsets.all(20),
                child:  DataTableTheme(
                  data: DataTableThemeData(
                    headingTextStyle: TextStyle(
                        color: Colors.white
                    ),
                    headingRowColor: MaterialStateColor.resolveWith((states) => Colors.blue), // Change the color here
                  ),
                  child: DataTable(

                    columnSpacing: 20, // Set your desired column spacing
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
                          'Disease Name',
                          style: TextStyle(fontStyle: FontStyle.italic),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'test',
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
                          'cost',
                          style: TextStyle(fontStyle: FontStyle.italic),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Date',
                          style: TextStyle(fontStyle: FontStyle.italic),
                        ),
                      ),

                    ],
                    rows: data
                        .map(
                          (patient) => DataRow(
                        cells: <DataCell>[
                          DataCell(Text(patient['result_id'].toString())),
                          DataCell(Text(patient['ds_name'].toString())),
                          DataCell(Text(patient['test_name'].toString())),
                          DataCell(Text(patient['cost'].toString())),
                          DataCell(Text(patient['result'].toString())),
                          DataCell(Text(patient['date_result_received'].toString())),
                        ],
                      ),
                    )
                        .toList(),
                  ),
                ),
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
      },
    );
  }
}
