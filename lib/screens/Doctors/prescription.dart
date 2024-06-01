import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hospital/lab/retrive_labtests.dart';
import 'package:hospital/screens/Doctors/Update_prescription.dart';
import 'package:http/http.dart' as http;
import '../../models/patient_model.dart';

const Color greenColor = Color(0xFF3AB14B);
const Color blueColor = Color(0xFF1368A1);

class PrescriptionScreen extends StatefulWidget {
  const PrescriptionScreen({super.key});

  @override
  _PrescriptionScreenState createState() => _PrescriptionScreenState();
}

class _PrescriptionScreenState extends State<PrescriptionScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<dynamic> _allData = [];
  List<dynamic> _filteredData = [];

  final TextEditingController vNoController = TextEditingController();
  final TextEditingController prDateController = TextEditingController();
  final TextEditingController prNameController = TextEditingController();
  final TextEditingController usagesController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController searchController = TextEditingController();

  final _form = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    searchController.addListener(_filterData);
    _fetchData();
  }

  var dropDownpaValue;

  @override
  void dispose() {
    _tabController.dispose();
    vNoController.dispose();
    prDateController.dispose();
    prNameController.dispose();
    usagesController.dispose();
    descriptionController.dispose();
    searchController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        prDateController.text = picked.toString().substring(0, 10);
      });
    }
  }

  Future<void> delete_record(var id) async {
    final response = await http.post(Uri.parse('http://192.168.43.239/hospital_api/All/delete.php'),
      body: {
        'table': 'prescription',
        'id': id,
        'deleted_id': 'pr_no',
      },
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      setState(() {
        if (data['success']) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Data deleted successfully')));
          _fetchData();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to delete data ${response.body}')));
        }
      });
    }
  }

  Future<void> _fetchData() async {
    var data = await operationsLab.instance.fetch_Data('SELECT * FROM prescription JOIN patient_table ON prescription.v_no = patient_table.p_no');
    setState(() {
      _allData = data;
      _filteredData = data;
    });
  }

  void _filterData() {
    setState(() {
      _filteredData = _allData.where((item) {
        return item['v_no'].toString().toLowerCase().contains(searchController.text.toLowerCase());
      }).toList();
    });
  }

  Future<void> insertData() async {
    final isValid = _form.currentState!.validate();
    if (isValid) {
      final data = {
        'table': 'prescription',
        'data': {
          'v_no': dropDownpaValue,
          'pr_date': prDateController.text,
          'pr_name': prNameController.text,
          'usages': usagesController.text,
          'description': descriptionController.text,
        }
      };
      try {
        var response = await http.post(Uri.parse('http://192.168.43.239/hospital_api/All/insertion.php'),
            body: json.encode(data));
        print(response.body);

        if (response.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Data inserted successfully')));
          _fetchData();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Data failed response body  ${response.body}')));
        }
      } catch (e) {
        print("There was an error: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: greenColor,
        title: Text(
          'Prescription',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white),
        ),
        bottom: TabBar(
          dividerColor: Colors.blue,
          controller: _tabController,
          tabs: [
            Tab(text: 'Add New'),
            Tab(text: 'Description Info'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Form(
                key: _form,
                child: Column(
                  children: [
                    FutureBuilder(
                        future: operations.instance.Patient_info(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            List<dynamic> pa = snapshot.data!;
                            return DropdownButtonFormField(
                              value: null,
                              icon: const Icon(Icons.keyboard_arrow_down),
                              items: pa.map((pat) {
                                return DropdownMenuItem(
                                  value: pat['p_no'].toString(),
                                  child: Row(
                                    children: [
                                      Icon(Icons.people),
                                      SizedBox(width: 10),
                                      Text(pat['name'].toString())
                                    ],
                                  ),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  dropDownpaValue = value!;
                                });
                              },
                              decoration: InputDecoration(
                                hintText: dropDownpaValue ?? 'select patient',
                                border: OutlineInputBorder(),
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
                        }
                    ),
                    TextFormField(
                      controller: prDateController,
                      decoration: InputDecoration(
                        label: Text('Prescription Date'),
                        suffixIcon: IconButton(
                          icon: Icon(Icons.calendar_today),
                          onPressed: () => _selectDate(context),
                        ),
                      ),
                      keyboardType: TextInputType.text,
                      autocorrect: false,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter a Date';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: prNameController,
                      decoration: InputDecoration(labelText: 'Prescription name'),
                    ),
                    TextFormField(
                      controller: usagesController,
                      decoration: InputDecoration(labelText: 'Usages'),
                    ),
                    TextFormField(
                      controller: descriptionController,
                      decoration: InputDecoration(labelText: 'Description'),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: blueColor),
                      onPressed: insertData,
                      child: Text('Submit', style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  controller: searchController,
                  decoration: InputDecoration(labelText: 'Search by V No'),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: FutureBuilder(
                        future: operationsLab.instance.fetch_Data('SELECT * FROM prescription JOIN patient_table ON prescription.v_no = patient_table.p_no'),
                        builder: (context, snapshot){
                          if(snapshot.connectionState == ConnectionState.done) {
                            if (snapshot.hasData) {
                              _allData = snapshot.data!;
                              _filteredData = snapshot.data!;
                            }
                          }
                          if (_filteredData.isNotEmpty) {
                            return SingleChildScrollView(
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
                                        'Prescription Date',
                                        style: TextStyle(fontStyle: FontStyle.italic),
                                      ),
                                    ),
                                    DataColumn(
                                      label: Text(
                                        'Prescription Name',
                                        style: TextStyle(fontStyle: FontStyle.italic),
                                      ),
                                    ),
                                    DataColumn(
                                      label: Text(
                                        'Usages',
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
                                        'Actions',
                                        style: TextStyle(fontStyle: FontStyle.italic),
                                      ),
                                    ),
                                  ],
                                  rows: List<DataRow>.generate(_filteredData.length, (int index) {
                                    return DataRow(
                                      color: MaterialStateProperty.resolveWith<Color?>((Set<MaterialState> states) {
                                        return index % 2 == 0 ? greenColor.withOpacity(0.3) : Colors.white;
                                      }),
                                      cells: <DataCell>[
                                        DataCell(Text(_filteredData[index]['pr_no'].toString())),
                                        DataCell(Text(_filteredData[index]['name'].toString())),
                                        DataCell(Text(_filteredData[index]['pr_date'].toString())),
                                        DataCell(Text(_filteredData[index]['pr_name'].toString())),
                                        DataCell(Text(_filteredData[index]['usages'].toString())),
                                        DataCell(Text(_filteredData[index]['description'].toString())),
                                        DataCell(
                                          Row(
                                            children: [
                                              IconButton(
                                                onPressed: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(builder: (context) => Update_Prescription_record_screen(
                                                        pres_id: _filteredData[index]['pr_no'].toString(), v_no: _filteredData[index]['name'].toString(),
                                                        pr_date: _filteredData[index]['pr_date'].toString(), pr_name: _filteredData[index]['pr_name'].toString(), usages:
                                                    _filteredData[index]['usages'].toString(), description: _filteredData[index]['description'].toString()))
                                                  );

                                                },
                                                icon: Icon(Icons.edit, color: blueColor),
                                              ),
                                              IconButton(
                                                onPressed: () => delete_record(_filteredData[index]['pr_no']),
                                                icon: Icon(Icons.delete, color: Colors.red),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    );
                                  }),
                                ),
                              ),
                            );
                          } else if (snapshot.hasError) {
                            return Center(
                              child: Text("An error occurred while fetching the data."),
                            );
                          } else {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                        }
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
