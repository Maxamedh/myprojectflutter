import 'package:flutter/material.dart';
import 'package:hospital/lab/retrive_labtests.dart';
import 'package:hospital/models/patient_model.dart';
//visits

Widget visits() {
  Future<List> visits = operationsLab.instance.fetch_Data(
      'select visits.v_no,name,staff_name,v_date from staff,doctor,visits,patient_table where staff.staff_no=doctor.staff_no and doctor.doctor_no=visits.doctor_no and patient_table.p_no=visits.patient'
  );

  return Container(
    margin: const EdgeInsets.only(top: 20),
    child: Column(
      children: [
        Text('All Visits', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        FutureBuilder(
          future: visits,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<dynamic> data = snapshot.data!;

              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Card(
                    child: DataTable(
                      columnSpacing: 20,
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
                            'Doctor Name',
                            style: TextStyle(fontStyle: FontStyle.italic),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Visit Date',
                            style: TextStyle(fontStyle: FontStyle.italic),
                          ),
                        ),
                      ],
                      rows: data.map((patient) => DataRow(
                        cells: <DataCell>[
                          DataCell(Text(patient['v_no'].toString())),
                          DataCell(Text(patient['name'].toString())),
                          DataCell(Text(patient['staff_name'].toString())),
                          DataCell(Text(patient['v_date'].toString())),
                        ],
                      )).toList(),
                    ),
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
      ],
    ),
  );
}

Widget visitsById(String Id) {
  Future<List> visits = operationsLab.instance.fetch_Data(
      'select visits.v_no,name,staff_name,v_date from staff,doctor,visits,patient_table where staff.staff_no=doctor.staff_no and doctor.doctor_no=visits.doctor_no and patient_table.p_no=visits.patient and visits.v_no=$Id'
  );

  return Container(
    margin: const EdgeInsets.only(top: 20),
    child: Column(
      children: [
        Text('Visit Details for ID: $Id', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        FutureBuilder(
          future: visits,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<dynamic> data = snapshot.data!;

              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Card(
                    child: DataTable(
                      columnSpacing: 20,
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
                            'Doctor Name',
                            style: TextStyle(fontStyle: FontStyle.italic),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Visit Date',
                            style: TextStyle(fontStyle: FontStyle.italic),
                          ),
                        ),
                      ],
                      rows: data.map((patient) => DataRow(
                        cells: <DataCell>[
                          DataCell(Text(patient['v_no'].toString())),
                          DataCell(Text(patient['name'].toString())),
                          DataCell(Text(patient['staff_name'].toString())),
                          DataCell(Text(patient['v_date'].toString())),
                        ],
                      )).toList(),
                    ),
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
      ],
    ),
  );
}


// checkments



Widget checkments() {
  Future<List> visits = operationsLab.instance.fetch_Data(
      'SELECT lab_results.result_id, name,ds_name , test_name,result,date_result_received FROM patient_table,lab_samples,lab_tests,lab_results,deseases WHERE patient_table.p_no=lab_samples.patient_id and lab_tests.test_id=lab_samples.test_no and lab_samples.sample_id=lab_results.sample_id and deseases.ds_no=lab_results.ds_no'
  );

  return Container(
    margin: const EdgeInsets.only(top: 20),
    child: Column(
      children: [
        const Text('All checkments', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        FutureBuilder(
          future: visits,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<dynamic> data = snapshot.data!;

              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Card(
                    child: DataTable(
                      columnSpacing: 20,
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
                            'date_result_received',
                            style: TextStyle(fontStyle: FontStyle.italic),
                          ),
                        ),

                      ],
                      rows: data.map((check) => DataRow(
                        cells: <DataCell>[
                          DataCell(Text(check['result_id'].toString())),
                          DataCell(Text(check['name'].toString())),
                          DataCell(Text(check['ds_name'].toString())),
                          DataCell(Text(check['test_name'].toString())),
                          DataCell(Text(check['result'].toString())),
                          DataCell(Text(check['date_result_received'].toString())),
                        ],
                      )).toList(),
                    ),
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
      ],
    ),
  );
}

Widget checkmentById(String Id) {
  Future<List> visits = operationsLab.instance.fetch_Data(
      'SELECT lab_results.result_id, name,ds_name , '
          'test_name,result,date_result_received FROM patient_table,lab_samples,lab_tests,lab_results,deseases WHERE patient_table.p_no=lab_samples.patient_id and lab_tests.test_id=lab_samples.test_no and lab_samples.sample_id=lab_results.sample_id and deseases.ds_no=lab_results.ds_no and lab_results.result_id=$Id'
  );

  return Container(
    margin: const EdgeInsets.only(top: 20),
    child: Column(
      children: [
        Text('Checkment Details for ID: $Id', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        FutureBuilder(
          future: visits,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<dynamic> data = snapshot.data!;

              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Card(
                    child: DataTable(
                      columnSpacing: 20,
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
                            'result',
                            style: TextStyle(fontStyle: FontStyle.italic),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'date_result_received',
                            style: TextStyle(fontStyle: FontStyle.italic),
                          ),
                        ),
                      ],
                      rows: data.map((check) => DataRow(
                        cells: <DataCell>[
                          DataCell(Text(check['result_id'].toString())),
                          DataCell(Text(check['name'].toString())),
                          DataCell(Text(check['ds_name'].toString())),
                          DataCell(Text(check['test_name'].toString())),
                          DataCell(Text(check['result'].toString())),
                          DataCell(Text(check['date_result_received'].toString())),
                        ],
                      )).toList(),
                    ),
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
      ],
    ),
  );
}

// Receipts Report

Widget Receipts() {
  Future<List> visits = operationsLab.instance.fetch_Data(
      'SELECT rc_no,name,amount,rec_date,discount,description,'
          'ac_name from patient_table pat join receipts r on pat.p_no=r.p_no join accounts ac on ac.ac_no=r.ac_no'
  );

  return Container(
    margin: const EdgeInsets.only(top: 20),
    child: Column(
      children: [
        const Text('All Receipts', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        FutureBuilder(
          future: visits,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<dynamic> data = snapshot.data!;

              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Card(
                    child: DataTable(
                      columnSpacing: 20,
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
                            'Amount',
                            style: TextStyle(fontStyle: FontStyle.italic),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Receipt Date',
                            style: TextStyle(fontStyle: FontStyle.italic),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Discount',
                            style: TextStyle(fontStyle: FontStyle.italic),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'description',
                            style: TextStyle(fontStyle: FontStyle.italic),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Account',
                            style: TextStyle(fontStyle: FontStyle.italic),
                          ),
                        ),

                      ],
                      rows: data.map((check) => DataRow(
                        cells: <DataCell>[
                          DataCell(Text(check['rc_no'].toString())),
                          DataCell(Text(check['name'].toString())),
                          DataCell(Text(check['amount'].toString())),
                          DataCell(Text(check['rec_date'].toString())),
                          DataCell(Text(check['discount'].toString())),
                          DataCell(Text(check['description'].toString())),
                          DataCell(Text(check['ac_name'].toString())),
                        ],
                      )).toList(),
                    ),
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
      ],
    ),
  );
}

Widget ReceiptById(String id) {
  Future<List> visits = operationsLab.instance.fetch_Data(
      'SELECT rc_no,name,amount,rec_date,discount,description,'
          'ac_name from patient_table pat join receipts r on pat.p_no=r.p_no join accounts ac on ac.ac_no=r.ac_no and rc_no=$id'
  );

  return Container(
    margin: const EdgeInsets.only(top: 20),
    child: Column(
      children: [
        Text('Receipt Details for ID: $id', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),        FutureBuilder(
          future: visits,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<dynamic> data = snapshot.data!;

              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Card(
                    child: DataTable(
                      columnSpacing: 20,
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
                            'Amount',
                            style: TextStyle(fontStyle: FontStyle.italic),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Receipt Date',
                            style: TextStyle(fontStyle: FontStyle.italic),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Discount',
                            style: TextStyle(fontStyle: FontStyle.italic),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'description',
                            style: TextStyle(fontStyle: FontStyle.italic),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Account',
                            style: TextStyle(fontStyle: FontStyle.italic),
                          ),
                        ),

                      ],
                      rows: data.map((check) => DataRow(
                        cells: <DataCell>[
                          DataCell(Text(check['rc_no'].toString())),
                          DataCell(Text(check['name'].toString())),
                          DataCell(Text(check['amount'].toString())),
                          DataCell(Text(check['rec_date'].toString())),
                          DataCell(Text(check['discount'].toString())),
                          DataCell(Text(check['description'].toString())),
                          DataCell(Text(check['ac_name'].toString())),
                        ],
                      )).toList(),
                    ),
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
      ],
    ),
  );
}

// Prescriptions Report
Widget prescriptions() {
  Future<List> prescriptions = operationsLab.instance.fetch_Data(
      'SELECT pr_no, name, pr_date, '
          'pr_name, usages, description FROM prescription pre join patient_table p on p.p_no=pre.v_no'
  );

  return Container(
    margin: const EdgeInsets.only(top: 20),
    child: Column(
      children: [
        const Text('All Prescriptions', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        FutureBuilder(
          future: prescriptions,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<dynamic> data = snapshot.data!;

              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Card(
                    child: DataTable(
                      columnSpacing: 20,
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
                            'Date',
                            style: TextStyle(fontStyle: FontStyle.italic),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'prescription Name',
                            style: TextStyle(fontStyle: FontStyle.italic),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'usages',
                            style: TextStyle(fontStyle: FontStyle.italic),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'description',
                            style: TextStyle(fontStyle: FontStyle.italic),
                          ),
                        ),

                      ],
                      rows: data.map((check) => DataRow(
                        cells: <DataCell>[
                          DataCell(Text(check['pr_no'].toString())),
                          DataCell(Text(check['name'].toString())),
                          DataCell(Text(check['pr_date'].toString())),
                          DataCell(Text(check['pr_name'].toString())),
                          DataCell(Text(check['usages'].toString())),
                          DataCell(Text(check['description'].toString())),
                        ],
                      )).toList(),
                    ),
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
      ],
    ),
  );
}

Widget prescriptionVyId(String id) {
  Future<List> prescriptions = operationsLab.instance.fetch_Data(
      'SELECT pr_no, name, pr_date, '
          'pr_name, usages, description FROM prescription pre join patient_table p on p.p_no=pre.v_no where pr_no=$id'
  );

  return Container(
    margin: const EdgeInsets.only(top: 20),
    child: Column(
      children: [
        Text('Prescriptions Details for ID: $id', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),        FutureBuilder(
          future: prescriptions,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<dynamic> data = snapshot.data!;

              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Card(
                    child: DataTable(
                      columnSpacing: 20,
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
                            'Date',
                            style: TextStyle(fontStyle: FontStyle.italic),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'prescription Name',
                            style: TextStyle(fontStyle: FontStyle.italic),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'usages',
                            style: TextStyle(fontStyle: FontStyle.italic),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'description',
                            style: TextStyle(fontStyle: FontStyle.italic),
                          ),
                        ),

                      ],
                      rows: data.map((check) => DataRow(
                        cells: <DataCell>[
                          DataCell(Text(check['pr_no'].toString())),
                          DataCell(Text(check['name'].toString())),
                          DataCell(Text(check['pr_date'].toString())),
                          DataCell(Text(check['pr_name'].toString())),
                          DataCell(Text(check['usages'].toString())),
                          DataCell(Text(check['description'].toString())),
                        ],
                      )).toList(),
                    ),
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
      ],
    ),
  );
}


// Statements

Widget statements() {
  Future<List> statement = operations.instance.statements();

  return Container(
    margin: const EdgeInsets.only(top: 20),
    child: Column(
      children: [
        const Text('All Statements', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        FutureBuilder(
          future: statement,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<dynamic> data = snapshot.data!;

              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Card(
                    child: DataTable(
                      columnSpacing: 20,
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
                            'Name',
                            style: TextStyle(fontStyle: FontStyle.italic),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Debit',
                            style: TextStyle(fontStyle: FontStyle.italic),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Credit',
                            style: TextStyle(fontStyle: FontStyle.italic),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Description',
                            style: TextStyle(fontStyle: FontStyle.italic),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Balance',
                            style: TextStyle(fontStyle: FontStyle.italic),
                          ),
                        ),
                      ],
                      rows: data.map((check) => DataRow(
                        cells: <DataCell>[
                          DataCell(Text(check['p_no'].toString())),
                          DataCell(Text(check['name'].toString())),
                          DataCell(Text(check['Debit'].toString())),
                          DataCell(Text(check['Credit'].toString())),
                          DataCell(Text(check['description'].toString())),
                          DataCell(Text(check['balance'].toString())),
                        ],
                      )).toList(),
                    ),
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
      ],
    ),
  );
}


Widget statementsById(String id) {
  Future<List> statements = operations.instance.statementsById(id);

  return Container(
    margin: const EdgeInsets.only(top: 20),
    child: Column(
      children: [
        Text('Statement Details for ID: $id', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),

        FutureBuilder(
          future: statements,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<dynamic> data = snapshot.data!;

              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Card(
                    child: DataTable(
                      columnSpacing: 20,
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
                            'Name',
                            style: TextStyle(fontStyle: FontStyle.italic),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Debit',
                            style: TextStyle(fontStyle: FontStyle.italic),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            ' Credit',
                            style: TextStyle(fontStyle: FontStyle.italic),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'description',
                            style: TextStyle(fontStyle: FontStyle.italic),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'balance',
                            style: TextStyle(fontStyle: FontStyle.italic),
                          ),
                        ),

                      ],
                      rows: data.map((check) => DataRow(
                        cells: <DataCell>[
                          DataCell(Text(check['p_no'].toString())),
                          DataCell(Text(check['name'].toString())),
                          DataCell(Text(check['Debit'].toString())),
                          DataCell(Text(check['Credit'].toString())),
                          DataCell(Text(check['description'].toString())),
                          DataCell(Text(check['balance'].toString())),
                        ],
                      )).toList(),
                    ),
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
      ],
    ),
  );
}