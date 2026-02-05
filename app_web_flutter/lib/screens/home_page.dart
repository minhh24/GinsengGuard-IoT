import 'package:flutter/material.dart';
import '../services/database_service.dart';
import '../models/thresholds.dart';
import 'dashboard_tab.dart';
import 'charts_tab.dart';
import 'settings_tab.dart';

class HomePage extends StatefulWidget {
  final VoidCallback onToggleTheme;

  const HomePage({Key? key, required this.onToggleTheme}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  late final List<Widget> _tabs;

  final DatabaseService databaseService = DatabaseService();
  Thresholds thresholds = Thresholds(
    tempRangeMin: 18.0,
    tempRangeMax: 35.0,
    humidityRangeMin: 40.0,
    humidityRangeMax: 80.0,
    soilMoistureRangeMin: 20.0,
    soilMoistureRangeMax: 60.0,
  );

  @override
  void initState() {
    super.initState();
    _tabs = [
      DashboardTab(
        databaseService: databaseService,
        thresholds: thresholds,
      ),
      ChartsTab(
        databaseService: databaseService,
      ),
      SettingsTab(
        onToggleTheme: widget.onToggleTheme,
        thresholds: thresholds,
        onThresholdChanged: (newThresholds) {
          setState(() {
            thresholds = newThresholds;
          });
        },
      ),
    ];
  }

  void _onTabTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _selectedIndex == 1
          ? null
          : AppBar(
        title: const Text('Trang chính'),
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: _tabs,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onTabTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'Biểu đồ',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Cài đặt',
          ),
        ],
      ),
    );
  }
}
