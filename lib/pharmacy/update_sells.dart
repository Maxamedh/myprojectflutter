import 'dart:convert';
import 'package:hospital/lab/retrive_labtests.dart';
import 'package:hospital/pharmacy/sells.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

TextEditingController medicine = TextEditingController();
TextEditingController price = TextEditingController();
TextEditingController sell_date = TextEditingController();
TextEditingController quantity = TextEditingController();

class Update_SellsFormScreen extends StatefulWidget {
  const Update_SellsFormScreen({super.key,
    required this.sells_id,
    required this.patient,
    required this.medicine,
    required this.quantity,
    required this.price,
    required this.sell_date,
  });

  final String sells_id;
  final String patient;
  final String medicine;
  final String quantity;
  final String price;
  final String sell_date;

  @override
  State<Update_SellsFormScreen> createState() => _Update_SellsFormScreenState();
}

class _Update_SellsFormScreenState extends State<Update_SellsFormScreen> {


  final _form = GlobalKey<FormState>();
  final List<Map<String, dynamic>> doctor_data = [];
  var dropDownspaValue;
  var dropDownsmedValue;
  var medicinename;
  String total_amount = '';
  String medicine_price = '';
  late Future<List> list;
  @override
  void initState() {
    dropDownspaValue=widget.patient;
    medicine.text=widget.medicine;
    print(widget.patient);
    quantity.text=widget.quantity;
    price.text=widget.price;
    sell_date.text=widget.sell_date;
    super.initState();
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
        sell_date.text = picked.toString().substring(0, 10);
      });
    }
  }

  void fetchData(String orderId) {
    list = operationsLab.instance.fetch_Data(
        "SELECT order_id, total_amount, medicines.name AS medicine, price, patient_table.name AS patient "
            "FROM onlineorders "
            "JOIN patient_table ON onlineorders.patient_id = patient_table.p_no "
            "JOIN medicines ON medicines.medicine_id = onlineorders.med_no "
            "WHERE status = 'pendding' AND order_id = '$orderId'"
    );

    list.then((value) {
      setState(() {
        if (value.isNotEmpty) {
          medicinename = value[0]['medicine'] ?? '';
          total_amount = value[0]['total_amount'] ?? '';
          medicine_price = value[0]['price'] ?? '';

          medicine.text = medicinename;
          quantity.text = total_amount;

          // Debug prints to see raw data
          print('Raw total_amount: $total_amount');
          print('Raw medicine_price: $medicine_price');

          // Check for non-numeric characters and clean the input
          total_amount = total_amount.replaceAll(RegExp(r'[^0-9.]'), '');
          medicine_price = medicine_price.replaceAll(RegExp(r'[^0-9.]'), '');

          try {
            double totalAmount = double.parse(total_amount);
            double medicinePrice = double.parse(medicine_price);
            price.text = (totalAmount * medicinePrice).toStringAsFixed(2);
          } catch (e) {
            print('Error parsing numbers: $e');
          }
        }
      });
    });
  }


  @override
  Widget build(BuildContext context) {
    Future<void> updateData() async {
      final isValid =_form.currentState!.validate();
      if(isValid){
        final data={
          'table': 'sells',
          'data': {
            'order_id': dropDownspaValue,
            'medicine': medicine.text,
            'quantity': quantity.text,
            'price': price.text,
            'sell_date': sell_date.text,

          },
          'updated_id':'sells_id',
          'id':widget.sells_id
        };
        try {
          var response = await http.post(Uri.parse('http://192.168.43.239/hospital_api/All/update.php'),
              body: json.encode(data));
          print(response.body);
          setState(() {
            if (response.statusCode == 200) {

              sell_date.clear();
              medicine.clear();
              price.clear();
              quantity.clear();

              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Data Updated successfully')));

              print("Data Updated successfully");
              Navigator.push(context, MaterialPageRoute(builder: (context)=>const SellsInfoScreen()));
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
        title: const Center(
          child: Text(
            'Update Sells ',
            style: TextStyle(color: Colors.white),
          ),
        ),
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
                        future: operationsLab.instance.fetch_Data(
                            "SELECT order_id, total_amount, patient_table.name AS patient "
                                "FROM onlineorders "
                                "JOIN patient_table ON onlineorders.patient_id = patient_table.p_no "
                                "WHERE status = 'pendding'"
                        ),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            List<dynamic> supplier = snapshot.data!;

                            return DropdownButtonFormField(
                              value: null,
                              icon: const Icon(Icons.keyboard_arrow_down),
                              items: supplier.map((sup) {
                                return DropdownMenuItem(
                                  value: sup['order_id'].toString(),
                                  child: Row(
                                    children: [
                                      Icon(Icons.people),
                                      SizedBox(width: 10),
                                      Text(sup['patient'].toString())
                                    ],
                                  ),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  dropDownspaValue = value;
                                  print('Selected order ID: $dropDownspaValue');
                                  fetchData(dropDownspaValue);
                                });
                              },
                              decoration: InputDecoration(
                                hintText: 'Select patient',
                                border: OutlineInputBorder(),
                              ),
                            );
                          } else if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          } else {
                            return CircularProgressIndicator();
                          }
                        },
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        controller: medicine,
                        enabled: false,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Medicine',
                        ),
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        controller: quantity,
                        enabled: false,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Quantity',
                        ),
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        controller: price,
                        enabled: false,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Price',
                        ),
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        controller: sell_date,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          suffixIcon: IconButton(
                            icon: Icon(Icons.calendar_today),
                            onPressed: () {
                              _selectDate(context);
                            },
                          ),
                          labelText: 'Sell Date',
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter sell date';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 10),
                      MaterialButton(
                        color: Color(0xFF3AB14B),
                        onPressed: updateData,
                        child: Text(
                          'Update',
                          style: TextStyle(color: Colors.white),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
