import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/material_symbols.dart';
import 'package:ternaknesia/components/custom_pop_up_dialog.dart';
import 'package:ternaknesia/screens/datasapipage.dart';
import 'package:ternaknesia/screens/nambahsapi.dart';

class Cattle {
  final String id;
  final int weight;
  final int age;
  final String gender;
  final String healthStatus;

  Cattle({
    required this.id,
    required this.weight,
    required this.age,
    required this.gender,
    required this.healthStatus,
  });

  factory Cattle.fromJson(Map<String, dynamic> json) {
    String healthStatus =
        (json['health_record'] != null && json['health_record'] == true)
            ? 'Sehat'
            : 'Tidak Sehat';

    return Cattle(
      id: json['cow_id']?.toString() ?? 'Unknown ID',
      weight: int.tryParse(json['weight']?.toString() ?? '0') ?? 0,
      age: int.tryParse(json['age']?.toString() ?? '0') ?? 0,
      gender: json['gender']?.toString() ?? 'Unknown',
      healthStatus: healthStatus,
    );
  }

  @override
  String toString() {
    return 'Cattle{id: $id, weight: $weight, age: $age, gender: $gender, healthStatus: $healthStatus}';
  }
}

class DataPage extends StatefulWidget {
  const DataPage({super.key});

  @override
  _DataPageState createState() => _DataPageState();
}

class _DataPageState extends State<DataPage> {
  TextEditingController searchController = TextEditingController();
  String searchQuery = '';
  Future<List<Cattle>>? cattleData;

  bool useStaticData = true;

  final List<Map<String, dynamic>> _staticCattleData = [
    {
      'id': '001',
      'weight': 100,
      'age': '2 Bulan',
      'status': 'SAKIT',
      'gender': 'Betina',
      'statusColor': Colors.red,
    },
    {
      'id': '002',
      'weight': 100,
      'age': '2 Bulan',
      'status': 'SEHAT',
      'gender': 'Jantan',
      'statusColor': Colors.green,
    },
  ];

  @override
  void initState() {
    super.initState();
    cattleData = fetchCattleData();
  }

  Future<List<Cattle>> fetchCattleData() async {
    try {
      final url =
          Uri.parse('${dotenv.env['BASE_URL']}:${dotenv.env['PORT']}/api/cows');

      final response = await http.get(url).timeout(const Duration(seconds: 5),
          onTimeout: () {
        throw Exception('Request timed out');
      });

      if (response.statusCode == 200) {
        List<dynamic> cattleJson = json.decode(response.body);

        return cattleJson.map((json) {
          return Cattle.fromJson(json);
        }).toList();
      } else {
        throw Exception(
            'Failed to load cattle data with status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error loading cattle data: $e');
    }
  }

  Future<void> _refreshData() async {
    setState(() {
      cattleData = fetchCattleData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: Column(
          children: [
            // Existing content from your original code
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  height: 70,
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
                  top: 12,
                  left: 20,
                  right: 20,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Data Sapi',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Row(
                        children: [
                          const Text(
                            'Fetch',
                            style: TextStyle(color: Colors.white),
                          ),
                          const SizedBox(width: 4),
                          Switch(
                            value: useStaticData,
                            onChanged: (value) {
                              setState(() {
                                useStaticData = value;
                              });
                            },
                            activeColor: Colors.white,
                          ),
                          const SizedBox(width: 4),
                          const Text(
                            'Data Statis',
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Expanded(
              child: useStaticData
                  ? _buildStaticDataList()
                  : FutureBuilder<List<Cattle>>(
                      future: cattleData,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (snapshot.hasError) {
                          return SingleChildScrollView(
                            physics: const AlwaysScrollableScrollPhysics(),
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Text(
                                  'Error loading data: ${snapshot.error}',
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ),
                            ),
                          );
                        } else if (!snapshot.hasData ||
                            snapshot.data!.isEmpty) {
                          return const SingleChildScrollView(
                            physics: AlwaysScrollableScrollPhysics(),
                            child: Center(
                              child: Padding(
                                padding: EdgeInsets.all(16.0),
                                child: Text(
                                  'No data found.',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),
                            ),
                          );
                        } else {
                          return _buildFetchedDataList(snapshot.data!);
                        }
                      },
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return MediaQuery(
                  data: MediaQuery.of(context).copyWith(
                    textScaler: TextScaler.noScaling,
                  ),
                  child: const TambahSapiPage(),
                );
              },
            ),
          );
        },
        elevation: 0,
        backgroundColor: const Color(0xFFC35804),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildStaticDataList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: _staticCattleData.length,
      itemBuilder: (context, index) {
        final cattle = _staticCattleData[index];
        return _buildCattleCard(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) {
                return DataSapiPage(
                  id: cattle['id'],
                  gender: cattle['gender'],
                  age: cattle['age'],
                  healthStatus: cattle['status'],
                );
              }),
            );
          },
          context,
          id: cattle['id'],
          weight: cattle['weight'],
          gender: cattle['gender'],
          age: cattle['age'],
          status: cattle['status'],
          statusColor: cattle['statusColor'],
        );
      },
    );
  }

  Widget _buildFetchedDataList(List<Cattle> cattleData) {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: cattleData.length,
      itemBuilder: (context, index) {
        final cattle = cattleData[index];
        return _buildCattleCard(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) {
                return DataSapiPage(
                  id: cattle.id,
                  gender: cattle.gender,
                  age: cattle.age.toString(),
                  healthStatus: cattle.healthStatus,
                );
              }),
            );
          },
          context,
          id: cattle.id,
          weight: cattle.weight,
          gender: cattle.gender,
          age: '${cattle.age} Bulan',
          status: cattle.healthStatus,
          statusColor: cattle.healthStatus.toLowerCase() == 'sehat'
              ? Colors.green
              : Colors.red,
        );
      },
    );
  }

  Widget _buildCattleCard(BuildContext context,
      {required String id,
      required int weight,
      required String age,
      required String status,
      required String gender,
      required Color statusColor,
      required VoidCallback onPressed}) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFF9E2B5),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: const Color(0xFFC35804),
            width: 1,
          ),
        ),
        margin: const EdgeInsets.symmetric(vertical: 8),
        child: Padding(
          padding: const EdgeInsets.all(14.0),
          child: Row(
            children: [
              const CircleAvatar(
                radius: 30,
                backgroundImage: AssetImage('assets/images/cow_alt.png'),
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
                                        title: 'ID SAPI', content: id);
                                  });
                            },
                            child: Text(
                              id,
                              style: const TextStyle(
                                fontSize: 20,
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
                            isHealthy: status.toLowerCase() == 'sehat',
                            isMale: gender.toLowerCase() == 'jantan'),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        _buildCowInfo(
                            'Berat', '$weight Kg', MaterialSymbols.weight),
                        _buildCowInfo(
                            'Umur', age, MaterialSymbols.calendar_month),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCowIndicator({required bool isHealthy, required bool isMale}) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
              isHealthy ? Colors.green.shade300 : Colors.red.shade300,
              isHealthy ? Colors.green.shade600 : Colors.red.shade600,
            ]),
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
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
              isMale ? Colors.blue.shade300 : Colors.pink.shade300,
              isMale ? Colors.blue.shade600 : Colors.pink.shade600,
            ]),
            borderRadius: BorderRadius.circular(50),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isMale ? Icons.male : Icons.female,
                color: Colors.white,
                size: 17,
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
              value,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ]),
    );
  }
}
