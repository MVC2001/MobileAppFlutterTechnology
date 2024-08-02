import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:online_result_slip_delivery_app/yourSlip.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_screen.dart'; // Import your authentication page
import 'package:file_picker/file_picker.dart'; // Import file picker
import 'package:intl/intl.dart'; // Import intl for date formatting

void main() {
  runApp(MaterialApp(
    title: 'Dashboard',
    home: DashboardScreen(),
    debugShowCheckedModeBanner: false,
  ));
}

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  String _email = 'Loading...';
  final String _userUrl = 'http://127.0.0.1:8000/api/student/user';
  final String _logoutUrl = 'http://127.0.0.1:8000/api/student/logout';
  final String _applyUrl = 'http://127.0.0.1:8000/api/student/apply';

  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String _indexNumber = '';
  String _year = '';
  PlatformFile? _file;
  final DateFormat _dateFormat = DateFormat('yyyy-MM-dd'); // Adjust format to YYYY-MM-DD

  @override
  void initState() {
    super.initState();
    _fetchUserEmail();
  }

  Future<void> _fetchUserEmail() async {
    final prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString('token') ?? '';

    final response = await http.get(
      Uri.parse(_userUrl),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        _email = data['email'];
      });
    } else {
      setState(() {
        _email = 'Failed to fetch email';
      });
    }
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString('token') ?? '';

    final response = await http.post(
      Uri.parse(_logoutUrl),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      await prefs.remove('token'); // Remove token from storage
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => AuthenticationPage()),
      );
    } else {
      // Handle error
      print('Logout failed');
    }
  }

  Future<void> _submitApplication() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save();

    final prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString('token') ?? '';

    final request = http.MultipartRequest('POST', Uri.parse(_applyUrl))
      ..headers['Authorization'] = 'Bearer $token'
      ..fields['name'] = _name
      ..fields['index_number'] = _indexNumber
      ..fields['year'] = _year;

    if (_file != null) {
      request.files.add(http.MultipartFile.fromBytes(
        'clearance_form',
        _file!.bytes!,
        filename: _file!.name,
      ));
    }

    final response = await request.send();
    final responseBody = await response.stream.bytesToString();
    print('Response Status: ${response.statusCode}');
    print('Response Body: $responseBody');

    if (response.statusCode == 201) {
      // Handle success
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Application submitted successfully')),
      );
    } else {
      // Handle error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to submit application')),
      );
    }
  }

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result != null) {
      setState(() {
        _file = result.files.first;
      });
    }
  }

  Future<void> _selectYear() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null && pickedDate != DateTime.now()) {
      setState(() {
        _year = _dateFormat.format(pickedDate); // Adjust to full date
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Dashboard',
          style: TextStyle(color: Colors.teal),
        ),
        backgroundColor: Colors.white,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Center(child: Text(_email)),
          ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Fill the form below to apply for result slip',
                style: TextStyle(fontSize: 20, color: Colors.teal),
              ),
              SizedBox(height: 16.0),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Name',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your name';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _name = value ?? '';
                      },
                    ),
                    SizedBox(height: 16.0),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Index Number',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your index number';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _indexNumber = value ?? '';
                      },
                    ),
                    SizedBox(height: 16.0),
                    GestureDetector(
                      onTap: _selectYear,
                      child: AbsorbPointer(
                        child: TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Year',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            suffixIcon: Icon(Icons.calendar_today),
                          ),
                          controller: TextEditingController(text: _year),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please select the year';
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                    SizedBox(height: 16.0),
                    ElevatedButton(
                      onPressed: _pickFile,
                      child: Text('Upload clearance form here'),
                    ),
                    if (_file != null) Text('Selected File: ${_file!.name}'),
                    SizedBox(height: 16.0),
                    ElevatedButton(
                      onPressed: _submitApplication,
                      child: Text('Submit Application'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.white54,
              ),
              child: Text(
                'Student Menu',
                style: TextStyle(fontSize: 20),
              ),
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('Password Reset'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.book),
              title: Text('Download Slip'),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DownloadSlip(),
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('LogOut'),
              onTap: _logout,
            ),
          ],
        ),
      ),
    );
  }
}
