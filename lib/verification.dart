import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:health/dashboard.dart';
import 'package:health/register.dart';
// ignore: depend_on_referenced_packages
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:health/globals.dart' as globals;
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart';

class VerificationPage extends StatefulWidget {
  const VerificationPage({Key? key}) : super(key: key);

  @override
  State<VerificationPage> createState() => _VerificationPageState();
}

class _VerificationPageState extends State<VerificationPage> {
  TextEditingController otp = TextEditingController();
  int inc =0;
  int emailotp =0;
  int referenceno =0;
  bool _loading = true;
  bool _content = false;

  void register() {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return const RegisterPage();
    }));
  }

  verify() async {

    String otpText = otp.text;
    if(otpText.isNotEmpty){
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
                    "Verifying.. Please Wait."),
              ]),
        ),
      );
      bool result = await InternetConnectionChecker().hasConnection;
      if (result == true) {

        final uri1 = Uri.parse('${globals.url}verifyaccount');
        final headers1 = {'Content-Type': 'application/json'};


        Map<String, dynamic> body1 = {
          "email": globals.email,
          "mailotp": otpText,
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
              'Account Verified Successfully',
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

  resend() async {
    bool result = await InternetConnectionChecker().hasConnection;
    if (result == true) {


      Random random = Random();
      referenceno = random.nextInt(100000);
      emailotp = random.nextInt(100000);



      final uri1 = Uri.parse('${globals.url}verifyotp');
      final headers1 = {'Content-Type': 'application/json'};


      Map<String, dynamic> body1 = {
        "email": globals.email,
        "referenceid": referenceno,
        "mailotp": emailotp,
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
            'OTP resented successfully',
          ),
          elevation: 10,
        );
        // Step 3
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(snackBar);

      }else{
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



  connect() async {
    bool result = await InternetConnectionChecker().hasConnection;
    if (result == true) {


      Random random = Random();
      referenceno = random.nextInt(100000);
      emailotp = random.nextInt(100000);



      final uri1 = Uri.parse('${globals.url}verifyotp');
      final headers1 = {'Content-Type': 'application/json'};


      Map<String, dynamic> body1 = {
        "email": globals.email,
        "referenceid": referenceno,
        "mailotp": emailotp,
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

        setState(() {
          _content = true;
          _loading = false;
        });

      }else{
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


  @override
  Widget build(BuildContext context) {
    if(inc ==0){
      connect();
      inc++;
    }
    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
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
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 100,),
                      Center(
                        child: SizedBox(
                            width: MediaQuery.of(context).size.width * 0.4,
                            child: Image.asset(
                              "assets/images/fLogo.jpg",
                              fit: BoxFit.scaleDown,
                            )),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      const Text(
                        "Verify Account",
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Text(
                        "Enter OTP Received on your mail (Ref No: $referenceno )",
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                      SizedBox(
                          width: MediaQuery.of(context).size.width * 0.8,
                          height: 50,
                          child: TextField(
                              maxLines: 1,
                              controller: otp,
                              textInputAction: TextInputAction.next,
                              decoration: const InputDecoration(
                                labelText: "OTP",
                                labelStyle: TextStyle(color: Colors.black, fontSize: 13),
                                hintText: "Enter OTP",
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
                                    borderRadius: BorderRadius.all(Radius.circular(5.0))),
                              ))),
                      const SizedBox(
                        height: 30,
                      ),
                      Center(
                        child: SizedBox(
                            width: MediaQuery.of(context).size.width * 0.8,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                GestureDetector(onTap: (){resend(); },child: const SizedBox(child: Text("Resend OTP",style: TextStyle(color: Colors.indigo),))),
                              ],
                            )),
                      ),
                      const SizedBox(
                        height: 20,
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
                                      borderRadius: BorderRadius.circular(25.0),
                                      side: const BorderSide(color: Colors.indigo)))),
                          onPressed: () {
                            verify();
                          },
                          child: const Text(
                            'VERIFY',
                            style: TextStyle(
                                fontSize: 16, letterSpacing: 3, color: Colors.white),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 50,
                      ),

                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
