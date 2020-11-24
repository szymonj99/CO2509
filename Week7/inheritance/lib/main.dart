import "package:flutter/material.dart";

class Module
{
  String title;

  void status()
  {
    print("Module is running.");
  }
  void setTitle(String title)
  {
    this.title = title;
  }
}

class Student extends Module
{
  String name = "placeholder";
  int grade = -1;

  Student(String name, int grade)
  {
    this.name = name;
    this.grade = grade;
  }

  void setGrade(int grade)
  {
    if (grade >= 70 && grade <= 80)
      {
        this.grade = 80;
      }
  }

}

class MyApp extends StatelessWidget
{
  @override
  Widget build(BuildContext context)
  {
    return MaterialApp(
      title: "Hello World!",
      home: Scaffold(
        appBar: AppBar(
          title: Text("Welcome to CO2509")
        ),
      ),
    );
  }
}

void main()
{
  Student student = Student("Simon", 100);
  student.status();
  student.setTitle("Software Engineering");
}