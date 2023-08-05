import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:idms/AppLogin/forget.dart';
import 'package:idms/AppStudent/IDMS.dart';
import 'package:provider/provider.dart';
import 'main.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
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
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            child: NeumorphicBackground(),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Consumer<SettingsProvider>(
              builder: (context, settingsProvider, _) {
                return ListView(
                  children: [
                    NeumorphicButton(
                      padding: EdgeInsets.zero,
                      onPressed: () {
                        // Handle dark mode toggle functionality here
                        settingsProvider.toggleDarkMode();
                      },
                      style: NeumorphicStyle(
                        depth: settingsProvider.isDarkModeEnabled ? -8 : 8,
                        intensity: 0.8,
                        color: Colors.white,
                      ),
                      child: ListTile(
                        title: Text(
                          'Dark Mode',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Roboto',
                            color: Colors.black,
                          ),
                        ),
                        trailing: NeumorphicSwitch(
                          value: settingsProvider.isDarkModeEnabled,
                          onChanged: (value) {
                            settingsProvider.toggleDarkMode();
                          },
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    NeumorphicButton(
                      padding: EdgeInsets.zero,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Forget(),
                          ),
                        );
                        // Handle password reset functionality here
                      },
                      style: NeumorphicStyle(
                        depth: 8,
                        intensity: 0.8,
                        color: Colors.white,
                      ),
                      child: ListTile(
                        title: Text(
                          'Password Reset',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                            fontFamily: 'Roboto',
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    NeumorphicButton(
                      padding: EdgeInsets.zero,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => IDM(),
                          ),
                        );
                        // Handle about app functionality here
                      },
                      style: NeumorphicStyle(
                        depth: 8,
                        intensity: 0.8,
                        color: Colors.white,
                      ),
                      child: ListTile(
                        title: Text(
                          'About App',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                            fontFamily: 'Roboto',
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    NeumorphicButton(
                      padding: EdgeInsets.zero,
                      onPressed: () {
                        // Handle report unwanted activity functionality here
                      },
                      style: NeumorphicStyle(
                        depth: 8,
                        intensity: 0.8,
                        color: Colors.white,
                      ),
                      child: ListTile(
                        title: Text(
                          'Report Unwanted Activity',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                            fontFamily: 'Roboto',
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    NeumorphicButton(
                      padding: EdgeInsets.zero,
                      onPressed: () {
                        // Handle view terms functionality here
                      },
                      style: NeumorphicStyle(
                        depth: 8,
                        intensity: 0.8,
                        color: Colors.white,
                      ),
                      child: ListTile(
                        title: Text(
                          'View Terms',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                            fontFamily: 'Roboto',
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    NeumorphicButton(
                      padding: EdgeInsets.zero,
                      onPressed: () {
                        // Handle view privacy policy functionality here
                      },
                      style: NeumorphicStyle(
                        depth: 8,
                        intensity: 0.8,
                        color: Colors.white,
                      ),
                      child: ListTile(
                        title: Text(
                          'View Privacy Policy',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                            fontFamily: 'Roboto',
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
