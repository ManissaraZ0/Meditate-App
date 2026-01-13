import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:meditate/common/color_extension.dart';
import 'package:just_audio/just_audio.dart';

class CourseDetailScreen extends StatefulWidget {
  final String prayerName;

  const CourseDetailScreen({super.key, required this.prayerName});

  @override
  State<CourseDetailScreen> createState() => _CourseDetailScreenState();
}

class _CourseDetailScreenState extends State<CourseDetailScreen> {
  final currentUserEmail = FirebaseAuth.instance.currentUser?.email ?? "";

  final AudioPlayer _player = AudioPlayer();

  bool isFaved = false;
  Map<String, dynamic>? prayerData;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final random = Random();
    final randomIndex = random.nextInt(5) + 1;
    final imagePath = "assets/images/detail_top$randomIndex.png";

    return FutureBuilder(
      future: fetchData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }

        if (prayerData == null) {
          return const Center(child: Text("ไม่พบบทสวด"));
        }

        _player.setAsset('assets/audios/${prayerData?['name']}.mp3');
        return Scaffold(
          body: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                SliverAppBar(
                  pinned: true,
                  backgroundColor: Colors.white,
                  leading: Padding(
                    padding: const EdgeInsets.only(left: 15),
                    child: InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Image.asset(
                        "assets/images/back_white.png",
                        width: 55,
                        height: 55,
                      ),
                    ),
                  ),
                  expandedHeight: context.width * 0.6,
                  actions: [
                    InkWell(
                      onTap: toggleFav,
                      child: Image.asset(
                        isFaved
                            ? "assets/images/faved_btn.png"
                            : "assets/images/fav_button.png",
                        width: 45,
                        height: 45,
                      ),
                    ),
                    const SizedBox(width: 15),
                  ],
                  flexibleSpace: FlexibleSpaceBar(
                    background: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(15),
                        bottomRight: Radius.circular(15),
                      ),
                      child: Image.asset(
                        imagePath,
                        width: context.width,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ];
            },
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.prayerName,
                    style: TextStyle(
                      color: TColor.primaryText,
                      fontSize: 25,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      StreamBuilder<PlayerState>(
                        stream: _player.playerStateStream,
                        builder: (context, snapshot) {
                          final playing = snapshot.data?.playing ?? false;
                          return Center(
                            child: IconButton(
                              iconSize: 50,
                              padding: EdgeInsets.zero,
                              alignment: Alignment.center,
                              icon: Icon(
                                playing ? Icons.pause : Icons.play_arrow,
                                size: 50,
                              ),
                              onPressed: () {
                                if (playing) {
                                  _player.pause();
                                } else {
                                  _player.play();
                                }
                              },
                            ),
                          );
                        },
                      ),
                      StreamBuilder<Duration?>(
                        stream: _player.durationStream,
                        builder: (context, snapshot) {
                          final duration = snapshot.data ?? Duration.zero;
                          return StreamBuilder<Duration>(
                            stream: _player.positionStream,
                            builder: (context, positionSnapshot) {
                              final position =
                                  positionSnapshot.data ?? Duration.zero;
                              return Column(
                                children: [
                                  Slider(
                                    min: 0,
                                    max: duration.inSeconds.toDouble(),
                                    value:
                                        position.inSeconds
                                            .clamp(0, duration.inSeconds)
                                            .toDouble(),
                                    onChanged: (value) {
                                      _player.seek(
                                        Duration(seconds: value.toInt()),
                                      );
                                    },
                                  ),
                                  Text(
                                    '${position.inMinutes}:${(position.inSeconds % 60).toString().padLeft(2, '0')} / '
                                    '${duration.inMinutes}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}',
                                    style: TextStyle(
                                      color: TColor.primaryText,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                    ),
                                    textAlign: TextAlign.start,
                                  ),
                                  const SizedBox(height: 10),
                                ],
                              );
                            },
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "บทสวด",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: TColor.primaryText,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    prayerData?['lyrics'] ?? "",
                    style: TextStyle(fontSize: 16, color: TColor.primaryText),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  Future<void> fetchData() async {
    final favDoc =
        await FirebaseFirestore.instance
            .collection("FavCollection")
            .doc(currentUserEmail)
            .get();

    final prayerDoc =
        await FirebaseFirestore.instance
            .collection("PrayerCollection")
            .doc(widget.prayerName)
            .get();

    final favList = List<String>.from(favDoc.data()?['fav'] ?? []);
    isFaved = favList.contains(widget.prayerName);
    prayerData = prayerDoc.data();
  }

  Future<void> toggleFav() async {
    final docRef = FirebaseFirestore.instance
        .collection("FavCollection")
        .doc(currentUserEmail);

    final doc = await docRef.get();
    List<String> favList = List<String>.from(doc.data()?['fav'] ?? []);

    setState(() {
      if (isFaved) {
        favList.remove(widget.prayerName);
        isFaved = false;
      } else {
        favList.add(widget.prayerName);
        isFaved = true;
      }
    });

    await docRef.set({'fav': favList});
  }
}
