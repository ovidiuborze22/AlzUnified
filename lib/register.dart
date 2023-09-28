import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:health/login.dart';
import 'package:health/globals.dart' as globals;
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart';
// ignore: depend_on_referenced_packages
import 'package:internet_connection_checker/internet_connection_checker.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  String dropDownValue = 'Male';
  TextEditingController dateInput = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();
  TextEditingController contact = TextEditingController();

  // List of items in our dropdown menu
  var items = ['Male', 'Female', 'Others'];

  // ignore: non_constant_identifier_names
  Future<void> Register() async {

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
                  "Registering.. Please Wait."),
            ]),
      ),
    );




    String emailAddress = email.text;
    String nameText = name.text;
    String contactText = contact.text;
    String password1 = password.text;
    String password2 = confirmPassword.text;
    String date = dateInput.text;

    if (emailAddress.isNotEmpty &&
        nameText.isNotEmpty &&
        contactText.isNotEmpty &&
        password1.isNotEmpty &&
        password2.isNotEmpty &&
        date.isNotEmpty) {
      if (password1 == password2) {
        if (!emailAddress.contains('@') || !emailAddress.contains('.')) {
          Navigator.pop(context);
          var snackBar = const SnackBar(
            content: Text(
              'Enter Proper Email ID',
            ),
            elevation: 10,
          );
          // Step 3
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        } else {
          if (password1.length >= 12) {
            RegExp passValid =
                RegExp(r"(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*\W)");

            if (passValid.hasMatch(password1)) {
              bool result = await InternetConnectionChecker().hasConnection;
              if (result == true) {

                final uri1 = Uri.parse('${globals.url}register');
                print(uri1);
                final headers1 = {'Content-Type': 'application/json'};


                Map<String, dynamic> body1 = {
                  "email": emailAddress,
                  "name": nameText,
                  "contactnumber": contactText,
                  "gender": dropDownValue,
                  "dob": date,
                  "password": password1,
                  "status": 0
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
                      'Account Created Successfully',
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
                }
                if (fState == "error") {
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
                if (fState == "exists") {
                  // ignore: use_build_context_synchronously
                  Navigator.pop(context);

                  var snackBar = const SnackBar(
                    content: Text(
                      'User Already Exists',
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
        }
      } else {
        Navigator.pop(context);
        var snackBar = const SnackBar(
          content: Text('Password Doesn\'t match'),
          elevation: 10,
        );
        // Step 3
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    } else {
      Navigator.pop(context);
      var snackBar = const SnackBar(
        content: Text('All Fields are Mandatory'),
        elevation: 10,
      );
      // Step 3
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  void login() {
    Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (BuildContext context) => const LoginPage()));
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
                const SizedBox(
                  height: 70,
                ),
                Center(
                  child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.3,
                      child: Image.asset(
                        "assets/images/fLogo.jpg",
                        fit: BoxFit.scaleDown,
                      )),
                ),
                const SizedBox(
                  height: 30,
                ),
                const Text(
                  "User Registration",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
                ),
                const SizedBox(
                  height: 30,
                ),
                const Text(
                  "New User! Kindly Register",
                  style: TextStyle(fontSize: 16, letterSpacing: 0.8),
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
                    child: TextField(
                        maxLines: 1,
                        controller: name,
                        textInputAction: TextInputAction.next,
                        decoration: const InputDecoration(
                          labelText: "Username",
                          labelStyle:
                              TextStyle(color: Colors.black, fontSize: 13),
                          hintText: "Enter Username",
                          hintStyle: TextStyle(fontSize: 13),
                          focusColor: Colors.black,
                          prefixIcon: Icon(
                            Icons.perm_identity,
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
                    height: 70,
                    child: TextField(
                        maxLines: 1,
                        maxLength: 11,
                        keyboardType: TextInputType.number,
                        controller: contact,
                        textInputAction: TextInputAction.next,
                        decoration: const InputDecoration(
                          labelText: "Contact Number",
                          labelStyle:
                              TextStyle(color: Colors.black, fontSize: 13),
                          hintText: "Enter Contact Number",
                          hintStyle: TextStyle(fontSize: 13),
                          focusColor: Colors.black,
                          prefixIcon: Icon(
                            Icons.phone,
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
                  child: TextField(
                    controller: dateInput,
                    decoration: const InputDecoration(
                        labelText: "Date of Birth",
                        labelStyle:
                            TextStyle(color: Colors.black, fontSize: 13),
                        prefixIcon: Icon(
                          Icons.date_range,
                          color: Colors.black,
                        ),
                        hintStyle: TextStyle(color: Colors.black, fontSize: 13),
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(5.0)))),
                    readOnly: true,
                    //set it true, so that user will not able to edit text
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(1950),
                        //DateTime.now() - not to allow to choose before today.
                        lastDate: DateTime(2100),
                      );
                      if (pickedDate != null) {
                        //pickedDate output format => 2021-03-10 00:00:00.000
                        String formattedDate =
                            DateFormat('yyyy-MM-dd').format(pickedDate);
                        //formatted date output using intl package =>  2021-03-16
                        setState(() {
                          dateInput.text =
                              formattedDate; //set output date to TextField value.
                        });
                      } else {}
                    },
                  ),
                ),
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
                          labelStyle:
                              TextStyle(color: Colors.black, fontSize: 13),
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
                        obscureText: true,
                        enableSuggestions: false,
                        autocorrect: false,
                        controller: confirmPassword,
                        textInputAction: TextInputAction.next,
                        decoration: const InputDecoration(
                          labelText: "Confirm Password",
                          labelStyle:
                              TextStyle(color: Colors.black, fontSize: 13),
                          hintText: "Enter Confirm Password",
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
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5.0))),
                        ))),
                const SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.1,
                    ),
                    const Text("Gender"),
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
                  height: 40,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  height: 50,
                  child: ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.indigo),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25.0),
                                    side: const BorderSide(
                                        color: Colors.indigo)))),
                    onPressed: () {
                      Register();
                    },
                    child: const Text(
                      'CREATE ACCOUNT',
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
                      "Already having an account -",
                      style: TextStyle(fontSize: 16),
                    ),
                    GestureDetector(
                        onTap: () {
                          login();
                        },
                        child: const Text(" Sign In",
                            style: TextStyle(
                                fontSize: 16, color: Colors.indigo)))
                  ],
                ),
                const SizedBox(
                  height: 50,
                )
              ],
            ),
          ),
        ));
  }
}
