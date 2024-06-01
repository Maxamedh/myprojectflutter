import 'dart:convert';
import 'package:hospital/pharmacy/insert_supplier.dart';
import 'package:hospital/pharmacy/suppliers.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

TextEditingController name = TextEditingController();
TextEditingController contact = TextEditingController();
TextEditingController address = TextEditingController();


class Update_SupplierFormScreen extends StatefulWidget {
  const Update_SupplierFormScreen({super.key,
  required this.supplier_id,
  required this.supp_name,
  required this.supp_contact,
  required this.sub_address,
  });

  final supplier_id;
  final supp_name;
  final supp_contact;
  final sub_address;

  @override
  State<Update_SupplierFormScreen> createState() => _Update_SupplierFormScreenState();
}

class _Update_SupplierFormScreenState extends State<Update_SupplierFormScreen> {
  @override
  void initState() {

    name.text=widget.supp_name;
    contact.text=widget.supp_contact;
    address.text=widget.sub_address;
    super.initState();
  }

  final _form = GlobalKey<FormState>();


  @override
  Widget build(BuildContext context) {
    Future<void> updateData() async {
      final isValid =_form.currentState!.validate();
      if(isValid){
        final data={
          'table': 'suppliers',
          'data': {
            'name': name.text,
            'contact': contact.text,
            'address': address.text,

          },
          'updated_id':'supplier_id',
          'id':widget.supplier_id
        };
        try {
          var response = await http.post(Uri.parse('http://192.168.43.239/hospital_api/All/update.php'),
              body: json.encode(data));
          print(response.body);
          setState(() {
            if (response.statusCode == 200) {

              name.clear();
              address.clear();
              contact.clear();

              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Data Updated successfully')));

              print("Data Updated successfully");
              Navigator.push(context, MaterialPageRoute(builder: (context)=>const SupplierInfoScreen()));
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
            'Add suppliers ',
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

                      SizedBox(height: 10),
                      TextFormField(
                        controller: name,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Name',
                        ),
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        controller: contact,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Contact',
                        ),
                        keyboardType: TextInputType.number,
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        controller: address,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Address',
                        ),
                      ),

                      SizedBox(height: 10),
                      MaterialButton(
                        color: Color(0xFF3AB14B),
                        onPressed: updateData,
                        child: const Text(
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
