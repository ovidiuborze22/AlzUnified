import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:health/dashboard.dart';
import 'package:health/forgetverify.dart';
import 'package:health/register.dart';
// ignore: depend_on_referenced_packages
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:health/globals.dart' as globals;
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart';

class ForgetEmailPage extends StatefulWidget {
  const ForgetEmailPage({Key? key}) : super(key: key);

  @override
  State<ForgetEmailPage> createState() => _ForgetEmailPageState();
}

class _ForgetEmailPageState extends State<ForgetEmailPage> {
  TextEditingController otp = TextEditingController();
  int inc =0;
  int emailotp =0;
  int referenceno =0;
  bool _loading = true;
  bool _content = true;

  void register() {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return const RegisterPage();
    }));
  }

  sendotp(){
    String email = otp.text;
    if(email.isNotEmpty){
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return ForgetVerifyPage(email: email);
      }));
    }else{
      // ignore: use_build_context_synchronously
      Navigator.pop(context);
      var snackBar = const SnackBar(
        content: Text(
          'All fields are Mandatory',
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
        body: Center(
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Visibility(
                  visible: _content,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 50,),
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
                      const Text(
                        "Enter Mail Id to recieve OTP",
                        style: TextStyle(fontSize: 16),
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
                                labelText: "Email",
                                labelStyle: TextStyle(color: Colors.black, fontSize: 13),
                                hintText: "Enter Email",
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
                        height: 50,
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
                            sendotp();
                          },
                          child: const Text(
                            'SEND OTP',
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
