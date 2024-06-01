  import 'dart:io';
  import 'package:flutter/material.dart';
  import 'package:hospital/lab/retrive_labtests.dart';
  import 'package:open_file/open_file.dart';
  import 'package:pdf/pdf.dart';
  import 'package:pdf/widgets.dart' as pw;
  import 'package:path_provider/path_provider.dart';
  import 'package:font_awesome_flutter/font_awesome_flutter.dart';
  import 'package:flutter/services.dart' show ByteData, Uint8List, rootBundle;


  class AppointmentIdCard extends StatefulWidget {
    final String logoPath;
    final String room;
    final String patient_id;

    AppointmentIdCard({
      required this.logoPath,
      required this.room,
      required this.patient_id,
    });

    @override
    State<AppointmentIdCard> createState() => _AppointmentIdCardState();
  }

  class _AppointmentIdCardState extends State<AppointmentIdCard> {
    String paitent_name = '';
    String doctor_name = '';
    String app_date = '';
    String duration = '';
    String appotnment_id = '';
    String gmail = '';
    String Staff_tel = '';
    late Future<List> adData;

    @override
    void initState() {
      adData = operationsLab.instance.fetch_Data(
          'SELECT app_no, p_no,name,staff_name,gmail,staff_tell,app_date,app_time_with_duration from staff, doctor,appointment,patient_table where staff.staff_no=doctor.staff_no and doctor.doctor_no=appointment.doctor_no and patient_table.p_no=appointment.patient_no and p_no=${widget.patient_id}');
      setState(() {
        adData.then((value) {
          paitent_name = value.isNotEmpty ? value[0]['name'] : '';
          doctor_name = value.isNotEmpty ? value[0]['staff_name'] : '';
          app_date = value.isNotEmpty ? value[0]['app_date'] : '';
          duration = value.isNotEmpty ? value[0]['app_time_with_duration'] : '';
          appotnment_id = value.isNotEmpty ? value[0]['app_no'] : '';
          gmail = value.isNotEmpty ? value[0]['gmail'] : '';
          Staff_tel = value.isNotEmpty ? value[0]['staff_tell'] : '';
          print(adData);
          print(paitent_name);
        });
      });

      super.initState();
    }

    Future<void> _saveAsPDF() async {
      final ByteData imageData = await rootBundle.load(widget.logoPath);
      final Uint8List imageBytes = imageData.buffer.asUint8List();
      final pdf = pw.Document();
      pdf.addPage(
        pw.Page(
          build: (pw.Context context) {
            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: <pw.Widget>[
                pw.Text(
                  'Appointment ID Card',
                  style:  pw.TextStyle(
                    fontSize: 20.0,
                    color: PdfColors.blue,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.SizedBox(height: 30.0),
                pw.Row(
                  children: <pw.Widget>[
                    pw.Image(
                      pw.MemoryImage(imageBytes),
                      width: 150,
                      height: 60.0,
                    ),
                    pw.SizedBox(width: 100.0),
                    pw.Expanded(
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: <pw.Widget>[
                          pw.Text('Date: $app_date', style: pw.TextStyle(
                            fontSize: 25,
                            color: PdfColors.green
                          )),
                          pw.SizedBox(height: 10,),
                          pw.Text('Appointment ID: $appotnment_id',style: pw.TextStyle(
                              fontSize: 25,
                              color: PdfColors.green)),
                        ]
                      ),
                    ),
                  ],
                ),
                pw.SizedBox(height: 20,),
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: <pw.Widget>[
                    pw.Divider(color: PdfColors.green),
                    pw.Text('Doctor Name: $doctor_name',style:pw.TextStyle(
                      fontSize: 20.0,
                      color: PdfColors.blue,
                      ),
                    ),
                    pw.Divider(color: PdfColors.green),
                    pw.SizedBox(height: 10.0),
                    pw.Text('Doctor Room: ${widget.room}',style:pw.TextStyle(
                      fontSize: 20.0,
                      color: PdfColors.blue,
                    ),),
                    pw.Divider(color: PdfColors.green),
                    pw.SizedBox(height: 10.0),
                    pw.Text('Patient name: $paitent_name',style:pw.TextStyle(
                      fontSize: 20.0,
                      color: PdfColors.blue,
                    ),),
                    pw.Divider(color: PdfColors.green),
                    pw.SizedBox(height: 10.0),
                    pw.Text('Time Duration: $duration',style:pw.TextStyle(
                      fontSize: 20.0,
                      color: PdfColors.blue,
                    ),),
                  ],
                ),
                pw.Divider(color: PdfColors.green),
                pw.SizedBox(height: 20,),
                pw.Container(

                  color: PdfColors.grey200,
                  padding: pw.EdgeInsets.all(16.0),
                  child: pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
                    children: <pw.Widget>[
                      pw.Column(
                        children: <pw.Widget>[
                          buildIcon(FontAwesomeIcons.envelope),
                          pw.SizedBox(height: 4.0),
                          pw.Text(gmail,style:pw.TextStyle(
                            fontSize: 20.0,
                            color: PdfColors.blue,

                          )),
                        ],
                      ),
                      pw.Column(
                        children: <pw.Widget>[
                          buildIcon(FontAwesomeIcons.phone),
                          pw.SizedBox(height: 4.0),
                          pw.Text(Staff_tel,style:pw.TextStyle(
                            fontSize: 20.0,
                            color: PdfColors.blue,
                          )),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      );

      final output = await getTemporaryDirectory();
      final file = File('${output.path}/appointment_id_card.pdf');
      await file.writeAsBytes(await pdf.save());
      OpenFile.open(file.path);
    }

    pw.Widget buildIcon(IconData icon) {
      return pw.Container(
        alignment: pw.Alignment.center,
        child: pw.Text(
          String.fromCharCode(icon.codePoint),
          style: pw.TextStyle(
            fontSize: 20.0,
            color: PdfColors.green,
          ),
        ),
      );
    }


    @override
    Widget build(BuildContext context) {
      return FutureBuilder(
        future: adData,
        builder: (context, snapshot) {
          return Card(
            elevation: 4.0,
            margin: EdgeInsets.all(16.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: Column(
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15.0),
                      topRight: Radius.circular(15.0),
                    ),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Row(
                    children: <Widget>[
                      SizedBox(width: 8.0),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'Appointment ID Card',
                              style: TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.download),
                        color: Colors.white,
                        onPressed: _saveAsPDF,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 30.0),
                Row(
                        children: <Widget>[
                        Image.asset(
                        widget.logoPath,
                        height: 60.0,
                        width: 150,
                        ),
                        SizedBox(width: 40.0),
                        Expanded(
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                        Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                        Text(
                        'Date: $app_date',
                        style: TextStyle(color: Colors.green, fontSize: 18),
                        ),
                        SizedBox(height: 10,),
                         Text('Appointment ID: $appotnment_id',
                  style: TextStyle(color: Colors.green),
                         ),
                        ],
                        ),
                        ],
                        ),
                        ),
                  ],
                  ),
                  SizedBox(height: 20,),
                  Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                  Divider(color: Colors.green),
                  Row(
                  children: [
                  Text(
                  'Doctor Name:    $doctor_name',
                  style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  ),
                  ),
                  ],
                  ),
                  Divider(color: Colors.green),
                  SizedBox(height: 10.0),
                  Text(
                  'Doctor Room:   ${widget.room}',
                  style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  ),
                  ),
                  Divider(color: Colors.green),
                  SizedBox(height: 10.0),
                  Text(
                  'Patient name:   $paitent_name',
                  style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  ),
                  ),
                  Divider(color: Colors.green,),
                  SizedBox(height: 10.0),
                  Text(
                  'Time Duration:   $duration',
                  style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  ),
                  ),
                  ],
                  ),
                  ),
                  Divider(color: Colors.green),
                  SizedBox(height: 20,),
                  Container(
                  color: Colors.grey[200],
                  padding: EdgeInsets.all(16.0),
                  child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                  Column(
                  children: <Widget>[
                  Icon(Icons.email),
                  SizedBox(height: 4.0),
                  Text(gmail),
                  ],
                  ),
                  Column(
                  children: <Widget>[
                  Icon(Icons.phone),
                  SizedBox(height: 4.0),
                  Text(Staff_tel as String),
                  ],
                  ),
                  ],
                  ),
                  )
              ],
            ),
          );
        },
      );
    }
  }
