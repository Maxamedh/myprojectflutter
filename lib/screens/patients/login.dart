import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:hospital/screens/patients/patient_registration%20Screen.dart';
import 'package:hospital/screens/patients/widgets/dashboard.dart';

class UserData {
  final int id;
  final String username;
  final String email;
  final String password;

  UserData({required this.id, required this.username, required this.email, required this.password});

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      id: int.parse(json['user_no']),
      username: json['username'],
      email: json['email'],
      password: json['password'],
    );
  }
}

class LoginPatientScreen extends StatefulWidget {
  const LoginPatientScreen({super.key});

  @override
  State<LoginPatientScreen> createState() => _LoginPatientScreenState();
}

class _LoginPatientScreenState extends State<LoginPatientScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLogin = true;

  Future<void> login() async {
    if (_formKey.currentState!.validate()) {
      final response = await http.post(
        Uri.parse('http://192.168.43.239/hospital_api/patient_oper/patient_login.php'),
        body: {
          'email': emailController.text,
          'password': passwordController.text,
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);

        if (data['authenticated']) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => PatientDashbord(email: emailController.text)),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Invalid username or password')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load data')),
        );
      }
    } else {
      print('Not validated');
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = Color(0xFF1368A1);
    final Color secondaryColor = Color(0xFF3AB14B);

    final theme = Theme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.symmetric(vertical: 30),
                width: 200,
                child: Image.asset('assets/loginIcon.png'),
              ),
              Card(
                elevation: 8.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextFormField(
                          controller: emailController,
                          decoration: InputDecoration(
                            labelText: 'Email Address',
                            prefixIcon: Icon(Icons.email, color: primaryColor),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty || !value.contains('@')) {
                              return 'Please enter a valid email address';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: passwordController,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            prefixIcon: Icon(Icons.lock, color: primaryColor),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          obscureText: true,
                          validator: (value) {
                            if (value == null || value.trim().length < 2) {
                              return 'Password must be at least 2 characters long';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: login,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                            backgroundColor: primaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text('Login', style: TextStyle(fontSize: 16, color: Colors.white)),
                        ),
                        const SizedBox(height: 16),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              _isLogin = !_isLogin;
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const RegisterPatientFormScreen()),
                              );
                            });
                          },
                          child: Text(
                            _isLogin ? 'Create an account' : 'I already have an account',
                            style: TextStyle(color: secondaryColor),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
