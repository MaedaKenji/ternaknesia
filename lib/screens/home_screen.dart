import 'package:flutter/material.dart';

import '../components/summary_cards.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:ternaknesia/components/custom_line_chart.dart';
import 'package:ternaknesia/components/custom_bar_chart.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  HomePage({super.key});

  List<FlSpot> getDataPointsForMilkProduction() {
    // Data dummy untuk "Hasil Perolehan Susu"
    return [
      const FlSpot(0, 10),
      const FlSpot(1, 20),
      const FlSpot(2, 30),
      const FlSpot(3, 40),
      const FlSpot(4, 50),
    ];
  }

  List<FlSpot> getDataPointsForGreenFodder() {
    // Data dummy untuk "Berat Pangan Hijauan"
    return [
      const FlSpot(0, 10),
      const FlSpot(1, 20),
      const FlSpot(2, 70),
      const FlSpot(3, 65),
      const FlSpot(4, 30),
    ];
  }

  List<FlSpot> getDataPointsForConcentratedFodder() {
    // Data dummy untuk "Berat Pangan Sentrat"
    return [
      const FlSpot(0, 15),
      const FlSpot(1, 25),
      const FlSpot(2, 60),
      const FlSpot(3, 55),
      const FlSpot(4, 35),
    ];
  }

  List<BarChartGroupData> getDataPointsForMilkProductionPerMonth() {
    return [
      BarChartGroupData(
        x: 0,
        barRods: [
          BarChartRodData(
            borderRadius: const BorderRadius.all(Radius.circular(0)),
            toY: 500,
            color: const Color(0xFFE6B87D),
            width: 20,
          ),
        ],
      ),
      BarChartGroupData(
        x: 1,
        barRods: [
          BarChartRodData(
            borderRadius: const BorderRadius.all(Radius.circular(0)),
            toY: 250,
            color: const Color(0xFFE6B87D),
            width: 20,
          ),
        ],
      ),
      BarChartGroupData(
        x: 2,
        barRods: [
          BarChartRodData(
            borderRadius: const BorderRadius.all(Radius.circular(0)),
            toY: 900,
            color: const Color(0xFFE6B87D),
            width: 20,
          ),
        ],
      ),
      BarChartGroupData(
        x: 3,
        barRods: [
          BarChartRodData(
            borderRadius: const BorderRadius.all(Radius.circular(0)),
            toY: 100,
            color: const Color(0xFFE6B87D),
            width: 20,
          ),
        ],
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    String displayName = 'Atha Rafifi Azmi';
    displayName = displayName.toUpperCase();

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Bagian header yang tetap
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                height: 140,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFFE6B87D), Color(0xFFF9E2B5)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                ),
              ),
              Positioned(
                left: 16,
                right: 16,
                top: 16,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: Image.asset(
                            'assets/images/LogoTernaknesia.png',
                            width: 50,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('SAPYY',
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 24,
                                  fontWeight: FontWeight.w800,
                                  color: const Color(0xFF8F3505),
                                )),
                            Text('Selamat Bekerja!',
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFF8F3505),
                                )),
                          ],
                        )
                      ],
                    ),
                    const SizedBox(height: 15),
                    Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFFD38C31),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: const Color(0xFFF9E2B5),
                          ),
                        ),
                        child: Row(
                          children: [
                            const Image(
                                image:
                                    AssetImage('assets/images/profileHome.png'),
                                width: 65),
                            const SizedBox(width: 16),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Hai, $displayName',
                                    style: TextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: 16,
                                      fontWeight: FontWeight.w800,
                                      color: Colors.white,
                                    )),
                                const Text(
                                  'Peternak',
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.white),
                                ),
                                const Text(
                                  'Sabtu, 26 Oktober 2024',
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.white),
                                ),
                              ],
                            ),
                          ],
                        )),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 60),
          // Bagian konten yang bisa di-scroll
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(0.0),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SummaryCards(),
                    const SizedBox(height: 16),
                    CustomLineChart(
                      title: 'Hasil Perolehan Susu',
                      dataPoints: getDataPointsForMilkProduction(),
                    ),
                    CustomLineChart(
                      title: 'Berat Pangan Hijauan',
                      dataPoints: getDataPointsForGreenFodder(),
                    ),
                    CustomLineChart(
                      title: 'Berat Pangan Sentrat',
                      dataPoints: getDataPointsForConcentratedFodder(),
                    ),
                    CustomBarChart(
                      title: 'Hasil Perolehan Susu',
                      data: getDataPointsForMilkProductionPerMonth(),
                    )
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
