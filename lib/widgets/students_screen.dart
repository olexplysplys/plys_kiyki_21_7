import 'package:flutter/material.dart';
import '../models/student.dart';
import 'student_item.dart';
import 'new_student.dart';

class StudentsScreen extends StatefulWidget {
  @override
  _StudentsScreenState createState() => _StudentsScreenState();
}

class _StudentsScreenState extends State<StudentsScreen> {
  List<Student> students = [
    Student(firstName: 'Anna', lastName: 'White', department: Department.finance, grade: 88, gender: Gender.female),
    Student(firstName: 'Jake', lastName: 'Lee', department: Department.it, grade: 91, gender: Gender.male),
    Student(firstName: 'Maria', lastName: 'Jones', department: Department.medical, grade: 77, gender: Gender.female),
    Student(firstName: 'Liam', lastName: 'Williams', department: Department.law, grade: 95, gender: Gender.male),
  ];

  void addStudent(Student student) {
    setState(() {
      students.add(student);
    });
  }

  void removeStudent(int index) {
    final removedStudent = students[index];
    setState(() {
      students.removeAt(index);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Student removed'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () => setState(() => students.insert(index, removedStudent)),
        ),
      ),
    );
  }

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
            return Dismissible(
              key: ValueKey(students[index].firstName + students[index].lastName),
              direction: DismissDirection.endToStart,
              onDismissed: (_) => removeStudent(index),
              background: Container(
                color: Colors.red,
                alignment: Alignment.centerRight,
                padding: EdgeInsets.only(right: 20),
                child: Icon(Icons.delete, color: Colors.white),
              ),
              child: InkWell(
                onTap: () => showModalBottomSheet(
                  context: context,
                  builder: (_) => NewStudent(
                    student: students[index],
                    onSave: (updatedStudent) {
                      setState(() => students[index] = updatedStudent);
                    },
                  ),
                ),
                child: StudentItem(student: students[index]),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showModalBottomSheet(
          context: context,
          builder: (_) => NewStudent(
            onSave: (newStudent) => addStudent(newStudent),
          ),
        ),
        child: Icon(Icons.add),
        backgroundColor: Colors.green,
      ),
    );
  }
}
