import 'package:flutter/material.dart';

String gradeOutput (int grade)
{
  if (grade >= 70)
    {
      return "Good Grade!";
    }
  else
    {
      return "Try again.";
    }
}

String getTitle()
{
  var year = 2020;
  var module = "CO2509";
  return "Hello World! " + module + " " + year.toString();
}

class Student
{
  String name;
  int grade;

  Student(String name, int grade)
  {
    this.name = name;
    this.grade = grade;
  }
  void study()
  {
    print ("*************************");
    print("${this.name} is studying.");
  }
}



void main()
{
  print(getTitle());
  var myGrades = [1, 56, 76, 23];
  for (var item in myGrades)
  {
      print(gradeOutput(item));
  }

  var image =
  {
    "tags" : ['UClan'],
    "url" : "https://www.uclan.ac.uk/assets/img/uclan-logo-2020.svg"
  };

  print (image["url"]);

  try
  {
    print (20 / 0);
  }
  on Exception
  {
    print("Can't divide by 0.");
  }

  Student student = Student("Test", 20);

  student.name = "Simon";
  student.grade = 100;
  student.study();
}