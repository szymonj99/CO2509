import 'package:flutter/material.dart';

String GradeOutput (int grade)
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

String GetTitle()
{
  var year = 2020;
  var module = "CO2509";
  return "Hello World! " + module + " " + year.toString();
}

void main()
{
  print(GetTitle());
  var myGrades = [1, 56, 76, 23];
  for (var item in myGrades)
  {
      print(GradeOutput(item));
  }

  var image =
  {
    "tags" : ['UClan'],
    "url" : "https://www.uclan.ac.uk/assets/img/uclan-logo-2020.svg"
  };

  print (image["url"]);
}