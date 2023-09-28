import 'package:flutter/material.dart';
import 'package:health/activity.dart';
import 'package:health/dashboard.dart';
import 'package:health/logout.dart';
import 'package:health/medicine.dart';
import 'package:health/notification.dart';
import 'package:health/register.dart';
import 'package:health/settings.dart';
import 'package:linear_progress_bar/linear_progress_bar.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:health/globals.dart' as globals;


import 'food.dart';
import 'forum.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({Key? key}) : super(key: key);

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
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
              const SizedBox(height: 20,),
              Container(
                padding: const EdgeInsets.only(right: 10,left: 10),
                width: MediaQuery.of(context).size.width*0.95,
                height: 150,
                child: Card(
                   color: Colors.grey[200],
                    child: ListTile(
                      onTap: (){
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                              return const ActivityPage();
                            }));
                      },
                      leading: const CircleAvatar(
                          backgroundColor: Colors.transparent,
                          child: SizedBox(
                            width: 300,
                            height: 250,
                            // child: ClipOval(
                            child: Padding(padding:EdgeInsets.only(top:30,left: 20),child: Icon(Icons.directions_run,color: Colors.black,size: 50,)),
                          )),
                      title: Padding(
                        padding: EdgeInsets.only(top:55,left: MediaQuery.of(context).size.width*0.15),
                        child: const Text('Activities',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w400,
                                letterSpacing: 0.5)),
                      ),
                      trailing: const Padding(
                        padding: EdgeInsets.only(top:45),
                        child: Icon(Icons.arrow_forward_rounded,color: Colors.black,),
                      ),
                    )),
              ),
              const SizedBox(height: 20,),
              Container(
                padding: const EdgeInsets.only(right: 10,left: 10),
                width: MediaQuery.of(context).size.width*0.95,
                height: 150,
                child: Card(
                    color: Colors.grey[200],
                    child: ListTile(
                      onTap: (){
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                              return const MedicinePage();
                            }));
                      },
                      leading: const CircleAvatar(
                          backgroundColor: Colors.transparent,
                          child: SizedBox(
                            width: 300,
                            height: 250,
                            // child: ClipOval(
                            child: Padding(padding:EdgeInsets.only(top:30,left: 20),child: Icon(Icons.medical_information,color: Colors.black,size: 50,)),
                          )),
                      title: Padding(
                        padding: EdgeInsets.only(top:55,left: MediaQuery.of(context).size.width*0.15),
                        child: const Text('Medicines',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w400,
                                letterSpacing: 0.5)),
                      ),
                      trailing: const Padding(
                        padding: EdgeInsets.only(top:45),
                        child: Icon(Icons.arrow_forward_rounded,color: Colors.black,),
                      ),
                    )),
              ),
              const SizedBox(height: 20,),
              Container(
                padding: const EdgeInsets.only(right: 10,left: 10),
                width: MediaQuery.of(context).size.width*0.95,
                height: 150,
                child: Card(
                    color: Colors.grey[200],
                    child: ListTile(
                      onTap: (){
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                              return const FoodPage();
                            }));
                      },
                      leading: const CircleAvatar(
                          backgroundColor: Colors.transparent,
                          child: SizedBox(
                            width: 300,
                            height: 250,
                            // child: ClipOval(
                            child: Padding(padding:EdgeInsets.only(top:30,left: 20),child: Icon(Icons.fastfood,color: Colors.black,size: 50,)),
                          )),
                      title: Padding(
                        padding: EdgeInsets.only(top:55,left: MediaQuery.of(context).size.width*0.15),
                        child: const Text('Food',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w400,
                                letterSpacing: 0.5)),
                      ),
                      trailing: const Padding(
                        padding: EdgeInsets.only(top:45),
                        child: Icon(Icons.arrow_forward_rounded,color: Colors.black,),
                      ),
                    )),
              ),
            ],
          )
        ));
  }
}
