import 'dart:convert';
import 'package:hospital/lab/retrive_labtests.dart';
import 'package:hospital/pharmacy/insert_orders.dart';
import 'package:hospital/pharmacy/orderSCreen.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

import 'medicine_info.dart';

TextEditingController exp_date =new TextEditingController();
TextEditingController order_date =new TextEditingController();
TextEditingController medicine =new TextEditingController();



class Update_OrderFormScreen extends StatefulWidget {
  const Update_OrderFormScreen({super.key,
  required this.order_id,
  required this.suplier,
  required this.order_date,
  required this.expected_date,
  required this.medicine,
  });

  final order_id;
  final suplier;
  final order_date;
  final expected_date;
  final medicine;

  @override
  State<Update_OrderFormScreen> createState() => _Update_OrderFormScreenState();
}

class _Update_OrderFormScreenState extends State<Update_OrderFormScreen> {


  @override
  void initState() {
    // TODO: implement initState

    dropDownsupplierValue=widget.suplier;
    order_date.text=widget.order_date;
    exp_date.text=widget.expected_date;
    medicine.text=widget.medicine;
    super.initState();
  }
  final _form = GlobalKey<FormState>();
  //final List<Map<String, dynamic>> data  =[];
  final List<Map<String, dynamic>> doctor_data  =[];
  var dropDownsupplierValue;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        exp_date.text = picked.toString().substring(0,
            10);
      });
    }
  }
  Future<void> _selectDate2(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        order_date.text = picked.toString().substring(0,
            10);
      });
    }
  }
  Future<void> updateData() async {
    final isValid =_form.currentState!.validate();
    if(isValid){
      final data={
        'table': 'orders',
        'data': {
          'supplier_id': dropDownsupplierValue,
          'order_date': order_date.text,
          'expected_date': exp_date.text,
          'medicine': medicine.text,

        },
        'updated_id':'order_id',
        'id':widget.order_id
      };
      try {
        var response = await http.post(Uri.parse('http://192.168.43.239/hospital_api/All/update.php'),
            body: json.encode(data));
        print(response.body);
        setState(() {
          if (response.statusCode == 200) {

            order_date.clear();
            exp_date.clear();
            medicine.clear();

            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Data Updated successfully')));

            print("Data Updated successfully");
            Navigator.push(context, MaterialPageRoute(builder: (context)=>const OrderInfoScreen()));
          } else {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Data failed response body  ${response.body}')));
            print("Failed to insert data");
            print("Status code: ${response.statusCode}");
            print("Response body: ${response.body}");
          }
        });

      } catch (e) {
        print("There was an error: $e");
      }
    }else{
      print('not valid');
    }
  }
  @override
  Widget build(BuildContext context) {
    int a=0;

    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Add Medicine ',style: TextStyle(
            color: Colors.white
        ),),),
        backgroundColor: Color(0xFF3AB14B),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 40),
              child: Form(
                key: _form,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    children: [
                      FutureBuilder(
                          future: operationsLab.instance.fetch_Data('SELECT * FROM suppliers'),
                          builder: (context, snapshot){
                            if(snapshot.hasData){
                              List<dynamic> supplier =snapshot.data!;

                              return SingleChildScrollView(
                                scrollDirection: Axis.vertical,
                                child: DropdownButtonFormField(
                                  value: null,
                                  icon: const Icon(Icons.keyboard_arrow_down),
                                  items: supplier.map((sup) {
                                    return DropdownMenuItem(
                                      value: sup['supplier_id'].toString(),
                                      child: Row(
                                        children: [
                                          Icon(Icons.people),
                                          SizedBox(width: 10,),
                                          Text(sup['name'].toString())
                                        ],
                                      ),
                                    );
                                  }).toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      dropDownsupplierValue=value;
                                      print(dropDownsupplierValue);
                                    });
                                  },
                                  decoration: InputDecoration(
                                    hintText: dropDownsupplierValue ?? 'Select  Supplier', // Hint text based on selected value
                                    border: OutlineInputBorder(),
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

                      SizedBox(height: 20,),
                      TextFormField(
                        controller: medicine,
                        decoration: InputDecoration(
                          label: Text('medicine'),

                        ),
                        keyboardType: TextInputType.text,

                        autocorrect: false,
                        validator: (value){
                          if(value==null || value.trim().isEmpty
                          ){
                            return 'Please Enter a order medicine';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20,),

                      TextFormField(
                        controller: order_date,
                        decoration: InputDecoration(
                          label: Text('Order Date'),
                          suffixIcon: IconButton(
                            icon: Icon(Icons.calendar_today),
                            onPressed: () => _selectDate2(context),
                          ),
                        ),
                        keyboardType: TextInputType.text,

                        autocorrect: false,
                        validator: (value){
                          if(value==null || value.trim().isEmpty
                          ){
                            return 'Please Enter a order Date';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: exp_date,
                        decoration: InputDecoration(
                          label: Text('Expected Date'),
                          suffixIcon: IconButton(
                            icon: Icon(Icons.calendar_today),
                            onPressed: () => _selectDate(context),
                          ),
                        ),
                        keyboardType: TextInputType.text,

                        autocorrect: false,
                        validator: (value){
                          if(value==null || value.trim().isEmpty
                          ){
                            return 'Please Enter expected Date';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20,),
                    ],
                  ),
                ),
              ),

            ),
            SizedBox(height: 20,),
            ElevatedButton(onPressed: updateData,
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF1368A1),
              ), child: Text('Update',style: TextStyle(color: Colors.white),),)
          ],
        ),
      ),
    );
  }
}
