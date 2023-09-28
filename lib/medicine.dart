import 'dart:convert';

import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:health/add_medicines.dart';
import 'package:health/dashboard.dart';
import 'package:health/forum.dart';
import 'package:health/logout.dart';
import 'package:health/notification.dart';
import 'package:health/register.dart';
import 'package:health/settings.dart';
import 'package:json_table/json_table.dart';
import 'package:linear_progress_bar/linear_progress_bar.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:health/globals.dart' as globals;
import 'menu.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';
// ignore: depend_on_referenced_packages
import 'package:internet_connection_checker/internet_connection_checker.dart';

class MedicinePage extends StatefulWidget {
  const MedicinePage({Key? key}) : super(key: key);

  @override
  State<MedicinePage> createState() => _MedicinePageState();
}

class _MedicinePageState extends State<MedicinePage> {
  List persons = [{'name':"VitaminC",'category':"1 Pill/M"},{'name':"Paracetamol",'category':"1 Pill/N"}];
  bool _content = false;
  bool _loading = true;
  int inc = 0;
  var fjson;
  String frequency="";


  // ignore: non_constant_identifier_names
  Delete(activityid,frequency,regdate) async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete'),
        content: const Text(
            'Do you want to delete this Medicine?'),
        actions: <Widget>[
          ElevatedButton(
            onPressed: () {
              Navigator.of(context, rootNavigator: true)
                  .pop(); // dismisses only the dialog and returns nothing
            },
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ButtonStyle(
                backgroundColor:
                MaterialStateProperty.all<Color>(Colors.indigo),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                        side: const BorderSide(color: Colors.indigo)))),
            onPressed: () async {

              bool result = await InternetConnectionChecker().hasConnection;
              if (result == true) {
                // ignore: use_build_context_synchronously
            //    Navigator.pop(context);
                // ignore: use_build_context_synchronously
                showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (context) =>  const AlertDialog(
                    content: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children:[
                          SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(    backgroundColor:
                            Colors
                                .black54,
                                valueColor:
                                AlwaysStoppedAnimation<
                                    Color>(
                                  Colors.black,
                                )),
                          ),
                          SizedBox(width: 10,),
                          Text(
                              "Delete in Progress.. Please Wait."),
                        ]),
                  ),
                );

                var now = DateTime.now();
                var formatter = DateFormat('yyyy-MM-dd');
                String formattedDate = formatter.format(now);

                final uri1 = Uri.parse('${globals.url}deletemedicine');
                final headers1 = {'Content-Type': 'application/json'};


                Map<String, dynamic> body1 = {
                  "activityid": activityid,
                  "date": formattedDate,
                  "uid":globals.uid,
                  "frequency":frequency,
                  "regdate":regdate
                };

                String jsonBody1 = json.encode(body1);
                final encoding1 = Encoding.getByName('utf-8');
                Response response1 = await post(
                  uri1,
                  headers: headers1,
                  body: jsonBody1,
                  encoding: encoding1,
                );
                String responseBody1 = response1.body;
                final data1 = await json.decode(responseBody1);

                String fState = data1["status"];
                if (fState == "success") {
                  // ignore: use_build_context_synchronously
                  Navigator.pop(context);


                  var snackBar = const SnackBar(
                    content: Text(
                      'Medicine Deleted Successfully',
                    ),
                    elevation: 10,
                  );
                  // Step 3
                  // ignore: use_build_context_synchronously
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);

                  Future.delayed(const Duration(milliseconds: 1000), () {
                    setState(() {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (BuildContext context) => const MedicinePage()));
                    });
                  });
                }else{
                  // ignore: use_build_context_synchronously
                  Navigator.pop(context);


                  var snackBar = const SnackBar(
                    content: Text(
                      'Something went wrong',
                    ),
                    elevation: 10,
                  );
                  // Step 3
                  // ignore: use_build_context_synchronously
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);

                }








              }else{
                // ignore: use_build_context_synchronously
                Navigator.pop(context);
                var snackBar = const SnackBar(
                  content: Text(
                    'Internet not available',
                  ),
                  elevation: 10,
                );
                // Step 3
                // ignore: use_build_context_synchronously
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              }
              // dismisses only the dialog and returns nothing
            },
            child: const Text('OK',style: TextStyle(color: Colors.white),),
          ),
        ],
      ),
    );
    print(activityid);

  }


  Future<void> connect() async {
    bool result = await InternetConnectionChecker().hasConnection;
    if (result == true) {
      var now = DateTime.now();
      var formatter = DateFormat('yyyy-MM-dd');
      String formattedDate = formatter.format(now);
      final uri1 = Uri.parse('${globals.url}datetodaymedicine');
      final headers1 = {'Content-Type': 'application/json'};

      Map<String, dynamic> body1 = {"uid": globals.uid, "date": formattedDate};

      String jsonBody1 = json.encode(body1);
      final encoding1 = Encoding.getByName('utf-8');
      Response response1 = await post(
        uri1,
        headers: headers1,
        body: jsonBody1,
        encoding: encoding1,
      );
      String responseBody1 = response1.body;
      final data1 = await json.decode(responseBody1);
      persons = data1;
      print(persons);

      final uri2 = Uri.parse('${globals.url}medicinetilldate');
      final headers2 = {'Content-Type': 'application/json'};

      Map<String, dynamic> body2 = {"uid": globals.uid, "date": formattedDate};

      String jsonBody2 = json.encode(body2);
      final encoding2 = Encoding.getByName('utf-8');
      Response response2 = await post(
        uri2,
        headers: headers2,
        body: jsonBody2,
        encoding: encoding2,
      );
      String responseBody2 = response2.body;
      fjson = await json.decode(responseBody2);

      if (inc == 0) {
        setState(() {
          _loading = false;
          _content = true;
        });
        inc++;
      }
    } else {}
  }

  // ignore: annotate_overrides
  void initState() {
    super.initState();
    connect();
  }


test(){

}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        bottomNavigationBar: BottomAppBar(
          color: Colors.indigo,
          child: Container(
            height: 50.0,
            color: Colors.indigo,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: IconButton(
                    tooltip: 'Home',
                    icon: const Icon(Icons.home_outlined,
                        size: 25, color: Colors.white),
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                            return const DashboardPage();
                          }));
                    },
                  ),
                ),
                Expanded(
                  child: IconButton(
                    tooltip: 'Hospital',
                    icon: const Icon(
                      Icons.local_hospital,
                      size: 25,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                            return const MenuPage();
                          }));
                    },
                  ),
                ),
                Expanded(
                  child: IconButton(
                    tooltip: 'Forum',
                    icon: const Icon(
                      Icons.chat_sharp,
                      size: 25,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                            return const ForumPage();
                          }));
                    },
                  ),
                ),
                Expanded(
                  child: IconButton(
                    tooltip: 'Logout',
                    icon: const Icon(
                      Icons.logout_outlined,
                      size: 25,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                            return const LogoutPage();
                          }));
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.indigo,
          title:  GestureDetector(
            onTap: (){
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) {
                    return const DashboardPage();
                  }));
            },
            child: Text(
              globals.appName,
              style: const TextStyle(color: Colors.white),
            ),
          ),
          actions: [
            GestureDetector(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) {
                        return const NotificationPage();
                      }));
                },
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    padding: const EdgeInsets.only(right: 30),
                    child: const Icon(
                      Icons.notifications,
                      size: 23,
                      color: Colors.white,
                    ),
                  ),
                )),
            GestureDetector(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) {
                        return const SettingsPage();
                      }));
                },
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    padding: const EdgeInsets.only(right: 30),
                    child: const Icon(
                      Icons.perm_identity,
                      size: 23,
                      color: Colors.white,
                    ),
                  ),
                ))
          ],
        ),
        body: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: [
                Visibility(
                    visible: _loading,
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 150,
                        ),
                        AlertDialog(
                          content: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                      backgroundColor: Colors.black54,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.black,
                                      )),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text("Loading.. Please Wait."),
                              ]),
                        ),
                      ],
                    )),
                Visibility(
                  visible: _content,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 20, left: 20, bottom: 10),
                          child: Row(
                            children: [
                              const SizedBox(
                                height: 20,
                              ),
                              const Text(
                                "Welcome ",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w500),
                              ),
                              Text(
                                "${globals.appName}!",
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w500),
                              )
                            ],
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(top: 20, left: 20),
                            child: Text(
                              "Medication Details",
                              style: TextStyle(
                                  fontWeight: FontWeight.w500, fontSize: 15),
                            ),
                          ),
                          const Spacer(),
                          Padding(
                            padding: const EdgeInsets.only(right: 20, top: 20),
                            child: ElevatedButton(
                                onPressed: () {
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) {
                                        return const AddMedicinesPage();
                                      }));
                                },
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all<Color>(
                                      Colors.indigo),
                                ),
                                child: const Row(
                                  children: [
                                    Icon(
                                      Icons.add,
                                      color: Colors.white,
                                    ),
                                    Text(
                                      " Add Medication",
                                      style: TextStyle(color: Colors.white),
                                    )
                                  ],
                                )),
                          )
                        ],
                      ),
                      const SizedBox(height: 30,),
                      // Container(
                      //   padding: const EdgeInsets.only(left: 20,right: 20),
                      //   height: 10,
                      //   child: LinearProgressBar(
                      //     maxSteps: 6,
                      //     progressType: LinearProgressBar.progressTypeLinear, // Use Linear progress
                      //     currentStep: 1,
                      //     progressColor: Colors.indigo,
                      //     backgroundColor: Colors.grey,
                      //   ),
                      // ),
                      // const Center(child: Padding(padding: EdgeInsets.only(top:20),child: Text("2/5 Medication Taken"),),),
                      // const SizedBox(height: 30,),
                      Padding(
                        padding: const EdgeInsets.only(top:10,left: 10,right: 10),
                        child: ListView.builder(
                          itemCount: persons.length,
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            if (persons[index]['frequency'] == 0) {
                              frequency = "Once (Today)";
                            }
                            if (persons[index]['frequency'] == 1) {
                              frequency = "Once (Tomorrow)";
                            }
                            if (persons[index]['frequency'] == 2) {
                              frequency = "Everyday";
                            }
                            return Card(
                                elevation: 5,
                                child: ListTile(
                                  leading: const CircleAvatar(
                                      backgroundColor: Colors.transparent,
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Spacer(),
                                          Icon(Icons.local_hospital,color: Colors.black,),
                                        ],
                                      )),
                                  title: Text(
                                      persons[index]['name'],
                                      style: const TextStyle(fontSize: 14,fontWeight: FontWeight.w500,letterSpacing: 0.5)
                                  ),
                                  subtitle: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        // ignore: prefer_interpolation_to_compose_strings
                                        "Purpose: " +
                                            persons[index]['description'],
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall,
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        // ignore: prefer_interpolation_to_compose_strings
                                        "Frequency: " + frequency,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall,
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        // ignore: prefer_interpolation_to_compose_strings
                                        "Dosage: " + persons[index]['dosage'],
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall,
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        // ignore: prefer_interpolation_to_compose_strings
                                        "Time: " + persons[index]['time'],
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall,
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                    ],
                                  ),
                                  trailing: GestureDetector(
                                    onTap: (){
                                      Delete(persons[index]['activityid'],persons[index]['frequency'],persons[index]['date']);
                                    },
                                    child: const Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Icon(Icons.delete),
                                      ],
                                    ),
                                  ),
                                ));
                          },
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(top:30,left: 20,bottom: 20),
                        child: Text("History",style: TextStyle(fontSize: 15,fontWeight: FontWeight.w500),),
                      ),
                      Container(
                          padding: const EdgeInsets.only(left: 20, right: 20),
                          width: MediaQuery.of(context).size.width*1.0,
                          // height: 10,
                          child: FutureBuilder(builder:
                              (context, AsyncSnapshot<String> snapshot) {
                            return JsonTable(
                              fjson,

                              tableCellBuilder: (value) {
                                return Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 4.0),
                                  decoration: BoxDecoration(border: Border.all(width: 0.5, color: Colors.grey.withOpacity(0.5))),
                                  child: Text(
                                    value,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                );
                              },
                            );
                          },future: test(),)),
                      const SizedBox(height: 25,)

                    ],
                  ),
                ),
              ],
            )));
  }
}
class SalesData {
  SalesData(this.year, this.sales);
  final String year;
  final double sales;
}