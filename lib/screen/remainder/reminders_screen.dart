import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:meditate/common/color_extension.dart';
import 'package:meditate/common_widget/round_button.dart';
import 'meditation_session_screen.dart';

class RemindersScreen extends StatefulWidget {
  const RemindersScreen({super.key});

  @override
  State<RemindersScreen> createState() => _RemindersScreenState();
}

class _RemindersScreenState extends State<RemindersScreen> {
  Duration selectedDuration = const Duration(minutes: 10);
  String selectedAmbientSound = 'สายฝน';
  String selectedEndingSound = 'ระฆัง';
  bool intervalEnabled = false;
  int intervalMinutes = 5;

  List<String> ambientSoundOptions = ['สายฝน', 'ป่าไม้', 'คลื่น'];
  List<String> endingSoundOptions = ['ระฆัง', 'ฆ้อง', 'กระดิ่งลม'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Text(
                "ตั้งเวลาทำสมาธิ",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: TColor.primaryText,
                ),
              ),

              const SizedBox(height: 30),

              // Duration Picker
              Text("ระยะเวลา", style: TextStyle(color: TColor.primaryText)),
              const SizedBox(height: 10),
              Container(
                height: 150,
                decoration: BoxDecoration(
                  color: const Color(0xffF5F5F9),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: CupertinoTimerPicker(
                  mode: CupertinoTimerPickerMode.hm,
                  initialTimerDuration: selectedDuration,
                  onTimerDurationChanged: (Duration newDuration) {
                    setState(() {
                      selectedDuration = newDuration;
                    });
                  },
                ),
              ),

              const SizedBox(height: 30),

              // Interval Bell
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "เปิดเสียงระฆังเตือนเป็นช่วง ๆ",
                    style: TextStyle(
                      color: TColor.primaryText,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  Switch(
                    value: intervalEnabled,
                    onChanged: (val) {
                      setState(() {
                        intervalEnabled = val;
                      });
                    },
                  ),
                ],
              ),
              if (intervalEnabled) ...[
                const SizedBox(height: 10),
                const Text("แจ้งเตือนทุก ๆ ... นาที :"),
                DropdownButton<int>(
                  value: intervalMinutes,
                  isExpanded: true,
                  items:
                      [5, 10, 15, 20, 30, 60]
                          .map(
                            (e) => DropdownMenuItem(
                              value: e,
                              child: Text('$e นาที'),
                            ),
                          )
                          .toList(),
                  onChanged: (val) {
                    if (val != null) {
                      setState(() {
                        intervalMinutes = val;
                      });
                    }
                  },
                ),
              ],

              const SizedBox(height: 20),

              // Ambient Sound
              Text(
                "เสียงบรรยากาศ",
                style: TextStyle(color: TColor.primaryText),
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.shade300),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12.withAlpha((0.05 * 255).round()),
                      blurRadius: 10,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: selectedAmbientSound,
                    isExpanded: true,
                    icon: const Icon(
                      Icons.expand_more,
                      color: Color(0xffd8b76c),
                      size: 28,
                    ),
                    style: TextStyle(
                      color: TColor.primaryText,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                    items:
                        ambientSoundOptions.map((e) {
                          IconData iconData;
                          switch (e) {
                            case 'สายฝน':
                              iconData = Icons.cloud;
                              break;
                            case 'ป่าไม้':
                              iconData = Icons.park;
                              break;
                            case 'คลื่น':
                              iconData = Icons.waves;
                              break;
                            default:
                              iconData = Icons.music_note;
                          }

                          return DropdownMenuItem<String>(
                            value: e,
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: const BoxDecoration(
                                    color: Color(0xfff5f3ef),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    iconData,
                                    color: Color(0xffd8b76c),
                                    size: 20,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  e,
                                  style: GoogleFonts.prompt(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: TColor.primaryText,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                    onChanged: (val) {
                      setState(() {
                        selectedAmbientSound = val!;
                      });
                    },
                  ),
                ),
              ),

              const SizedBox(height: 20),

              Text("เสียงส่งท้าย", style: TextStyle(color: TColor.primaryText)),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.shade300),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12.withAlpha((0.05 * 255).round()),
                      blurRadius: 10,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: selectedEndingSound,
                    isExpanded: true,
                    icon: const Icon(
                      Icons.expand_more,
                      color: Color(0xffd8b76c),
                      size: 28,
                    ),
                    style: GoogleFonts.prompt(
                      color: TColor.primaryText,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                    items:
                        endingSoundOptions.map((e) {
                          IconData iconData;
                          switch (e) {
                            case 'ระฆัง':
                              iconData = Icons.notifications;
                              break;
                            case 'ฆ้อง':
                              iconData = Icons.circle;
                              break;
                            case 'กระดิ่งลม':
                              iconData = Icons.wind_power;
                              break;
                            default:
                              iconData = Icons.music_note;
                          }

                          return DropdownMenuItem<String>(
                            value: e,
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: const BoxDecoration(
                                    color: Color(0xfff5f3ef),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    iconData,
                                    color: Color(0xffd8b76c),
                                    size: 20,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  e,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: TColor.primaryText,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                    onChanged: (val) {
                      setState(() {
                        selectedEndingSound = val!;
                      });
                    },
                  ),
                ),
              ),

              const SizedBox(height: 30),
              RoundButton(
                title: "เริ่มทำสมาธิ",
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => MeditationSessionScreen(
                            duration: selectedDuration,
                            ambientSound: selectedAmbientSound,
                            endingSound: selectedEndingSound,
                            intervalEnabled: intervalEnabled,
                            intervalMinutes: intervalMinutes,
                          ),
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
