import 'dart:convert';
import 'dart:io';
import 'package:hospital/lab/lab_tests.dart';
import 'package:hospital/lab/retrive_labtests.dart';
import 'package:http/http.dart' as http;
import 'package:date_time_picker_widget/date_time_picker_widget.dart';
import 'package:flutter/material.dart';
import 'package:hospital/models/patient_model.dart';

TextEditingController test_name =new TextEditingController();
TextEditingController description =new TextEditingController();
TextEditingController cost =new TextEditingController();


class Insert_Lab_t_record_screen extends StatefulWidget {
  const Insert_Lab_t_record_screen({super.key});



  @override
  State<Insert_Lab_t_record_screen> createState() => _Insert_Lab_t_record_screenState();
}

class _Insert_Lab_t_record_screenState extends State<Insert_Lab_t_record_screen> {


  @override
  void initState() {
    // TODO: implement initState
    operations.instance.fetchDoctor();

    super.initState();
  }

  final _form = GlobalKey<FormState>();

  //final List<Map<String, dynamic>> data  =[];
  final List<Map<String, dynamic>> doctor_data = [];

  @override
  Widget build(BuildContext context) {
    int a=0;
    Future<void> insertData() async {
      final isValid =_form.currentState!.validate();
      if(isValid){
      final data={
        'table': 'lab_tests',
        'data': {
          'test_name': test_name.text,
          'description': description.text,
          'cost': cost.text,
        }
      };
      try {
        var response = await http.post(Uri.parse('http://192.168.43.239/hospital_api/All/insertion.php'),
            body: json.encode(data));
        print(response.body);
        setState(() {
          operationsLab.instance.fetch_Data('select * from lab_tests');
        });
        if (response.statusCode == 200) {

          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Data inserted successfully')));

          print("Data inserted successfully");
          Navigator.push(context, MaterialPageRoute(builder: (context)=>LabtestScreen()));
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
        title: const Center(child: Text('Add Labs',style:
        TextStyle(color: Colors.white),),),
        backgroundColor: Color(0xFF3AB14B),
      ),
      body: ListView(
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 40),
            child: Form(
              key: _form,
              child: Column(
                children: [

                  TextFormField(
                    controller: test_name,
                    decoration: InputDecoration(
                      label: Text('Test Name'),

                    ),
                    keyboardType: TextInputType.text,

                    autocorrect: false,
                    validator: (value){
                      if(value==null || value.trim().isEmpty
                      ){
                        return 'Please inter Name';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20,),
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
                  SizedBox(height: 20,),
                  TextFormField(
                    controller: cost,
                    decoration: InputDecoration(
                      label: Text('Cost'),
                     hintText: 'Enter the cost'
                    ),
                    keyboardType: TextInputType.number,
                    autocorrect: false,
                    validator: (value){
                      if(value==null || value.trim().isEmpty
                      ){
                        return 'Please Enter A cost';
                      }
                      return null;
                    },
                  ),

                  SizedBox(height: 10,),

                  ElevatedButton(onPressed: insertData,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF1368A1),
                    ), child: Text('Save',style: TextStyle(color: Colors.white),),)
                ],
              ),

            ),

          ),


        ],
      ),
    );
  }
}
