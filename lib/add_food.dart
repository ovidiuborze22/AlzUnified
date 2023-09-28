import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:health/dashboard.dart';
import 'package:health/food.dart';
import 'package:health/forum.dart';
import 'package:health/logout.dart';
import 'package:health/notification.dart';
import 'package:health/settings.dart';
import 'package:health/globals.dart' as globals;
import 'menu.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';

class AddFoodPage extends StatefulWidget {
  const AddFoodPage({Key? key}) : super(key: key);

  @override
  State<AddFoodPage> createState() => _AddFoodPageState();
}

class _AddFoodPageState extends State<AddFoodPage> {
  bool _remainder = false;
  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  String dropDownValue = 'Once (Today)';
  var items = ['Once (Today)','Once (Tomorrow)', 'Everyday'];
  String name="";
  String description = "";
  String time = "";
  int frequency = 0;
  int remainder =0;
  String formattedDate="";


  addFood() async {
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
                  "Submitting.. Please Wait."),
            ]),
      ),
    );


    name = nameController.text;
    description = descriptionController.text;
    time = timeController.text;
    if(name.isNotEmpty && description.isNotEmpty && time.isNotEmpty){

      if(dropDownValue == "Once (Today)"){
        frequency = 0;
        var now = DateTime.now();
        var formatter = DateFormat('yyyy-MM-dd');
        formattedDate = formatter.format(now);
      }
      if(dropDownValue == "Once (Tomorrow)"){
        frequency = 1;
        var now = DateTime.now().add(const Duration(days: 1));
        var formatter = DateFormat('yyyy-MM-dd');
        formattedDate = formatter.format(now);
      }
      if(dropDownValue == "Everyday"){
        frequency = 2;
        var now = DateTime.now();
        var formatter = DateFormat('yyyy-MM-dd');
        formattedDate = formatter.format(now);
      }

      if(_remainder){
        remainder = 1;
      }else{
        remainder =0;
      }


      final DateTime date1 = DateTime.now();
      int timestamp1 = date1.millisecondsSinceEpoch;
      String ftime = "T$timestamp1";

      final uri1 = Uri.parse('${globals.url}addfood');
      final headers1 = {'Content-Type': 'application/json'};


      Map<String, dynamic> body1 = {
        "name": name,
        "description": description,
        "frequency": frequency,
        "time": time,
        "remainder": remainder,
        "date": formattedDate,
        "uid":globals.uid,
        "activityid":ftime
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
            'Food registered Successfully',
          ),
          elevation: 10,
        );
        // Step 3
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(snackBar);

        Future.delayed(const Duration(milliseconds: 1000), () {
          setState(() {
            Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (BuildContext context) => const FoodPage()));
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
      Navigator.pop(context);

      var snackBar = const SnackBar(
        content: Text(
          'All fields are mandatory',
        ),
        elevation: 10,
      );
      // Step 3
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }




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
          title: GestureDetector(
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
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
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
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  child: Padding(
                    padding:
                    const EdgeInsets.only(top: 20, left: 20, bottom: 10),
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
                          "${globals.name}!",
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w500),
                        )
                      ],
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 20, left: 20, bottom: 15),
                  child: Text("Add New Food",
                      style:
                      TextStyle(fontWeight: FontWeight.w500, fontSize: 15)),
                ),
                const SizedBox(
                  height: 25,
                ),
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                          width: MediaQuery.of(context).size.width * 0.8,
                          height: 50,
                          child: TextField(
                              maxLines: 1,
                              controller: nameController,
                              textInputAction: TextInputAction.next,
                              decoration: const InputDecoration(
                                labelText: "Food Name",
                                labelStyle: TextStyle(
                                    color: Colors.black, fontSize: 13),
                                hintText: "Enter Food Name",
                                hintStyle: TextStyle(fontSize: 13),
                                focusColor: Colors.black,
                                prefixIcon: Icon(
                                  Icons.mail,
                                  color: Colors.black,
                                ),
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.black, width: 1.0),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(5.0),
                                    )),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.black, width: 1.0),
                                    borderRadius:
                                    BorderRadius.all(Radius.circular(5.0))),
                              ))),
                      const SizedBox(
                        height: 30,
                      ),
                      SizedBox(
                          width: MediaQuery.of(context).size.width * 0.8,
                          height: 50,
                          child: TextField(
                              maxLines: 1,
                              controller: descriptionController,
                              textInputAction: TextInputAction.next,
                              decoration: const InputDecoration(
                                labelText: "Description",
                                labelStyle: TextStyle(
                                    color: Colors.black, fontSize: 13),
                                hintText: "Enter Description",
                                hintStyle: TextStyle(fontSize: 13),
                                focusColor: Colors.black,
                                prefixIcon: Icon(
                                  Icons.perm_identity,
                                  color: Colors.black,
                                ),
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.black, width: 1.0),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(5.0),
                                    )),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.black, width: 1.0),
                                    borderRadius:
                                    BorderRadius.all(Radius.circular(5.0))),
                              ))),
                      const SizedBox(
                        height: 30,
                      ),
                      SizedBox(
                          width: MediaQuery.of(context).size.width * 0.8,
                          height: 50,
                          child:  TextField(
                              readOnly: true,
                              //maxLines: 1,
                              onTap: () async {
                                var time = await showTimePicker(
                                    context: context, initialTime: TimeOfDay.now());

                                if (time != null) {
                                  setState(() {
                                    print(time.format(context));
                                    timeController.text = time.format(context);
                                  });

                                }
                              },
                              controller: timeController,
                              textInputAction: TextInputAction.next,
                              decoration: const InputDecoration(
                                labelText: "Time",
                                labelStyle:
                                TextStyle(color: Colors.black, fontSize: 13),
                                focusColor: Colors.black,
                                prefixIcon: Icon(
                                  Icons.timelapse,
                                  color: Colors.black,
                                ),

                                border: OutlineInputBorder(
                                    borderSide:
                                    BorderSide(color: Colors.black, width: 1.0),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(5.0),
                                    )),
                                focusedBorder: OutlineInputBorder(
                                    borderSide:
                                    BorderSide(color: Colors.black, width: 1.0),
                                    borderRadius:
                                    BorderRadius.all(Radius.circular(5.0))),
                              ))),
                      const SizedBox(height: 30,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.1,
                          ),
                          const Text("Frequency"),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.8,
                        height: 50,
                        child: DropdownButton(
                          isExpanded: true,
                          value: dropDownValue,
                          icon: const Icon(Icons.keyboard_arrow_down),
                          items: items.map((String items) {
                            return DropdownMenuItem(
                              value: items,
                              child: Text(items),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              dropDownValue = newValue!;
                            });
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          padding: EdgeInsets.only(left: MediaQuery.of(context).size.width*0.08),

                          child: Row(
                            children: [
                              Checkbox(
                                value: _remainder,
                                onChanged: (value) {
                                  setState(() {
                                    if (value!) {
                                      _remainder = true;
                                    } else {
                                      _remainder = false;
                                    }
                                  });
                                },
                              ),
                              const Text('Set Remainder'),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 30,),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.8,
                        height: 50,
                        child: ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Colors.indigo),
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(25.0),
                                      side: const BorderSide(
                                          color: Colors.indigo)))),
                          onPressed: () {
                            addFood();
                          },
                          child: const Text(
                            'Add Food',
                            style: TextStyle(
                                fontSize: 16,
                                letterSpacing: 3,
                                color: Colors.white),
                          ),
                        ),
                      ),
                      const SizedBox(height: 50,)
                    ],
                  ),
                )
              ],
            )));
  }
}
