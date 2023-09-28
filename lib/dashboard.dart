import 'dart:convert';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:health/add_activity.dart';
import 'package:health/add_food.dart';
import 'package:health/add_medicines.dart';
import 'package:health/forum.dart';
import 'package:health/logout.dart';
import 'package:health/menu.dart';
import 'package:health/notification.dart';
import 'package:health/settings.dart';
import 'package:linear_progress_bar/linear_progress_bar.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:health/globals.dart' as globals;
// ignore: depend_on_referenced_packages
import 'package:http/http.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';

// ignore: depend_on_referenced_packages
import 'package:internet_connection_checker/internet_connection_checker.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  List persons = [

  ];
  List medicinesList =[];
  List foodList =[];
  List activityList =[];
  List logs =[];
  int i =0;
  bool updated = false;
  bool notupdated = true;

  int inc =0;
  int activity =0;
  int food =0;
  int medicine =0;
  int activityCompleted =0;
  int totalProgress=0;
  int foodCompleted =0;
  int medicineCompleted =0;
  List<SalesData> chartData = [];
  bool _content = false;
  bool _loading = true;
  int progress =0;
  int total =0;
  int completed =0;
  AudioPlayer player = AudioPlayer();


  //final datas = '[{"Year":"Mon","x1" :35,"x2": 40},{"Year":"Tue","x1" :435,"x2": 240},{"Year":"Wed","x1" :435,"x2": 240},{"Year":"Thu","x1" :35,"x2": 40}]';



  // final List<ChartData> SalesData = [
  //   ChartData("1998", 35, 40),
  //   ChartData("1999", 28, 40),
  //   ChartData("2000", 34, 40),
  //   ChartData("2001", 32, 40),
  //   ChartData("2002", 40, 40)
  // ];




  alert() async {
    String audioasset = "assets/sounds/alarm.mp3";
    ByteData bytes = await rootBundle.load(audioasset); //load audio from assets
    Uint8List audiobytes = bytes.buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes);

    //await player!.setSourceAsset('assets/audio/sample_audio.mp3');
    player.play(BytesSource(audiobytes));


    if (!globals.emergencyemail.contains('@') || !globals.emergencyemail.contains('.')) {
      var snackBar = const SnackBar(
        content: Text(
          'Emergency Mail not Added',
        ),
        elevation: 10,
      );
      // Step 3
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(snackBar);

    }else {
      bool result = await InternetConnectionChecker().hasConnection;
      if (result == true) {
        final uri1 = Uri.parse('${globals.url}emergencyemail');
        final headers1 = {'Content-Type': 'application/json'};

        String datetime = DateTime.now().toString();


        Map<String, dynamic> body1 = {
          "email": globals.emergencyemail,
          "fromemail": globals.email,
          "ftime": datetime,
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
          var snackBar = const SnackBar(
            content: Text(
              'User Notified successfully',
            ),
            elevation: 10,
          );
          // Step 3
          // ignore: use_build_context_synchronously
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        } else {
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
    }

  }

  update(id,activityId,names) async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Update'),
        content: const Text(
            'Do you want to update this activity?'),
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
                              "Update in Progress.. Please Wait."),
                        ]),
                  ),
                );

                var now = DateTime.now();
                var formatter = DateFormat('yyyy-MM-dd');
                String formattedDate = formatter.format(now);

                final uri1 = Uri.parse('${globals.url}finalupdateactivity');
                final headers1 = {'Content-Type': 'application/json'};


                Map<String, dynamic> body1 = {
                  "activityid": activityId,
                  "date": formattedDate,
                  "uid":globals.uid,
                  "name":names
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
                      'Activity Updated Successfully',
                    ),
                    elevation: 10,
                  );
                  // Step 3
                  // ignore: use_build_context_synchronously
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);

                  Future.delayed(const Duration(milliseconds: 1000), () {
                    setState(() {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (BuildContext context) => const DashboardPage()));
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


  }

  Future<void> connect() async {

    bool result = await InternetConnectionChecker().hasConnection;
    if (result == true) {

       var now = DateTime.now();
      var formatter = DateFormat('yyyy-MM-dd');
      String formattedDate = formatter.format(now);



       final uri51 = Uri.parse('${globals.url}updateolddate');
       final headers51 = {'Content-Type': 'application/json'};


       Map<String, dynamic> body51 = {
         "uid": globals.uid,
         "date": formattedDate
       };

       String jsonBody51 = json.encode(body51);
       final encoding51 = Encoding.getByName('utf-8');
       Response response51 = await post(
         uri51,
         headers: headers51,
         body: jsonBody51,
         encoding: encoding51,
       );
       String responseBody51 = response51.body;



      final uri1 = Uri.parse('${globals.url}activity');
      final headers1 = {'Content-Type': 'application/json'};


      Map<String, dynamic> body1 = {
        "email": globals.email,
        "uid": globals.uid,
        "date": formattedDate
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
       if(responseBody1.isNotEmpty) {
         final data1 = await json.decode(responseBody1);

         activity = data1[0]["activity"];
         food = data1[0]["food"];
         medicine = data1[0]["medicine"];
         activityCompleted = data1[0]["activitycompleted"];
         foodCompleted = data1[0]["foodcompleted"];
         medicineCompleted = data1[0]["medicinecompleted"];

         total = activity + food + medicine;
         completed = activityCompleted + medicineCompleted + foodCompleted;
       }
         if (total == 0) {
           totalProgress = 1;
         } else {
           totalProgress = total;
         }




       final uri2 = Uri.parse('${globals.url}logs');
       final headers2 = {'Content-Type': 'application/json'};


       Map<String, dynamic> body2 = {
         "uid": globals.uid,
         "date": formattedDate
       };

       String jsonBody2 = json.encode(body2);
       final encoding2 = Encoding.getByName('utf-8');
       Response response2 = await post(
         uri2,
         headers: headers2,
         body: jsonBody2,
         encoding: encoding2,
       );
       String responseBody2 = response2.body;
       if(responseBody2.isNotEmpty) {
         final data2 = await json.decode(responseBody2);
         logs = data2;
       }


       var now1 = DateTime.now().add(const Duration(days: 1));
       var formatter1 = DateFormat('yyyy-MM-dd');
       String formattedDate1 = formatter1.format(now1);

       final uri3 = Uri.parse('${globals.url}activitylogs');
       final headers3 = {'Content-Type': 'application/json'};


       Map<String, dynamic> body3 = {
         "uid": globals.uid,
         "date": formattedDate1
       };

       String jsonBody3 = json.encode(body3);
       final encoding3 = Encoding.getByName('utf-8');
       Response response3 = await post(
         uri3,
         headers: headers3,
         body: jsonBody3,
         encoding: encoding3,
       );
       String responseBody3 = response3.body;
       if(responseBody3.isNotEmpty) {
         final data3 = await json.decode(responseBody3);
         activityList = data3;
       }

       final uri4 = Uri.parse('${globals.url}medicinelogs');
       final headers4 = {'Content-Type': 'application/json'};


       Map<String, dynamic> body4 = {
         "uid": globals.uid,
         "date": formattedDate1
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
       medicinesList = data4;

       final uri5 = Uri.parse('${globals.url}foodlogs');
       final headers5 = {'Content-Type': 'application/json'};


       Map<String, dynamic> body5 = {
         "uid": globals.uid,
         "date": formattedDate1
       };

       String jsonBody5 = json.encode(body5);
       final encoding5 = Encoding.getByName('utf-8');
       Response response5 = await post(
         uri5,
         headers: headers5,
         body: jsonBody5,
         encoding: encoding5,
       );
       String responseBody5 = response5.body;
       final data5 = await json.decode(responseBody5);
       foodList = data5;


       if(inc == 0){
         loadSalesData();
         setState(() {
           _loading = false;
           _content = true;
         });
         inc++;
       }
    }else{

    }

  }




  // ignore: annotate_overrides
  void initState(){
    super.initState();
    connect();
  }


  Future loadSalesData() async {
    final datas = '[{"Year":"Total","x1" :$completed,"x2": $total},{"Year":"Food","x1" :$foodCompleted,"x2": $food},{"Year":"Medicine","x1" :$medicineCompleted,"x2": $medicine},{"Year":"Activity","x1" :$activityCompleted,"x2": $activity}]';


    // final String jsonString = datas;
    final dynamic jsonResponse = json.decode(datas);
    for (Map<String, dynamic> i in jsonResponse) {
      chartData.add(SalesData.fromJson(i));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        bottomNavigationBar: BottomAppBar(
          color: Colors.deepOrange,
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
                    onPressed: () {},
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
          title: Text(
            globals.appName,
            style: const TextStyle(color: Colors.white),
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
              Visibility(visible:_loading, child:  const Column(mainAxisAlignment:MainAxisAlignment.center, crossAxisAlignment:CrossAxisAlignment.center,children: [SizedBox(height: 150,),   AlertDialog(
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
                        "Loading.. Please Wait."),
                  ]),
            ),
          ],)),
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
                              "${globals.name}!",
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w500),
                            )
                          ],
                        ),
                      ),
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Padding(
                          padding: const EdgeInsets.only(top: 10, left: 20),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.only(right: 20),
                                width: MediaQuery.of(context).size.width * 0.8,
                                height: 100,
                                child: Card(
                                    color: Colors.grey[200],
                                    child:  ListTile(
                                      onTap: (){
                                        Navigator.push(context, MaterialPageRoute(builder: (context) {
                                          return const AddActivityPage();
                                        }));
                                      },
                                      leading: const CircleAvatar(
                                          backgroundColor: Colors.transparent,
                                          child: Padding(
                                            padding: EdgeInsets.only(top:15),
                                            child: SizedBox(
                                              // child: ClipOval(
                                              child: Icon(Icons.directions_run,color: Colors.black,size: 35,),

                                              // Image.network(
                                              //     // ignore: prefer_interpolation_to_compose_strings
                                              //     "${globals.finalUrl}images/shops/"+
                                              //  persons[index]['img'],
                                              //   // ),
                                              // )
                                            ),
                                          )),
                                      title: const Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(height: 20,),
                                          Text('Activities',
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w500,
                                                  letterSpacing: 0.5)),
                                          SizedBox(height: 10,),
                                          Text(
                                            // ignore: prefer_interpolation_to_compose_strings
                                              "Create your own activity "),
                                        ],
                                      ),
                                    )),
                              ),
                              Container(
                                padding: const EdgeInsets.only(right: 20),
                                width: MediaQuery.of(context).size.width * 0.9,
                                height: 100,
                                child: Card(
                                    color: Colors.grey[200],
                                    child:  ListTile(
                                      onTap: (){
                                        Navigator.push(context, MaterialPageRoute(builder: (context) {
                                          return const AddMedicinesPage();
                                        }));
                                      },
                                      leading: const CircleAvatar(
                                          backgroundColor: Colors.transparent,
                                          child: Padding(
                                            padding: EdgeInsets.only(top:15),
                                            child: SizedBox(
                                              // child: ClipOval(
                                              child: Icon(Icons.local_hospital,color: Colors.black,size: 35,),

                                              // Image.network(
                                              //     // ignore: prefer_interpolation_to_compose_strings
                                              //     "${globals.finalUrl}images/shops/"+
                                              //  persons[index]['img'],
                                              //   // ),
                                              // )
                                            ),
                                          )),
                                      title: const Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(height: 20,),
                                          Text('Medicines',
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w500,
                                                  letterSpacing: 0.5)),
                                          SizedBox(height: 10,),
                                          Text(
                                            // ignore: prefer_interpolation_to_compose_strings
                                              "Create new Medical History "),
                                        ],
                                      ),
                                    )),
                              ),
                              Container(
                                padding: const EdgeInsets.only(right: 20),
                                width: MediaQuery.of(context).size.width * 0.8,
                                height: 100,
                                child: Card(
                                    color: Colors.grey[200],
                                    child: ListTile(
                                      onTap: (){
                                        Navigator.push(context, MaterialPageRoute(builder: (context) {
                                          return const AddFoodPage();
                                        }));
                                      },
                                      leading: const CircleAvatar(
                                          backgroundColor: Colors.transparent,
                                          child: Padding(
                                            padding: EdgeInsets.only(top:15),
                                            child: SizedBox(
                                              // child: ClipOval(
                                              child: Icon(Icons.fastfood_rounded,color: Colors.black,size: 35,),

                                              // Image.network(
                                              //     // ignore: prefer_interpolation_to_compose_strings
                                              //     "${globals.finalUrl}images/shops/"+
                                              //  persons[index]['img'],
                                              //   // ),
                                              // )
                                            ),
                                          )),
                                      title: const Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(height: 20,),
                                          Text('Food',
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w500,
                                                  letterSpacing: 0.5)),
                                          SizedBox(height: 10,),
                                          Text(
                                            // ignore: prefer_interpolation_to_compose_strings
                                              "Create Food Remainder "),
                                        ],
                                      ),
                                    )),
                              ),
                            ],
                          )),
                    ),
                    const Padding(
                        padding: EdgeInsets.only(top: 30, left: 20),
                        child: Text(
                          "Today's Progress",
                          style: TextStyle(fontSize: 16),
                        )),
                    const SizedBox(
                      height: 25,
                    ),
                    Container(
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      height: 10,
                      child: LinearProgressBar(
                        maxSteps: totalProgress,
                        progressType: LinearProgressBar.progressTypeLinear,
                        // Use Linear progress
                        currentStep: completed,
                        progressColor: Colors.indigo,
                        backgroundColor: Colors.grey,
                      ),
                    ),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: Text(("$completed/${total!} Task Completed")),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Padding(
                        padding: EdgeInsets.only(top: 30, left: 20),
                        child: Text(
                          "Activity History",
                          style: TextStyle(fontSize: 16),
                        )),
                    const SizedBox(
                      height: 25,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
                      child: ListView.builder(
                        itemCount: activityList.length,
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          String id = activityList[index]['activityid'].toString();
                          String currentval = logs[0][id].toString();
                          if(currentval == "0"){
                            notupdated = true;
                            updated = false;
                          }else{
                            notupdated = false;
                            updated = true;
                          }


                          return Card(
                              elevation: 5,
                              child: ListTile(
                                leading: const CircleAvatar(
                                    backgroundColor: Colors.transparent,
                                    child: SizedBox(
                                        width: 100,
                                        height: 100,
                                        // child: ClipOval(
                                        child: Icon(
                                          Icons.run_circle_outlined,
                                          color: Colors.black,
                                        ))),
                                title: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Text(activityList[index]['name'],
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
                                          activityList[index]['description'],
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall,
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      // ignore: prefer_interpolation_to_compose_strings
                                      "Time: " + activityList[index]['time'],
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall,
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                  ],
                                ),
                                trailing: Column(children: [ GestureDetector(onTap:(){
                                  update(activityList[index]['id'],activityList[index]['activityid'],"activity");

                                }, child: Visibility(visible: notupdated,child: const Icon(Icons.update,color:Colors.red))),
                                 Visibility(visible: updated,child: const Icon(Icons.check,color: Colors.green,))],),
                              ));
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
                      child: ListView.builder(
                        itemCount: medicinesList.length,
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          String id = medicinesList[index]['activityid'].toString();
                          String currentval = logs[0][id].toString();
                          if(currentval == "0"){
                            notupdated = true;
                            updated = false;
                          }else{
                            notupdated = false;
                            updated = true;
                          }
                          return Card(
                              elevation: 5,
                              child: ListTile(
                                leading: const CircleAvatar(
                                    backgroundColor: Colors.transparent,
                                    child: SizedBox(
                                        width: 100,
                                        height: 100,
                                        // child: ClipOval(
                                        child: Icon(
                                          Icons.local_hospital,
                                          color: Colors.black,
                                        ))),
                                title: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Text(medicinesList[index]['name'],
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
                                      "Purpose: " +
                                          medicinesList[index]['description'],
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall,
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      // ignore: prefer_interpolation_to_compose_strings
                                      "Dosage: " + medicinesList[index]['dosage'],
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall,
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      // ignore: prefer_interpolation_to_compose_strings
                                      "Time: " + medicinesList[index]['time'],
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall,
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                  ],
                                ),
                                 trailing: Column(children: [GestureDetector(onTap:(){
                              update(medicinesList[index]['id'],medicinesList[index]['activityid'],"medical");

                              }, child:Visibility(visible: notupdated,child: const Icon(Icons.update,color:Colors.red))),
                                   Visibility(visible: updated,child: const Icon(Icons.check,color: Colors.green,))],),
                              ));
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
                      child: ListView.builder(
                        itemCount: foodList.length,
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (context, index) {

                          String id = foodList[index]['activityid'].toString();
                          String currentval = logs[0][id].toString();
                          if(currentval == "0"){
                            notupdated = true;
                            updated = false;
                          }else{
                            notupdated = false;
                            updated = true;
                          }
                          return Card(
                              elevation: 5,
                              child: ListTile(
                                leading: const CircleAvatar(
                                    backgroundColor: Colors.transparent,
                                    child: SizedBox(
                                        width: 100,
                                        height: 100,
                                        // child: ClipOval(
                                        child: Icon(
                                          Icons.fastfood,
                                          color: Colors.black,
                                        ))),
                                title: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Text(foodList[index]['name'],
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
                                          foodList[index]['description'],
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall,
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      // ignore: prefer_interpolation_to_compose_strings
                                      "Time: " + foodList[index]['time'],
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall,
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                  ],
                                ),
                                trailing: Column(children: [GestureDetector(onTap:(){
                              update(foodList[index]['id'],foodList[index]['activityid'],"food");

                              }, child:Visibility(visible: notupdated,child: const Icon(Icons.update,color:Colors.red))),
                                  Visibility(visible: updated,child: const Icon(Icons.check,color: Colors.green,))],),
                              ));
                        },
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(top: 30, left: 20, bottom: 20),
                      child: Text(
                        "Analytics",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                      ),
                    ),
                    Center(
                      child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.95,
                          height: 300,
                          child: SfCartesianChart(
                              primaryXAxis: CategoryAxis(),
                              legend: const Legend(isVisible: true,position: LegendPosition.top),
                              // Enable tooltip
                              tooltipBehavior:
                              TooltipBehavior(enable: true),
                            // Columns will be rendered back to back
                              enableSideBySideSeriesPlacement: false,
                              series: <ChartSeries<SalesData, String>>[
                                ColumnSeries<SalesData, String>(
                                    dataSource: chartData,
                                    xValueMapper: (SalesData data, _) => data.year,
                                    yValueMapper: (SalesData data, _) => data.x1,
                                 name:
                                  'Performed Activity',
                                ),
                                ColumnSeries<SalesData, String>(
                                    opacity: 0.9,
                                    width: 0.4,
                                    dataSource: chartData,
                                    xValueMapper: (SalesData data, _) => data.year,
                                    yValueMapper: (SalesData data, _) => data.x2,
                                  name:
                                  'Total Activity',
                                )
                              ]
                          )),
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    Center(
                      child: Container(
                        width: MediaQuery.of(context).size.width*0.9,
                        padding: const EdgeInsets.only(left:20,right: 20),
                        color: Colors.grey[200],
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const SizedBox(height: 40,),
                            const Text("Emergency Button",style: TextStyle(fontSize: 15,fontWeight: FontWeight.w500),),
                            const SizedBox(height: 40,),
                            GestureDetector(onTap:(){alert();},child: const Icon(Icons.circle_notifications_sharp,size: 100,color: Colors.red,)),
                            const SizedBox(height: 20,),
                            const Text("Click here to create SOS alert",style: TextStyle(fontSize: 14,fontWeight: FontWeight.w400),),
                            const SizedBox(height: 40,),

                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 40,)

                  ],
                ),
              ),
            ],
          ),
        ));
  }
}

class SalesData {
  SalesData(this.year, this.x1, this.x2);

  final String year;
  final double x1;
  final double x2;

  factory SalesData.fromJson(Map<String, dynamic> parsedJson) {
    return SalesData(
      parsedJson['Year'].toString(),
      parsedJson['x1'].toDouble(),
      parsedJson['x2'].toDouble(),
    );
  }
}
