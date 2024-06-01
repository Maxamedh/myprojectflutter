import 'dart:convert';
import 'package:hospital/lab/retrive_labtests.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

import 'medicine_info.dart';

TextEditingController exp_date =new TextEditingController();
TextEditingController price =new TextEditingController();
TextEditingController description =new TextEditingController();
TextEditingController name =new TextEditingController();
TextEditingController category =new TextEditingController();
TextEditingController quantity =new TextEditingController();



class UpdateMedicineFormScreen extends StatefulWidget {
  const UpdateMedicineFormScreen({super.key,
    required this.name,
    required this.medicine_id,
    required this.description,
    required this.category,
    required this.price,
    required this.quantity,
    required this.expiryDate,
    required this.suplier_id
  });

  final String name;
  final String medicine_id;
  final String description;
  final String category;
  final String price;
  final String quantity;
 final  String expiryDate;
 final  String suplier_id;

  @override
  State<UpdateMedicineFormScreen> createState() => _UpdateMedicineFormScreenState();
}

class _UpdateMedicineFormScreenState extends State<UpdateMedicineFormScreen> {


  @override
  void initState() {
    // TODO: implement initState
    name.text=widget.name;
    description.text=widget.description;
    category.text=widget.category;
    price.text=widget.price;
    quantity.text=widget.quantity;
    exp_date.text=widget.expiryDate;
    dropDownsupplierValue=widget.suplier_id;
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

  Future<void> updateData() async {
    final isValid =_form.currentState!.validate();
    if(isValid){
      final data={
        'table': 'medicines',
        'data': {
          'name': name.text,
          'description': description.text,
          'category': category.text,
          'price': price.text,
          'quantity': quantity.text,
          'expiry_date': exp_date.text,
          'supplier_id': dropDownsupplierValue,
        },
        'updated_id':'medicine_id',
        'id':widget.medicine_id
      };
      try {
        var response = await http.post(Uri.parse('http://192.168.43.239/hospital_api/All/update.php'),
            body: json.encode(data));
        print(response.body);
        setState(() {
          if (response.statusCode == 200) {
            name.clear();
            description.clear();
            category.clear();
            price.clear();
            quantity.clear();
            exp_date.clear();

            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Data Updated successfully')));

            print("Data Updated successfully");
            Navigator.push(context, MaterialPageRoute(builder: (context)=>MedicineInfoScreen()));
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
                        controller: name,
                        decoration: const InputDecoration(
                          label: Text('Medicine Name'),
                        ),
                        keyboardType: TextInputType.text,

                        autocorrect: false,
                        validator: (value){
                          if(value==null || value.trim().isEmpty
                          ){
                            return 'Please Enter medicine';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20,),
                      TextFormField(
                        controller: description,
                        decoration: const InputDecoration(
                          label: Text('Description'),
                        ),
                        keyboardType: TextInputType.text,

                        autocorrect: false,
                        validator: (value){
                          if(value==null || value.trim().isEmpty
                          ){
                            return 'Please Enter Description';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20,),
                      TextFormField(
                        controller: category,
                        decoration: const InputDecoration(
                          label: Text('Category'),
                        ),
                        keyboardType: TextInputType.text,

                        autocorrect: false,
                        validator: (value){
                          if(value==null || value.trim().isEmpty
                          ){
                            return 'Please Enter Description';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: price,
                        decoration: const InputDecoration(
                          label: Text('Price'),
                        ),
                        keyboardType: TextInputType.number,

                        autocorrect: false,
                        validator: (value){
                          if(value==null || value.trim().isEmpty
                          ){
                            return 'Please Enter Price';
                          }
                          return null;
                        },
                      ),

                      TextFormField(
                        controller: quantity,
                        decoration: const InputDecoration(
                          label: Text('Quantity'),
                        ),
                        keyboardType: TextInputType.number,

                        autocorrect: false,
                        validator: (value){
                          if(value==null || value.trim().isEmpty
                          ){
                            return 'Please Enter quantity';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: exp_date,
                        decoration: InputDecoration(
                          label: Text('Expire Date'),
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
                            return 'Please Enter a Date';
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
