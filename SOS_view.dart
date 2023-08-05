import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'AppStudent/user_location_map_page.dart';

class LocationListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Live SOS Users'),
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
      body: _buildSosUsersList(),
    );
  }

  Widget _buildSosUsersList() {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream:
          FirebaseFirestore.instance.collection('user_locations').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final userLocations = snapshot.data!.docs;
          return ListView.builder(
            itemCount: userLocations.length,
            itemBuilder: (context, index) {
              final locationData = userLocations[index].data();
              final latitude = locationData['latitude'] ?? 0.0;
              final longitude = locationData['longitude'] ?? 0.0;
              final userId = locationData['userId'] ?? '';
              final username = locationData['username'] ?? '';
              final timestamp = locationData['timestamp'] as Timestamp?;

              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => UserLocationMapPage(
                        latitude: latitude,
                        longitude: longitude,
                      ),
                    ),
                  );
                },
                child: Neumorphic(
                  style: NeumorphicStyle(
                    depth: 5,
                    intensity: 0.8,
                    shape: NeumorphicShape.flat,
                    lightSource: LightSource.topLeft,
                    color: Colors.white,
                  ),
                  child: ListTile(
                    title: Text('User ID: $userId'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Username: $username'),
                        Text('Last Updated: ${_formatTimestamp(timestamp)}'),
                      ],
                    ),
                    trailing: Text('Lat: $latitude, Long: $longitude'),
                  ),
                ),
              );
            },
          );
        } else if (snapshot.hasError) {
          return Center(child: Text('Error fetching SOS users.'));
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  String _formatTimestamp(Timestamp? timestamp) {
    if (timestamp == null) {
      return 'N/A';
    }

    final dateTime = timestamp.toDate();
    return '${dateTime.toLocal()}';
  }
}
