import 'package:flutter/material.dart';
import '../models/student.dart';
import 'student_item.dart';

class StudentsScreen extends StatelessWidget {
  final List<Student> students = [
    Student(firstName: 'Anna', lastName: 'White', department: Department.finance, grade: 88, gender: Gender.female),
    Student(firstName: 'Jake', lastName: 'Lee', department: Department.it, grade: 91, gender: Gender.male),
    Student(firstName: 'Maria', lastName: 'Jones', department: Department.medical, grade: 77, gender: Gender.female),
    Student(firstName: 'Liam', lastName: 'Williams', department: Department.law, grade: 95, gender: Gender.male),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Student Directory',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 12.0),
        child: ListView.builder(
          itemCount: students.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 5.0),
              child: StudentItem(student: students[index]),
            );
          },
        ),
      ),
    );
  }
}
