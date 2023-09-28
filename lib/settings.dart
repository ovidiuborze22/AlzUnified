import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:health/dashboard.dart';
import 'package:health/forget.dart';
import 'package:health/forum.dart';
import 'package:health/notification.dart';
import 'package:health/globals.dart' as globals;

// ignore: depend_on_referenced_packages
import 'package:image_picker/image_picker.dart';

// ignore: depend_on_referenced_packages
import 'package:http/http.dart';

// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';

// ignore: depend_on_referenced_packages
import 'package:internet_connection_checker/internet_connection_checker.dart';

import 'food.dart';
import 'login.dart';
import 'menu.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  List persons = [
    {'name': "OvidiuBorze", 'category': "New"},
    {'name': "OvidiuBorze", 'category': "New"}
  ];
  bool _loading = true;
  bool _content = false;
  int inc = 0;
  String finImage = "";
  bool _noImg = true;
  bool _img = false;
  String _orgImg = "";
  late Uint8List _fmanBytes;
  String _manBytes = "";
  bool imageAccepted = false;
  TextEditingController email = TextEditingController();


  test(){

  }

  // ignore: annotate_overrides
  void initState() {
    super.initState();
    connect();
  }

  aboutapp(){
    showDialog(
      context: context,
      builder: (context) =>  const AlertDialog(
        content: SizedBox(height: 170,
        child: Column(children: [
          Text("About APP",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 15),),
          SizedBox(height: 30,),
          Text("Version: 1.0.0",style: TextStyle(fontSize: 14),),
          SizedBox(height: 30,),
          Text("Made by Ovidiu ❤️",style: TextStyle(fontSize: 14),)
        ],),)
      ),
    );

  }

  update() async {
    String emergencyEmail = email.text;
    if (emergencyEmail.isNotEmpty) {
      if (!emergencyEmail.contains('@') || !emergencyEmail.contains('.')) {
        Navigator.pop(context);
        var snackBar = const SnackBar(
          content: Text(
            'Enter Proper Email ID',
          ),
          elevation: 10,
        );
        // Step 3
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }else{
        Navigator.pop(context);

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
                      "Updating.. Please Wait."),
                ]),
          ),
        );




        bool result = await InternetConnectionChecker().hasConnection;
        if (result == true) {
          final uri1 = Uri.parse('${globals.url}updateemergency');
          final headers1 = {'Content-Type': 'application/json'};

          Map<String, dynamic> body1 = {"email": globals.email,"emergency":email.text};

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
            globals.emergencyemail = email.text;

            // ignore: use_build_context_synchronously
            Navigator.pop(context);

            var snackBar = const SnackBar(
              content: Text(
                'Updated Successfully',
              ),
              elevation: 10,
            );
            // Step 3
            // ignore: use_build_context_synchronously
            ScaffoldMessenger.of(context).showSnackBar(snackBar);

            Future.delayed(const Duration(milliseconds: 1000), () {
              setState(() {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (BuildContext context) => const SettingsPage()));
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
      }

    }
  }

  emergency() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: SizedBox(
          height: 200,
          child: Column(
            children: [
              const Text(
                "Emergency Contact",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
              ),
              const SizedBox(
                height: 40,
              ),
              SizedBox(
                  child: TextField(
                      maxLines: 1,
                      controller: email,
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                        labelText: "Email",
                        labelStyle:
                            TextStyle(color: Colors.black, fontSize: 13),
                        hintText: "Enter Email Address",
                        hintStyle: TextStyle(fontSize: 13),
                        focusColor: Colors.black,
                        prefixIcon: Icon(
                          Icons.mail,
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
              const SizedBox(
                height: 30,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                height: 50,
                child: ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.indigo),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0),
                              side: const BorderSide(color: Colors.indigo)))),
                  onPressed: () {
                    update();
                  },
                  child: const Text(
                    'UPDATE',
                    style: TextStyle(
                        fontSize: 16, letterSpacing: 3, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  deleteaccount() async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Alert'),
        content: const Text(
            'Do You want to Delete the account?'),
        actions: <Widget>[
          ElevatedButton(
            style: ButtonStyle(
                backgroundColor:
                MaterialStateProperty.all<
                    Color>(Colors.black)),
            onPressed: () async {
              // ignore: use_build_context_synchronously
              Navigator.pop(context);
              showDialog(
                barrierDismissible: false,
                context: context,
                builder: (context) => const AlertDialog(
                  content: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
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
                    Text("Deleting.. Please Wait."),
                  ]),
                ),
              );
              bool result = await InternetConnectionChecker().hasConnection;
              if (result == true) {
                var now = DateTime.now();
                var formatter = DateFormat('yyyy-MM-dd');
                String formattedDate = formatter.format(now);
                final uri1 = Uri.parse('${globals.url}deleteaccount');
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
                String fState = data1["status"];
                if (fState == "success") {

                  var snackBar = const SnackBar(
                    content: Text(
                      'Account Deleted Successfully',
                    ),
                    elevation: 10,
                  );
                  // Step 3
                  // ignore: use_build_context_synchronously
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);

                  Future.delayed(const Duration(milliseconds: 1000), () {
                    setState(() {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (BuildContext context) => const LoginPage()));
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



  }

  Future<void> connect() async {
    bool result = await InternetConnectionChecker().hasConnection;
    if (result == true) {
      var now = DateTime.now();
      var formatter = DateFormat('yyyy-MM-dd');
      String formattedDate = formatter.format(now);
      final uri1 = Uri.parse('${globals.url}getprofile');
      final headers1 = {'Content-Type': 'application/json'};

      Map<String, dynamic> body1 = {"uid": globals.uid};

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
      globals.emergencyemail = persons[0]['emergencyemail'];
      email.text =  persons[0]['emergencyemail'];

      if (persons[0]['gender'] == "Male") {
        finImage = "assets/images/malef.png";
      } else {
        finImage = "assets/images/femalef.png";
      }

      if (persons[0]['profile'] == 0) {
        _noImg = true;
        _img = false;

        ByteData bytes = await rootBundle.load('assets/images/malef.png');
        var buffer = bytes.buffer;
        _manBytes = base64.encode(Uint8List.view(buffer));
        _fmanBytes = const Base64Decoder().convert(_manBytes);
        String img64 = base64Encode(_fmanBytes);
        _orgImg = img64;
      } else {
        _img = true;
        _noImg = false;

        _orgImg = persons[0]['profileimg'];
      }

      if (inc == 0) {
        setState(() {
          _loading = false;
          _content = true;
        });
        inc++;
      }
    } else {}
  }

  Future<void> selectImage() async {
    bool result = await InternetConnectionChecker().hasConnection;
    if (result == true) {
      final image = await ImagePicker()
          .pickImage(source: ImageSource.gallery, imageQuality: 70);
      if (image == null) return;
      if (image == null) return;
      final bytes = File(image.path).readAsBytesSync();
      if (image.path.endsWith("png")) {
        imageAccepted = true;
      } else if (image.path.endsWith("jpg")) {
        imageAccepted = true;
      } else if (image.path.endsWith("jpeg")) {
        imageAccepted = true;
      } else {
        imageAccepted = false;
      }

      if (imageAccepted) {
        // ignore: use_build_context_synchronously
        showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) => const AlertDialog(
            content:
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                    backgroundColor: Colors.black26,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Colors.black,
                    )),
              ),
              SizedBox(
                width: 10,
              ),
              Text("Uploading Image.. Please Wait."),
            ]),
          ),
        );
        int sizeInBytes = bytes.lengthInBytes;
        double sizeInMb = sizeInBytes / (1024 * 1024);
        sizeInMb = sizeInMb * 1000;
        int i = sizeInMb.toInt();
        if (i < 200) {
          String imageF = base64Encode(bytes);
          final uri4 = Uri.parse('${globals.url}uploadimg');
          final headers4 = {'Content-Type': 'application/json'};

          Map<String, dynamic> body4 = {
            "uid": globals.uid,
            "images": imageF,
            "email": globals.email
          };
          String jsonBody4 = json.encode(body4);
          final encoding4 = Encoding.getByName('utf-8');
          Response response4 = await post(
            uri4,
            headers: headers4,
            body: jsonBody4,
            encoding: encoding4,
          );

          String responseBody1 = response4.body;

          final data1 = await json.decode(responseBody1);
          String fState = data1["status"];

          if (fState == "success") {
            var snackBar = const SnackBar(
              content: Text('Updated Successfully'),
              elevation: 10,
              behavior: SnackBarBehavior.floating,
            );
            // Step 3
            // ignore: use_build_context_synchronously
            ScaffoldMessenger.of(context).showSnackBar(snackBar);

            Future.delayed(const Duration(milliseconds: 1000), () {
              setState(() {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (BuildContext context) => const SettingsPage()));
              });
            });

            // ignore: use_build_context_synchronously
            Navigator.pop(context);
          } else {
            var snackBar = const SnackBar(
              content: Text('Something went wrong'),
              elevation: 10,
              behavior: SnackBarBehavior.floating,
            );
            // Step 3
            // ignore: use_build_context_synchronously
            ScaffoldMessenger.of(context).showSnackBar(snackBar);

            // ignore: use_build_context_synchronously
            Navigator.pop(context);
          }
        } else {
          // ignore: use_build_context_synchronously
          Navigator.pop(context);
          var snackBar = const SnackBar(
            content: Text(
              'File Size is Higher',
            ),
            elevation: 10,
            behavior: SnackBarBehavior.floating,
          );
          // ignore: use_build_context_synchronously
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      } else {
        // ignore: use_build_context_synchronously
        Navigator.pop(context);
        var snackBar = const SnackBar(
          content: Text(
            'Image format not valid',
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
                        child: Text("Settings",
                            style: TextStyle(
                                fontWeight: FontWeight.w500, fontSize: 15)),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Visibility(
                        visible: _noImg,
                        child: GestureDetector(
                          onTap: () {
                            selectImage();
                          },
                          child: Center(
                            child: SizedBox(
                                width: 120,
                                height: 120,
                                child: Image.asset(finImage)),
                          ),
                        ),
                      ),
                      FutureBuilder(
                          builder: (context, AsyncSnapshot<String> snapshot) {
                        return Visibility(
                          visible: _img,
                          child: GestureDetector(
                            onTap: () {
                              selectImage();
                            },
                            child: Center(
                              child: SizedBox(
                                  width: 120,
                                  height: 120,
                                  child: Image.memory(base64Decode(_orgImg))),
                            ),
                          ),
                        );
                      },future: test(),),
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 15),
                          // ignore: prefer_const_constructors
                          child: Text(
                            globals.name,
                            style: const TextStyle(
                                fontSize: 17, fontWeight: FontWeight.w400),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.email),
                              Padding(
                                padding: const EdgeInsets.only(left: 5),
                                child: Text(globals.email),
                              )
                            ],
                          ),
                          FutureBuilder(builder:
                              (context, AsyncSnapshot<String> snapshot) {
                            return Row(
                              children: [
                                const Icon(Icons.phone),
                                Padding(
                                  padding: const EdgeInsets.only(left: 5),
                                  child: Text(persons[0]['contact']),
                                )
                              ],
                            );
                          },future: test(),),
                        ],
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20, right: 20),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * 1.0,
                          child: Card(
                              color: Colors.grey[200],
                              child: ListTile(
                                onTap: () {
                                  Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              const ForgetEmailPage()));
                                },
                                leading: const CircleAvatar(
                                    backgroundColor: Colors.transparent,
                                    child: SizedBox(
                                      // child: ClipOval(
                                      child: Icon(
                                        Icons.password,
                                        color: Colors.black,
                                        size: 25,
                                      ),

                                      // Image.network(
                                      //     // ignore: prefer_interpolation_to_compose_strings
                                      //     "${globals.finalUrl}images/shops/"+
                                      //  persons[index]['img'],
                                      //   // ),
                                      // )
                                    )),
                                title: const Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text('Forget Password',
                                        style: TextStyle(
                                            fontSize: 14, letterSpacing: 0.5)),
                                    SizedBox(
                                      height: 10,
                                    ),
                                  ],
                                ),
                              )),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20, right: 20),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * 1.0,
                          child: Card(
                              color: Colors.grey[200],
                              child: ListTile(
                                onTap: () {
                                  emergency();
                                },
                                leading: const CircleAvatar(
                                    backgroundColor: Colors.transparent,
                                    child: SizedBox(
                                      // child: ClipOval(
                                      child: Icon(
                                        Icons.sos,
                                        color: Colors.black,
                                        size: 25,
                                      ),

                                      // Image.network(
                                      //     // ignore: prefer_interpolation_to_compose_strings
                                      //     "${globals.finalUrl}images/shops/"+
                                      //  persons[index]['img'],
                                      //   // ),
                                      // )
                                    )),
                                title: const Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text('Emergency Contact',
                                        style: TextStyle(
                                            fontSize: 14, letterSpacing: 0.5)),
                                    SizedBox(
                                      height: 10,
                                    ),
                                  ],
                                ),
                              )),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20, right: 20),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * 1.0,
                          child: Card(
                              color: Colors.grey[200],
                              child: ListTile(
                                onTap: () {
                                  deleteaccount();
                                },
                                leading: const CircleAvatar(
                                    backgroundColor: Colors.transparent,
                                    child: SizedBox(
                                      // child: ClipOval(
                                      child: Icon(
                                        Icons.delete,
                                        color: Colors.black,
                                        size: 25,
                                      ),

                                      // Image.network(
                                      //     // ignore: prefer_interpolation_to_compose_strings
                                      //     "${globals.finalUrl}images/shops/"+
                                      //  persons[index]['img'],
                                      //   // ),
                                      // )
                                    )),
                                title: const Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text('Delete Account',
                                        style: TextStyle(
                                            fontSize: 14, letterSpacing: 0.5)),
                                    SizedBox(
                                      height: 10,
                                    ),
                                  ],
                                ),
                              )),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20, right: 20),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * 1.0,
                          child: Card(
                              color: Colors.grey[200],
                              child: ListTile(
                                onTap: () {
                                  aboutapp();
                                },
                                leading: const CircleAvatar(
                                    backgroundColor: Colors.transparent,
                                    child: SizedBox(
                                      // child: ClipOval(
                                      child: Icon(
                                        Icons.info,
                                        color: Colors.black,
                                        size: 25,
                                      ),

                                      // Image.network(
                                      //     // ignore: prefer_interpolation_to_compose_strings
                                      //     "${globals.finalUrl}images/shops/"+
                                      //  persons[index]['img'],
                                      //   // ),
                                      // )
                                    )),
                                title: const Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text('About App',
                                        style: TextStyle(
                                            fontSize: 14, letterSpacing: 0.5)),
                                    SizedBox(
                                      height: 10,
                                    ),
                                  ],
                                ),
                              )),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20, right: 20),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * 1.0,
                          child: Card(
                              color: Colors.grey[200],
                              child: ListTile(
                                onTap: () {
                                  // Navigator.push(context, MaterialPageRoute(builder: (context) {
                                  //   return const AddActivityPage();
                                  // }));
                                },
                                leading: const CircleAvatar(
                                    backgroundColor: Colors.transparent,
                                    child: SizedBox(
                                      // child: ClipOval(
                                      child: Icon(
                                        Icons.logout,
                                        color: Colors.black,
                                        size: 25,
                                      ),

                                      // Image.network(
                                      //     // ignore: prefer_interpolation_to_compose_strings
                                      //     "${globals.finalUrl}images/shops/"+
                                      //  persons[index]['img'],
                                      //   // ),
                                      // )
                                    )),
                                title: const Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text('Logout',
                                        style: TextStyle(
                                            fontSize: 14, letterSpacing: 0.5)),
                                    SizedBox(
                                      height: 10,
                                    ),
                                  ],
                                ),
                              )),
                        ),
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                    ],
                  ),
                ),
              ],
            )));
  }
}
