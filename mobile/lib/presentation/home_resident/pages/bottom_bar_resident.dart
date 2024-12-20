import 'package:flutter/material.dart';
import 'package:isentry/core/configs/theme/app_colors.dart';
import 'package:isentry/presentation/home_resident/pages/dashboard.dart';
import 'package:isentry/presentation/home_resident/pages/log_activity.dart';
import 'package:lucide_icons/lucide_icons.dart';

class HomeResidentPage extends StatefulWidget {
  final String userId;
  const HomeResidentPage({super.key, required this.userId});

  @override
  State<HomeResidentPage> createState() => _BottomBarResidentState();
}

class _BottomBarResidentState extends State<HomeResidentPage> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final List<Widget> widgetOptions = <Widget>[
      DashboardResidentPage(userId: widget.userId),
      LogActivityPage(userId: widget.userId),
    ];

    void onItemTapped(int index) {
      setState(() {
        _selectedIndex = index;
      });
    }

    return Scaffold(
      body: widgetOptions[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: AppColors.background,
        items: [
          BottomNavigationBarItem(
            icon: const Icon(LucideIcons.layoutDashboard),
            label: _selectedIndex == 0 ? 'Dashboard' : '',
          ),
          BottomNavigationBarItem(
            icon: const Icon(LucideIcons.timerReset),
            label: _selectedIndex == 1 ? 'log' : '',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        onTap: onItemTapped,
        elevation: 0,
        selectedIconTheme: const IconThemeData(
          size: 30,
        ),
        unselectedIconTheme: const IconThemeData(
          size: 24,
        ),
        showUnselectedLabels: false,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: const TextStyle(
          fontSize: 10,
          letterSpacing: 1,
          height: 2.0,
        ),
      ),
    );
  }
}
