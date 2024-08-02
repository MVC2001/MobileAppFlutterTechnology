import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:geolocator/geolocator.dart';
import 'package:nearbyhealthfacilityfinder/screens/google_maplocation.dart';
import 'package:nearbyhealthfacilityfinder/screens/passwordReset.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: AuthenticationPage(),
  ));
}

class AuthenticationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => Dashboard()),
            );
          },
          child: Text('Login'),
        ),
      ),
    );
  }
}

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  String userEmail = '';
  final storage = FlutterSecureStorage();
  List<dynamic>? facilitiesData;
  List<dynamic> filteredFacilitiesData = [];
  TextEditingController placeController = TextEditingController();
  TextEditingController facilityTypeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _retrieveUserToken();
    _fetchFacilitiesData();
  }

  Future<void> _retrieveUserToken() async {
    String? userToken = await storage.read(key: 'user_token');
    if (userToken != null) {
      _fetchLoggedUserName(userToken);
    } else {
      print('User token not found in local storage');
    }
  }

  Future<void> _fetchLoggedUserName(String token) async {
    final response = await http.get(
      Uri.parse('http://127.0.0.1:8000/api/user/namev1'),
      headers: <String, String>{
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      setState(() {
        userEmail = jsonData['email'];
      });
    } else {
      print('Failed to fetch user name: ${response.statusCode}');
    }
  }

  Future<void> _fetchFacilitiesData() async {
    final response = await http.get(
      Uri.parse('http://127.0.0.1:8000/api/facilities'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      setState(() {
        facilitiesData = jsonData;
      });
    } else {
      print('Failed to fetch facilities data: ${response.statusCode}');
    }
  }

  Future<void> _logout(BuildContext context) async {
    final response = await http.post(
      Uri.parse('http://127.0.0.1:8000/api/logoutv1'),
    );
    if (response.statusCode == 200) {
      await storage.delete(key: 'user_token');
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => AuthenticationPage()),
      );
    } else {
      print('Failed to logout: ${response.statusCode}');
    }
  }

  void _searchByPlace(String searchText) {
    setState(() {
      if (searchText.isEmpty) {
        filteredFacilitiesData = [];
      } else {
        filteredFacilitiesData = facilitiesData!
            .where((facility) =>
            facility['place']
                .toString()
                .toLowerCase()
                .contains(searchText.toLowerCase()))
            .toList();
      }
    });
  }

  void _searchByCategory(String searchText) {
    setState(() {
      if (searchText.isEmpty) {
        filteredFacilitiesData = [];
      } else {
        filteredFacilitiesData = facilitiesData!
            .where((facility) =>
            facility['category']
                .toString()
                .toLowerCase()
                .contains(searchText.toLowerCase()))
            .toList();
      }
    });
  }

  Future<Map<String, dynamic>> _generateDistanceByCategory(
      String category, double? facilityLat, double? facilityLong) async {
    Random random = Random();
    if (facilityLat == null || facilityLong == null) {
      return {
        'distance': random.nextDouble() * 10 + 1, // Random distance between 1 and 10 km
        'cardinalPoint': _getRandomCardinalPoint(random),
        'category': category,
      };
    }

    Position? currentPosition = await Geolocator.getCurrentPosition();
    if (currentPosition == null) {
      return {
        'distance': random.nextDouble() * 10 + 1, // Random distance between 1 and 10 km
        'cardinalPoint': _getRandomCardinalPoint(random),
        'category': category,
      };
    }

    // Custom logic to fetch coordinates based on category
    double? targetLat;
    double? targetLong;

    // Example custom logic to fetch coordinates based on category
    if (category == 'Hospital') {
      // Fetch hospital coordinates
      targetLat = 1.234; // Replace with actual coordinate for hospitals
      targetLong = 2.345; // Replace with actual coordinate for hospitals
    } else if (category == 'Clinic') {
      // Fetch clinic coordinates
      targetLat = 3.456; // Replace with actual coordinate for clinics
      targetLong = 4.567; // Replace with actual coordinate for clinics
    } else if (category == 'Pharmacy') {
      // Fetch pharmacy coordinates
      targetLat = 5.678; // Replace with actual coordinate for pharmacies
      targetLong = 6.789; // Replace with actual coordinate for pharmacies
    }

    double distanceInMeters = await Geolocator.distanceBetween(
      currentPosition.latitude,
      currentPosition.longitude,
      targetLat!,
      targetLong!,
    );

    double distanceInKm = distanceInMeters / 1000;

    return {
      'distance': distanceInKm,
      'cardinalPoint': _getRandomCardinalPoint(random),
      'category': category,
    };
  }

  String _getRandomCardinalPoint(Random random) {
    List<String> cardinalPoints = ['North', 'South', 'East', 'West'];
    return cardinalPoints[random.nextInt(cardinalPoints.length)];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 3,
        backgroundColor: Colors.blueGrey,
        title: Text(userEmail.isEmpty ? 'Loading...' : 'Welcome, $userEmail'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              _logout(context);
            },
          )
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blueGrey,
              ),
              child: Text(
                'User Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              title: Text('Logout'),
              leading: Icon(Icons.logout),
              onTap: () {
                _logout(context);
              },
            ),
            ListTile(
              title: Text('Password Reset'),
              leading: Icon(Icons.lock),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PasswordReset()),
                );
              },
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  children: [
                    Expanded(
                      flex: 6,
                      child: TextField(
                        controller: placeController,
                        onChanged: _searchByPlace,
                        decoration: InputDecoration(
                          labelText: 'Search by Place',
                          prefixIcon: Icon(Icons.search),
                        ),
                      ),
                    ),
                    SizedBox(width: 8.0),
                    Expanded(
                      flex: 6,
                      child: TextField(
                        controller: facilityTypeController,
                        onChanged: _searchByCategory,
                        decoration: InputDecoration(
                          labelText: 'Search by Health center',
                          prefixIcon: Icon(Icons.search),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16.0),
              filteredFacilitiesData.isEmpty
                  ? Center(child: Text('No facilities found.'))
                  : Column(
                children: [
                  for (var facility in filteredFacilitiesData) ...[
                    Card(
                      color: Colors.blueGrey,
                      shadowColor: Colors.blueGrey,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            SizedBox(height: 8.0),
                            Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  facility['place'].toString(),
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    fontSize: 18.0,
                                  ),
                                ),
                                Text(
                                  ' ${facility['category']}',
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 8.0),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white70,
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.stretch,
                                  children: [
                                    Text(
                                      'HealthCenter -> ${facility['category']}',
                                      style: TextStyle(
                                        fontSize: 16.0,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    SizedBox(height: 8.0),
                                    Text(
                                      'Service -> ${facility['service']}',
                                      style: TextStyle(
                                        fontSize: 16.0,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    SizedBox(height: 8.0),
                                    Text(
                                      'Contact -> ${facility['contact']}',
                                      style: TextStyle(
                                        fontSize: 16.0,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    SizedBox(height: 8.0),
                                    Text(
                                      'WebLink -> ${facility['websiteLink']}',
                                      style: TextStyle(
                                        fontSize: 16.0,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    SizedBox(height: 8.0),
                                    Text(
                                      'Description -> ${facility['description']}',
                                      style: TextStyle(
                                        fontSize: 16.0,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    SizedBox(height: 8.0),
                                    FutureBuilder(
                                      future: _generateDistanceByCategory(
                                        facility['category'],
                                        facility['lat'] != null
                                            ? double.tryParse(
                                            facility['lat'])
                                            : null,
                                        facility['long'] != null
                                            ? double.tryParse(
                                            facility['long'])
                                            : null,
                                      ),
                                      builder: (context,
                                          AsyncSnapshot<
                                              Map<String, dynamic>>
                                          snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return CircularProgressIndicator();
                                        } else if (snapshot.hasError) {
                                          return Text(
                                              'Error: ${snapshot.error}');
                                        } else {
                                          double distance =
                                              snapshot.data!['distance'] ??
                                                  0.0;
                                          String cardinalPoint =
                                              snapshot.data![
                                              'cardinalPoint'] ??
                                                  '';

                                          return Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment
                                                .stretch,
                                            children: [
                                              Text(
                                                'Distance: ${distance.toStringAsFixed(2)} km $cardinalPoint',
                                                style: TextStyle(
                                                  fontSize: 16.0,
                                                  color: Colors.black87,
                                                ),
                                              ),
                                              SizedBox(height: 8.0),
                                              Row(
                                                children: [
                                                  Icon(Icons.place,
                                                      color:
                                                      Colors.blueGrey),
                                                  Expanded(
                                                    child: Container(
                                                      height: 1.0,
                                                      color:
                                                      Colors.blueGrey,
                                                    ),
                                                  ),
                                                  Icon(Icons.place,
                                                      color:
                                                      Colors.blueGrey),
                                                ],
                                              ),
                                              SizedBox(height: 8.0),
                                              Row(
                                                children: [
                                                  Text(
                                                    'From ${facility['place']}',
                                                    style: TextStyle(
                                                      fontSize: 16.0,
                                                      color:
                                                      Colors.black87,
                                                    ),
                                                  ),
                                                  Spacer(),
                                                  Text(
                                                    'To ${facility['category']}',
                                                    style: TextStyle(
                                                      fontSize: 16.0,
                                                      color:
                                                      Colors.black87,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(height: 8.0),
                                              ElevatedButton(
                                                onPressed: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          GoogleLocation(),
                                                    ),
                                                  );
                                                },
                                                child: Text(
                                                  'Find Location',
                                                  style: TextStyle(
                                                    color:
                                                    Colors.blueGrey,
                                                    fontWeight:
                                                    FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          );
                                        }
                                      },
                                    ),
                                    SizedBox(height: 8.0),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: 8.0),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 16.0),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
