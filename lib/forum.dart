import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:health/dashboard.dart';
import 'package:health/notification.dart';
import 'package:health/globals.dart' as globals;
import 'package:health/settings.dart';

// ignore: depend_on_referenced_packages
import 'package:http/http.dart';

// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';

// ignore: depend_on_referenced_packages
import 'package:internet_connection_checker/internet_connection_checker.dart';

import 'food.dart';
import 'menu.dart';

class ForumPage extends StatefulWidget {
  const ForumPage({Key? key}) : super(key: key);

  @override
  State<ForumPage> createState() => _ForumPageState();
}

class _ForumPageState extends State<ForumPage> {
  List persons = [];
  bool _loading = true;
  bool _content = false;
  int inc = 0;
  String finImage = "";
  TextEditingController message = TextEditingController();
  late Timer _timer;
  bool isLongPressed = false;

  // ignore: annotate_overrides
  void initState() {
    super.initState();
    connect();
  }

  Future<void> deleteData(fid, indexes) async {
    bool result = await InternetConnectionChecker().hasConnection;
    if (result == true) {
      final uri4 = Uri.parse('${globals.url}deletemsg');
      final headers4 = {'Content-Type': 'application/json'};
      Map<String, dynamic> body4 = {
        "status": 0,
        "id": fid,
      };
      String jsonBody4 = json.encode(body4);
      final encoding4 = Encoding.getByName('utf-8');
      Response response4 = await post(
        uri4,
        headers: headers4,
        body: jsonBody4,
        encoding: encoding4,
      );
      String responseBody4 = response4.body;
      final data4 = await json.decode(responseBody4);
      String fstate = data4["status"];

      if (fstate == "success") {

        var snackBar = const SnackBar(
          content: Text('Message Deleted Successfully'),
          elevation: 10,
          behavior: SnackBarBehavior.floating,
        );
        // Step 3
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(snackBar);

        Future.delayed(const Duration(milliseconds: 1000), () {
          setState(() {
            Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (BuildContext context) => const ForumPage()));
          });
        });

      } else {
        var snackBar = const SnackBar(
          content: Text(
            "Couldn't Delete Message",
            // ignore: use_build_context_synchronously
          ),
          elevation: 10,
          behavior: SnackBarBehavior.floating,
        );
        // Step 3
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    } else {
      var snackBar = const SnackBar(
        content: Text(
          'Internet not available',
          // ignore: use_build_context_synchronously
        ),
        elevation: 10,
        behavior: SnackBarBehavior.floating,
      );
      // Step 3
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  void _startOperation() {
    _timer = Timer(const Duration(milliseconds: 1000), () {
      isLongPressed = true;
    });
  }

  Future<void> sendMessage() async {
    if (message.text.isNotEmpty) {
      String msgf = message.text;
      message.text = "";
      bool result = await InternetConnectionChecker().hasConnection;
      if (result == true) {
        final uri4 = Uri.parse('${globals.url}insertpersonal');
        final headers4 = {'Content-Type': 'application/json'};
        Map<String, dynamic> body4 = {
          "email": globals.email,
          "message": msgf,
          "name": globals.name
        };
        String jsonBody4 = json.encode(body4);
        final encoding4 = Encoding.getByName('utf-8');
        Response response4 = await post(
          uri4,
          headers: headers4,
          body: jsonBody4,
          encoding: encoding4,
        );
        //  _Fstatus = 1;
        String responseBody4 = response4.body;
        final data1 = await json.decode(responseBody4);
        String fState = data1["status"];
        if (fState == "success") {
          // ignore: use_build_context_synchronously
          Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (BuildContext context) => const ForumPage()));
        } else {
          var snackBar = const SnackBar(
            content: Text(
              'Something went wrong',
            ),
            elevation: 10,
            behavior: SnackBarBehavior.floating,
          );
          // Step 3
          // ignore: use_build_context_synchronously
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      } else {
        var snackBar = const SnackBar(
          content: Text(
            'Internet not available',
          ),
          elevation: 10,
          behavior: SnackBarBehavior.floating,
        );
        // Step 3
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    }
  }

  Future<void> connect() async {
    bool result = await InternetConnectionChecker().hasConnection;
    if (result == true) {
      final uri1 = Uri.parse('${globals.url}getmsg');
      final headers1 = {'Content-Type': 'application/json'};

      Map<String, dynamic> body1 = {"email": globals.email};

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

      if (inc == 0) {
        setState(() {
          _loading = false;
          _content = true;
        });
        inc++;
      }
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        // bottomNavigationBar: BottomAppBar(
        //   color: Colors.indigo,
        //   child: Container(
        //     height: 50.0,
        //     color: Colors.indigo,
        //     child: Row(
        //       mainAxisAlignment: MainAxisAlignment.center,
        //       children: <Widget>[
        //         Expanded(
        //           child: IconButton(
        //             tooltip: 'Home',
        //             icon: const Icon(Icons.home_outlined,
        //                 size: 25, color: Colors.white),
        //             onPressed: () {
        //               Navigator.push(context,
        //                   MaterialPageRoute(builder: (context) {
        //                     return const DashboardPage();
        //                   }));
        //             },
        //           ),
        //         ),
        //         Expanded(
        //           child: IconButton(
        //             tooltip: 'Hospital',
        //             icon: const Icon(
        //               Icons.local_hospital,
        //               size: 25,
        //               color: Colors.white,
        //             ),
        //             onPressed: () {
        //               Navigator.push(context,
        //                   MaterialPageRoute(builder: (context) {
        //                     return const MenuPage();
        //                   }));
        //             },
        //           ),
        //         ),
        //         Expanded(
        //           child: IconButton(
        //             tooltip: 'Forum',
        //             icon: const Icon(
        //               Icons.chat_sharp,
        //               size: 25,
        //               color: Colors.white,
        //             ),
        //             onPressed: () {
        //               Navigator.push(context,
        //                   MaterialPageRoute(builder: (context) {
        //                     return const ForumPage();
        //                   }));
        //             },
        //           ),
        //         ),
        //         Expanded(
        //           child: IconButton(
        //             tooltip: 'Logout',
        //             icon: const Icon(
        //               Icons.logout_outlined,
        //               size: 25,
        //               color: Colors.white,
        //             ),
        //             onPressed: () {},
        //           ),
        //         ),
        //       ],
        //     ),
        //   ),
        // ),
        bottomNavigationBar: Visibility(
            visible: _content,
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Container(
                  //height: MediaQuery.of(context).viewInsets.bottom,
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      border: Border(
                          top: BorderSide(color: Colors.grey, width: 1.0))),
                  child: Padding(
                    // ignore: prefer_const_constructors
                    padding: EdgeInsets.all(8.0),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20.0),
                            child: Container(
                              color: Colors.white,
                              child: Row(
                                children: <Widget>[
                                  const SizedBox(width: 8.0),
                                  Expanded(
                                    child: TextField(
                                      controller: message,
                                      decoration: const InputDecoration(
                                        hintText: 'Type a message',
                                        border: InputBorder.none,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 5.0,
                        ),
                        GestureDetector(
                          onTap: () {
                            sendMessage();
                          },
                          // ignore: prefer_const_constructors

                          child: const Icon(Icons.send),
                        ),
                      ],
                    ),
                  )),
              SizedBox(
                height: MediaQuery.of(context).viewInsets.bottom,
              ),
            ])),
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
                  child: ListView.builder(
                      itemCount: persons.length,
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        if (persons[index]['email'] == globals.email) {
                          var dt = DateTime.fromMillisecondsSinceEpoch(
                              int.parse(persons[index]['date']) * 1000);
                          var d12 = DateFormat('MM/dd/yyyy, hh:mm a').format(dt);
                          return GestureDetector(
                              onTapDown: (_) {
                                _startOperation();
                              },
                              onTapUp: (_) async {
                                _timer.cancel();
                                if (isLongPressed) {
                                  await showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: const Text('Alert'),
                                      content: const Text(
                                          'Do You want to Delete this Message?'),
                                      actions: <Widget>[
                                        ElevatedButton(
                                          style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStateProperty.all<
                                                      Color>(Colors.black)),
                                          onPressed: () {
                                            deleteData(persons[index]['id'],
                                                index); // dismisses only the dialog and returns nothing
                                          },
                                          child: const Text(
                                            'Delete',
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.white),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                  isLongPressed = false;
                                }
                              },
                              child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(80, 10, 10, 10),
                                  child: ListTile(
                                      tileColor: Colors.grey[200],
                                      shape: RoundedRectangleBorder(
                                        side: const BorderSide(
                                            color: Colors.grey, width: 0.2),
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      subtitle: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.only(
                                                top: 10, bottom: 20),
                                            child: Row(
                                              children: [
                                                const Icon(
                                                  Icons.person,
                                                  color: Colors.black,
                                                  size: 20,
                                                ),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                Text(
                                                  persons[index]['name'],
                                                  style: const TextStyle(
                                                      fontSize: 16,
                                                      fontWeight: FontWeight.w400,
                                                      letterSpacing: 0.5,
                                                      color: Colors.black),
                                                )
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.8,
                                              child: Text(
                                                persons[index]['message'],
                                                style: const TextStyle(
                                                    fontSize: 15,
                                                    color: Colors.black),
                                                textAlign: TextAlign.justify,
                                              )),
                                          Container(
                                              padding: const EdgeInsets.only(
                                                  top: 15, bottom: 10),
                                              alignment: Alignment.bottomRight,
                                              child: Text(d12.toString(),
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .labelMedium))
                                        ],
                                      ))));
                        } else {

                          var dt = DateTime.fromMillisecondsSinceEpoch(
                              int.parse(persons[index]['date']) * 1000);
                          var d12 = DateFormat('MM/dd/yyyy, hh:mm a').format(dt);
                          return Padding(
                              padding: const EdgeInsets.fromLTRB(10, 10, 80, 10),
                              child: ListTile(
                                  tileColor: Colors.grey[200],
                                  shape: RoundedRectangleBorder(
                                    side: const BorderSide(
                                        color: Colors.grey, width: 0.2),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  subtitle: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.only(
                                            top: 10, bottom: 20),
                                        child: Row(
                                          children: [
                                            const Icon(
                                              Icons.person,
                                              color: Colors.black,
                                              size: 20,
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            Text(
                                              persons[index]['name'],
                                              style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w400,
                                                  letterSpacing: 0.5,
                                                  color: Colors.black),
                                            )
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                          width:
                                              MediaQuery.of(context).size.width *
                                                  0.8,
                                          child: Text(
                                            persons[index]['message'],
                                            style: const TextStyle(
                                                fontSize: 15,
                                                color: Colors.black),
                                            textAlign: TextAlign.justify,
                                          )),
                                      Container(
                                          padding: const EdgeInsets.only(
                                              top: 15, bottom: 10),
                                          alignment: Alignment.bottomRight,
                                          child: Text(d12.toString(),
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .labelMedium))
                                    ],
                                  )));
                        }
                      }),
                )
              ],
            )));
  }
}
