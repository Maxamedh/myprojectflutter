import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../lab/retrive_labtests.dart';

TextEditingController _messageController = TextEditingController();

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key, required this.patient_id});

  final String patient_id;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late Future<List> content;
  late Future<List> doctor_id;
  String doctor_no = '';
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // FirebaseMessaging.instance.getToken().then((token) {
    //   print('FCM Token: $token');
    // });
    //
    // FirebaseMessaging.instance.subscribeToTopic('your_topic_name');
    //
    // FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    //   print("Message received: ${message.notification?.body}");
    //
    // });

    // Initialize content with an empty list Future
    content = Future.value([]);
    doctor_id = operationsLab.instance.fetch_Data('SELECT doctor_no FROM appointment');
    doctor_id.then((value) {
      setState(() {
        doctor_no = value.isNotEmpty ? value[0]['doctor_no'] : '';
        fetchContent();
      });
    });
  }

  void fetchContent() {
    setState(() {
      content = operationsLab.instance.fetch_Data(
        'SELECT * FROM contacts WHERE patient_id=${widget.patient_id} OR doctor_id=$doctor_no',
      );
    });
  }

  Future<void> insertData() async {
    final data = {
      'table': 'contacts',
      'data': {
        'patient_id': widget.patient_id,
        'doctor_id': doctor_no,
        'Message': _messageController.text,
        'sender': 'patient'
      }
    };
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


        await http.post(
          Uri.parse('https://fcm.googleapis.com/fcm/send'),
          headers: <String, String>{
            'Content-Type': 'application/json',
            'Authorization': 'key=YOUR_SERVER_KEY',
          },
          body: jsonEncode(<String, dynamic>{
            'notification': <String, dynamic>{
              'body': 'New message from patient',
              'title': 'New Message',
            },
            'priority': 'high',
            'data': <String, dynamic>{
              'click_action': 'FLUTTER_NOTIFICATION_CLICK',
              'id': '1',
              'status': 'done'
            },
            'to': 'YOUR_DEVICE_TOKEN',
          }),
        );

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
                      final isMe = message['sender'] == 'patient';
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
