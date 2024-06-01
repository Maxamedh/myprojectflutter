import 'dart:convert';
import 'package:hospital/pharmacy/suppliers.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

TextEditingController name = TextEditingController();
TextEditingController contact = TextEditingController();
TextEditingController address = TextEditingController();


class Insert_SupplierFormScreen extends StatefulWidget {
  const Insert_SupplierFormScreen({super.key});

  @override
  State<Insert_SupplierFormScreen> createState() => _Insert_SupplierFormScreenState();
}

class _Insert_SupplierFormScreenState extends State<Insert_SupplierFormScreen> {
  @override
  void initState() {
    super.initState();
  }

  final _form = GlobalKey<FormState>();


  @override
  Widget build(BuildContext context) {
    Future<void> insertData() async {
      final isValid = _form.currentState!.validate();
      if (isValid) {
        final data = {
          'table': 'suppliers',
          'data': {
            'name': name.text,
            'contact': contact.text,
            'address': address.text,

          }
        };
        try {
          var response = await http.post(
            Uri.parse('http://192.168.43.239/hospital_api/All/insertion.php'),
            body: json.encode(data),
          );
          print(response.body);
          setState(() {});

          if (response.statusCode == 200) {
            contact.clear();
            address.clear();
            name.clear();


            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Data inserted successfully')));

            print("Data inserted successfully");
            Navigator.push(context, MaterialPageRoute(builder: (context) => const SupplierInfoScreen()));
          } else {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Data failed response body  ${response.body}')));
            print("Failed to insert data");
            print("Status code: ${response.statusCode}");
            print("Response body: ${response.body}");
          }
        } catch (e) {
          print("There was an error: $e");
        }
      } else {
        print('Form is not valid');
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
                        onPressed: insertData,
                        child: Text(
                          'Insert',
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
