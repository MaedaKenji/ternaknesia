import 'package:flutter/material.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/material_symbols.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:ternaknesia/components/custom_pop_up_dialog.dart';
import 'package:ternaknesia/components/dialogs.dart';
import 'package:ternaknesia/components/multi_chart_container.dart';
import 'package:ternaknesia/components/sections.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ternaknesia/provider/user_role.dart';
import 'package:ternaknesia/screens/addeditnfctag.dart';

class DataSapiPage extends StatefulWidget {
  final String id;
  final String gender;
  final String age;
  final String healthStatus;
  final bool isProductive;
  final bool isConnectedToNFCTag;
  double predictionSusu = 0;
  double susuSaatIni = 0;
  double beratSaatIni = 0;
  double pakanHijauSaatIni = 0;
  double pakanSentratSaatIni = 0;

  DataSapiPage({
    super.key,
    required this.id,
    required this.gender,
    required this.age,
    required this.healthStatus,
    required this.isProductive,
    required this.isConnectedToNFCTag,
  });

  @override
  _DataSapiPageState createState() => _DataSapiPageState();
}

class _DataSapiPageState extends State<DataSapiPage> {
  List<double> beratBadan = [];
  List<double> susu = [];
  List<double> pakanHijau = [];
  List<double> pakanSentrat = [];
  List<String> historyData = ['70 Kg', '65 Kg', '72 Kg', '68 Kg'];
  int _currentChartIndex = 0;
  bool isLoading = true;
  String errorMessage = '';

  Map<String, Map<String, List<FlSpot>>> milkAndWeightDataDinamis = {
    'produksiSusu': {},
    'beratBadan': {},
  };
  Map<String, List<Map<String, dynamic>>>
      milkProductionAndWeightHistoryDynamic = {
    'produksiSusu': [],
    'beratBadan': [],
  };
  Map<String, Map<String, List<FlSpot>>> dinamisFeedData = {
    'pakanHijau': {},
    'pakanSentrat': {}
  };
  Map<String, List<Map<String, dynamic>>> dinamisFeedDataHistory = {
    'pakanHijau': [],
    'pakanSentrat': [],
  };

  TextEditingController stressLevelController = TextEditingController();
  TextEditingController healthStatusController = TextEditingController();
  TextEditingController birahiController = TextEditingController();
  TextEditingController statusController = TextEditingController();

  Map<String, Map<String, List<FlSpot>>> feedData = {
    'pakanHijau': {
      'Januari': [
        const FlSpot(0, 30),
        const FlSpot(1, 35),
        const FlSpot(2, 40)
      ],
      'Februari': [
        const FlSpot(0, 32),
        const FlSpot(1, 33),
        const FlSpot(2, 36)
      ],
    },
    'pakanSentrat': {
      'Januari': [
        const FlSpot(0, 20),
        const FlSpot(1, 25),
        const FlSpot(2, 30)
      ],
      'Februari': [
        const FlSpot(0, 22),
        const FlSpot(1, 23),
        const FlSpot(2, 26)
      ],
    },
  };
  final Map<String, List<Map<String, dynamic>>> feedDataHistory = {
    'pakanHijau': [
      {'date': DateTime(2024, 11, 28), 'data': '50 kg'},
      {'date': DateTime(2024, 11, 29), 'data': '52 kg'},
      {'date': DateTime(2024, 11, 30), 'data': '55 kg'},
      {'date': DateTime(2024, 12, 1), 'data': '48 kg'},
    ],
    'pakanSentrat': [
      {'date': DateTime(2024, 11, 28), 'data': '60 kg'},
      {'date': DateTime(2024, 11, 29), 'data': '58 kg'},
      {'date': DateTime(2024, 11, 30), 'data': '62 kg'},
      {'date': DateTime(2024, 12, 1), 'data': '65 kg'},
    ],
  };

  Map<String, Map<String, List<FlSpot>>> milkAndWeightData = {
    'produksiSusu': {
      'Januari': [
        const FlSpot(0, 50),
        const FlSpot(1, 55),
        const FlSpot(2, 60)
      ],
      'Februari': [
        const FlSpot(0, 52),
        const FlSpot(1, 53),
        const FlSpot(2, 56)
      ],
    },
    'beratBadan': {
      'Januari': [
        const FlSpot(0, 70),
        const FlSpot(1, 72),
        const FlSpot(2, 75)
      ],
      'Februari': [
        const FlSpot(0, 68),
        const FlSpot(1, 69),
        const FlSpot(2, 71)
      ],
    },
  };
  final Map<String, List<Map<String, dynamic>>> milkProductionAndWeightHistory =
      {
    'produksiSusu': [
      // {'date': DateTime(2024, 11, 28), 'data': '50 L'},
      // {'date': DateTime(2024, 11, 29), 'data': '52 L'},
      // {'date': DateTime(2024, 11, 30), 'data': '55 L'},
      // {'date': DateTime(2024, 12, 1), 'data': '48 L'},
    ],
    'beratBadan': [
      // {'date': DateTime(2024, 11, 28), 'data': '70 Kg'},
      // {'date': DateTime(2024, 11, 29), 'data': '68 Kg'},
      // {'date': DateTime(2024, 11, 30), 'data': '72 Kg'},
      // {'date': DateTime(2024, 12, 1), 'data': '75 Kg'},
    ],
  };

  final List<Map<String, dynamic>> stressLevelHistory = [
    {'date': DateTime(2024, 11, 28), 'data': 'Tidak'},
    {'date': DateTime(2024, 11, 29), 'data': 'Ringan'},
    {'date': DateTime(2024, 11, 30), 'data': 'Berat'},
    {'date': DateTime(2024, 12, 6), 'data': 'Ringan'},
  ];

  final List<Map<String, dynamic>> healthStatusHistory = [
    {'date': DateTime(2024, 11, 28), 'data': 'Sehat'},
    {'date': DateTime(2024, 11, 29), 'data': 'Sakit'},
    {'date': DateTime(2024, 11, 30), 'data': 'Sehat'},
    {'date': DateTime(2024, 12, 1), 'data': 'Sakit'},
  ];

  final List<Map<String, dynamic>> birahiHistory = [
    {'date': DateTime(2024, 11, 28), 'data': 'Ya'},
    {'date': DateTime(2024, 11, 29), 'data': 'Tidak'},
    {'date': DateTime(2024, 11, 30), 'data': 'Ya'},
    {'date': DateTime(2024, 12, 1), 'data': 'Ya'},
  ];

  @override
  void initState() {
    super.initState();
    _refreshData();
  }

  void _nextChart() {
    setState(() {
      _currentChartIndex = (_currentChartIndex + 1) % 4;
    });
  }

  void _previousChart() {
    setState(() {
      _currentChartIndex = (_currentChartIndex - 1) % 4;
      if (_currentChartIndex < 0) {
        _currentChartIndex = 3;
      }
    });
  }

  void _addNewData() {
    String key;
    if (_currentChartIndex == 0) {
      key = 'produksiSusu';
    } else if (_currentChartIndex == 1) {
      key = 'beratBadan';
    } else if (_currentChartIndex == 2) {
      key = 'pakanHijau';
    } else {
      key = 'pakanSentrat';
    }

    showDialog(
      context: context,
      builder: (context) => _NewDataDialog(id: widget.id),
    ).then((data) {
      if (data != null && data.isNotEmpty) {
        final Map<String, String> dictionary = {key: data};
        _sendDataToServer(dictionary);
      }
    });
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return const AlertDialog(
          content: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.orange, size: 40),
              SizedBox(width: 10),
              Text("PERUBAHAN DATA SAPI BERHASIL"),
            ],
          ),
        );
      },
    );
  }

  void _showHistory() async {
    await showDialog(
      context: context,
      builder: (context) {
        return _HistoryDialog(
          data: historyData,
          onDelete: (index) {
            setState(() {
              historyData.removeAt(index);
            });
          },
        );
      },
    );
  }

  Widget _buildHeader(
      {required String id,
      required String gender,
      required String age,
      required String healthStatus,
      required bool isProductive}) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          height: 110,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFC35804), Color(0xFFE6B87D)],
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
          top: 12,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.arrow_back_ios,
                      color: Colors.white,
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Detail Sapi $id',
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFFF9E2B5),
                  borderRadius: const BorderRadius.all(Radius.circular(20)),
                  border: Border.all(
                    color: const Color(0xFFC35804),
                  ),
                ),
                child: Row(
                  children: [
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        const CircleAvatar(
                          radius: 36,
                          backgroundImage:
                              AssetImage('assets/images/cow_alt.png'),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 5, vertical: 5),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  gender.toLowerCase() == 'jantan'
                                      ? Colors.blue.shade300
                                      : Colors.pink.shade300,
                                  gender.toLowerCase() == 'jantan'
                                      ? Colors.blue.shade600
                                      : Colors.pink.shade600,
                                ],
                              ),
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  gender.toLowerCase() == 'jantan'
                                      ? Icons.male
                                      : Icons.female,
                                  color: Colors.white,
                                  size: 17,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return CustomPopUpDialog(
                                          title: 'ID SAPI',
                                          content: id,
                                        );
                                      },
                                    );
                                  },
                                  child: Text(
                                    id,
                                    style: const TextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: 24,
                                      fontWeight: FontWeight.w800,
                                      color: Color(0xFF8F3505),
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    softWrap: false,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              _buildCowIndicator(
                                  isHealthy:
                                      healthStatus.toUpperCase() == 'SEHAT',
                                  isProductive: isProductive),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _buildCowInfo(
                                'Berat',
                                '350 Kg',
                                MaterialSymbols.weight,
                              ),
                              _buildCowInfo(
                                  'Umur', age, MaterialSymbols.calendar_month),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCowInfo(String label, String value, String icon) {
    return Expanded(
      child: Row(children: [
        Iconify(
          icon,
          size: 32,
          color: const Color(0xFF8F3505),
        ),
        const SizedBox(width: 4),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: Color(0xFF8F3505),
              ),
            ),
            Text(
              label == 'Umur' ? '$value Bulan' : value,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ]),
    );
  }

  Widget _buildCowIndicator({
    bool? isHealthy,
    bool? isProductive,
  }) {
    return Row(
      children: [
        if (isHealthy != null)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  isHealthy ? Colors.green.shade300 : Colors.red.shade300,
                  isHealthy ? Colors.green.shade600 : Colors.red.shade600,
                ],
              ),
              borderRadius: BorderRadius.circular(50),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  isHealthy ? Icons.check : Icons.error,
                  color: Colors.white,
                  size: 12,
                ),
                const SizedBox(width: 4),
                Text(
                  isHealthy ? 'SEHAT' : 'SAKIT',
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        if (isProductive == true) const SizedBox(width: 8),
        if (isProductive != null && isProductive)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.green.shade300,
                  Colors.green.shade600,
                ],
              ),
              borderRadius: BorderRadius.circular(50),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.check,
                  color: Colors.white,
                  size: 12,
                ),
                SizedBox(width: 4),
                Text(
                  'PRODUKTIF',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Future<void> _sendDataToServer(Map<String, String> data) async {
    try {
      final url = Uri.parse(
          '${dotenv.env['BASE_URL']}:${dotenv.env['PORT']}/api/cows/tambahdata/${widget.id}');
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(data),
      );

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Data berhasil dikirim ke server")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text("Gagal mengirim data ke server di data page")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  Map<String, Map<String, List<FlSpot>>> processFeedData(
      List<Map<String, dynamic>> feedHijauan,
      List<Map<String, dynamic>> feedSentrate) {
    Map<String, Map<String, List<FlSpot>>> feedData = {
      'pakanHijau': {},
      'pakanSentrat': {},
    };

    feedHijauan.sort((a, b) {
      DateTime dateA = DateTime.parse(a['tanggal']);
      DateTime dateB = DateTime.parse(b['tanggal']);
      return dateA.compareTo(dateB);
    });

    for (var feed in feedHijauan) {
      DateTime date = DateTime.parse(feed['tanggal']);
      double amount = double.tryParse(feed['pakan']?.toString() ?? '0') ?? 0;
      String monthWithYear = _getMonthWithYear(date);

      feedData['pakanHijau'] ??= {};
      feedData['pakanHijau']?[monthWithYear] ??= [];
      feedData['pakanHijau']?[monthWithYear]!
          .add(FlSpot(date.day.toDouble(), amount));
    }

    feedSentrate.sort((a, b) {
      DateTime dateA = DateTime.parse(a['tanggal']);
      DateTime dateB = DateTime.parse(b['tanggal']);
      return dateA.compareTo(dateB);
    });

    for (var feed in feedSentrate) {
      DateTime date = DateTime.parse(feed['tanggal']);
      double amount = double.tryParse(feed['pakan']?.toString() ?? '0') ?? 0;
      String monthWithYear = _getMonthWithYear(date);

      feedData['pakanSentrat'] ??= {};
      feedData['pakanSentrat']?[monthWithYear] ??= [];
      feedData['pakanSentrat']?[monthWithYear]!
          .add(FlSpot(date.day.toDouble(), amount));
    }

    return feedData;
  }

  Map<String, Map<String, List<FlSpot>>> processMilkAndWeightData(
      List<Map<String, dynamic>> milkProduction,
      List<Map<String, dynamic>> weights) {
    Map<String, Map<String, List<FlSpot>>> milkAndWeightData = {
      'produksiSusu': {},
      'beratBadan': {},
    };

    milkProduction.sort((a, b) {
      DateTime dateA = DateTime.parse(a['tanggal']);
      DateTime dateB = DateTime.parse(b['tanggal']);
      return dateA.compareTo(dateB);
    });

    for (var milk in milkProduction) {
      DateTime date = DateTime.parse(milk['tanggal']);
      double productionAmount =
          double.tryParse(milk['produksi']?.toString() ?? '0') ?? 0;
      String monthWithYear = _getMonthWithYear(date);

      milkAndWeightData['produksiSusu'] ??= {};
      milkAndWeightData['produksiSusu']?[monthWithYear] ??= [];
      milkAndWeightData['produksiSusu']?[monthWithYear]!
          .add(FlSpot(date.day.toDouble(), productionAmount));
    }

    weights.sort((a, b) {
      DateTime dateA = DateTime.parse(a['tanggal']);
      DateTime dateB = DateTime.parse(b['tanggal']);
      return dateA.compareTo(dateB);
    });

    for (var weight in weights) {
      DateTime date = DateTime.parse(weight['tanggal']);
      double weightValue =
          double.tryParse(weight['berat']?.toString() ?? '0') ?? 0;
      String monthWithYear = _getMonthWithYear(date);

      milkAndWeightData['beratBadan'] ??= {};
      milkAndWeightData['beratBadan']?[monthWithYear] ??= [];
      milkAndWeightData['beratBadan']?[monthWithYear]!
          .add(FlSpot(date.day.toDouble(), weightValue));
    }

    return milkAndWeightData;
  }

  String _getMonthWithYear(DateTime date) {
    const monthNames = [
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
    return '${monthNames[date.month - 1]} ${date.year}';
  }

  void updateChartData(Map<String, dynamic> apiResponse) {
    List<Map<String, dynamic>> recentFeedHijauan =
        List<Map<String, dynamic>>.from(apiResponse['recent_feed_hijauan']);
    List<Map<String, dynamic>> recentFeedSentrate =
        List<Map<String, dynamic>>.from(apiResponse['recent_feed_sentrate']);
    List<Map<String, dynamic>> recentMilkProduction =
        List<Map<String, dynamic>>.from(apiResponse['recent_milk_production']);
    List<Map<String, dynamic>> recentWeights =
        List<Map<String, dynamic>>.from(apiResponse['recent_weights']);

    final feedData = processFeedData(recentFeedHijauan, recentFeedSentrate);
    final milkAndWeightData =
        processMilkAndWeightData(recentMilkProduction, recentWeights);

    setState(() {
      this.feedData = feedData;
      this.milkAndWeightData = milkAndWeightData;
    });
  }

  void _showNotesHistory() async {
    final List<Map<String, dynamic>> historyData = [
      {'date': DateTime(2024, 11, 28), 'data': 'Diare'},
      {'date': DateTime(2024, 11, 29), 'data': 'Sakit Perut dan mata merah'},
      {'date': DateTime(2024, 11, 30), 'data': 'Kesepian :('},
      {'date': DateTime(2024, 12, 1), 'data': 'Sakit perut'},
    ];

    await showDialog(
      context: context,
      builder: (context) {
        return HistoryDialog(
          title: 'Riwayat Catatan',
          data: historyData,
          onEdit: (index) async {
            String initialData = historyData[index]['data'];

            String? updatedData = await showDialog<String>(
              context: context,
              builder: (context) {
                return EditDataDialog(
                  id: historyData[index]['date'].toString(),
                  initialData: initialData,
                  title: formattedDate(historyData[index]['date']),
                );
              },
            );

            if (updatedData != null && updatedData.isNotEmpty) {
              setState(() {
                historyData[index]['data'] = updatedData;
              });
            }
          },
          onDelete: (index) {
            setState(() {
              historyData.removeAt(index);
            });
          },
        );
      },
    );
  }

  void _showTreatmentHistory() async {
    final List<Map<String, dynamic>> historyData = [
      {'date': DateTime(2024, 11, 28), 'data': 'Diberi obat diare'},
      {'date': DateTime(2024, 11, 29), 'data': 'Diberi obat mata dan perut'},
      {'date': DateTime(2024, 11, 30), 'data': 'Diberi obat kesepian'},
      {'date': DateTime(2024, 12, 1), 'data': 'Diberi obat perut'},
    ];
    await showDialog(
      context: context,
      builder: (context) {
        return HistoryDialog(
          title: 'Riwayat Pengobatan',
          data: historyData,
          onEdit: (index) async {
            String initialData = historyData[index]['data'];

            String? updatedData = await showDialog<String>(
              context: context,
              builder: (context) {
                return EditDataDialog(
                  id: historyData[index]['date'].toString(),
                  initialData: initialData,
                  title: formattedDate(historyData[index]['date']),
                );
              },
            );

            if (updatedData != null && updatedData.isNotEmpty) {
              setState(() {
                historyData[index]['data'] = updatedData;
              });
            }
          },
          onDelete: (index) {
            setState(() {
              historyData.removeAt(index);
            });
          },
        );
      },
    );
  }

  String formattedDate(DateTime date) {
    return MaterialLocalizations.of(context).formatShortDate(date);
  }

  Future<http.Response> fetchData() async {
    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    try {
      final url = Uri.parse(
          '${dotenv.env['BASE_URL']}:${dotenv.env['PORT']}/api/cows/${widget.id}');
      final response = await http.get(url).timeout(const Duration(seconds: 5));
      final data = json.decode(response.body);

      final urlString =
          '${dotenv.env['BASE_URL']}:${dotenv.env['PORT']}/api/cows/predict-milk/${widget.id}';
      final urlSusu = Uri.parse(urlString);
      final responseSusu =
          await http.get(urlSusu).timeout(const Duration(seconds: 5));
      final dataSusu = json.decode(responseSusu.body);
      final predicted_daily_milk = dataSusu['predicted_daily_milk'];

      // Simpan nilai prediksi susu ke widget.predictionSusu
      setState(() {
        widget.predictionSusu = predicted_daily_milk;
        widget.beratSaatIni =
            double.parse(data['recent_weights'][0]['berat'].toStringAsFixed(2));

        widget.susuSaatIni = double.parse(
            data['recent_milk_production'][0]['produksi'].toStringAsFixed(2));
        widget.pakanHijauSaatIni = double.parse(
            data['recent_feed_hijauan'][0]['pakan'].toStringAsFixed(2));
        widget.pakanSentratSaatIni = double.parse(
            data['recent_feed_sentrate'][0]['pakan'].toStringAsFixed(2));
        widget.beratSaatIni = data['recent_weights'][0]['berat'].toDouble();
        // widget.susuSaatIni = data['recent_milk_production'][0]['produksi'].toDouble();
        // widget.pakanHijauSaatIni = data['recent_feed_hijauan'][0]['pakan'].toDouble();
        // widget.pakanSentratSaatIni = data['recent_feed_sentrate'][0]['pakan'].toDouble();
      });

      // Proses data produksi susu dan berat badan untuk dikirimkan ke UI
      List<Map<String, dynamic>> milkProduction =
          (data['recent_milk_production'] as List).map((item) {
        return {
          'date': DateTime.parse(item['tanggal']),
          'data': '${item['produksi']} L',
        };
      }).toList();

      List<Map<String, dynamic>> weightHistory =
          (data['recent_weights'] as List).map((item) {
        return {
          'date': DateTime.parse(item['tanggal']),
          'data': '${item['berat']} Kg',
        };
      }).toList();

      List<Map<String, dynamic>> pakanHijauData = [];
      if (data['recent_feed_hijauan'] != null) {
        pakanHijauData = (data['recent_feed_hijauan'] as List).map((item) {
          return {
            'date': DateTime.parse(item['tanggal']),
            'data': '${item['pakan']} kg',
          };
        }).toList();
      }

      List<Map<String, dynamic>> pakanSentratData = [];
      if (data['recent_feed_sentrate'] != null) {
        pakanSentratData = (data['recent_feed_sentrate'] as List).map((item) {
          return {
            'date': DateTime.parse(item['tanggal']),
            'data': '${item['pakan']} kg',
          };
        }).toList();
      }

      // Proses data ke dalam struktur yang dibutuhkan untuk grafik
      setState(() {
        milkAndWeightDataDinamis =
            processMilkAndWeightData2(milkProduction, weightHistory);
        milkProductionAndWeightHistory['produksiSusu']!.addAll(milkProduction);
        milkProductionAndWeightHistory['beratBadan']!.addAll(weightHistory);

        dinamisFeedData = processFeed(pakanHijauData, pakanSentratData);
        dinamisFeedDataHistory['pakanHijau']!.addAll(pakanHijauData);
        dinamisFeedDataHistory['pakanSentrat']!.addAll(pakanSentratData);
      });
      return response;
    } catch (e) {
      setState(() {
        errorMessage = 'Terjadi kesalahan: $e';
      });
      rethrow;
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Map<String, Map<String, List<FlSpot>>> processMilkAndWeightData2(
    List<Map<String, dynamic>> milkProduction,
    List<Map<String, dynamic>> weightHistory,
  ) {
    Map<String, Map<String, List<FlSpot>>> result = {
      'produksiSusu': {},
      'beratBadan': {},
    };

    // Proses produksi susu
    for (var item in milkProduction) {
      String monthYear = DateFormat('MMMM yyyy').format(item['date']);
      if (!result['produksiSusu']!.containsKey(monthYear)) {
        result['produksiSusu']![monthYear] = [];
      }
      int index = result['produksiSusu']![monthYear]!.length;
      result['produksiSusu']![monthYear]!.add(FlSpot(
          index.toDouble(), double.parse(item['data'].replaceAll(' L', ''))));
    }

    // Proses berat badan
    for (var item in weightHistory) {
      String monthYear = DateFormat('MMMM yyyy').format(item['date']);
      if (!result['beratBadan']!.containsKey(monthYear)) {
        result['beratBadan']![monthYear] = [];
      }
      int index = result['beratBadan']![monthYear]!.length;
      result['beratBadan']![monthYear]!.add(FlSpot(
          index.toDouble(), double.parse(item['data'].replaceAll(' Kg', ''))));
    }

    return result;
  }

  Map<String, Map<String, List<FlSpot>>> processFeed(
    List<Map<String, dynamic>> feedDataHijauan,
    List<Map<String, dynamic>> feedDataSentrat,
  ) {
    Map<String, Map<String, List<FlSpot>>> result = {
      'pakanHijau': {},
      'pakanSentrat': {},
    };

    for (var item in feedDataHijauan) {
      String monthYear = DateFormat('MMMM yyyy').format(item['date']);
      if (!result['pakanHijau']!.containsKey(monthYear)) {
        result['pakanHijau']![monthYear] = [];
      }
      int index = result['pakanHijau']![monthYear]!.length;
      result['pakanHijau']![monthYear]!.add(FlSpot(
          index.toDouble(), double.parse(item['data'].replaceAll(' kg', ''))));
    }

    // Proses pakan sentrat
    for (var item in feedDataSentrat) {
      String monthYear = DateFormat('MMMM yyyy').format(item['date']);
      if (!result['pakanSentrat']!.containsKey(monthYear)) {
        result['pakanSentrat']![monthYear] = [];
      }
      int index = result['pakanSentrat']![monthYear]!.length;
      result['pakanSentrat']![monthYear]!.add(FlSpot(
          index.toDouble(), double.parse(item['data'].replaceAll(' kg', ''))));
    }

    return result;
  }

  Future<http.Response> fetchDataAsli() async {
    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    try {
      final url = Uri.parse(
          '${dotenv.env['BASE_URL']}:${dotenv.env['PORT']}/api/cows/${widget.id}');
      final response = await http.get(url).timeout(const Duration(seconds: 5));
      final data = json.decode(response.body);

      final urlString =
          '${dotenv.env['BASE_URL']}:${dotenv.env['PORT']}/api/cows/predict-milk/${widget.id}';
      final urlSusu = Uri.parse(urlString);
      final responseSusu =
          await http.get(urlSusu).timeout(const Duration(seconds: 5));
      final dataSusu = json.decode(responseSusu.body);
      final predicted_daily_milk = dataSusu['predicted_daily_milk'];

      setState(() {
        widget.predictionSusu = predicted_daily_milk;
      });

      List<Map<String, dynamic>> milkProduction =
          (data['recent_milk_production'] as List).map((item) {
        return {
          'date': DateTime.parse(item['tanggal']),
          'data': '${item['produksi']} L',
        };
      }).toList();

      List<Map<String, dynamic>> weightHistory =
          (data['recent_weights'] as List).map((item) {
        return {
          'date': DateTime.parse(item['tanggal']),
          'data': '${item['berat']} Kg',
        };
      }).toList();

      setState(() {
        milkProductionAndWeightHistoryDynamic = {
          'produksiSusu': milkProduction,
          'beratBadan': weightHistory,
        };
      });
      setState(() {
        milkProductionAndWeightHistoryDynamic = {
          'produksiSusu': milkProduction,
          'beratBadan': weightHistory,
        };
      });

      if (response.statusCode == 200) {
        return response;
      } else {
        setState(() {
          errorMessage =
              'Gagal memuat data. Status code: ${response.statusCode}';
        });
        throw Exception(
            'Failed to fetch data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Terjadi kesalahan: $e';
      });
      rethrow;
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _refreshData() async {
    try {
      final response = await fetchData();
      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body) as Map<String, dynamic>;

        final recentWeights = List<Map<String, dynamic>>.from(
            responseBody['recent_weights'] ?? []);
        final recentMilkProduction = List<Map<String, dynamic>>.from(
            responseBody['recent_milk_production'] ?? []);
        final recentFeedHijauan = List<Map<String, dynamic>>.from(
            responseBody['recent_feed_hijauan'] ?? []);
        final recentFeedSentrate = List<Map<String, dynamic>>.from(
            responseBody['recent_feed_sentrate'] ?? []);

        setState(() {
          feedData = processFeedData(recentFeedHijauan, recentFeedSentrate);
          milkAndWeightData =
              processMilkAndWeightData(recentMilkProduction, recentWeights);
        });
      } else {
        throw Exception(
            'Failed to fetch data. Status code: ${response.statusCode}');
      }
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    final userRole = Provider.of<UserRole>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _refreshData,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      color: Colors.white,
                      child: _buildHeader(
                        id: widget.id,
                        gender: widget.gender,
                        age: widget.age,
                        healthStatus: widget.healthStatus,
                        isProductive: widget.isProductive,
                      ),
                    ),
                    const SizedBox(height: 70),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 16),
                          const Text(
                            'PRODUKSI SUSU & BERAT BADAN',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF8F3505),
                            ),
                          ),
                          const SizedBox(height: 10),
                          MultiChartContainer(
                            label: 'produksiSusu & beratBadan',
                            historyData: milkProductionAndWeightHistory,
                            chartsData: milkAndWeightDataDinamis,
                            id: widget.id,
                            predictionSusu: widget.predictionSusu,
                            onEdit: (index) async {
                              Navigator.of(context).pop();

                              String initialData =
                                  milkProductionAndWeightHistory[
                                      'produksiSusu']![index]['data'];

                              String? updatedData = await showDialog<String>(
                                context: context,
                                builder: (context) {
                                  return EditDataDialog(
                                    id: milkProductionAndWeightHistory[
                                            'produksiSusu']![index]['date']
                                        .toString(),
                                    initialData: initialData,
                                    title: formattedDate(
                                        milkProductionAndWeightHistory[
                                            'produksiSusu']![index]['date']),
                                  );
                                },
                              );

                              if (updatedData != null &&
                                  updatedData.isNotEmpty) {
                                setState(() {
                                  milkProductionAndWeightHistory[
                                          'produksiSusu']![index]['data'] =
                                      updatedData;
                                });
                              }
                            },
                            onDelete: (index) {
                              setState(() {
                                milkProductionAndWeightHistory['produksiSusu']
                                    ?.removeAt(index);
                              });
                            },
                          ),
                          const SizedBox(height: 25),
                          const Divider(
                            color: Colors.black12,
                            thickness: 1,
                          ),
                          const SizedBox(height: 25),
                          const Text(
                            'PAKAN YANG DIBERIKAN',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF8F3505),
                            ),
                          ),
                          const SizedBox(height: 10),
                          MultiChartContainer(
                            label: 'pakanHijau & pakanSentrat',
                            historyData: dinamisFeedDataHistory,
                            chartsData: dinamisFeedData,
                            id: widget.id,
                            onEdit: (index) async {
                              Navigator.of(context).pop();

                              String initialData =
                                  feedDataHistory['pakanHijau']![index]['data'];

                              String? updatedData = await showDialog<String>(
                                context: context,
                                builder: (context) {
                                  return EditDataDialog(
                                    id: feedDataHistory['pakanHijau']![index]
                                            ['date']
                                        .toString(),
                                    initialData: initialData,
                                    title: formattedDate(
                                        feedDataHistory['pakanHijau']![index]
                                            ['date']),
                                  );
                                },
                              );

                              if (updatedData != null &&
                                  updatedData.isNotEmpty) {
                                setState(() {
                                  feedDataHistory['pakanHijau']![index]
                                      ['data'] = updatedData;
                                });
                              }
                            },
                            onDelete: (index) {
                              setState(() {
                                feedDataHistory['pakanHijau']!.removeAt(index);
                              });
                            },
                          ),
                          const SizedBox(height: 25),
                          const Divider(
                            color: Colors.black12,
                            thickness: 1,
                          ),
                          const SizedBox(height: 15),
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF9E2B5),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.calendar_today,
                                  color: Color(0xFF8F3505),
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  'Hari Ini, ${formattedDate(DateTime.now())}',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF8F3505),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 15),
                          ConditionsSection(
                              healthStatus: widget.healthStatus,
                              stressLevelHistory: stressLevelHistory,
                              addEditStressLevelDateNow: () async {
                                String updatedData =
                                    stressLevelController.text.trim();

                                if (updatedData.isNotEmpty) {
                                  setState(() {
                                    stressLevelHistory.add({
                                      'date': DateTime.now(),
                                      'data': updatedData,
                                    });
                                  });
                                }
                              },
                              healthStatusHistory: healthStatusHistory,
                              addEditHealthStatusDateNow: () async {
                                String updatedData =
                                    healthStatusController.text.trim();

                                if (updatedData.isNotEmpty) {
                                  setState(() {
                                    healthStatusHistory.add({
                                      'date': DateTime.now(),
                                      'data': updatedData,
                                    });
                                  });

                                  ShowAddEditDataResultDialog.show(
                                      context, true,
                                      customMessage:
                                          'Data kesehatan berhasil ditambahkan!');
                                } else {
                                  ShowAddEditDataResultDialog.show(
                                      context, false,
                                      customMessage:
                                          'Gagal menambahkan data kesehatan!');
                                }
                              },
                              birahiHistory: birahiHistory,
                              addEditBirahiDateNow: () async {
                                String updatedData =
                                    birahiController.text.trim();

                                if (updatedData.isNotEmpty) {
                                  setState(() {
                                    birahiHistory.add({
                                      'date': DateTime.now(),
                                      'data': updatedData,
                                    });
                                  });

                                  ShowAddEditDataResultDialog.show(
                                      context, true,
                                      customMessage:
                                          'Data birahi berhasil ditambahkan!');
                                } else {
                                  ShowAddEditDataResultDialog.show(
                                      context, false,
                                      customMessage:
                                          'Gagal menambahkan data birahi!');
                                }
                              },
                              editHealthStatus: (index) async {
                                String updatedData =
                                    healthStatusController.text.trim();

                                if (updatedData.isNotEmpty) {
                                  setState(() {
                                    healthStatusHistory[index]['data'] =
                                        updatedData;
                                  });

                                  ShowResultDialog.show(context, true,
                                      customMessage:
                                          'Data kesehatan berhasil diperbarui!');
                                } else {
                                  ShowResultDialog.show(context, false,
                                      customMessage:
                                          'Gagal memperbarui data kesehatan!');
                                }

                                Future.delayed(const Duration(seconds: 2), () {
                                  Navigator.of(context).pop();
                                });
                              },
                              editStressLevel: (index) async {
                                String updatedData =
                                    stressLevelController.text.trim();

                                if (updatedData.isNotEmpty) {
                                  setState(() {
                                    stressLevelHistory[index]['data'] =
                                        updatedData;
                                  });

                                  ShowResultDialog.show(context, true,
                                      customMessage:
                                          'Tingkat stres berhasil diperbarui!');
                                } else {
                                  ShowResultDialog.show(context, false,
                                      customMessage:
                                          'Gagal memperbarui tingkat stres!');
                                }

                                Future.delayed(const Duration(seconds: 2), () {
                                  Navigator.of(context).pop();
                                });
                              },
                              editBirahi: (index) async {
                                String updatedData =
                                    birahiController.text.trim();

                                if (updatedData.isNotEmpty) {
                                  setState(() {
                                    birahiHistory[index]['data'] = updatedData;
                                  });

                                  ShowResultDialog.show(context, true,
                                      customMessage:
                                          'Data birahi berhasil diperbarui!');
                                } else {
                                  ShowResultDialog.show(context, false,
                                      customMessage:
                                          'Gagal memperbarui data birahi!');
                                }

                                Future.delayed(const Duration(seconds: 2), () {
                                  Navigator.of(context).pop();
                                });
                              },
                              deleteStressLevel: (index) {
                                setState(() {
                                  stressLevelHistory.removeAt(index);
                                });

                                Navigator.of(context).pop();

                                ShowResultDialog.show(context, true,
                                    customMessage:
                                        'Tingkat stres berhasil dihapus!');
                              },
                              deleteHealthStatus: (index) {
                                setState(() {
                                  healthStatusHistory.removeAt(index);
                                });

                                Navigator.of(context).pop();

                                ShowResultDialog.show(context, true,
                                    customMessage:
                                        'Data kesehatan berhasil dihapus!');
                              },
                              deleteBirahi: (index) {
                                setState(() {
                                  birahiHistory.removeAt(index);
                                });

                                Navigator.of(context).pop();

                                ShowResultDialog.show(context, true,
                                    customMessage:
                                        'Data birahi berhasil dihapus!');
                              }),
                          const SizedBox(height: 20),
                          if (widget.healthStatus.toUpperCase() == 'SAKIT') ...[
                            const Text(
                              'CATATAN :',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.brown,
                              ),
                            ),
                            const SizedBox(height: 10),
                            TextField(
                              readOnly: userRole.role == 'doctor' ||
                                  userRole.role == 'admin',
                              maxLines: 4,
                              decoration: InputDecoration(
                                labelStyle: const TextStyle(
                                  color: Color(0xFF8F3505),
                                ),
                                hintStyle: TextStyle(
                                  color:
                                      const Color(0xFF8F3505).withOpacity(0.5),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(
                                      color: Color(0xFF8F3505)),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(
                                      color: Color(0xFF8F3505)),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(
                                      color: Color(0xFF8F3505)),
                                ),
                                hintText: userRole.role == 'doctor' ||
                                        userRole.role == 'admin'
                                    ? 'Catatan hanya bisa diisi oleh peternak!'
                                    : 'Masukkan catatan...',
                              ),
                            ),
                            const SizedBox(height: 10),
                            ElevatedButton(
                              onPressed: () {
                                _showNotesHistory();
                              },
                              style: ElevatedButton.styleFrom(
                                elevation: 0,
                                backgroundColor:
                                    const Color(0xFF8F3505).withOpacity(0.1),
                                minimumSize: const Size(double.infinity, 50),
                                side:
                                    const BorderSide(color: Color(0xFF8F3505)),
                                padding: const EdgeInsets.symmetric(
                                    vertical: 15, horizontal: 20),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
                              child: const Text(
                                'RIWAYAT CATATAN',
                                style: TextStyle(
                                  color: Color(0xFF8F3505),
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            const Text(
                              'DIAGNOSIS DAN PENGOBATAN :',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.brown,
                              ),
                            ),
                            const SizedBox(height: 10),
                            TextField(
                              readOnly: userRole.role == 'admin' ||
                                  userRole.role == 'user',
                              maxLines: 4,
                              decoration: InputDecoration(
                                labelStyle: const TextStyle(
                                  color: Color(0xFF8F3505),
                                ),
                                hintStyle: TextStyle(
                                  color:
                                      const Color(0xFF8F3505).withOpacity(0.5),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(
                                      color: Color(0xFF8F3505)),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(
                                      color: Color(0xFF8F3505)),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(
                                      color: Color(0xFF8F3505)),
                                ),
                                hintText: userRole.role == 'admin' ||
                                        userRole.role == 'user'
                                    ? 'Diagnosis dan pengobatan hanya bisa diisi oleh dokter!'
                                    : 'Masukkan diagnosis dan pengobatan...',
                              ),
                            ),
                            const SizedBox(height: 10),
                            ElevatedButton(
                              onPressed: () {
                                _showTreatmentHistory();
                              },
                              style: ElevatedButton.styleFrom(
                                elevation: 0,
                                backgroundColor:
                                    const Color(0xFF8F3505).withOpacity(0.1),
                                minimumSize: const Size(double.infinity, 50),
                                side:
                                    const BorderSide(color: Color(0xFF8F3505)),
                                padding: const EdgeInsets.symmetric(
                                    vertical: 15, horizontal: 20),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
                              child: const Text(
                                'RIWAYAT PENGOBATAN',
                                style: TextStyle(
                                  color: Color(0xFF8F3505),
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                          if (widget.healthStatus.toUpperCase() == 'SEHAT')
                            Container(
                                padding: const EdgeInsets.all(10.0),
                                decoration: BoxDecoration(
                                  color:
                                      const Color(0xFF4caf4f).withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: Colors.green,
                                  ),
                                ),
                                child: const Text(
                                  'Catatan: Karena sapi dalam kondisi sehat, maka kolom catatan dan diagnosis disembunyikan!',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Color(0xFF2d8a30),
                                    fontSize: 15,
                                  ),
                                )),
                          const SizedBox(height: 30),
                          if (userRole.role != 'doctor') ...[
                            if (userRole.role == 'user' &&
                                widget.isConnectedToNFCTag)
                              Container(
                                child: OutlinedButton(
                                  onPressed: () {
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (context) {
                                      return AddEditNFCTag(
                                          id: widget.id,
                                          isConnectedToNFCTag:
                                              widget.isConnectedToNFCTag);
                                    }));
                                  },
                                  style: OutlinedButton.styleFrom(
                                    side: const BorderSide(
                                        color: Color(0xFF8F3505)),
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 15, horizontal: 20),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                  ),
                                  child: const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Edit NFC Tag',
                                        style: TextStyle(
                                          color: Color(0xFF8F3505),
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(width: 5),
                                      Icon(
                                        Icons.edit,
                                        color: Color(0xFF8F3505),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            if (!widget.isConnectedToNFCTag)
                              Container(
                                child: OutlinedButton(
                                  onPressed: () {
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (context) {
                                      return AddEditNFCTag(
                                          id: widget.id,
                                          isConnectedToNFCTag:
                                              widget.isConnectedToNFCTag);
                                    }));
                                  },
                                  style: OutlinedButton.styleFrom(
                                    side: const BorderSide(color: Colors.green),
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 15, horizontal: 20),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                  ),
                                  child: const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Sambung NFC Tag',
                                        style: TextStyle(
                                          color: Colors.green,
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(width: 5),
                                      Icon(
                                        Icons.add,
                                        color: Colors.green,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                Flexible(
                                  flex: 1,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      ShowResultDialog.show(context, true,
                                          customMessage:
                                              'Data berhasil disimpan!');
                                    },
                                    style: ElevatedButton.styleFrom(
                                      elevation: 0,
                                      backgroundColor: const Color(0xFF8F3505),
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 15, horizontal: 20),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(14),
                                      ),
                                    ),
                                    child: const Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Simpan/OK',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(width: 5),
                                        Icon(
                                          Icons.save,
                                          color: Colors.white,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Flexible(
                                  flex: 1,
                                  child: ElevatedButton(
                                    onPressed: () {},
                                    style: ElevatedButton.styleFrom(
                                      elevation: 0,
                                      backgroundColor: Colors.red,
                                      minimumSize:
                                          const Size(double.infinity, 50),
                                      side: const BorderSide(
                                          color: Color(0xFFFF3939)),
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 15, horizontal: 20),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(14),
                                      ),
                                    ),
                                    child: const Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Keluarkan Sapi',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(width: 5),
                                        Icon(
                                          Icons.exit_to_app,
                                          color: Colors.white,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                          ],
                          if (userRole.role == 'doctor')
                            ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                elevation: 0,
                                backgroundColor:
                                    const Color(0xFF4caf4f).withOpacity(0.2),
                                minimumSize: const Size(double.infinity, 50),
                                side: const BorderSide(color: Colors.green),
                                padding: const EdgeInsets.symmetric(
                                    vertical: 15, horizontal: 20),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
                              child: const Text(
                                'SELESAI DIAGNOSIS',
                                style: TextStyle(
                                  color: Color(0xFF2d8a30),
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          const SizedBox(height: 10),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}

class _NewDataDialog extends StatelessWidget {
  final String id;

  const _NewDataDialog({required this.id});

  @override
  Widget build(BuildContext context) {
    TextEditingController controller = TextEditingController();

    return AlertDialog(
      title: const Text("SILAHKAN INPUT DATA BARU :"),
      content: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text("BATAL"),
        ),
        TextButton(
          onPressed: () {
            String data = controller.text;
            Navigator.of(context).pop(data);
          },
          child: const Text("OK"),
        ),
      ],
    );
  }
}

class _HistoryDialog extends StatelessWidget {
  final List<String> data;
  final Function(int) onDelete;

  const _HistoryDialog({required this.data, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("RIWAYAT PAKAN"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: data.asMap().entries.map((entry) {
          int index = entry.key;
          String value = entry.value;
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(value),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.orange),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.orange),
                    onPressed: () => onDelete(index),
                  ),
                ],
              ),
            ],
          );
        }).toList(),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text("BATAL"),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text("OK"),
        ),
      ],
    );
  }
}
