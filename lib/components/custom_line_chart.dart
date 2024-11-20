import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class CustomLineChart extends StatefulWidget {
  final String title;
  final List<Map<String, dynamic>> allData;

  const CustomLineChart({
    super.key,
    required this.title,
    required this.allData,
  });

  @override
  State<CustomLineChart> createState() => _CustomLineChartState();
}

class _CustomLineChartState extends State<CustomLineChart> {
  String selectedMonth = 'Oktober'; // Bulan default
  final List<String> months = [
    'Januari',
    'Februari',
    'Maret',
    'April',
    'Mei',
    'Juni',
    'Juli',
    'Agustus',
    'September',
    'Oktober',
    'November',
    'Desember'
  ];

  List<FlSpot> _getFilteredData() {
    // Konversi bulan ke angka (Januari = 1, dsb.)
    int monthIndex = months.indexOf(selectedMonth) + 1;

    // Filter data berdasarkan bulan
    final filteredData = widget.allData.where((data) {
      final date = DateTime.parse(data['date']);
      return date.month == monthIndex;
    }).toList();

    // Konversi ke FlSpot
    return filteredData.map((data) {
      final date = DateTime.parse(data['date']);
      return FlSpot(date.day.toDouble(), data['value'].toDouble());
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final filteredDataPoints = _getFilteredData();

    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.title,
            style: const TextStyle(
              color: Color(0xFFC35804),
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Text(
                'Bulan : ',
                style: TextStyle(
                  color: Color(0xFF8F3505),
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 8),
              DropdownButton<String>(
                value: selectedMonth,
                icon:
                    const Icon(Icons.arrow_drop_down, color: Color(0xFFC35804)),
                items: months.map((String month) {
                  return DropdownMenuItem<String>(
                    value: month,
                    child: Text(
                      month,
                      style: const TextStyle(color: Color(0xFFC35804)),
                    ),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedMonth = newValue!;
                  });
                },
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 200,
            child: LineChart(
              LineChartData(
                gridData: const FlGridData(show: true),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 20, // Interval sumbu Y
                      getTitlesWidget: (value, meta) {
                        return Text(
                          value.toInt().toString(),
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.black,
                          ),
                        );
                      },
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 1, // Interval sumbu X untuk menampilkan tanggal
                      getTitlesWidget: (value, meta) {
                        final day = value.toInt().toString();
                        return Text(
                          '$day',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.black,
                          ),
                        );
                      },
                    ),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(
                        showTitles: false), // Menyembunyikan keterangan atas
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(
                        showTitles: false), // Menyembunyikan keterangan kanan
                  ),
                ),
                borderData: FlBorderData(
                  show: true,
                  border: const Border(
                    left: BorderSide(color: Colors.black, width: 1),
                    bottom: BorderSide(color: Colors.black, width: 1),
                  ),
                ),
                minY: 0,
                maxY: 100,
                lineBarsData: [
                  LineChartBarData(
                    spots: filteredDataPoints,
                    isCurved: true,
                    color: const Color(0xFFC35804),
                    barWidth: 3,
                    dotData: const FlDotData(show: true),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
