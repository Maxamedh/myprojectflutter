
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hospital/finance/expense_charge_insert.dart';
import 'package:hospital/finance/expense_charge_update.dart';
import 'package:hospital/finance/expense_register.dart';
import 'package:hospital/finance/expense_update.dart';
import 'package:hospital/lab/retrive_labtests.dart';
import 'package:hospital/pharmacy/Update_medicine.dart';
import 'package:http/http.dart' as http;
import 'package:hospital/models/patient_model.dart';

import 'medicine_insertion.dart';
class MedicineInfoScreen extends StatefulWidget {
  const MedicineInfoScreen({super.key});

  @override
  State<MedicineInfoScreen> createState() => _MedicineInfoScreenScreenState();
}
class _MedicineInfoScreenScreenState extends State<MedicineInfoScreen> {
  final _form = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    Future<void> delete_record(var id) async{
      final response = await http.post(Uri.parse('http://192.168.43.239/hospital_api/All/delete.php'),
        body: {
          'table':'medicines',
          'id':id,
          'deleted_id':'medicine_id',
        },
      );

      if(response.statusCode==200){

        Map<String,dynamic> data =json.decode(response.body);
        setState(() {
          if(data['success']){
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Data deleted successfully')));
          }else{
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to delete data ${response.body}')));
          }
        });
      }
    }


    final List<Map<String, dynamic>> data  =[];

    int i=0;
    return Scaffold(
      appBar: AppBar(
        title: const Center(child:  Text('Medicine Information'),),
      ),
      body: ListView(
        children: [
          TextButton.icon(onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=>MedicineFormScreen()));
          }, icon: const Icon(Icons.add), label: const Text('Add Medicine',style:
          TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.blue
          ),
          )
          ),
          SizedBox(height: 20,),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: FutureBuilder(
                future: operationsLab.instance.fetch_Data(""
                    "SELECT medicine_id, medicines.name medicine, description, category, price, quantity, expiry_date, suppliers.name supplier FROM medicines join suppliers on suppliers.supplier_id=medicines.supplier_id"),
                builder: (context, snapshot){
                  if(snapshot.hasData){
                    List<dynamic> data =snapshot.data!;

                    return SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Card(

                        child: DataTable(
                          columnSpacing: (MediaQuery.of(context).size.width / 10) * 0.5,
                          dataRowHeight: 80,
                          columns:  <DataColumn>[

                            DataColumn(
                              label: Text(
                                'ID',
                                style: TextStyle(fontStyle: FontStyle.italic),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'Medicine',
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
                                'Category',
                                style: TextStyle(fontStyle: FontStyle.italic),
                              ),

                            ),
                            DataColumn(
                              label: Text(
                                'price',
                                style: TextStyle(fontStyle: FontStyle.italic),
                              ),

                            ),
                            DataColumn(
                              label: Text(
                                'Quantity',
                                style: TextStyle(fontStyle: FontStyle.italic),
                              ),

                            ),
                            DataColumn(
                              label: Text(
                                'Expire Date',
                                style: TextStyle(fontStyle: FontStyle.italic),
                              ),

                            ),
                            DataColumn(
                              label: Text(
                                'Supplier',
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
                              .map((medicine) => DataRow(
                            cells: <DataCell>[
                              DataCell(Text(medicine['medicine_id'].toString())),
                              DataCell(Text(medicine['medicine'].toString())),
                              DataCell(Text(medicine['description'].toString())),
                              DataCell(Text(medicine['category'].toString())),
                              DataCell(Text(medicine['price'].toString())),
                              DataCell(Text(medicine['quantity'].toString())),
                              DataCell(Text(medicine['expiry_date'].toString())),
                              DataCell(Text(medicine['supplier'].toString())),
                              DataCell(Row(children: [
                                IconButton(onPressed: (){
                                  Navigator.push(context, MaterialPageRoute(builder: (context)=>
                                    UpdateMedicineFormScreen(
                                        name: medicine['medicine'].toString(), medicine_id:
                                        medicine['medicine_id'].toString(), description:
                                        medicine['description'].toString(), category:
                                        medicine['category'].toString(), price: medicine['price'].toString(),
                                        quantity: medicine['quantity'].toString(),
                                        expiryDate: medicine['expiry_date'].toString(),
                                        suplier_id: medicine['supplier'].toString())
                                  ));
                                },icon:
                                Icon(Icons.edit),color: Colors.blue,

                                ),
                                SizedBox(width: 5,),
                                IconButton(onPressed: (){
                                  delete_record(medicine['medicine_id']);
                                },icon: Icon(Icons.delete),color: Colors.red,

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

          )
        ],
      ),
    );
  }
}
