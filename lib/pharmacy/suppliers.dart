
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hospital/finance/expense_charge_insert.dart';
import 'package:hospital/finance/expense_charge_update.dart';
import 'package:hospital/finance/expense_register.dart';
import 'package:hospital/finance/expense_update.dart';
import 'package:hospital/lab/retrive_labtests.dart';
import 'package:hospital/pharmacy/Update_medicine.dart';
import 'package:hospital/pharmacy/update_order.dart';
import 'package:hospital/pharmacy/update_sells.dart';
import 'package:hospital/pharmacy/update_supplier.dart';
import 'package:http/http.dart' as http;
import 'package:hospital/models/patient_model.dart';

import 'insert_orders.dart';
import 'insert_sells.dart';
import 'insert_supplier.dart';
import 'medicine_insertion.dart';
class SupplierInfoScreen extends StatefulWidget {
  const SupplierInfoScreen({super.key});

  @override
  State<SupplierInfoScreen> createState() => _OrderInfoScreenScreenState();
}
class _OrderInfoScreenScreenState extends State<SupplierInfoScreen> {

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

          'table':'suppliers',
          'id':id,
          'deleted_id':'supplier_id',
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
        title: const Center(child:  Text('supplier Information'),),
      ),
      body: ListView(
        children: [
          TextButton.icon(onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=>const Insert_SupplierFormScreen()));
          }, icon: const Icon(Icons.add), label: const Text('add supplier',style:
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
                future: operationsLab.instance.fetch_Data("SELECT * FROM suppliers"),
                builder: (context, snapshot){
                  if(snapshot.hasData){
                    List<dynamic> data =snapshot.data!;

                    return SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Card(

                        child: DataTable(
                          columnSpacing: (MediaQuery.of(context).size.width / 10) * 0.5,
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
                                'Name',
                                style: TextStyle(fontStyle: FontStyle.italic),
                              ),

                            ),
                            DataColumn(
                              label: Text(
                                'Contact',
                                style: TextStyle(fontStyle: FontStyle.italic),
                              ),

                            ),
                            DataColumn(
                              label: Text(
                                'Address',
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
                              .map((suppli) => DataRow(
                            cells: <DataCell>[
                              DataCell(Text(suppli['supplier_id'].toString())),
                              DataCell(Text(suppli['name'].toString())),
                              DataCell(Text(suppli['contact'].toString())),
                              DataCell(Text(suppli['address'].toString())),
                              DataCell(Row(children: [
                                IconButton(onPressed: (){
                                  Navigator.push(context, MaterialPageRoute(builder: (context)=>
                                     Update_SupplierFormScreen(
                                         supplier_id: suppli['supplier_id'].toString(),
                                         supp_name: suppli['name'].toString(),
                                         supp_contact: suppli['contact'].toString(),
                                         sub_address: suppli['address'].toString())
                                  ));
                                },icon:
                                Icon(Icons.edit),color: Colors.blue,

                                ),
                                SizedBox(width: 5,),
                                IconButton(onPressed: (){
                                  delete_record(suppli['supplier_id']);
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
