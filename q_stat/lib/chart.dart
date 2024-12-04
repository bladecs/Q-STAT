import 'package:flutter/material.dart';

class MyChartPage extends StatefulWidget {
  final List<Map<String, dynamic>> classes;
  final List<int> cumulativeFrequencies;
  final List<int> frequencies; // Menambahkan data frekuensi untuk histogram
  final double mean;
  final double variance;
  final List<double> normalDistributionX;
  final List<double> normalDistributionY;
  final List<double> zScores;
  final String inputComparisons;

  const MyChartPage({
    super.key,
    required this.classes,
    required this.cumulativeFrequencies,
    required this.frequencies,
    required this.mean,
    required this.variance,
    required this.normalDistributionX,
    required this.normalDistributionY,
    required this.zScores,
    required this.inputComparisons,
  });

  @override
  _MyChartPageState createState() => _MyChartPageState();
}

class _MyChartPageState extends State<MyChartPage> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Result'),
      ),
      body: Column(
        children: [
          // Bagian IndexedStack untuk chart, tetap tidak bisa digulir
          SizedBox(
            height: 350, // Ukuran tetap untuk grafik
            child: Stack(
              children: [
                IndexedStack(
                  index: _currentIndex,
                  children: [
                    // Histogram
                    _buildChartCard(
                      child: HistogramChartWidget(
                        classes: widget.classes,
                        frequencies: widget.frequencies,
                      ),
                    ),
                    // Distribusi Normal
                    _buildChartCard(
                      child: LineChartWidget(
                        xValues: widget.normalDistributionX,
                        yValues: widget.normalDistributionY,
                      ),
                    ),
                  ],
                ),
                // Tombol navigasi kiri
                _buildNavigationButton(
                  onPressed: () {
                    setState(() {
                      _currentIndex = (_currentIndex - 1).clamp(0, 1);
                    });
                  },
                  left: 16,
                  top: 145,
                  icon: Icons.arrow_back,
                ),
                // Tombol navigasi kanan
                _buildNavigationButton(
                  onPressed: () {
                    setState(() {
                      _currentIndex = (_currentIndex + 1).clamp(0, 1);
                    });
                  },
                  right: 16,
                  top: 145,
                  icon: Icons.arrow_forward,
                ),
              ],
            ),
          ),

          // Bagian yang bisa di-scroll: Tabel dan Statistik
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildDataTable(),
                  _buildStatisticsCard(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper function to build chart cards
  Widget _buildChartCard({required Widget child}) {
    return Container(
      width: double.infinity,
      color: const Color(0xFF0F031C),
      alignment: Alignment.center,
      child: Card(
        elevation: 5,
        margin: const EdgeInsets.all(16),
        child: Container(
          width: 300,
          height: 300,
          padding: const EdgeInsets.all(20),
          child: child,
        ),
      ),
    );
  }

  // Helper function to build navigation buttons
  Widget _buildNavigationButton({
    required VoidCallback onPressed,
    double? left,
    double? right,
    double top = 145,
    required IconData icon,
  }) {
    return Positioned(
      left: left,
      right: right,
      top: top,
      child: RawMaterialButton(
        onPressed: onPressed,
        elevation: 5,
        fillColor: Colors.white,
        shape: const CircleBorder(),
        constraints: const BoxConstraints.tightFor(width: 40, height: 40),
        child: Icon(icon, color: Colors.black),
      ),
    );
  }

  // Helper function to build the DataTable for Z-Scores
  Widget _buildDataTable() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(8),
      child: Card(
        elevation: 5,
        margin: const EdgeInsets.all(16),
        child: DataTable(
          columnSpacing: 16.0,
          dataRowMinHeight: 48.0,
          dataRowMaxHeight: 64.0,
          headingRowHeight: 56.0,
          columns: const [
            DataColumn(label: Text('Interval')),
            DataColumn(label: Text('F')),
            DataColumn(label: Text('F(k)')),
            DataColumn(label: Text('Z-Score')),
          ],
          rows: widget.classes.asMap().entries.map((entry) {
            int index = entry.key;
            Map<String, dynamic> intervalData = entry.value;
            return DataRow(
              cells: [
                DataCell(Text(intervalData['interval'])),
                DataCell(Text(intervalData['frequency'].toString())),
                DataCell(Text(widget.cumulativeFrequencies[index].toString())),
                DataCell(Text(widget.zScores[index].toStringAsFixed(2))),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }

  // Helper function to build the Statistics Card (Mean and Variance)
  Widget _buildStatisticsCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(8),
      child: Card(
        elevation: 5,
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 16),
        child: Column(
          mainAxisSize:
              MainAxisSize.min, // Menghindari overflow dan menyesuaikan tinggi
          children: [
            ListTile(
              title: const Text('Mean'),
              trailing: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: 200, // Tentukan lebar maksimum untuk trailing
                ),
                child: Text(
                  widget.mean.toStringAsFixed(2),
                  overflow: TextOverflow.clip, // Mencegah overflow teks
                  softWrap:
                      true, // Membuat teks bisa turun ke bawah jika terlalu panjang
                ),
              ),
            ),
            ListTile(
              title: const Text('Variance'),
              trailing: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: 200, // Tentukan lebar maksimum untuk trailing
                ),
                child: Text(
                  widget.variance.toStringAsFixed(2),
                  overflow: TextOverflow.clip,
                  softWrap: true,
                ),
              ),
            ),
            ListTile(
              title: const Text('Comparison'),
              trailing: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: 150, // Tentukan lebar maksimum untuk trailing
                ),
                child: Text(
                  widget.inputComparisons,
                  overflow: TextOverflow.clip,
                  softWrap: true,
                  textAlign: TextAlign.right,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LineChartWidget extends StatelessWidget {
  final List<double> xValues;
  final List<double> yValues;
  final double chartWidth;
  final double chartHeight;

  const LineChartWidget({
    super.key,
    required this.xValues,
    required this.yValues,
    this.chartWidth = double.infinity, // Default lebar layar penuh
    this.chartHeight = 300, // Default tinggi 300
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: chartWidth, // Atur lebar area chart
      height: chartHeight, // Atur tinggi area chart
      child: CustomPaint(
        painter: LineChartPainter(xValues, yValues),
      ),
    );
  }
}

class LineChartPainter extends CustomPainter {
  final List<double> xValues;
  final List<double> yValues;

  LineChartPainter(this.xValues, this.yValues);

  @override
  void paint(Canvas canvas, Size size) {
    Paint axisPaint = Paint()
      ..color = Colors.grey // Warna untuk garis sumbu
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    Paint gridPaint = Paint()
      ..color = Colors.grey.withOpacity(0.5) // Warna gridlines
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.5;

    Paint linePaint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    Paint fillPaint = Paint()
      ..color = Colors.blue
          .withOpacity(0.3) // Warna transparan untuk area bawah kurva
      ..style = PaintingStyle.fill;

    // Hitung skala sumbu X dan Y
    double xMin = xValues.first;
    double xMax = xValues.last;
    double yMax = yValues.reduce((a, b) => a > b ? a : b);

    // Jarak margin untuk label di sisi kiri dan bawah
    double margin = 40;

    // Geser grafik agar tidak menutupi label
    double chartWidth = size.width - margin;
    double chartHeight = size.height - margin;

    // Garis sumbu X
    canvas.drawLine(
      Offset(margin, chartHeight), // Mulai dari titik margin di bawah
      Offset(size.width, chartHeight), // Akhir di ujung kanan
      axisPaint,
    );

    // Garis sumbu Y
    canvas.drawLine(
      Offset(margin, 0), // Mulai dari atas
      Offset(margin, chartHeight), // Akhir di bawah
      axisPaint,
    );

    // Gambar gridlines horizontal (sumbu Y)
    int ySteps = 5; // Jumlah pembagian sumbu Y
    for (int i = 0; i <= ySteps; i++) {
      double y = chartHeight - (i * chartHeight / ySteps); // Posisi grid
      double yValue = yMax * (i / ySteps); // Nilai label Y

      canvas.drawLine(
        Offset(margin, y), // Mulai dari margin
        Offset(size.width, y), // Akhir di ujung kanan
        gridPaint,
      );

      // Label Y
      TextSpan span = TextSpan(
        style: const TextStyle(color: Colors.black, fontSize: 10),
        text: yValue.toStringAsFixed(3), // Ubah presisi menjadi 3 desimal
      );
      TextPainter tp = TextPainter(
        text: span,
        textAlign: TextAlign.right,
        textDirection: TextDirection.ltr,
      );
      tp.layout();
      tp.paint(canvas, Offset(margin - 10 - tp.width, y - tp.height / 2));
    }

    // Gambar gridlines vertikal (sumbu X)
    int xSteps = 5;
    for (int i = 0; i <= xSteps; i++) {
      double x = margin + (i * chartWidth / xSteps); // Posisi grid
      double xValue = xMin + (i * (xMax - xMin) / xSteps); // Nilai label X

      canvas.drawLine(
        Offset(x, 0), // Mulai dari atas
        Offset(x, chartHeight), // Akhir di bawah
        gridPaint,
      );

      // Label X
      TextSpan span = TextSpan(
        style: const TextStyle(color: Colors.black, fontSize: 12),
        text: xValue.toStringAsFixed(1),
      );
      TextPainter tp = TextPainter(
        text: span,
        textAlign: TextAlign.center,
        textDirection: TextDirection.ltr,
      );
      tp.layout();
      tp.paint(canvas, Offset(x - tp.width / 2, chartHeight + 5));
    }

    // Path untuk kurva
    Path path = Path();
    Path fillPath = Path();

    for (int i = 0; i < xValues.length; i++) {
      double x =
          margin + (xValues[i] - xMin) / (xMax - xMin) * chartWidth; // Skala X
      double y = chartHeight - (yValues[i] / yMax * chartHeight); // Skala Y

      if (i == 0) {
        path.moveTo(x, y);
        fillPath.moveTo(x, chartHeight); // Mulai area bawah dari garis sumbu X
        fillPath.lineTo(x, y); // Hubungkan ke titik kurva
      } else {
        path.lineTo(x, y);
        fillPath.lineTo(x, y); // Lanjutkan area bawah mengikuti titik kurva
      }
    }

    // Tutup area fill dengan garis ke bawah kanvas
    fillPath.lineTo(margin + chartWidth, chartHeight);
    fillPath.close();

    // Gambar area bawah kurva
    canvas.drawPath(fillPath, fillPaint);

    // Gambar garis kurva
    canvas.drawPath(path, linePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

class HistogramChartWidget extends StatelessWidget {
  final List<Map<String, dynamic>> classes;
  final List<int> frequencies;

  const HistogramChartWidget({
    super.key,
    required this.classes,
    required this.frequencies,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300, // Atur tinggi area histogram
      child: CustomPaint(
        painter: HistogramPainter(classes, frequencies),
      ),
    );
  }
}

class HistogramPainter extends CustomPainter {
  final List<Map<String, dynamic>> classes;
  final List<int> frequencies;

  final int yTicks; // Jumlah ticks pada sumbu Y

  HistogramPainter(this.classes, this.frequencies, {this.yTicks = 5});

  @override
  void paint(Canvas canvas, Size size) {
    Paint barPaint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.fill;

    Paint axisPaint = Paint()
      ..color = Colors.grey
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    Paint tickPaint = Paint()
      ..color = Colors.grey
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.5;

    // Margin untuk sumbu
    double margin = 40;
    double chartWidth = size.width - margin - 10; // Sesuaikan batas kanan
    double chartHeight = size.height - margin - 10; // Sesuaikan batas bawah

    // Garis Sumbu X dan Y
    canvas.drawLine(
      Offset(margin, chartHeight),
      Offset(size.width - 10, chartHeight), // Sesuaikan batas kanan
      axisPaint,
    );
    canvas.drawLine(
      Offset(margin, 10), // Sesuaikan batas atas
      Offset(margin, chartHeight),
      axisPaint,
    );

    // Hitung nilai maksimum untuk skala Y
    int maxFrequency = frequencies.reduce((a, b) => a > b ? a : b);

    // Gambar ticks dan nilai pada sumbu Y
    double tickSpacing = chartHeight / yTicks;
    double tickStep = maxFrequency / yTicks;

    for (int i = 0; i <= yTicks; i++) {
      double y = chartHeight - (i * tickSpacing);
      double frequencyValue = tickStep * i; // Nilai pada sumbu Y

      // Garis kecil pada sumbu Y
      canvas.drawLine(
        Offset(margin - 5, y),
        Offset(margin, y),
        tickPaint,
      );

      // Label pada sumbu Y
      TextSpan span = TextSpan(
        style: const TextStyle(color: Colors.black, fontSize: 10),
        text: frequencyValue.toStringAsFixed(1), // Format desimal
      );
      TextPainter tp = TextPainter(
        text: span,
        textAlign: TextAlign.right,
        textDirection: TextDirection.ltr,
      );
      tp.layout();
      tp.paint(canvas, Offset(margin - tp.width - 8, y - tp.height / 2));
    }

    // Menentukan jarak antar bar
    double barSpacing = 5; // Jarak horizontal antar bar
    double totalSpacing =
        barSpacing * (classes.length - 1); // Total jarak antar bar
    double barWidth =
        (chartWidth - totalSpacing) / classes.length; // Lebar setiap bar

    // Gambar batang histogram
    for (int i = 0; i < frequencies.length; i++) {
      double x = margin + i * (barWidth + barSpacing);
      double y = chartHeight - (frequencies[i] / maxFrequency * chartHeight);
      double barHeight = chartHeight - y;

      // Pastikan batang tidak keluar dari area
      canvas.drawRect(
        Rect.fromLTWH(x, y, barWidth, barHeight),
        barPaint,
      );
    }

    // Menambahkan label pada sumbu X
    for (int i = 0; i < classes.length; i++) {
      TextSpan span = TextSpan(
        style: const TextStyle(color: Colors.black, fontSize: 10),
        text: classes[i]['interval'],
      );
      TextPainter tp = TextPainter(
        text: span,
        textAlign: TextAlign.center,
        textDirection: TextDirection.ltr,
      );
      tp.layout();
      tp.paint(
        canvas,
        Offset(
          margin + i * (barWidth + barSpacing) + (barWidth - tp.width) / 2,
          chartHeight + 5,
        ),
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
