import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:online_result_slip_delivery_app/dashboard.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(MaterialApp(
    title: 'Your Slip',
    home: DownloadSlip(),
    debugShowCheckedModeBanner: false,
  ));
}

class DownloadSlip extends StatefulWidget {
  const DownloadSlip({super.key});

  @override
  State<DownloadSlip> createState() => _DownloadSlipState();
}

class _DownloadSlipState extends State<DownloadSlip> {
  final String _fetchStatusUrl = 'http://127.0.0.1:8000/api/application-status';
  List<dynamic> _sleeps = [];
  String _statusMessage = '';
  Icon _statusIcon = Icon(Icons.hourglass_empty, color: Colors.orange);

  @override
  void initState() {
    super.initState();
    _fetchApplicationStatus();
  }

  Future<void> _fetchApplicationStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString('token') ?? '';

    final response = await http.get(
      Uri.parse(_fetchStatusUrl),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      setState(() {
        _sleeps = data;
        if (_sleeps.any((slip) => slip['status'] == 'sent')) {
          _statusMessage = 'Application approved successfully';
          _statusIcon = Icon(Icons.check_circle, color: Colors.green);
        } else {
          _statusMessage = 'Application Pending! wait for approve';
          _statusIcon = Icon(Icons.hourglass_empty, color: Colors.orange);
        }
      });
    } else {
      // Handle error
      print('Failed to fetch application status');
    }
  }

  Future<void> _downloadSlip(String studentId) async {
    final url = 'http://127.0.0.1:8000/uploads/$studentId.pdf';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      Fluttertoast.showToast(
        msg: "Could not launch $url",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Download Your Slip'),
        actions: [
          IconButton(
            icon: Icon(Icons.dashboard),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => DashboardScreen()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            color: Colors.teal,
            width: double.infinity,
            padding: EdgeInsets.all(16.0),
            child: Column(
              children: [
                Text(
                  'Application Status',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _statusIcon,
                    SizedBox(width: 8),
                    Text(
                      _statusMessage,
                      style: TextStyle(
                        color: _statusMessage == 'Application approved successfully'
                            ? Colors.white
                            : Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: _sleeps.isEmpty
                ? Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
              padding: EdgeInsets.all(16.0),
              child: Table(
                border: TableBorder.all(),
                columnWidths: const {
                  0: FlexColumnWidth(2),
                  1: FlexColumnWidth(2),
                  2: FlexColumnWidth(1),
                  3: FlexColumnWidth(2),
                  4: FlexColumnWidth(2),
                  5: FlexColumnWidth(1),
                },
                children: [
                  TableRow(
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                    ),
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('Name',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('Index Number',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('Year',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('Status',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('Created At',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('Download',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                  ..._sleeps.map((slip) {
                    return TableRow(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(slip['name']),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(slip['index_number']),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(slip['year']),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Text(slip['status']),
                              SizedBox(width: 8),
                              slip['status'] == 'sent'
                                  ? Icon(Icons.check_circle,
                                  color: Colors.green)
                                  : Icon(Icons.error, color: Colors.red),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(slip['created_at']),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: slip['status'] == 'sent'
                              ? IconButton(
                            icon: Icon(Icons.download),
                            onPressed: () {
                              _downloadSlip(slip['student_id']);
                            },
                          )
                              : FutureBuilder(
                            future:
                            Future.delayed(Duration(seconds: 2),
                                    () {
                                  Fluttertoast.showToast(
                                    msg: "Pending slip not sent",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.CENTER,
                                    backgroundColor: Colors.orange,
                                    textColor: Colors.white,
                                  );
                                }),
                            builder: (context, snapshot) {
                              return Icon(
                                  Icons.pause_circle_filled,
                                  color: Colors.orange);
                            },
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
