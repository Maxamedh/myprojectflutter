import 'dart:convert';
import 'package:hospital/finance/Expenses.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

TextEditingController expesne_Name =new TextEditingController();


class Update_Expense_record_screen extends StatefulWidget {
  const Update_Expense_record_screen({super.key,
    required this.exp_id,
    required this.expense_name
  });

  final String exp_id;
  final String expense_name;



  @override
  State<Update_Expense_record_screen> createState() => _Update_Expense_record_screenState();
}

class _Update_Expense_record_screenState extends State<Update_Expense_record_screen> {


  @override
  void initState() {
    // TODO: implement initState
    expesne_Name.text=widget.expense_name;
    super.initState();
  }

  final _form = GlobalKey<FormState>();

  //final List<Map<String, dynamic>> data  =[];
  final List<Map<String, dynamic>> doctor_data = [];

  @override
  Widget build(BuildContext context) {
    int a=0;
    Future<void> updateData() async {
      final isValid =_form.currentState!.validate();
      if(isValid){
        final data={
          'table': 'expenses',
          'data': {
            'exp_name': expesne_Name.text,
          },
          'updated_id':'ex_no',
          'id':widget.exp_id
        };
        try {
          var response = await http.post(Uri.parse('http://192.168.43.239/hospital_api/All/update.php'),
              body: json.encode(data));
          print(response.body);
          setState(() {
            if (response.statusCode == 200) {

              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Data Updated successfully')));

              print("Data Updated successfully");
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
        title: const Center(child: Text('Update Expense',style:
        TextStyle(color: Colors.white),),),
        backgroundColor: Color(0xFF3AB14B),
      ),
      body: ListView(
        children: [
           Center(
              child: Form(
                key: _form,
                child: Column(
                  children: [
                    SizedBox(height: 20,),
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

                    ElevatedButton(onPressed: updateData,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF1368A1),
                      ), child: Text('Update',style: TextStyle(color: Colors.white),),)
                  ],
                ),

              ),
            ),




        ],
      ),
    );
  }
}
