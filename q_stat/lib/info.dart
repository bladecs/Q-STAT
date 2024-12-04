import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class InfoPageDashboard extends StatefulWidget {
  const InfoPageDashboard({super.key});

  @override
  _InfoPageDashboardState createState() => _InfoPageDashboardState();
}

class _InfoPageDashboardState extends State<InfoPageDashboard> {
  bool _isContactPersonVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Image.asset(
            "assets/info.png",
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
              shadowColor: Color(0xFF0F031C), // Set the shadow color
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 30, horizontal: 30),
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(bottom: 20),
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle, // Make the image circular
                        border: Border.all(
                          color: Colors.white, // Set the border color to white
                          width: 5, // Set the border width
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Color(0xFF0F031C), // Set the shadow color
                            blurRadius: 10, // Set the blur radius of the shadow
                            spreadRadius:
                                1, // Set the spread radius of the shadow
                          ),
                        ],
                      ),
                      child: ClipOval(
                        child: Image.asset(
                          "assets/logo.png",
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Q-Stat adalah aplikasi analisis statistik modern yang dirancang untuk menyederhanakan proses pengolahan dan visualisasi data. Dengan antarmuka yang intuitif dan alat-alat analisis yang canggih, Q-Stat memungkinkan pengguna untuk melakukan perhitungan statistik secara cepat dan akurat, mulai dari analisis deskriptif hingga uji hipotesis.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12,
                        fontFamily: "Trip Sans",
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF230B46),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Container(
            width: 200,
            child: Text(
              "Made by : Adhwa Nabi, Aqila Hafizh, Dzulhaqqi, Hafizh Ahmad",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                fontFamily: "Trip Sans",
                fontWeight: FontWeight.bold,
                color: const Color(0xFF9F9A9A),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
