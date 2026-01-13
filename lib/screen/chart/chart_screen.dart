import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:meditate/common/color_extension.dart';

class ChartScreen extends StatefulWidget {
  const ChartScreen({super.key});

  @override
  State<ChartScreen> createState() => _ChartScreenState();
}

class _ChartScreenState extends State<ChartScreen> {
  Map<String, int> meditationData = {};
  int weeklyTotal = 0;

  DateTime selectedWeekStart = _startOfWeek(DateTime.now());

  static DateTime _startOfWeek(DateTime date) {
    date = DateTime(date.year, date.month, date.day);
    return date.subtract(Duration(days: date.weekday - 1));
  }

  @override
  void initState() {
    super.initState();
    fetchMeditationData();
  }

  Future<void> fetchMeditationData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    DateTime weekStart = DateTime(
      selectedWeekStart.year,
      selectedWeekStart.month,
      selectedWeekStart.day,
    );
    DateTime weekEnd = selectedWeekStart.add(Duration(days: 6));
    weekEnd = DateTime(
      weekEnd.year,
      weekEnd.month,
      weekEnd.day,
      23,
      59,
      59,
      999,
    );
    debugPrint('weekStart : $weekStart, weekEnd: $weekEnd');
    final querySnapshot =
        await FirebaseFirestore.instance
            .collection('meditation_sessions')
            .where('email', isEqualTo: user.email)
            .where(
              'date',
              isGreaterThanOrEqualTo: Timestamp.fromDate(weekStart),
            )
            .where('date', isLessThan: Timestamp.fromDate(weekEnd))
            .orderBy('date')
            .get();

    Map<String, int> tempData = {};
    int totalMinutes = 0;

    for (var doc in querySnapshot.docs) {
      DateTime date = (doc['date'] as Timestamp).toDate();
      String dateKey = DateFormat('yyyy-MM-dd').format(date);
      int minutes = doc['duration'] ?? 0;

      tempData[dateKey] = (tempData[dateKey] ?? 0) + minutes;
      totalMinutes += minutes;
    }

    if (mounted) {
      setState(() {
        meditationData = tempData;
        weeklyTotal = totalMinutes;
      });
    }

    debugPrint(meditationData.toString());
  }

  @override
  Widget build(BuildContext context) {
    List<DateTime> weekDates = List.generate(
      7,
      (index) => selectedWeekStart.add(Duration(days: index)),
    );
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        flexibleSpace: Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 12.0),
            child: Image.asset(
              "assets/images/logo_black.png",
              width: context.width * 0.5,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 35),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child:
                    user == null
                        ? Center(child: Text('กรุณาเข้าสู่ระบบ'))
                        : StreamBuilder<QuerySnapshot>(
                          stream:
                              FirebaseFirestore.instance
                                  .collection('meditation_sessions')
                                  .where('email', isEqualTo: user.email)
                                  .where(
                                    'date',
                                    isGreaterThanOrEqualTo: Timestamp.fromDate(
                                      DateTime(
                                        selectedWeekStart.year,
                                        selectedWeekStart.month,
                                        selectedWeekStart.day,
                                      ),
                                    ),
                                  )
                                  .where(
                                    'date',
                                    isLessThan: Timestamp.fromDate(
                                      DateTime(
                                        selectedWeekStart
                                            .add(Duration(days: 6))
                                            .year,
                                        selectedWeekStart
                                            .add(Duration(days: 6))
                                            .month,
                                        selectedWeekStart
                                            .add(Duration(days: 6))
                                            .day,
                                        23,
                                        59,
                                        59,
                                        999,
                                      ),
                                    ),
                                  )
                                  .orderBy('date')
                                  .snapshots(),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return Center(child: CircularProgressIndicator());
                            }

                            Map<String, int> meditationData = {};
                            int weeklyTotal = 0;

                            for (var doc in snapshot.data!.docs) {
                              DateTime date =
                                  (doc['date'] as Timestamp).toDate();
                              String day = DateFormat(
                                'yyyy-MM-dd',
                              ).format(date);
                              int minutes = doc['duration'] ?? 0;

                              meditationData[day] =
                                  (meditationData[day] ?? 0) + minutes;
                              weeklyTotal += minutes;
                            }

                            return Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  'กราฟการนั่งสมาธิรายวัน',
                                  style: TextStyle(
                                    color: TColor.primaryText,
                                    fontSize: 22,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(height: 30),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    IconButton(
                                      icon: Icon(Icons.arrow_back),
                                      onPressed: () {
                                        setState(() {
                                          selectedWeekStart = selectedWeekStart
                                              .subtract(Duration(days: 7));
                                        });
                                        fetchMeditationData();
                                      },
                                    ),
                                    Text(
                                      '${DateFormat('dd MMM').format(selectedWeekStart)} - ${DateFormat('dd MMM').format(selectedWeekStart.add(Duration(days: 6)))}',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.arrow_forward),
                                      onPressed: () {
                                        final nextWeek = selectedWeekStart.add(
                                          Duration(days: 7),
                                        );
                                        if (nextWeek.isBefore(
                                          DateTime.now().add(Duration(days: 1)),
                                        )) {
                                          setState(() {
                                            selectedWeekStart = nextWeek;
                                          });
                                          fetchMeditationData();
                                        }
                                      },
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 300,
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: SizedBox(
                                      width: 380,
                                      child: BarChart(
                                        BarChartData(
                                          barGroups:
                                              weekDates.map((date) {
                                                String dateKey = DateFormat(
                                                  'yyyy-MM-dd',
                                                ).format(date);
                                                int value =
                                                    meditationData[dateKey] ??
                                                    0;
                                                return BarChartGroupData(
                                                  x: weekDates.indexOf(date),
                                                  barRods: [
                                                    BarChartRodData(
                                                      toY: value.toDouble(),
                                                      width: 22,
                                                      color: TColor.primary,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            4,
                                                          ),
                                                    ),
                                                  ],
                                                );
                                              }).toList(),
                                          titlesData: FlTitlesData(
                                            bottomTitles: AxisTitles(
                                              sideTitles: SideTitles(
                                                showTitles: true,
                                                reservedSize: 32,
                                                getTitlesWidget: (value, meta) {
                                                  DateTime date =
                                                      selectedWeekStart.add(
                                                        Duration(
                                                          days: value.toInt(),
                                                        ),
                                                      );
                                                  return Column(
                                                    children: [
                                                      Text(
                                                        DateFormat(
                                                          'EEE',
                                                        ).format(date),
                                                      ),
                                                      Text(
                                                        DateFormat(
                                                          'dd/MM',
                                                        ).format(date),
                                                        style: TextStyle(
                                                          fontSize: 5.5,
                                                        ),
                                                      ),
                                                    ],
                                                  );
                                                },
                                              ),
                                            ),
                                            leftTitles: AxisTitles(
                                              sideTitles: SideTitles(
                                                showTitles: true,
                                                reservedSize: 28,
                                              ),
                                            ),
                                            topTitles: AxisTitles(
                                              sideTitles: SideTitles(
                                                showTitles: true,
                                                reservedSize: 32,
                                              ),
                                            ),
                                          ),
                                          borderData: FlBorderData(show: false),
                                          gridData: FlGridData(show: false),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 30),
                                Text(
                                  'เฉลี่ยสัปดาห์นี้: ${meditationData.isNotEmpty ? (weeklyTotal / meditationData.length).toStringAsFixed(1) : '0'} นาที/วัน',
                                  style: TextStyle(
                                    color: TColor.primaryText,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(height: 16),
                              ],
                            );
                          },
                        ),
              ),
              StreamBuilder<QuerySnapshot>(
                stream:
                    FirebaseFirestore.instance
                        .collection('meditation_sessions')
                        .where('email', isEqualTo: user!.email)
                        .where(
                          'date',
                          isGreaterThanOrEqualTo: Timestamp.fromDate(
                            DateTime(
                              DateTime.now().year,
                              DateTime.now().month,
                              DateTime.now().day,
                            ),
                          ),
                        )
                        .where(
                          'date',
                          isLessThan: Timestamp.fromDate(
                            DateTime(
                              DateTime.now().year,
                              DateTime.now().month,
                              DateTime.now().day + 1,
                            ),
                          ),
                        )
                        .orderBy('date')
                        .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return CircularProgressIndicator();
                  }

                  int todayTotal = 0;
                  for (var doc in snapshot.data!.docs) {
                    int minutes = doc['duration'] ?? 0;
                    todayTotal += minutes;
                  }

                  double dailyProgress = (todayTotal / 30).clamp(0.0, 1.0);

                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 60),
                    child: Column(
                      children: [
                        Text(
                          'ความก้าวหน้ารายวัน',
                          style: TextStyle(
                            fontSize: 16,
                            color: TColor.primaryText,
                          ),
                        ),
                        SizedBox(height: 5),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: LinearProgressIndicator(
                            value: dailyProgress,
                            minHeight: 25,
                            backgroundColor: Colors.grey[300],
                            color: TColor.primary,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          '$todayTotal / 30 นาที',
                          style: TextStyle(
                            fontSize: 15,
                            color: TColor.primaryText,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
