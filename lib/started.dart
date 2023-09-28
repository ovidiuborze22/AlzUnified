import 'package:flutter/material.dart';
import 'package:health/login.dart';
import 'package:health/globals.dart' as globals;


class StartedPage extends StatefulWidget {
  const StartedPage({Key? key}) : super(key: key);

  @override
  State<StartedPage> createState() => _StartedPageState();
}

class _StartedPageState extends State<StartedPage> {


  @override
  Widget build(BuildContext context) {
    void submit(){
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (BuildContext context) => const LoginPage()));
    }


    return Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.7,
                  child: Image.asset(
                    "assets/images/fLogo.jpg",
                    fit: BoxFit.scaleDown,
                  )),
            ),
            const SizedBox(height: 30,),
             Text("Welcome ${globals.appName}!",style: const TextStyle(fontSize: 22,fontWeight: FontWeight.w500),),
            const SizedBox(height: 30,),
            const Text("Access to your Healthcare Solution in real-time",style: TextStyle(fontSize: 16),),
            const SizedBox(height: 50,),
            SizedBox(
              width: MediaQuery.of(context).size.width*0.8,
              height: 50,
              child: ElevatedButton(
                style: ButtonStyle(
                    backgroundColor:
                    MaterialStateProperty.all<Color>(Colors.indigo),
                    shape: MaterialStateProperty
                        .all<RoundedRectangleBorder>(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25.0),
                        side: const BorderSide(color: Colors.indigo)))),
                onPressed: () {
                  submit();
                },
                child: const Text(
                  'Get Started',
                  style: TextStyle(
                      fontSize: 16,
                      letterSpacing: 3,
                      color:Colors.white
                  ),
                ),
              ),
            ),
          ],
        ));
  }
}
