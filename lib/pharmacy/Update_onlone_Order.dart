import 'dart:convert';
import 'package:hospital/lab/retrive_labtests.dart';
import 'package:hospital/pharmacy/Insert_online_order.dart';
import 'package:hospital/pharmacy/orderSCreen.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

import 'ONline_order.dart';
import 'medicine_info.dart';

TextEditingController order_date =new TextEditingController();
TextEditingController medicine =new TextEditingController();
TextEditingController Address =new TextEditingController();
TextEditingController delivered =new TextEditingController();
TextEditingController quantity =new TextEditingController();



class Update_Online_OrderFormScreen extends StatefulWidget {
  const Update_Online_OrderFormScreen({super.key,
    required this.order_id,
    required this.patient,
    required this.order_date,
    required this.quantity,
    required this.Address,
    required this.medicine,
    required this.deliveredDate
  });

  final order_id;
  final patient;
  final order_date;
  final quantity;
  final medicine;
  final deliveredDate;
  final Address;

  @override
  State<Update_Online_OrderFormScreen> createState() => _Update_Online_OrderFormScreenState();
}

class _Update_Online_OrderFormScreenState extends State<Update_Online_OrderFormScreen> {


  @override
  void initState() {
    // TODO: implement initState
    dropDownspaValue=widget.patient;
    order_date.text=widget.order_date;
    quantity.text=widget.quantity;
    dropDownsmedValue=widget.medicine;
    delivered.text=widget.deliveredDate;
    Address.text=widget.Address;
    super.initState();
  }
  final _form = GlobalKey<FormState>();
  //final List<Map<String, dynamic>> data  =[];
  final List<Map<String, dynamic>> doctor_data  =[];
  var dropDownspaValue;
  var dropDownsmedValue;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        delivered.text = picked.toString().substring(0,
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

  @override
  Widget build(BuildContext context) {
    int a=0;
    Future<void> updateData() async {
      final isValid =_form.currentState!.validate();
      if(isValid){
        final data={
          'table': 'onlineorders',
          'data': {

            'patient_id':dropDownspaValue,
            'order_date': order_date.text,
            'total_amount': quantity.text,
            'med_no': dropDownsmedValue,
            'delivery_date': delivered.text,
            'address': Address.text,

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
              delivered.clear();
              medicine.clear();
              quantity.clear();
              Address.clear();

              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Data Updated successfully')));

              print("Data Updated successfully");
              Navigator.push(context, MaterialPageRoute(builder: (context)=>const onlineOrderinfoScreen()));
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

    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Send Orders ',style: TextStyle(
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
                          future: operationsLab.instance.fetch_Data('SELECT * FROM patient_table'),
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
                                      value: sup['p_no'].toString(),
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
                                      dropDownspaValue=value;
                                      print(dropDownspaValue);
                                    });
                                  },
                                  decoration: InputDecoration(
                                    hintText: dropDownspaValue ?? 'Select  patient', // Hint text based on selected value
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
                      TextFormField(
                        controller: order_date,
                        decoration: InputDecoration(
                          label: const Text('Order Date'),
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

                      SizedBox(height: 20,),
                      TextFormField(
                        controller: quantity,
                        decoration: InputDecoration(
                          label: Text('quantity'),

                        ),
                        keyboardType: TextInputType.number,

                        autocorrect: false,
                        validator: (value){
                          if(value==null || value.trim().isEmpty
                          ){
                            return 'Please Enter a a quantity';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20,),
                      FutureBuilder(
                          future: operationsLab.instance.fetch_Data('SELECT * FROM medicines'),
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
                                      value: sup['medicine_id'].toString(),
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
                                      dropDownsmedValue=value;
                                      print(dropDownsmedValue);
                                    });
                                  },
                                  decoration: InputDecoration(
                                    hintText: dropDownsmedValue ?? 'Select  Medecine', // Hint text based on selected value
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
                        controller: delivered,
                        decoration: InputDecoration(
                          label: const Text('delivered Date'),
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
                            return 'Please Enter Delivered Date';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20,),
                      TextFormField(
                        controller: Address,
                        decoration: const InputDecoration(
                          label: Text('Address'),

                        ),
                        keyboardType: TextInputType.text,

                        autocorrect: false,
                        validator: (value){
                          if(value==null || value.trim().isEmpty
                          ){
                            return 'Please Enter Address';
                          }
                          return null;
                        },
                      ),
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
