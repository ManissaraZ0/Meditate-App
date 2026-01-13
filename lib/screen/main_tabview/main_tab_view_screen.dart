import 'package:flutter/material.dart';
import 'package:meditate/common_widget/tab_button.dart';
import 'package:meditate/screen/chart/chart_screen.dart';
import 'package:meditate/screen/home/home_screen.dart';
import 'package:meditate/screen/favorite/favorite_screen.dart';
import 'package:meditate/screen/remainder/reminders_screen.dart';

class MainTabViewScreen extends StatefulWidget {
  const MainTabViewScreen({super.key});

  @override
  State<MainTabViewScreen> createState() => _MainTabViewScreenState();
}

class _MainTabViewScreenState extends State<MainTabViewScreen>
    with SingleTickerProviderStateMixin {
  TabController? controller;
  int selectTab = 0;

  @override
  void initState() {
    super.initState();
    controller = TabController(length: 4, vsync: this);
    controller?.addListener(() {
      selectTab = controller?.index ?? 0;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TabBarView(controller: controller, children: [
        const HomeScreen(),
        const RemindersScreen(),
        const ChartScreen(),
        const FavoriteScreen(),
      ]),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.only(top: 15, bottom: 8),
        decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: const [
              BoxShadow(
                  color: Colors.black12, blurRadius: 4, offset: Offset(0, -4))
            ]),
        child: SafeArea(
            child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            TabButton(
                icon: "assets/images/home_tab.png",
                title: "หน้าหลัก",
                isSelect: selectTab == 0,
                onPressed: () {
                  changeTab(0);
                }),
            TabButton(
                icon: "assets/images/meditate_tab.png",
                title: "ทำสมาธิ",
                isSelect: selectTab == 1,
                onPressed: () {
                  changeTab(1);
                }),
            TabButton(
                icon: "assets/images/chart_tab.png",
                title: "สถิติ",
                isSelect: selectTab == 2,
                onPressed: () {
                  changeTab(2);
                }),
            TabButton(
                icon: "assets/images/favorite_tab.png",
                title: "รายการโปรด",
                isSelect: selectTab == 3,
                onPressed: () {
                  changeTab(3);
                }),
          ],
        )),
      ),
    );
  }

  void changeTab(int index) {
    selectTab = index;
    controller?.animateTo(index);
    setState(() {});
  }
}
