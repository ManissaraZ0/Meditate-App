// import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:meditate/common/color_extension.dart';
import 'package:meditate/screen/home/course_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/images/logo_black.png", //logo ข้างบน (samma sati)
                    width: context.width * 0.5,
                  ),
                ],
              ),
              const SizedBox(height: 35),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      greetingMessage(),
                      style: TextStyle(
                        color: TColor.primaryText,
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "ใช้เวลาสักครู่ในการหายใจลึก ๆ และตั้งจิตให้นิ่ง",
                      style: TextStyle(
                        color: TColor.secondaryText,
                        fontSize: 17,
                      ),
                    ),
                    const SizedBox(height: 25),
                    Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              context.push(
                                const CourseDetailScreen(
                                  prayerName: "มงคลจักรวาล 8 ทิศ",
                                ),
                              );
                            },
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Color(0xff67250c),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Image.asset(
                                          "assets/images/h22.png", //รูปใน Basics course
                                          width: 80,
                                          height: 80,
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 15,
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const SizedBox(height: 5),
                                          Text(
                                            "มงคลจักรวาล 8 ทิศ",
                                            style: TextStyle(
                                              color: TColor.tertiary,
                                              fontSize: 15,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                          const SizedBox(height: 20),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              InkWell(
                                                onTap: () {},
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    color: TColor.tertiary,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          20,
                                                        ),
                                                  ),
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                        vertical: 8,
                                                        horizontal: 15,
                                                      ),
                                                  child: Text(
                                                    "เริ่มต้น",
                                                    style: TextStyle(
                                                      color: TColor.primaryText,
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 15),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              context.push(
                                CourseDetailScreen(
                                  prayerName: "บทสัพพมงคลคาถา",
                                ),
                              );
                            },
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Color(0xff9ffff0),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Image.asset(
                                          "assets/images/h11.png", //รูปใน relaxation course
                                          width: 80,
                                          height: 80,
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 15,
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const SizedBox(height: 5),
                                          Text(
                                            "บทสัพพมงคลคาถา",
                                            style: TextStyle(
                                              color: TColor.primaryText,
                                              fontSize: 15,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                          const SizedBox(height: 20),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              InkWell(
                                                onTap: () {},
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    color: TColor.primaryText,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          20,
                                                        ),
                                                  ),
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                        vertical: 8,
                                                        horizontal: 15,
                                                      ),
                                                  child: Text(
                                                    "เริ่มต้น",
                                                    style: TextStyle(
                                                      color: TColor.tertiary,
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 15),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Container(
                      width: double.maxFinite,
                      decoration: BoxDecoration(
                        color: const Color(0xff333242),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Image.asset(
                            "assets/images/d1.png", //รูปพื้นหลังกรอบ daily thought
                            width: double.maxFinite,
                            fit: BoxFit.fitWidth,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 15,
                              vertical: 15,
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: InkWell(
                                    onTap: () {
                                      context.push(
                                        CourseDetailScreen(
                                          prayerName: "บทชัยมงคลคาถา (พาหุง)",
                                        ),
                                      );
                                    },
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "บทชัยมงคลคาถา (พาหุง)",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 18,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                      ],
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: () {},
                                  child: Image.asset(
                                    "assets/images/play.png", //รูปปุ่มเล่น
                                    width: 40,
                                    height: 40,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 35),
                    Text(
                      "บทสวดมนต์ทั้งหมด",
                      style: TextStyle(
                        color: TColor.primaryText,
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: context.width * 0.35 * 0.7 + 45 + 40,
                child: StreamBuilder(
                  stream:
                      FirebaseFirestore.instance
                          .collection("PrayerCollection")
                          .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return const Center(
                        child: Text('พบข้อผิดพลาดในการดึงข้อมูลบทสวดมนต์'),
                      );
                    } else if (!snapshot.hasData ||
                        snapshot.data!.docs.isEmpty) {
                      return const Center(
                        child: Text(
                          'ไม่พบข้อมูลบทสวด',
                          style: TextStyle(color: Colors.white),
                        ),
                      );
                    }

                    final prayerDocs = snapshot.data!.docs;

                    return ListView.separated(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 20,
                      ),
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        var prayer = prayerDocs[index].data();
                        return SizedBox(
                          width: context.width * 0.35,
                          child: InkWell(
                            onTap: () {
                              context.push(
                                CourseDetailScreen(
                                  prayerName: "${prayer["name"]}",
                                ),
                              );
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Image.asset(
                                  "assets/images/${prayer["name"]}.png",
                                  width: context.width * 0.35,
                                  height: context.width * 0.35 * 0.7,
                                  fit: BoxFit.cover,
                                ),
                                const SizedBox(height: 8),
                                Flexible(
                                  child: Text(
                                    prayer["name"] ?? "",
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: TColor.primaryText,
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 4),
                              ],
                            ),
                          ),
                        );
                      },
                      separatorBuilder:
                          (context, index) => const SizedBox(width: 20),
                      itemCount: prayerDocs.length,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String greetingMessage() {
    final now = DateTime.now();
    final hour = now.hour;

    if (hour >= 6 && hour < 12) {
      return "อรุณสวัสดิ์ยามเช้า ☀️";
    } else if (hour >= 12 && hour < 18) {
      return "สวัสดียามบ่าย 🌤️";
    } else if (hour >= 18 && hour < 22) {
      return "สวัสดียามเย็น ⛅";
    } else {
      return "สวัสดียามค่ำ 🌙";
    }
  }
}
