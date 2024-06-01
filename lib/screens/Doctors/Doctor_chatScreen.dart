import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../lab/retrive_labtests.dart';

TextEditingController _messageController = TextEditingController();

class DoctorChatScreen extends StatefulWidget {
  const DoctorChatScreen({super.key, required this.doctor_no});

  final  doctor_no;

  @override
  State<DoctorChatScreen> createState() => _DoctorChatScreenState();
}

class _DoctorChatScreenState extends State<DoctorChatScreen> {
  late Future<List> content;
  late Future<List> patient_id;
  String patientNO = '';
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    content = Future.value([]);

    patient_id = operationsLab.instance.fetch_Data('SELECT patient_id FROM contacts');
    patient_id.then((value) {
      setState(() {
        patientNO = value.isNotEmpty ? value[0]['patient_id'] : '';
        print(patientNO);
        print(value);
        fetchContent();
      });
    });
  }

  void fetchContent() {
    setState(() {
      content = operationsLab.instance.fetch_Data(
        'SELECT * FROM contacts WHERE patient_id=$patientNO OR doctor_id=${widget.doctor_no}',
      );
    });
  }

  Future<void> insertData() async {
    final data = {
      'table': 'contacts',
      'data': {
        'patient_id': patientNO,
        'doctor_id': widget.doctor_no,
        'Message': _messageController.text,
        'sender': 'doctor'
      }
    };

    print(data);
    try {
      var response = await http.post(
        Uri.parse('http://192.168.43.239/hospital_api/All/insertion.php'),
        body: json.encode(data),
      );

      print(response.body);
      if (response.statusCode == 200) {
        print("Data inserted successfully");
        _messageController.clear();
        fetchContent();
        _scrollToBottom();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Data failed response body ${response.body}')),
        );
        print("Failed to insert data");
        print("Status code: ${response.statusCode}");
        print("Response body: ${response.body}");
      }
    } catch (e) {
      print("There was an error: $e");
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('FlutterChat'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.exit_to_app,
              color: Theme.of(context).colorScheme.primary,
            ),
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder<List>(
              future: content,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No data available'));
                } else {
                  WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
                  return ListView.builder(
                    controller: _scrollController,
                    itemCount: snapshot.data?.length,
                    itemBuilder: (context, index) {
                      final message = snapshot.data?[index];
                      final isMe =  message['sender'] == 'doctor'; // Replace 'sender_id' with your actual field name
                        return Align(
                          alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 14),
                            margin: EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                            decoration: BoxDecoration(
                              color: isMe ? Colors.green[200] : Colors.blue[200],
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              message['Message'],
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        );
                    },
                  );
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15, right: 1, bottom: 14),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    textCapitalization: TextCapitalization.sentences,
                    autocorrect: true,
                    enableSuggestions: true,
                    decoration: const InputDecoration(labelText: 'Send a message...'),
                  ),
                ),
                IconButton(
                  color: Theme.of(context).colorScheme.primary,
                  icon: const Icon(Icons.send),
                  onPressed: insertData,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
