import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:meditate/common/color_extension.dart';
import 'package:meditate/screen/home/course_detail_screen.dart';
import 'package:meditate/screen/login/authentication_helper.dart';

import '../login/startup_screen.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  final currentUserName = FirebaseAuth.instance.currentUser?.email ?? "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TColor.primary,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(
          "รายการโปรด",
          style: TextStyle(
            color: TColor.primaryTextW,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.logout, color: TColor.primaryTextW),
            onPressed: _logout,
            tooltip: 'ออกจากระบบ',
          ),
        ],
      ),
      body: StreamBuilder(
        stream:
            FirebaseFirestore.instance
                .collection("FavCollection")
                .doc(currentUserName.toString())
                .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('พบข้อผิดพลาดในการดึงข้อมูล'));
          } else if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(
              child: Text(
                'ยังไม่มีบันทึกรายการโปรด',
                style: TextStyle(color: Colors.white),
              ),
            );
          }

          final data = snapshot.data!.data() as Map<String, dynamic>;
          final List favList = List<String>.from(data['fav'] ?? []);

          return GridView.builder(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 15,
              mainAxisSpacing: 15,
              childAspectRatio: 1.08,
            ),
            itemCount: favList.length,
            itemBuilder: (context, index) {
              var document = favList[index];

              return InkWell(
                onTap: () {
                  context.push(CourseDetailScreen(prayerName: "$document"));
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.asset(
                        "assets/images/$document.png",
                        width: double.maxFinite,
                        height: context.width * 0.3,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "$document",
                      maxLines: 1,
                      style: TextStyle(
                        color: TColor.primaryTextW,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _logout() async {
    await AuthenticationHelper().signOutUser();
    if (!mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const StartupScreen()),
      (route) => false,
    );
  }
}
