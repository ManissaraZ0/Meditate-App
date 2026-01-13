import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'dart:async';

class MeditationSessionScreen extends StatefulWidget {
  final Duration duration;
  final String ambientSound;
  final String endingSound;
  final bool intervalEnabled;
  final int intervalMinutes;

  const MeditationSessionScreen({
    super.key,
    required this.duration,
    required this.ambientSound,
    required this.endingSound,
    required this.intervalEnabled,
    required this.intervalMinutes,
  });

  @override
  State<MeditationSessionScreen> createState() =>
      _MeditationSessionScreenState();
}

class _MeditationSessionScreenState extends State<MeditationSessionScreen> {
  late AudioPlayer _ambientPlayer;
  late AudioPlayer _intervalPlayer;
  late AudioPlayer _endingPlayer;
  late Duration remaining;
  Timer? _timer;
  Timer? _intervalTimer;
  bool isPaused = false;

  @override
  void initState() {
    super.initState();
    _ambientPlayer = AudioPlayer();
    _intervalPlayer = AudioPlayer();
    _endingPlayer = AudioPlayer();
    remaining = widget.duration;
    _playAmbientSound();
    _startTimer();

    if (widget.intervalEnabled) {
      _startIntervalTimer();
    }
  }

  Future<void> _playAmbientSound() async {
    try {
      final fileName = widget.ambientSound.toLowerCase().replaceAll(' ', '_');
      await _ambientPlayer.setAsset('assets/audios/$fileName.mp3');
      await _ambientPlayer.setLoopMode(LoopMode.one);
      await _ambientPlayer.play();
    } catch (_) {}
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted || isPaused) return;
      setState(() {
        if (remaining.inSeconds > 0) {
          remaining -= const Duration(seconds: 1);
        } else {
          timer.cancel();
          _ambientPlayer.stop();
          _playEndingSound();
        }
      });
    });
  }

  void _startIntervalTimer() {
    _intervalTimer = Timer.periodic(Duration(minutes: widget.intervalMinutes), (
      timer,
    ) {
      if (!mounted || isPaused) return;
      _playIntervalNotificationSound();
    });
  }

  Future<void> _playIntervalNotificationSound() async {
    try {
      const intervalSound = 'เสียงแจ้งเตือน.mp3';
      await _intervalPlayer.setAsset('assets/audios/$intervalSound');
      await _intervalPlayer.setLoopMode(LoopMode.off);
      await _intervalPlayer.play();
    } catch (_) {}
  }

  Future<void> _playEndingSound() async {
    try {
      final fileName = widget.endingSound.toLowerCase().replaceAll(' ', '_');
      final path = 'assets/audios/$fileName.mp3';
      await _endingPlayer.setAsset(path);
      await _endingPlayer.setLoopMode(LoopMode.off);
      await _endingPlayer.play();
    } catch (_) {}
  }

  void _pauseOrResume() {
    setState(() {
      isPaused = !isPaused;
    });

    if (isPaused) {
      _timer?.cancel();
      _intervalTimer?.cancel();
      _ambientPlayer.pause();
    } else {
      _startTimer();
      if (widget.intervalEnabled) {
        _startIntervalTimer();
      }
      _ambientPlayer.play();
    }
  }

  void _stopSession() async {
    _timer?.cancel();
    _intervalTimer?.cancel();
    _ambientPlayer.stop();
    _intervalPlayer.stop();
    _endingPlayer.stop();

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    debugPrint('Logged in as: ${user.email}');

    final email = user.email;
    final now = DateTime.now();
    final durationDone = widget.duration - remaining;

    final meditationSessionsMapDoc = <String, dynamic>{
      'email': email,
      'date': now,
      'duration': durationDone.inMinutes,
    };

    await FirebaseFirestore.instance
        .collection('meditation_sessions')
        .doc()
        .set(meditationSessionsMapDoc);

    if (mounted) {
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _intervalTimer?.cancel();
    _ambientPlayer.dispose();
    _intervalPlayer.dispose();
    _endingPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final secondsLeft = remaining.inSeconds;
    final totalSeconds = widget.duration.inSeconds;
    final percent = 1 - ((totalSeconds - secondsLeft) / totalSeconds);

    final hours = remaining.inHours.toString().padLeft(2, '0');
    final minutes = remaining.inMinutes
        .remainder(60)
        .toString()
        .padLeft(2, '0');
    final seconds = remaining.inSeconds
        .remainder(60)
        .toString()
        .padLeft(2, '0');

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 38, 38, 38),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 250,
                height: 250,
                child: CircularProgressIndicator(
                  value: percent,
                  strokeWidth: 20,
                  backgroundColor: Colors.grey.shade200,
                  valueColor: const AlwaysStoppedAnimation(Color(0xffd8b76c)),
                ),
              ),
              Column(
                children: [
                  Text(
                    '$hours:$minutes:$seconds',
                    style: const TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(221, 229, 219, 175),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 50),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: _stopSession,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  side: const BorderSide(color: Colors.black26),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 16,
                  ),
                ),
                child: const Text('หยุด'),
              ),
              const SizedBox(width: 20),
              ElevatedButton(
                onPressed: _pauseOrResume,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xffd8b76c),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 16,
                  ),
                ),
                child: Text(isPaused ? 'ทำต่อ' : 'พัก'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
