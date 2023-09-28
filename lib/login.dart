import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:health/dashboard.dart';
import 'package:health/forget.dart';
import 'package:health/register.dart';
import 'package:health/verification.dart';
// ignore: depend_on_referenced_packages
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:health/globals.dart' as globals;
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  void register() {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return const RegisterPage();
    }));
  }

  Future<void> login() async {
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
                  "Logging In.. Please Wait."),
            ]),
      ),
    );

    String emailText = email.text;
    String passwordText = password.text;

    if(emailText.isNotEmpty && passwordText.isNotEmpty){

      bool result = await InternetConnectionChecker().hasConnection;
      if (result == true) {

        final uri1 = Uri.parse('${globals.url}login');
        final headers1 = {'Content-Type': 'application/json'};


        Map<String, dynamic> body1 = {
          "email": emailText,
          "password": passwordText,
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

          if(data1["verify"] == 0){
            globals.name = data1["name"];
            globals.uid = data1["uid"];
            globals.email = emailText;
            globals.emergencyemail = data1["emergencyemail"];


            // ignore: use_build_context_synchronously
            Navigator.pop(context);


            // ignore: use_build_context_synchronously
            Navigator
                .of(context)
                .pushReplacement(
                MaterialPageRoute(
                    builder: (BuildContext context) => const VerificationPage()
                )
            );
            // ignore: use_build_context_synchronously
            // Navigator
            //     .of(context)
            //     .pushReplacement(
            //     MaterialPageRoute(
            //         builder: (BuildContext context) => const DashboardPage()
            //     )
            // );

          }else{
            globals.name = data1["name"];
            globals.uid = data1["uid"];
            globals.email = emailText;
            globals.emergencyemail = data1["emergencyemail"];

            // ignore: use_build_context_synchronously
            Navigator.pop(context);


            // ignore: use_build_context_synchronously
            Navigator
                .of(context)
                .pushReplacement(
                MaterialPageRoute(
                    builder: (BuildContext context) => const DashboardPage()
                )
            );


          }
        }else {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
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
                  "User Login",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
                ),
                const SizedBox(
                  height: 30,
                ),
                const Text(
                  "Existing User! Kindly Login",
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
                        controller: email,
                        textInputAction: TextInputAction.next,
                        decoration: const InputDecoration(
                          labelText: "Email",
                          labelStyle: TextStyle(color: Colors.black, fontSize: 13),
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
                            Icons.key,
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
                  height: 20,
                ),
                Center(
                  child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          GestureDetector(onTap: (){   Navigator.push(context, MaterialPageRoute(builder: (context) {
                            return const ForgetEmailPage();
                          }));},child: const SizedBox(child: Text("Forget Password?"))),
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
                      login();
                    },
                    child: const Text(
                      'LOGIN',
                      style: TextStyle(
                          fontSize: 16, letterSpacing: 3, color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 50,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "New User! Kindly Register -",
                      style: TextStyle(fontSize: 16),
                    ),
                    GestureDetector(
                        onTap: () {
                          register();
                        },
                        child: const Text(" Sign Up",
                            style:
                                TextStyle(fontSize: 16, color: Colors.indigo)))
                  ],
                )
              ],
            ),
          ),
        ));
  }
}
