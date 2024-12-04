import 'package:flutter/material.dart';
import 'package:another_flushbar/flushbar.dart';
import 'dart:math';
import 'chart.dart';

class HomePageDashboard extends StatefulWidget {
  const HomePageDashboard({super.key});
  @override
  _HomePageDashboardState createState() => _HomePageDashboardState();
}

class _HomePageDashboardState extends State<HomePageDashboard> {
  bool isManualSelected = true; // Untuk toggle Manual dan CSV
  String _result = '';
  final TextEditingController _inputController = TextEditingController();

  void _calculateSturges(BuildContext context) {
    List<double> data = _inputController.text
        .split(',')
        .map((e) => double.tryParse(e.trim()))
        .where((e) => e != null)
        .cast<double>()
        .toList();

    if (data.isEmpty) {
      setState(() {
        _result = 'Mohon masukkan data yang valid.';
      });
      Flushbar(
        message: _result,
        backgroundColor: Colors.white,
        messageColor: Colors.black,
        borderRadius: BorderRadius.circular(12),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 3),
        positionOffset: 20, // Offset dari atas
        flushbarPosition: FlushbarPosition.TOP,
      ).show(context);
      return;
    } else if (data.length < 2) {
      setState(() {
        _result = 'Angka yang anda masukan kurang';
      });
      Flushbar(
        message: _result,
        backgroundColor: Colors.white,
        messageColor: Colors.black,
        borderRadius: BorderRadius.circular(12),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 3),
        positionOffset: 20, // Offset dari atas
        flushbarPosition: FlushbarPosition.TOP,
      ).show(context);
    } else {
      int n = data.length;

      // Hitung mean dan standar deviasi
      double mean = data.reduce((a, b) => a + b) / n;
      double variance =
          data.map((value) => pow(value - mean, 2)).reduce((a, b) => a + b) /
              (n - 1);
      double stdDev = sqrt(variance);

      // Hitung distribusi normal (PDF) untuk setiap nilai dalam rentang data
      double minValue = data.reduce((a, b) => a < b ? a : b);
      double maxValue = data.reduce((a, b) => a > b ? a : b);
      double step = (maxValue - minValue) / 100;

      List<double> xValues = List.generate(
        101,
        (index) => minValue + index * step,
      );

      List<double> yValues = xValues.map((x) {
        return (1 / (stdDev * sqrt(2 * pi))) *
            exp(-0.5 * pow((x - mean) / stdDev, 2));
      }).toList();

      // Aturan Sturges
      int k = (1 + 3.322 * log(n) / log(10)).round(); // Jumlah kelas
      double range = maxValue - minValue; // Rentang
      double classWidth = (range / k).ceilToDouble(); // Lebar kelas

      double lowerBound = minValue;
      List<Map<String, dynamic>> classes = [];
      List<int> cumulativeFrequencies = [];
      int cumulativeFrequency = 0;

      // Hitung kelas interval dan frekuensi
      for (int i = 0; i < k; i++) {
        double upperBound =
            i == k - 1 ? lowerBound + classWidth : lowerBound + classWidth;

        int frequency = data
            .where((value) => value >= lowerBound && value < upperBound)
            .length;

        cumulativeFrequency += frequency;
        cumulativeFrequencies.add(cumulativeFrequency);

        classes.add({
          'interval':
              '${lowerBound.toStringAsFixed(1)} - ${upperBound.toStringAsFixed(1)}',
          'frequency': frequency,
        });

        lowerBound = upperBound;
      }

      List<double> zScores =
          data.map((value) => (value - mean) / stdDev).toList();

      int countInRange = zScores.where((z) => z >= -2 && z <= 2).length;
      double proportionInRange = countInRange / zScores.length;

      String overallComparison;
      if (proportionInRange > 0.95) {
        overallComparison = 'Data sesuai dengan distribusi normal';
      } else if (proportionInRange > 0.8) {
        overallComparison = 'Data hampir sesuai dengan distribusi normal';
      } else {
        overallComparison = 'Data tidak sesuai dengan distribusi normal';
      }

      double getNormalDensity(double x, double mean, double stdDev) {
        return (1 / (stdDev * sqrt(2 * pi))) *
            exp(-0.5 * pow((x - mean) / stdDev, 2));
      }

      // Navigasi ke MyChartPage dengan data yang telah dihitung
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MyChartPage(
            classes: classes,
            cumulativeFrequencies: cumulativeFrequencies,
            frequencies: classes.map((c) => c['frequency'] as int).toList(),
            mean: mean,
            variance: variance,
            normalDistributionX: xValues, // Sumbu X distribusi normal
            normalDistributionY: yValues, // Sumbu Y distribusi normal
            zScores: zScores,
            inputComparisons: overallComparison, // Tambahkan data perbandingan
          ),
        ),
      );
    }
  }

  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            color: const Color(0xFF0F031C),
            width: double.infinity,
            height: 300,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Image.asset(
                  "assets/logo.png",
                  width: 250,
                  height: 250,
                ),
                const Positioned(
                  bottom: 40,
                  child: Text(
                    "Q-STAT",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontFamily: "Trip Sans",
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Container(
                width: 370,
                padding: const EdgeInsets.all(20),
                child: Stack(
                  clipBehavior: Clip.hardEdge,
                  children: [
                    Card(
                      margin: const EdgeInsets.only(bottom: 20),
                      elevation: 10,
                      color: const Color(0xFF0F031C),
                      shadowColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 25),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Toggle buttons for Manual and CSV options
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        isManualSelected = true;
                                      });
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10, horizontal: 20),
                                      decoration: BoxDecoration(
                                        color: isManualSelected
                                            ? Colors.white
                                            : const Color(0xFF230B46),
                                        borderRadius: const BorderRadius.only(
                                            topLeft: Radius.circular(12)),
                                        border: Border.all(
                                          color: isManualSelected
                                              ? Colors.white
                                              : const Color(0xFF230B46),
                                          width: 2,
                                        ),
                                      ),
                                      child: Text(
                                        'Manual',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 24,
                                          fontFamily: "Trip Sans",
                                          fontWeight: isManualSelected
                                              ? FontWeight.bold
                                              : FontWeight.normal,
                                          color: isManualSelected
                                              ? const Color(0xFF0F031C)
                                              : Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        isManualSelected = false;
                                      });
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10, horizontal: 20),
                                      decoration: BoxDecoration(
                                        color: !isManualSelected
                                            ? Colors.white
                                            : const Color(0xFF230B46),
                                        borderRadius: const BorderRadius.only(
                                            topRight: Radius.circular(12)),
                                        border: Border.all(
                                          color: !isManualSelected
                                              ? Colors.white
                                              : const Color(0xFF230B46),
                                          width: 2,
                                        ),
                                      ),
                                      child: Text(
                                        'CSV',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 24,
                                          fontFamily: "Trip Sans",
                                          fontWeight: !isManualSelected
                                              ? FontWeight.bold
                                              : FontWeight.normal,
                                          color: !isManualSelected
                                              ? const Color(0xFF0F031C)
                                              : Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            // Switch between Manual and CSV content
                            isManualSelected
                                ? Container(
                                    padding: const EdgeInsets.all(16),
                                    child: Column(
                                      children: [
                                        const Text(
                                          'Masukan data',
                                          style: TextStyle(
                                              fontSize: 18,
                                              color: Colors.white,
                                              fontFamily: "Trip Sans"),
                                        ),
                                        const SizedBox(height: 8),
                                        TextField(
                                          controller: _inputController,
                                          decoration: InputDecoration(
                                              filled: true,
                                              fillColor: Colors.white,
                                              border: const OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Colors.white)),
                                              hintText:
                                                  'Contoh: 6.1,6.2,6.3,6.4',
                                              hintStyle: TextStyle(
                                                fontSize: 14,
                                                fontFamily: 'Trip Sans',
                                                color: Colors.grey[400],
                                              )),
                                          keyboardType: TextInputType.number,
                                        ),
                                        const SizedBox(height: 12),
                                        SizedBox(
                                          width: 200,
                                          height: 50,
                                          child: ElevatedButton(
                                            onPressed: () {
                                              _calculateSturges(context);
                                            },
                                            style: ElevatedButton.styleFrom(
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                            ),
                                            child: const Text(
                                              'Calculate',
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: Color(0xFF0F031C),
                                                fontFamily: "Trip Sans",
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : Container(
                                    padding: const EdgeInsets.all(16),
                                    child: Column(
                                      children: [
                                        const Text(
                                          'Upload CSV file:',
                                          style: TextStyle(
                                              fontSize: 18,
                                              color: Colors.white,
                                              fontFamily: "Trip Sans"),
                                        ),
                                        const SizedBox(height: 8),
                                        ElevatedButton(
                                          onPressed: () {
                                            // Add function to upload CSV
                                          },
                                          child: const Text('Select File'),
                                        ),
                                      ],
                                    ),
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
