
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
import 'package:http/http.dart' as http;
import 'package:hospital/models/patient_model.dart';

import 'insert_orders.dart';
import 'insert_sells.dart';
import 'medicine_insertion.dart';
class SellsInfoScreen extends StatefulWidget {
  const SellsInfoScreen({super.key});

  @override
  State<SellsInfoScreen> createState() => _OrderInfoScreenScreenState();
}
class _OrderInfoScreenScreenState extends State<SellsInfoScreen> {
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
          'table':'sells',
          'id':id,
          'deleted_id':'sells_id',
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
        title: const Center(child:  Text('sells Information'),),
      ),
      body: ListView(
        children: [
          TextButton.icon(onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=>const Insert_SellsFormScreen()));
          }, icon: const Icon(Icons.add), label: const Text('add sells',style:
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
                future: operationsLab.instance.fetch_Data("SELECT sells.sells_id,p_no, patient_table.name patient, medicine, sells.quantity, sells.price, "
                    "sells.sell_date FROM patient_table,onlineorders,sells  where patient_table.p_no=onlineorders.patient_id and onlineorders.order_id"),
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
                                'patient',
                                style: TextStyle(fontStyle: FontStyle.italic),
                              ),

                            ),
                            DataColumn(
                              label: Text(
                                'medicine',
                                style: TextStyle(fontStyle: FontStyle.italic),
                              ),

                            ),
                            DataColumn(
                              label: Text(
                                'quantity',
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
                                'sell_date',
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
                              .map((sells) => DataRow(
                            cells: <DataCell>[
                              DataCell(Text(sells['sells_id'].toString())),
                              DataCell(Text(sells['patient'].toString())),
                              DataCell(Text(sells['medicine'].toString())),
                              DataCell(Text(sells['quantity'].toString())),
                              DataCell(Text(sells['price'].toString())),
                              DataCell(Text(sells['sell_date'].toString())),
                              DataCell(Row(children: [
                                IconButton(onPressed: (){
                                  Navigator.push(context, MaterialPageRoute(builder: (context)=>
                                     Update_SellsFormScreen(
                                         sells_id: sells['sells_id'].toString(),
                                         patient: sells['patient'].toString(),
                                         medicine: sells['medicine'].toString(),
                                         quantity: sells['quantity'].toString(),
                                         price: sells['price'].toString(),
                                         sell_date: sells['sell_date'].toString())
                                  ));
                                },icon:
                                Icon(Icons.edit),color: Colors.blue,

                                ),
                                SizedBox(width: 5,),
                                IconButton(onPressed: (){
                                  delete_record(sells['sells_id']);
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
