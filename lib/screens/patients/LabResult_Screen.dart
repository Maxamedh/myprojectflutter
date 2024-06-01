import 'package:flutter/material.dart';
import 'package:hospital/screens/patients/widgets/Appointment.dart';
import 'package:hospital/screens/patients/widgets/Current_chekment.dart';
import 'package:hospital/screens/patients/widgets/Labs.dart';

var islohin;

class LabResultScreen extends StatefulWidget {
  const LabResultScreen({super.key,
    required this.patient_id,required this.patient_name
  });

  final patient_id;
  final patient_name;


  @override
  State<LabResultScreen> createState() => _LabResultScreenState();
}

class _LabResultScreenState extends State<LabResultScreen> {

  int _selectedPageIndex =0;
  void _selectPage(int index){
    setState(() {
      _selectedPageIndex=index;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget activePage=  LabsResult(patient_id: widget.patient_id,);
    if(_selectedPageIndex==1 ){
      setState(() {
        activePage= CurrentCheckment(patient_id: widget.patient_id);
      });

    }else if(_selectedPageIndex==2){
      activePage=const Appointment();
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Center(child: Text('${widget.patient_name }   Dashboard',style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white
        ),),),
      ),
      body: activePage,
      bottomNavigationBar: BottomNavigationBar(
        onTap: _selectPage,
        currentIndex: _selectedPageIndex,
        type: BottomNavigationBarType.fixed,
        unselectedItemColor: Colors.cyan,
        selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
        unselectedLabelStyle: TextStyle(fontWeight: FontWeight.normal),
        items: const [

          BottomNavigationBarItem(
            icon:Icon(
              Icons.medical_services,
              size: 26,
            ),
            label: 'Historical Checkments',
            backgroundColor: Colors.blue,


          ),
          BottomNavigationBarItem(
              icon:Icon(
                Icons.calendar_today,
                size: 26,
              ),
              label: 'Current checkment',
              backgroundColor: Colors.blue

          ),

        ],
      ),
    );
  }
}
