import 'package:flutter/material.dart';
import 'package:health/activity.dart';
import 'package:health/dashboard.dart';
import 'package:health/login.dart';
import 'package:health/medicine.dart';
import 'package:health/register.dart';
import 'package:linear_progress_bar/linear_progress_bar.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:health/globals.dart' as globals;


import 'food.dart';
import 'menu.dart';

class LogoutPage extends StatefulWidget {
  const LogoutPage({Key? key}) : super(key: key);

  @override
  State<LogoutPage> createState() => _LogoutPageState();
}

class _LogoutPageState extends State<LogoutPage> {

  @override
  void initState(){
    super.initState();
    Future.delayed(const Duration(milliseconds: 1000), () {
      setState(() {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (BuildContext context) => const LoginPage()));
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        backgroundColor: Colors.white,
        body:  Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AlertDialog(
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
                        "Logout In Progress.. Please Wait."),
                  ]),
            )
          ],
        ));
  }
}
