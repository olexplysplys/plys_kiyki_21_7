import 'package:flutter/material.dart';
import '../models/student.dart';

class NewStudent extends StatefulWidget {
  final Student? student;
  final Function(Student) onSave;

  const NewStudent({Key? key, this.student, required this.onSave}) : super(key: key);

  @override
  _NewStudentState createState() => _NewStudentState();
}

class _NewStudentState extends State<NewStudent> {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController gradeController = TextEditingController();
  Department? selectedDepartment;
  Gender? selectedGender;

  @override
  void initState() {
    super.initState();
    if (widget.student != null) {
      firstNameController.text = widget.student!.firstName;
      lastNameController.text = widget.student!.lastName;
      gradeController.text = widget.student!.grade.toString();
      selectedDepartment = widget.student!.department;
      selectedGender = widget.student!.gender;
    }
  }

  void saveStudent() {
    final firstName = firstNameController.text;
    final lastName = lastNameController.text;
    final grade = int.tryParse(gradeController.text) ?? 0;
    if (selectedDepartment != null && selectedGender != null) {
      final newStudent = Student(
        firstName: firstName,
        lastName: lastName,
        department: selectedDepartment!,
        grade: grade,
        gender: selectedGender!,
      );
      widget.onSave(newStudent);
      Navigator.pop(context);
    }
  }

  void cancel() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.only(
          left: 16.0,
          right: 16.0,
          top: 16.0,
          bottom: MediaQuery.of(context).viewInsets.bottom + 16.0,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: firstNameController,
              decoration: InputDecoration(labelText: 'First Name'),
            ),
            TextField(
              controller: lastNameController,
              decoration: InputDecoration(labelText: 'Last Name'),
            ),
            TextField(
              controller: gradeController,
              decoration: InputDecoration(labelText: 'Grade'),
              keyboardType: TextInputType.number,
            ),
            DropdownButton<Department>(
              value: selectedDepartment,
              hint: Text('Select Department'),
              items: Department.values.map((dept) {
                return DropdownMenuItem(
                  value: dept,
                  child: Text(dept.toString().split('.').last),
                );
              }).toList(),
              onChanged: (value) => setState(() => selectedDepartment = value),
            ),
            DropdownButton<Gender>(
              value: selectedGender,
              hint: Text('Select Gender'),
              items: Gender.values.map((gen) {
                return DropdownMenuItem(
                  value: gen,
                  child: Text(gen.toString().split('.').last),
                );
              }).toList(),
              onChanged: (value) => setState(() => selectedGender = value),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: saveStudent,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  child: Text('Save'),
                ),
                TextButton(
                  onPressed: cancel,
                  child: Text('Cancel', style: TextStyle(color: Colors.red)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
