import 'dart:convert';

import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:health/add_activity.dart';
import 'package:health/dashboard.dart';
import 'package:health/logout.dart';
import 'package:health/notification.dart';
import 'package:health/register.dart';
import 'package:health/settings.dart';
import 'package:json_table/json_table.dart';
import 'package:linear_progress_bar/linear_progress_bar.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:health/globals.dart' as globals;
import 'package:url_launcher/url_launcher.dart';
import 'forum.dart';
import 'menu.dart';

// ignore: depend_on_referenced_packages
import 'package:http/http.dart';

// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';

// ignore: depend_on_referenced_packages
import 'package:internet_connection_checker/internet_connection_checker.dart';

class ActivityPage extends StatefulWidget {
  const ActivityPage({Key? key}) : super(key: key);

  @override
  State<ActivityPage> createState() => _ActivityPageState();
}

class _ActivityPageState extends State<ActivityPage> {
  List<DateTime?> _dates = [];
  List persons = [];
  int inc = 0;
  bool _content = false;
  bool _loading = true;
  String frequency = "";
  var fjson;

  Future<void> connect() async {
    bool result = await InternetConnectionChecker().hasConnection;
    if (result == true) {
      var now = DateTime.now();
      var formatter = DateFormat('yyyy-MM-dd');
      String formattedDate = formatter.format(now);
      final uri1 = Uri.parse('${globals.url}datetodayactivity');
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

      final uri2 = Uri.parse('${globals.url}activitytilldate');
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

  Delete(activityid, frequency, regdate) async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete'),
        content: const Text('Do you want to delete this activity?'),
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
                //  Navigator.pop(context);
                // ignore: use_build_context_synchronously
                showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (context) => const AlertDialog(
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
                          Text("Delete in Progress.. Please Wait."),
                        ]),
                  ),
                );

                var now = DateTime.now();
                var formatter = DateFormat('yyyy-MM-dd');
                String formattedDate = formatter.format(now);

                final uri1 = Uri.parse('${globals.url}deleteactivity');
                final headers1 = {'Content-Type': 'application/json'};

                Map<String, dynamic> body1 = {
                  "activityid": activityid,
                  "date": formattedDate,
                  "uid": globals.uid,
                  "frequency": frequency,
                  "regdate": regdate
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
                      'Activity Deleted Successfully',
                    ),
                    elevation: 10,
                  );
                  // Step 3
                  // ignore: use_build_context_synchronously
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);

                  Future.delayed(const Duration(milliseconds: 1000), () {
                    setState(() {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (BuildContext context) =>
                              const ActivityPage()));
                    });
                  });
                } else {
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
              } else {
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
            child: const Text(
              'OK',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  test() {}

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
                    tooltip: 'Menu',
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
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
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
                          padding: const EdgeInsets.only(
                              top: 20, left: 20, bottom: 10),
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
                        child: Text("Activity Suggestions",
                            style: TextStyle(
                                fontWeight: FontWeight.w500, fontSize: 15)),
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          GestureDetector(
                            onTap: () async {
                              String url =
                                  "https://play.google.com/store/apps/details?id=running.tracker.gps.map";
                              var urllaunchable = await canLaunch(
                                  url); //canLaunch is from url_launcher package
                              if (urllaunchable) {
                                await launchUrl(Uri.parse(
                                    url)); //launch is from url_launcher package to launch URL
                              } else {}
                            },
                            child: const Icon(
                              Icons.directions_run,
                              size: 35,
                            ),
                          ),
                          GestureDetector(
                              onTap: () async {
                                String url =
                                    "https://play.google.com/store/apps/details?id=com.audible.application";
                                var urllaunchable = await canLaunch(
                                    url); //canLaunch is from url_launcher package
                                if (urllaunchable) {
                                  await launchUrl(Uri.parse(
                                      url)); //launch is from url_launcher package to launch URL
                                } else {}
                              },
                              child: const Icon(Icons.book_sharp, size: 35)),
                          GestureDetector(
                              onTap: () async {
                                String url =
                                    "https://play.google.com/store/apps/details?id=com.audible.application";
                                var urllaunchable = await canLaunch(
                                    url); //canLaunch is from url_launcher package
                                if (urllaunchable) {
                                  await launchUrl(Uri.parse(
                                      url)); //launch is from url_launcher package to launch URL
                                } else {}
                              },
                              child: const Icon(Icons.movie, size: 35)),
                          GestureDetector(
                              onTap: () async {
                                String url =
                                    "https://play.google.com/store/apps/details?id=com.freshplanet.games.SongPop3";
                                var urllaunchable = await canLaunch(
                                    url); //canLaunch is from url_launcher package
                                if (urllaunchable) {
                                  await launchUrl(Uri.parse(
                                      url)); //launch is from url_launcher package to launch URL
                                } else {}
                              },
                              child: const Icon(Icons.music_note, size: 35))
                        ],
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          GestureDetector(
                            onTap: () async {
                              String url =
                                  "https://play.google.com/store/apps/details?id=com.gamovation.tileclub";
                              var urllaunchable = await canLaunch(
                                  url); //canLaunch is from url_launcher package
                              if (urllaunchable) {
                                await launchUrl(Uri.parse(
                                    url)); //launch is from url_launcher package to launch URL
                              } else {}
                            },
                            child: const Icon(
                              Icons.sports_cricket_outlined,
                              size: 35,
                            ),
                          ),
                          GestureDetector(
                              onTap: () async {
                                String url =
                                    "https://play.google.com/store/apps/details?id=com.puzzle.word.wordcrossscape.gp";
                                var urllaunchable = await canLaunch(
                                    url); //canLaunch is from url_launcher package
                                if (urllaunchable) {
                                  await launchUrl(Uri.parse(
                                      url)); //launch is from url_launcher package to launch URL
                                } else {}
                              },
                              child:
                                  const Icon(Icons.games_outlined, size: 35)),
                          GestureDetector(
                              onTap: () async {
                                String url =
                                    "https://play.google.com/store/apps/details?id=com.livingmaples.alzheimer.brain.test";
                                var urllaunchable = await canLaunch(
                                    url); //canLaunch is from url_launcher package
                                if (urllaunchable) {
                                  await launchUrl(Uri.parse(
                                      url)); //launch is from url_launcher package to launch URL
                                } else {}
                              },
                              child:
                                  const Icon(Icons.local_hospital, size: 35)),
                              GestureDetector(onTap:() async {  String url =
                                  "https://play.google.com";
                              var urllaunchable = await canLaunch(
                                  url); //canLaunch is from url_launcher package
                              if (urllaunchable) {
                                await launchUrl(Uri.parse(
                                    url)); //launch is from url_launcher package to launch URL
                              } else {}}, child: const Icon(Icons.search, size: 35))
                        ],
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      Row(
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(top: 20, left: 20),
                            child: Text(
                              "Activity Details",
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
                                    return const AddActivityPage();
                                  }));
                                },
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.indigo),
                                ),
                                child: const Row(
                                  children: [
                                    Icon(
                                      Icons.add,
                                      color: Colors.white,
                                    ),
                                    Text(
                                      " New Activity",
                                      style: TextStyle(color: Colors.white),
                                    )
                                  ],
                                )),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 10, left: 10, right: 10, bottom: 15),
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
                                  leading: const Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      CircleAvatar(
                                          backgroundColor: Colors.transparent,
                                          child: Icon(
                                            Icons.directions_run,
                                            color: Colors.black,
                                            size: 30,
                                          )),
                                    ],
                                  ),
                                  title: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Text(persons[index]['name'],
                                          style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                              letterSpacing: 0.5)),
                                    ],
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
                                        "Description: " +
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
                                    onTap: () {
                                      Delete(
                                          persons[index]['activityid'],
                                          persons[index]['frequency'],
                                          persons[index]['date']);
                                    },
                                    child: const Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Icon(Icons.delete),
                                      ],
                                    ),
                                  ),
                                ));
                          },
                        ),
                      ),
                      // Container(
                      //   padding: const EdgeInsets.only(left: 10, right: 10),
                      //   width: MediaQuery.of(context).size.width * 1.0,
                      //   height: 350,
                      //   child: CalendarDatePicker2(
                      //     config: CalendarDatePicker2Config(),
                      //     value: _dates,
                      //     onValueChanged: (dates) => {_dates = dates, print(_dates)},
                      //   ),
                      // ),
                      const SizedBox(
                        height: 0,
                      ),
                      const Padding(
                        padding: EdgeInsets.only(top: 20, left: 20, bottom: 15),
                        child: Text("History",
                            style: TextStyle(
                                fontWeight: FontWeight.w500, fontSize: 15)),
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      Container(
                          padding: const EdgeInsets.only(left: 20, right: 20),
                          width: MediaQuery.of(context).size.width * 1.0,
                          // height: 10,
                          child: FutureBuilder(
                            builder: (context, AsyncSnapshot<String> snapshot) {
                              return JsonTable(
                                fjson,
                                tableCellBuilder: (value) {
                                  return Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 25.0, vertical: 4.0),
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            width: 0.5,
                                            color:
                                                Colors.grey.withOpacity(0.5))),
                                    child: Text(
                                      value,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                  );
                                },
                              );
                            },
                            future: test(),
                          )),
                      const SizedBox(
                        height: 30,
                      )
                    ],
                  ),
                ),
              ],
            )));
  }
}
