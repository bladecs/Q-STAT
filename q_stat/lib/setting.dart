import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SettingPageDashboard extends StatefulWidget {
  const SettingPageDashboard({super.key});

  @override
  _SettingPageDashboardState createState() => _SettingPageDashboardState();
}

class _SettingPageDashboardState extends State<SettingPageDashboard> {
  bool _isContactPersonVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Image.asset(
            "assets/setting.png",
            width: double.infinity,
            height: 200,
          ),
          Container(
            width: double.infinity,
            height: 400, // Set the height here
            padding: EdgeInsets.all(20),
            child: Card(
              elevation: 10,
              color: Colors.white,
              shadowColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 30, horizontal: 30),
                child: Column(
                  children: [
                    Text(
                      "SETTING",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 24,
                          fontFamily: "Trip Sans",
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF230B46)),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _isContactPersonVisible = !_isContactPersonVisible;
                        });
                      },
                      child: Container(
                        margin: EdgeInsets.only(top: 20),
                        padding:
                            EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                        decoration: BoxDecoration(
                          color: const Color(0xFF0F031C),
                          borderRadius: BorderRadius.circular(12),
                          border:
                              Border.all(color: Color(0xFF0F031C), width: 2),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Contact Person',
                              style: TextStyle(
                                  fontSize: 18,
                                  fontFamily: "Trip Sans",
                                  fontWeight: FontWeight.normal,
                                  color: Colors.white),
                            ),
                            Icon(
                              Icons.contact_phone, // Example icon
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (_isContactPersonVisible)
                      Padding(
                        padding: EdgeInsets.only(top: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.phone, color: Colors.black),
                                SizedBox(width: 10),
                                Text(
                                  "Nomor HP: 0812-3456-7890",
                                  style: TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                            Row(
                              children: [
                                Icon(Icons.email, color: Colors.black),
                                SizedBox(width: 10),
                                Text(
                                  "Email: example@mail.com",
                                  style: TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    GestureDetector(
                      onTap: () {
                        // Exit the app when "Exit Application" is tapped
                        SystemNavigator.pop(); // Exits the app
                      },
                      child: Container(
                        margin: EdgeInsets.only(top: 15),
                        padding:
                            EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                        decoration: BoxDecoration(
                          color: const Color(0xFF0F031C),
                          borderRadius: BorderRadius.circular(12),
                          border:
                              Border.all(color: Color(0xFF0F031C), width: 2),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Exit Application',
                              style: TextStyle(
                                  fontSize: 18,
                                  fontFamily: "Trip Sans",
                                  fontWeight: FontWeight.normal,
                                  color: Colors.white),
                            ),
                            Icon(
                              Icons.exit_to_app, // Example icon for exit
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
