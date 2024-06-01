import 'dart:convert';
import 'package:hospital/finance/Expenses.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

TextEditingController expesne_Name =new TextEditingController();


class Insert_Expense_record_screen extends StatefulWidget {
  const Insert_Expense_record_screen({super.key});



  @override
  State<Insert_Expense_record_screen> createState() => _Insert_Expense_record_screenState();
}

class _Insert_Expense_record_screenState extends State<Insert_Expense_record_screen> {


  @override
  void initState() {
    // TODO: implement initState

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
          'table': 'expenses',
          'data': {
            'exp_name': expesne_Name.text,

          }
        };
        try {
          var response = await http.post(Uri.parse('http://192.168.43.239/hospital_api/All/insertion.php'),
              body: json.encode(data));
          print(response.body);
          setState(() {
            if (response.statusCode == 200) {

              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Data inserted successfully')));
             
              print("Data inserted successfully");
              Navigator.push(context, MaterialPageRoute(builder: (context)=>ExpenseScreen()));
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
        title: const Center(child: Text('Add Expense',style: TextStyle(
          color: Colors.white
        ),),),
        backgroundColor: Color(0xFF3AB14B),
      ),
      body: ListView(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 40),
            child: Center(
              child: Form(
                key: _form,
                child: Column(
                  children: [

                    TextFormField(
                      controller: expesne_Name,
                      decoration: InputDecoration(
                        label: Text('Expense Name'),

                      ),
                      keyboardType: TextInputType.text,

                      autocorrect: false,
                      validator: (value){
                        if(value==null || value.trim().isEmpty
                        ){
                          return 'Please inter Expense';
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

          ),


        ],
      ),
    );
  }
}
