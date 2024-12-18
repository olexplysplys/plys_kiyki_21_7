import 'package:flutter/material.dart';
import '../models/student.dart';
import '../models/department.dart';

class StudentItem extends StatelessWidget {
  final Student student;

  const StudentItem({Key? key, required this.student}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(departmentIcons[student.department]),
      title: Text('${student.firstName} ${student.lastName}'),
      subtitle: Text('Grade: ${student.grade}'),
    );
  }
}
