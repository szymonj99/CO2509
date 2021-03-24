import 'package:flutter/material.dart';

void main()
{
  runApp(MyApp());
}

class MyApp extends StatelessWidget
{
  @override
  Widget build(BuildContext context)
  {
    return MaterialApp(
      title: "Welcome to CO2509: Mobile computing",
      home: Scaffold(
        appBar: AppBar(
          title: Text("Welcome to CO2509"),
        ),
        body: Center(
          // child: Icon(
          //   Icons.access_alarm_outlined,
          //   color: Colors.red,
          //   size: 200,
          // ),
          //child: Image.asset("assets/images/photo1.png",),
          child: Image.network("https://www.uclan.ac.uk/assets/img/uclan-logo.png", fit: BoxFit.fitWidth)
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.arrow_circle_up_outlined),
          onPressed: ()
          {
            print("onPressed method for the Floating Action Button.");
          },
        ),
      )
    );
  }
}