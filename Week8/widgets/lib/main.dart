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
          child: Text("Hello World"),
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