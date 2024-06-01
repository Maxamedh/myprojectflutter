import 'package:flutter/material.dart';
import 'package:hospital/screens/Admin/patient_registration.dart';

import '../../Reports/Prescription_report.dart';
import '../../Reports/Statements.dart';
import '../../Reports/Visits_report.dart';
import '../../Reports/checkment_report.dart';
import '../../Reports/receipts_report.dart';
import '../../finance/Expense_charge.dart';
import '../../finance/Expense_payment.dart';
import '../../finance/Expenses.dart';
import '../../finance/Payments.dart';
import '../../finance/receipts.dart';
import '../../finance/salary_charge.dart';
import '../../lab/lab_results.dart';
import '../../lab/lab_tests.dart';
import '../../lab/samples.dart';
import '../../pharmacy/ONline_order.dart';
import '../../pharmacy/medicine_info.dart';
import '../../pharmacy/medicine_insertion.dart';
import '../../pharmacy/orderSCreen.dart';
import '../../pharmacy/sells.dart';
import '../../pharmacy/suppliers.dart';
import '../schedule.dart';
import '../staffs.dart';
import '../visits.dart';
import '../work_schedule.dart';
import 'doctor_registration.dart';

class MyDrawer extends StatefulWidget {
  const MyDrawer({super.key});

  @override
  _MyDrawerState createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  final ValueNotifier<int?> _expandedIndexNotifier = ValueNotifier<int?>(null);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Color(0xFF1368A1),
            ),
            child: Text(
              'Menu',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.dashboard),
            title: const Text('Dashboard'),
            onTap: () {
              // Navigate to dashboard screen
            },
          ),
          ValueListenableBuilder<int?>(
            valueListenable: _expandedIndexNotifier,
            builder: (context, expandedIndex, child) {
              return Column(
                children: [
                  ExpansionTile(
                    key: UniqueKey(),
                    leading: const Icon(Icons.app_registration),
                    title: const Text('Patient Management'),
                    initiallyExpanded: expandedIndex == 0,
                    onExpansionChanged: (isExpanded) {
                      if (isExpanded) {
                        _expandedIndexNotifier.value = 0;
                      } else if (_expandedIndexNotifier.value == 0) {
                        _expandedIndexNotifier.value = null;
                      }
                    },
                    children: <Widget>[
                      ListTile(
                        title: const Text('patient Registration'),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const PatientRegistrationScreen()),
                          );
                        },
                      ),
                      ListTile(
                        title: const Text('Visits'),
                        onTap: () {
                        Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) =>  VisitScreen()),
                        );

                        },
                      ),
                    ],
                  ),
                  ExpansionTile(
                    key: UniqueKey(),
                    leading: const Icon(Icons.attach_money),
                    title: const Text('Staff Management'),
                    initiallyExpanded: expandedIndex == 1,
                    onExpansionChanged: (isExpanded) {
                      if (isExpanded) {
                        _expandedIndexNotifier.value = 1;
                      } else if (_expandedIndexNotifier.value == 1) {
                        _expandedIndexNotifier.value = null;
                      }
                    },
                    children: <Widget>[
                      ListTile(
                        title: const Text('Staff Registration'),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const StaffScreen()),
                          );
                        },
                      ),
                      ListTile(
                        title: const Text('Doctor Registration'),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const DoctorRegistrationScreen()),
                          );
                        },
                      ),
                      ListTile(
                        title: const Text('Scheduling'),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const WorkScreen()),
                          );
                        },
                      ),
                      ListTile(
                        title: const Text('Salary Payment'),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const PaymentScreen()),
                          );
                        },
                      ),
                      ListTile(
                        title: const Text('Statement'),
                        onTap: () {

                        },
                      ),
                      ListTile(
                        title: const Text('Doctor Availability'),
                        onTap: () {
                          const SizedBox(height: 16,
                            width: 16,
                            child: CircularProgressIndicator(),);
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) =>  Doctor_schedule_screen()),
                          );
                        },
                      ),
                    ],
                  ),
                  ExpansionTile(
                    key: UniqueKey(),
                    leading: const Icon(Icons.attach_money),
                    title: const Text('Laboratory Management'),
                    initiallyExpanded: expandedIndex == 2,
                    onExpansionChanged: (isExpanded) {
                      if (isExpanded) {
                        _expandedIndexNotifier.value = 2;
                      } else if (_expandedIndexNotifier.value == 2) {
                        _expandedIndexNotifier.value = null;
                      }
                    },
                    children: <Widget>[
                      ListTile(
                        title: const Text('Lab Tests'),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const LabtestScreen()),
                          );
                        },
                      ),
                      ListTile(
                        title: const Text('Lab Samples'),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const LabSampletestScreen()),
                          );
                        },
                      ),
                      ListTile(
                        title: const Text('Lab Results'),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const LabResulttestScreen()),
                          );
                        },
                      ),

                    ],
                  ),
                  ExpansionTile(
                    key: UniqueKey(),
                    leading: const Icon(Icons.attach_money),
                    title: const Text('Finance'),
                    initiallyExpanded: expandedIndex == 3,
                    onExpansionChanged: (isExpanded) {
                      if (isExpanded) {
                        _expandedIndexNotifier.value = 3;
                      } else if (_expandedIndexNotifier.value == 3) {
                        _expandedIndexNotifier.value = null;
                      }
                    },
                    children: <Widget>[
                      ListTile(
                        title: const Text('Salary Charge'),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const Salary_chargeScreen()),
                          );
                        },
                      ),
                      ListTile(
                        title: const Text('Expense Charge'),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const Expense_chargeScreen()),
                          );
                        },
                      ),
                      ListTile(
                        title: const Text('Expenses'),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const ExpenseScreen()),
                          );
                        },
                      ),
                      ListTile(
                        title: const Text('Payment'),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const PaymentScreen()),
                          );
                        },
                      ),
                      ListTile(
                        title: const Text('Receipts'),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const ReceiptsScreen()),
                          );
                        },
                      ),
                      ListTile(
                        title: const Text('Expense Payment'),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const Expense_payScreen()),
                          );
                        },
                      ),
                    ],
                  ),
                  ExpansionTile(
                    key: UniqueKey(),
                    leading: const Icon(Icons.attach_money),
                    title: const Text('Pharmacy'),
                    initiallyExpanded: expandedIndex == 4,
                    onExpansionChanged: (isExpanded) {
                      if (isExpanded) {
                        _expandedIndexNotifier.value = 4;
                      } else if (_expandedIndexNotifier.value == 4) {
                        _expandedIndexNotifier.value = null;
                      }
                    },
                    children: <Widget>[
                      ListTile(
                        title: const Text('Medicine'),
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>const MedicineInfoScreen()));
                        },
                      ),
                      ListTile(
                        title: const Text('Orders'),
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>const OrderInfoScreen()));

                        },
                      ),
                      ListTile(
                        title: const Text('Online Orders'),
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>const onlineOrderinfoScreen()));

                        },
                      ),
                      ListTile(
                        title: const Text('Delivery'),
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>const SellsInfoScreen()));

                        },
                      ),
                      ListTile(
                        title: const Text('Suppliers'),
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>const SupplierInfoScreen()));

                        },
                      ),
                      ListTile(
                        title: const Text('Expired Medicines'),
                        onTap: () {
                          // Navigate to Accounts screen
                        },
                      ),

                    ],
                  ),
                  ExpansionTile(
                    key: UniqueKey(),
                    leading: const Icon(Icons.attach_money),
                    title: const Text('Reports'),
                    initiallyExpanded: expandedIndex == 5,
                    onExpansionChanged: (isExpanded) {
                      if (isExpanded) {
                        _expandedIndexNotifier.value = 5;
                      } else if (_expandedIndexNotifier.value == 5) {
                        _expandedIndexNotifier.value = null;
                      }
                    },
                    children: <Widget>[

                      ListTile(
                        title: const Text('Visits'),
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>const VisitsReport()));

                        },
                      ),
                      ListTile(
                        title: const Text('Checkments'),
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>const CheckmentReport()));

                        },
                      ),
                      ListTile(
                        title: const Text('Receipts'),
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>const ReceptsReport()));

                        },
                      ),
                      ListTile(
                        title: const Text('Prescription'),
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>const PrescriptionReport()));

                        },
                      ),
                      ListTile(
                        title: const Text('Patient Statement'),
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>const StatementReport()));

                        },
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.people),
            title: const Text('User Accounts'),
            onTap: () {
              // Navigate to User Accounts screen
            },
          ),

        ],
      ),
    );
  }
}

