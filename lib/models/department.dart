import 'package:flutter/material.dart';

enum Department { finance, law, it, medical }

const Map<Department, String> departmentNames = {
  Department.finance: 'Finance',
  Department.law: 'Law',
  Department.it: 'IT',
  Department.medical: 'Medical',
};

const Map<Department, IconData> departmentIcons = {
  Department.finance: Icons.attach_money,
  Department.law: Icons.gavel,
  Department.it: Icons.computer,
  Department.medical: Icons.local_hospital,
};
