import 'package:flutter/material.dart';
import 'package:health/activity.dart';
import 'package:health/dashboard.dart';
import 'package:health/medicine.dart';
import 'package:health/register.dart';
import 'package:health/settings.dart';
import 'package:linear_progress_bar/linear_progress_bar.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:health/globals.dart' as globals;


import 'food.dart';
import 'menu.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({Key? key}) : super(key: key);

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  List persons = [{'name':"OvidiuBorze",'category':"New"},{'name':"OvidiuBorze",'category':"New"}];


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
                    tooltip: 'Settings',
                    icon: const Icon(
                      Icons.settings_outlined,
                      size: 25,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                            return const SettingsPage();
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
                    onPressed: () {},
                  ),
                ),
              ],
            ),
          ),
        ),
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.indigo,
          title:  Text(
            globals.appName,
            style: const TextStyle(color: Colors.white),
          ),
          actions: [

            GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
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
                )),
            GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return const DashboardPage();
                  }));
                },
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    padding: const EdgeInsets.only(right: 30),
                    child: const Icon(
                      Icons.home,
                      size: 23,
                      color: Colors.white,
                    ),
                  ),
                )),
          ],
        ),
        body:  SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: [
                SizedBox(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 20, left: 20,bottom: 10),
                    child: Row(
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        const Text(
                          "Welcome ",
                          style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                        ),
                        Text(
                          "${globals.name}!",
                          style:
                          const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                        )
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 60,),
                const Center(child: Text("No notification found"))
              ],
            )
        ));
  }
}
