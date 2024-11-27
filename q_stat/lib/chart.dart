import 'package:flutter/material.dart';

class MyChartPage extends StatefulWidget {
  final List<Map<String, dynamic>> classes;
  final List<int> cumulativeFrequencies;
  final List<int> frequencies; // Menambahkan data frekuensi untuk histogram
  final double mean;
  final double variance;
  final List<double> normalDistributionX;
  final List<double> normalDistributionY;

  MyChartPage({
    required this.classes,
    required this.cumulativeFrequencies,
    required this.frequencies, // Menambahkan frekuensi
    required this.mean,
    required this.variance,
    required this.normalDistributionX,
    required this.normalDistributionY,
  });

  @override
  _MyChartPageState createState() => _MyChartPageState();
}

class _MyChartPageState extends State<MyChartPage> {
  int _currentIndex = 0; // Indeks halaman saat ini

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Result'),
      ),
      body: Stack(
        children: [
          // Menggunakan IndexedStack untuk mengganti tampilan berdasarkan indeks
          IndexedStack(
            index: _currentIndex,
            children: [
              // Halaman pertama (Histogram)
              Container(
                width: double.infinity,
                height: 350, // Tetap diatur tingginya
                color: Color(0xFF0F031C),
                alignment: Alignment.topCenter, // Letakkan di atas
                child: Card(
                  elevation: 5,
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  child: Container(
                    width: 300,
                    height: 300,
                    padding: const EdgeInsets.all(20),
                    child: HistogramChartWidget(
                      classes: widget.classes,
                      frequencies: widget.frequencies,
                    ),
                  ),
                ),
              ),
              // Halaman kedua (Distribusi Normal)
              Container(
                width: double.infinity,
                height: 350, // Tetap diatur tingginya
                color: Color(0xFF0F031C),
                alignment: Alignment.topCenter, // Letakkan di atas
                child: Card(
                  elevation: 5,
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  child: Container(
                    width: 300,
                    height: 300,
                    padding: const EdgeInsets.all(20),
                    child: LineChartWidget(
                      xValues: widget.normalDistributionX,
                      yValues: widget.normalDistributionY,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Container(
            child: Expanded(
              child:Padding(padding:EdgeInsets.all(20)),
              ),
          ),
          // Tombol navigasi kiri
          Positioned(
            left: 16,
            top: 0,
            bottom: 0,
            child: Center(
              child: RawMaterialButton(
                onPressed: () {
                  setState(() {
                    _currentIndex = (_currentIndex - 1)
                        .clamp(0, 1); // Navigasi ke halaman sebelumnya
                  });
                },
                elevation: 5,
                fillColor: Colors.white, // Warna latar tombol
                shape: CircleBorder(), // Membuat tombol berbentuk lingkaran
                constraints: BoxConstraints.tightFor(
                  width: 40, // Lebar tombol
                  height: 40, // Tinggi tombol
                ),
                child: Icon(
                  Icons.arrow_back, // Ikon panah kiri
                  color: Colors.black, // Warna ikon
                ),
              ),
            ),
          ),
          // Tombol navigasi kanan
          Positioned(
            right: 16,
            top: 0,
            bottom: 0,
            child: Center(
              child: RawMaterialButton(
                onPressed: () {
                  setState(() {
                    _currentIndex = (_currentIndex + 1)
                        .clamp(0, 1); // Navigasi ke halaman berikutnya
                  });
                },
                elevation: 5,
                fillColor: Colors.white, // Warna latar tombol
                shape: CircleBorder(), // Membuat tombol berbentuk lingkaran
                constraints: BoxConstraints.tightFor(
                  width: 40, // Lebar tombol
                  height: 40, // Tinggi tombol
                ),
                child: Icon(
                  Icons.arrow_forward, // Ikon panah kanan
                  color: Colors.black, // Warna ikon
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class LineChartWidget extends StatelessWidget {
  final List<double> xValues;
  final List<double> yValues;
  final double chartWidth;
  final double chartHeight;

  LineChartWidget({
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
        style: TextStyle(color: Colors.black, fontSize: 10),
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
        style: TextStyle(color: Colors.black, fontSize: 12),
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

  HistogramChartWidget({
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
        style: TextStyle(color: Colors.black, fontSize: 10),
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
        style: TextStyle(color: Colors.black, fontSize: 10),
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
