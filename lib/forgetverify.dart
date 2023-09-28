import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:health/dashboard.dart';
import 'package:health/login.dart';
import 'package:health/register.dart';
// ignore: depend_on_referenced_packages
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:health/globals.dart' as globals;
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart';

class ForgetVerifyPage extends StatefulWidget {
  String email;
  ForgetVerifyPage({super.key, required this.email});

  //const ForgetVerifyPage({Key? key}) : super(key: key);

  @override
  State<ForgetVerifyPage> createState() => _ForgetVerifyPageState();
}

class _ForgetVerifyPageState extends State<ForgetVerifyPage> {
  TextEditingController otp = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController confirmpassword = TextEditingController();
  int inc =0;
  int emailotp =0;
  int referenceno =0;
  bool _loading = true;
  bool _content = false;
  late String email;

  void register() {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return const RegisterPage();
    }));
  }

  verify() async {

    String otpText = otp.text;
    String pass1 = password.text;
    String pass2 = confirmpassword.text;

    if(otpText.isNotEmpty && pass1.isNotEmpty && pass2.isNotEmpty) {
      if (pass1.length >= 12) {
        RegExp passValid =
        RegExp(r"(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*\W)");

        if (passValid.hasMatch(pass1)) {
          if (pass1 == pass2) {
            showDialog(
              barrierDismissible: false,
              context: context,
              builder: (context) =>
              const AlertDialog(
                content: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(backgroundColor:
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
              final uri1 = Uri.parse('${globals.url}resetpassword');
              final headers1 = {'Content-Type': 'application/json'};


              Map<String, dynamic> body1 = {
                "email": email,
                "mailotp": otpText,
                "password": pass1
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
                    'Password changed Successfully',
                  ),
                  elevation: 10,
                );
                // Step 3
                // ignore: use_build_context_synchronously
                ScaffoldMessenger.of(context).showSnackBar(snackBar);

                Future.delayed(const Duration(milliseconds: 1000), () {
                  setState(() {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (
                            BuildContext context) => const LoginPage()));
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
          }else{
            Navigator.pop(context);
            var snackBar = const SnackBar(
              content: Text(
                'Password Not Matching',
              ),
              elevation: 10,
            );
            // Step 3
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          }

        } else {
          Navigator.pop(context);
          var snackBar = const SnackBar(
            content: Text(
              'Password should contain Capital,small letter, Number & Special characteristics (Min 12)',
            ),
            elevation: 10,
          );
          // Step 3
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      } else {
        Navigator.pop(context);
        var snackBar = const SnackBar(
          content: Text(
            'Minimum 12 Characters required',
          ),
          elevation: 10,
        );
        // Step 3
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



      final uri1 = Uri.parse('${globals.url}forgetotp');
      final headers1 = {'Content-Type': 'application/json'};


      Map<String, dynamic> body1 = {
        "email": emailotp,
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



      final uri1 = Uri.parse('${globals.url}forgetotp');
      final headers1 = {'Content-Type': 'application/json'};


      Map<String, dynamic> body1 = {
        "email": email,
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
    email = widget.email;
    if(inc ==0){
      connect();
      inc++;
    }
    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Center(
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
                          "Forget Password",
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
                        SizedBox(
                            width: MediaQuery.of(context).size.width * 0.8,
                            height: 50,
                            child: TextField(
                                maxLines: 1,
                                obscureText: true,
                                enableSuggestions: false,
                                autocorrect: false,
                                controller: password,
                                textInputAction: TextInputAction.next,
                                decoration: const InputDecoration(
                                  labelText: "Password",
                                  labelStyle: TextStyle(color: Colors.black, fontSize: 13),
                                  hintText: "Enter Password",
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
                        SizedBox(
                            width: MediaQuery.of(context).size.width * 0.8,
                            height: 50,
                            child: TextField(
                                maxLines: 1,
                                controller: confirmpassword,
                                obscureText: true,
                                enableSuggestions: false,
                                autocorrect: false,
                                textInputAction: TextInputAction.next,
                                decoration: const InputDecoration(
                                  labelText: "Confirm Password",
                                  labelStyle: TextStyle(color: Colors.black, fontSize: 13),
                                  hintText: "Enter Confirm Password",
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
                              'CHANGE PASSWORD',
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
          ),
        ));
  }
}
