import 'package:flutter/material.dart';
import 'dart:math';
import 'chart.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class CustomStartDocked extends FloatingActionButtonLocation {
  @override
  Offset getOffset(ScaffoldPrelayoutGeometry scaffoldGeometry) {
    final double fabX = scaffoldGeometry.scaffoldSize.width * 0.083;
    final double fabY = scaffoldGeometry.scaffoldSize.height -
        scaffoldGeometry.floatingActionButtonSize.height -
        53;
    return Offset(fabX, fabY);
  }
}

class CustomEndDocked extends FloatingActionButtonLocation {
  @override
  Offset getOffset(ScaffoldPrelayoutGeometry scaffoldGeometry) {
    final double fabX = scaffoldGeometry.scaffoldSize.width * 0.913 -
        scaffoldGeometry.floatingActionButtonSize.width;
    final double fabY = scaffoldGeometry.scaffoldSize.height -
        scaffoldGeometry.floatingActionButtonSize.height -
        53;
    return Offset(fabX, fabY);
  }
}

class _MyHomePageState extends State<MyHomePage> {
  bool isManualSelected = true;
  int _selectedIndex = 1;
  final TextEditingController _inputController = TextEditingController();
  String _result = '';
  String _suggestion = '';

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  IconData _fabIcon() {
    switch (_selectedIndex) {
      case 0:
        return Icons.settings;
      case 1:
        return Icons.home;
      case 2:
        return Icons.info;
      default:
        return Icons.home;
    }
  }

  void _fabAction() {
    switch (_selectedIndex) {
      case 0:
        print("Settings button pressed");
        break;
      case 1:
        print("Home button pressed");
        break;
      case 2:
        print("Info button pressed");
        break;
      default:
        print("Home button pressed");
    }
  }

  FloatingActionButtonLocation _fabLocation() {
    switch (_selectedIndex) {
      case 0:
        return CustomStartDocked();
      case 1:
        return FloatingActionButtonLocation.centerDocked;
      case 2:
        return CustomEndDocked();
      default:
        return FloatingActionButtonLocation.centerDocked;
    }
  }

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
      return;
    }

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

    // Navigasi ke MyChartPage dengan data yang telah dihitung
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MyChartPage(
          classes: classes,
          cumulativeFrequencies: cumulativeFrequencies,
          frequencies: classes
              .map((c) => c['frequency'] as int)
              .toList(), // Create the frequencies list
          mean: mean,
          variance: variance,
          normalDistributionX: xValues, // Sumbu X distribusi normal
          normalDistributionY: yValues, // Sumbu Y distribusi normal
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          // Logo and title section
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
                Positioned(
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
                padding: EdgeInsets.all(20),
                child: Stack(
                  clipBehavior: Clip.hardEdge,
                  children: [
                    Card(
                      margin: EdgeInsets.only(bottom: 20),
                      elevation: 10,
                      color: const Color(0xFF0F031C),
                      shadowColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: EdgeInsets.only(bottom: 25),
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
                                      padding: EdgeInsets.symmetric(
                                          vertical: 10, horizontal: 20),
                                      decoration: BoxDecoration(
                                        color: isManualSelected
                                            ? Colors.white
                                            : const Color(0xFF230B46),
                                        borderRadius: BorderRadius.only(
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
                                      padding: EdgeInsets.symmetric(
                                          vertical: 10, horizontal: 20),
                                      decoration: BoxDecoration(
                                        color: !isManualSelected
                                            ? Colors.white
                                            : const Color(0xFF230B46),
                                        borderRadius: BorderRadius.only(
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
                            SizedBox(height: 16),
                            // Switch between Manual and CSV content
                            AnimatedSwitcher(
                              duration: Duration(milliseconds: 500),
                              transitionBuilder:
                                  (Widget child, Animation<double> animation) {
                                final fadeAnimation = CurvedAnimation(
                                  parent: animation,
                                  curve:
                                      Interval(0.5, 1.0, curve: Curves.easeOut),
                                );

                                return SlideTransition(
                                  position: Tween<Offset>(
                                    begin: Offset(0.0, 1.0),
                                    end: Offset(0.0, 0.0),
                                  ).animate(animation),
                                  child: FadeTransition(
                                    opacity: fadeAnimation,
                                    child: child,
                                  ),
                                );
                              },
                              child: AnimatedSize(
                                duration: Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                                child: isManualSelected
                                    ? Container(
                                        key: ValueKey('ManualContent'),
                                        padding: EdgeInsets.all(16),
                                        child: Column(
                                          children: [
                                            Text(
                                              'Masukan data',
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  color: Colors.white,
                                                  fontFamily: "Trip Sans"),
                                            ),
                                            SizedBox(height: 8),
                                            TextField(
                                              controller: _inputController,
                                              decoration: InputDecoration(
                                                  filled: true,
                                                  fillColor: Colors.white,
                                                  border: OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: Colors.white)),
                                                  hintText:
                                                      'Contoh: 6.1,6.2,6.3,6.4',
                                                  hintStyle: TextStyle(
                                                    fontSize: 14,
                                                    fontFamily: 'Trip Sans',
                                                    color: Colors.grey[400],
                                                  )),
                                              keyboardType:
                                                  TextInputType.number,
                                            ),
                                            SizedBox(height: 12),
                                            Container(
                                              width: 200,
                                              height: 50,
                                              child: ElevatedButton(
                                                onPressed: () {
                                                  _calculateSturges(context);
                                                },
                                                style: ElevatedButton.styleFrom(
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                  ),
                                                ),
                                                child: Text(
                                                  'Calculate',
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    color:
                                                        const Color(0xFF0F031C),
                                                    fontFamily: "Trip Sans",
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    : Container(
                                        key: ValueKey('CSVContent'),
                                        child: Column(
                                          children: [
                                            Text(
                                              'Upload CSV file:',
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  color: Colors.white,
                                                  fontFamily: "Trip Sans"),
                                            ),
                                            SizedBox(height: 8),
                                            Container(
                                              width: 220,
                                              height: 220,
                                              child: ElevatedButton(
                                                onPressed: () {
                                                  // Add function to upload CSV
                                                },
                                                style: ElevatedButton.styleFrom(
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                  ),
                                                ),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Icon(
                                                      Icons.folder_open,
                                                      size: 50,
                                                      color: const Color(
                                                          0xFF0F031C),
                                                    ),
                                                    SizedBox(height: 10),
                                                    Text(
                                                      'Select Folder',
                                                      style: TextStyle(
                                                        fontSize: 18,
                                                        color: const Color(
                                                            0xFF0F031C),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            SizedBox(height: 12),
                                            Container(
                                              width: 200,
                                              height: 50,
                                              child: ElevatedButton(
                                                onPressed: () {
                                                  // Add function to calculate
                                                },
                                                style: ElevatedButton.styleFrom(
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                  ),
                                                ),
                                                child: Text(
                                                  'Calculate',
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    color:
                                                        const Color(0xFF0F031C),
                                                    fontFamily: "Trip Sans",
                                                  ),
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
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
      // Bottom navigation bar with animations on selection
      floatingActionButton: FloatingActionButton(
        onPressed: _fabAction,
        backgroundColor: Colors.white,
        child: Icon(
          _fabIcon(),
          color: Colors.purple[900],
          size: 30,
        ),
      ),
      floatingActionButtonLocation: _fabLocation(),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8.0,
        color: const Color(0xFF0F031C),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            // Icon Settings
            AnimatedOpacity(
              opacity: _fabIcon() == Icons.settings ? 0.0 : 1.0,
              duration: Duration(milliseconds: 300),
              child: IconButton(
                icon: Icon(
                  Icons.settings,
                  color: _selectedIndex == 0 ? Colors.white : Colors.grey,
                ),
                onPressed: () => _onItemTapped(0),
              ),
            ),
            SizedBox(width: 0),

            // Icon Home
            AnimatedOpacity(
              opacity: _fabIcon() == Icons.home ? 0.0 : 1.0,
              duration: Duration(milliseconds: 300),
              child: IconButton(
                icon: Icon(
                  Icons.home,
                  color: _selectedIndex == 1 ? Colors.white : Colors.grey,
                ),
                onPressed: () => _onItemTapped(1),
              ),
            ),
            SizedBox(width: 0), // Space for the FAB

            // Icon Info
            AnimatedOpacity(
              opacity: _fabIcon() == Icons.info ? 0.0 : 1.0,
              duration: Duration(milliseconds: 300),
              child: IconButton(
                icon: Icon(
                  Icons.info,
                  color: _selectedIndex == 2 ? Colors.white : Colors.grey,
                ),
                onPressed: () => _onItemTapped(2),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
