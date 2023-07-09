import 'dart:convert';
import 'package:create_student_backend_api_save/student_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() => runApp(DrivingSchoolApp());

class DrivingSchoolApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Driving School App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: StudentListScreen(),
    );
  }
}

class StudentListScreen extends StatefulWidget {
  @override
  _StudentListScreenState createState() => _StudentListScreenState();
}

class _StudentListScreenState extends State<StudentListScreen> {
  List<Student> students = [];

  Future<void> fetchStudents() async {
    final apiUrl = 'http://localhost:5000/api/students';
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final List<dynamic> responseData = jsonDecode(response.body);
      setState(() {
        students = responseData.map((json) => Student.fromJson(json)).toList();
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchStudents();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Student List'),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            ListTile(
              title: Text('Add Student'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => NewStudentScreen()),
                );
              },
            ),
            ListTile(
              title: Text('Student List'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: ListView.builder(
        itemCount: students.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            title: Text(students[index].name),
            subtitle: Text(students[index].mobileNumber),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditStudentScreen(
                          student: students[index],
                        ),
                      ),
                    );
                  },
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    // Implement delete functionality
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class EditStudentScreen extends StatelessWidget {
  final Student student;

  EditStudentScreen({required this.student});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Student'),
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: TextEditingController(text: student.name),
              decoration: InputDecoration(
                labelText: 'Name',
              ),
            ),
            TextField(
              controller: TextEditingController(text: student.mobileNumber),
              decoration: InputDecoration(
                labelText: 'Mobile Number',
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                // Implement update functionality
              },
              child: Text('Update'),
            ),
          ],
        ),
      ),
    );
  }
}

class NewStudentScreen extends StatefulWidget {
  @override
  _NewStudentScreenState createState() => _NewStudentScreenState();
}

class _NewStudentScreenState extends State<NewStudentScreen> {

  TextEditingController nameController = TextEditingController();
  TextEditingController mobileNumberController = TextEditingController();

  void createStudent() {
    String name = nameController.text;
    String mobileNumber = mobileNumberController.text;

    // Perform validation if needed

    // Create a new student object
    //temporary id: -1 , later , create one more constructor
    // Student newStudent = Student(id:"-1", name: name, mobileNumber: mobileNumber);
    Student newStudent = Student.withoutId(name, mobileNumber);

    // Send the new student data to the server using an API request
    // Here, you can use the http package to send a POST request

    // Example code for sending the request
    final apiUrl = 'http://localhost:5000/api/students';
    http.post(Uri.parse(apiUrl),
        body: jsonEncode({
          'name': newStudent.name,
          'mobile_number': newStudent.mobileNumber,
        }),
        headers: {'Content-Type': 'application/json'}).then((response) {
      if (response.statusCode == 201) {
        // Student created successfully
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Success'),
              content: Text('Student created successfully.'),
              actions: [
                TextButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pop(); // Pop the new student screen
                  },
                ),
              ],
            );
          },
        );
      } else {
        // Error creating student
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Error'),
              content: Text('Failed to create student.'),
              actions: [
                TextButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text('New Student'),
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'Name',
              ),
            ),
            TextField(
              controller: mobileNumberController,
              decoration: InputDecoration(
                labelText: 'Mobile Number',
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: createStudent,
              child: Text('Create'),
            ),
          ],
        ),
      ),
    );
  }
}
