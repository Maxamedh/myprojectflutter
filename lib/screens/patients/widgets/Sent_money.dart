import 'dart:convert';
import 'package:hospital/finance/receipts.dart';
import 'package:hospital/lab/retrive_labtests.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:telephony/telephony.dart';

TextEditingController rec_date =new TextEditingController();
TextEditingController amount =new TextEditingController();
TextEditingController discount =new TextEditingController();
TextEditingController description =new TextEditingController();


class Send_Receipt_record_screen extends StatefulWidget {
  const Send_Receipt_record_screen({super.key,
    required this.patient_id,required this.doctor_no,
    required this.timeDuration,required this.app_date,required this.room
  });
final patient_id;
final doctor_no;
final timeDuration;
final app_date;
final room;
  @override
  State<Send_Receipt_record_screen> createState() => _Send_Receipt_record_screenState();
}

class _Send_Receipt_record_screenState extends State<Send_Receipt_record_screen> {

Telephony telephony=Telephony.instance;
  @override
  void initState() {
    // TODO: implement initState
  amount.text=10.toString();
    super.initState();
  }
  @override

  final _form = GlobalKey<FormState>();
  //final List<Map<String, dynamic>> data  =[];
  final List<Map<String, dynamic>> doctor_data  =[];
  var dropDownaccValue;
  var dropDownpatValue;



  String startTime = '';
  String endTime ='';


  Future<void> insertData() async {

    List<String>? parts = widget.timeDuration.split(' -');
    startTime = parts![0];
    endTime = parts[1];
    print("Start Time: $startTime");
    print("End Time: $endTime");
    final isValid =_form.currentState!.validate();
    if(isValid){
      final data={
        'table': 'appointment',
        'data': {
          'patient_no': widget.patient_id,
          'doctor_no': widget.doctor_no,
          'app_date': widget.app_date,
          'app_time_with_duration': widget.timeDuration,
        }
      };
      try {
        var response = await http.post(Uri.parse('http://192.168.43.239/hospital_api/All/insertion.php'),
            body: json.encode(data));
        print(response.body);
        setState(() {
          operationsLab.instance.fetch_Data('select * from appointment');
        });
        if (response.statusCode == 200) {
          operationsLab.instance.fetch_Data("UPDATE doctor_availability set status='Inactive' WHERE start_time='${startTime}'  and end_time='${endTime}'");
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Data inserted successfully')));

          print("Data inserted successfully");

        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Data failed response body  ${response.body}')));
          print("Failed to insert data");
          print("Status code: ${response.statusCode}");
          print("Response body: ${response.body}");
        }
      } catch (e) {
        print("There was an error: $e");
      }
    }else{
      print('not valid');
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    print(telephony.simOperatorName);
    print(telephony.simOperator);
    print(telephony.callState);
    print(telephony.cellularDataState);
    print(telephony.isSmsCapable);
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        rec_date.text = picked.toString().substring(0,
            10);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    int a=0;
    Future<void> insertData() async {
      final isValid =_form.currentState!.validate();
      if(isValid){
        final data={
          'table': 'receipts',
          'data': {
            'p_no': dropDownpatValue,
            'amount': amount.text,
            'rec_date':  rec_date.text,
            'discount':discount.text,
            'description': description.text,
            'ac_no': dropDownaccValue,
          }
        };
        try {
          var response = await http.post(Uri.parse('http://192.168.43.239/hospital_api/All/insertion.php'),
              body: json.encode(data));
          print(response.body);
          setState(() {
          });
          if (response.statusCode == 200) {

            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Data inserted successfully')));

            print("Data inserted successfully");
            Navigator.push(context, MaterialPageRoute(builder: (context)=>ReceiptsScreen()));
          } else {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Data failed response body  ${response.body}')));
            print("Failed to insert data");
            print("Status code: ${response.statusCode}");
            print("Response body: ${response.body}");
          }
        } catch (e) {
          print("There was an error: $e");
        }
      }else{
        print('not valid');
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Add Receipts'),),
      ),
      body:Card(

        color: Colors.blue,
        child: Center(
          child: Container(
            color: Colors.white,
            child: Form(

              key: _form,
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  children: [
                  Container(
                    width: 100,
                      height: 100,
                      child: Image.asset('assets/payment.png')
                  ),
                    SizedBox(height: 10,),
                    const Text('Idcard Payment form',style: TextStyle(
                        fontSize: 20,fontWeight: FontWeight.bold, color: Colors.blue
                    ),),
                    SizedBox(height: 10,),
                    FutureBuilder(
                        future: operationsLab.instance.fetch_Data('SELECT * FROM accounts order by ac_no asc limit 3'),
                        builder: (context, snapshot){
                          if(snapshot.hasData){
                            List<dynamic> account =snapshot.data!;
        
                            return SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                              child: DropdownButtonFormField(
                                value: null,
                                icon: const Icon(Icons.keyboard_arrow_down),
                                items: account.map((acc) {
                                  return DropdownMenuItem(
                                    value: acc['ac_no'].toString(),
                                    child: Row(
                                      children: [
                                        Icon(Icons.people),
                                        SizedBox(width: 10,),
                                        Text('${acc['ac_name'].toString()}')
                                      ],

                                    ),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    dropDownaccValue=value;
                                    print(dropDownaccValue);
                                  });
                                },
                                decoration: InputDecoration(
                                  hintText: dropDownaccValue ?? 'Select account',
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
        
                    SizedBox(height: 16,),
        
                    TextFormField(
                      controller: amount,
                      decoration: InputDecoration(
                        label: Text('Amount'),
                        filled: true,
                        fillColor: Colors.grey[200], // Light grey background to indicate read-only
                      ),
                      keyboardType: TextInputType.number,
                      autocorrect: false,
                      enabled: false, // Make the TextFormField read-only
                      validator: (value) {
        
                      },
                    ),
                    SizedBox(height: 16,),
        
                    TextFormField(
                      controller: description,
                      decoration: InputDecoration(
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
        
                 SizedBox(height: 16,),
                    ElevatedButton(onPressed: insertData, child: Text('Save'))
                  ],
                ),
              ),
            ),
          ),
        ),
      )
    );
  }
}
