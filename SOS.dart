import 'dart:async';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FirebaseLocationPage extends StatefulWidget {
  @override
  _FirebaseLocationPageState createState() => _FirebaseLocationPageState();
}

class _FirebaseLocationPageState extends State<FirebaseLocationPage> {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late StreamSubscription<Position> _positionStream;
  late DocumentReference<Map<String, dynamic>> _locationDocument;
  bool _isButtonDisabled = false;
  Position? _currentPosition;

  String userId = ''; // Initialize with appropriate data
  String username = ''; // Initialize with appropriate data
  String userType = ''; // Initialize with appropriate data
  String name = ''; // Initialize with appropriate data

  @override
  void initState() {
    super.initState();
    _loadUserDataFromPrefs();
    _isButtonDisabled = false;
  }

  Future<void> _loadUserDataFromPrefs() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      setState(() {
        userId = prefs.getString('userId') ?? '';
        username = prefs.getString('username') ?? '';
        userType = prefs.getString('userType') ?? '';
        name = prefs.getString('name') ?? '';
      });
    } catch (e) {
      // Handle the error here, e.g., show an error message to the user
      print('Error loading data from shared preferences: $e');
    }
  }

  @override
  void dispose() {
    super.dispose();
    _positionStream.cancel();
  }

  void _createLocationDocumentAndStartUpdating() async {
    setState(() {
      _isButtonDisabled = true;
    });

    var status = await Permission.location.request();
    if (status.isGranted) {
      // Save data to Firestore
      final locationData = {
        'latitude': null,
        'longitude': null,
        'timestamp': FieldValue.serverTimestamp(),
        'userId': userId,
        'username': username,
        'userType': userType,
        'name': name,
      };
      try {
        _locationDocument =
            await _firestore.collection('user_locations').add(locationData);
      } catch (e) {
        // Handle the error here, e.g., show an error message to the user
        print('Error saving data to Firestore: $e');
        setState(() {
          _isButtonDisabled = false;
        });
        return;
      }

      // Save data to SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      try {
        prefs.setString('userId', userId);
        prefs.setString('username', username);
        prefs.setString('userType', userType);
        prefs.setString('name', name);
      } catch (e) {
        // Handle the error here, e.g., show an error message to the user
        print('Error saving data to shared preferences: $e');
        setState(() {
          _isButtonDisabled = false;
        });
        return;
      }

      _getCurrentPositionAndUpload();
      _positionStream = Geolocator.getPositionStream().listen((position) {
        setState(() {
          _currentPosition = position;
        });
        _uploadLocationToFirestore();
      });
      Timer.periodic(Duration(seconds: 1), (timer) {
        _uploadLocationToFirestore();
      });
    } else {
      setState(() {
        _isButtonDisabled = false;
      });
      // Handle if user denies location permission
      // You can show a dialog or snackbar to inform the user
      // that the location permission is required for this feature.
    }
  }

  void _getCurrentPositionAndUpload() async {
    Position position = await Geolocator.getCurrentPosition();
    setState(() {
      _currentPosition = position;
    });
    _uploadLocationToFirestore();
  }

  void _uploadLocationToFirestore() {
    if (_currentPosition != null && _locationDocument != null) {
      _locationDocument.update({
        'latitude': _currentPosition!.latitude,
        'longitude': _currentPosition!.longitude,
        'timestamp': FieldValue.serverTimestamp(),
      }).catchError((e) {
        // Handle the error here, e.g., show an error message to the user
        print('Error updating location data to Firestore: $e');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SOS'),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 112, 174, 250),
                Color.fromARGB(255, 218, 229, 244)
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              stops: [0.0, 0.7], // Optional, add color stops for more control
            ),
          ),
        ),
        elevation: 0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_currentPosition != null) ...[
              Text('Latitude: ${_currentPosition!.latitude}'),
              Text('Longitude: ${_currentPosition!.longitude}'),
            ],
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _isButtonDisabled
                  ? null
                  : _createLocationDocumentAndStartUpdating,
              child: Text('Emergency SOS!'),
            ),
            if (_currentPosition == null)
              Text('Location permission not granted.'),
          ],
        ),
      ),
    );
  }
}
