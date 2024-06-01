import 'package:flutter/material.dart';
import 'package:hospital/lab/retrive_labtests.dart';

class CurrentCheckment extends StatelessWidget {
  const CurrentCheckment({super.key,required this.patient_id});

  final patient_id;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: operationsLab.instance.fetch_Data('SELECT result_id,ds_name,test_name,cost,result,date_result_received FROM lab_results,lab_samples,lab_tests,deseases WHERE lab_tests.test_id=lab_samples.test_no and lab_samples.sample_id=lab_results.sample_id and deseases.ds_no=lab_results.ds_no and lab_samples.patient_id=${patient_id} and date_result_received=NOW()'),
        builder: (context, snapshot){
          if(snapshot.hasData){

            List<dynamic> data =snapshot.data!;

            return SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Card(
                  margin: EdgeInsets.all(20),
                  child:  DataTableTheme(
                    data: DataTableThemeData(
                      headingTextStyle: TextStyle(
                          color: Colors.white
                      ),
                      headingRowColor: MaterialStateColor.resolveWith((states) => Colors.blue), // Change the color here
                    ),
                    child: DataTable(
                      columnSpacing: (MediaQuery.of(context).size.width / 10) * 1,
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
                            'diseases',
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
                            'result',
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
                          .map((check) => DataRow(
                        cells: <DataCell>[
                          DataCell(Text(check['result_id'].toString())),
                          DataCell(Text(check['ds_name'].toString())),
                          DataCell(Text(check['test_name'].toString())),
                          DataCell(Text(check['cost'].toString())),
                          DataCell(Text(check['result'].toString())),
                          DataCell(Text(check['date_result_received'].toString())),





                        ],
                      ))
                          .toList(),



                    ),
                  ),
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
    );
  }
}
