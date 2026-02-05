import 'package:flutter/material.dart';
import '../services/database_service.dart';
import '../widgets/sensor_card.dart';
import '../models/thresholds.dart';

class DashboardTab extends StatefulWidget {
  final DatabaseService databaseService;
  final Thresholds thresholds;

  const DashboardTab({Key? key, required this.databaseService, required this.thresholds}) : super(key: key);

  @override
  State<DashboardTab> createState() => _DashboardTabState();
}

class _DashboardTabState extends State<DashboardTab> with AutomaticKeepAliveClientMixin {
  Map<String, double> slave1Data = {'humidity': 0.0, 'soil_moisture': 0.0, 'temperature': 0.0, 'battery': 0.0};
  Map<String, double> slave2Data = {'humidity': 0.0, 'soil_moisture': 0.0, 'temperature': 0.0, 'battery': 0.0};

  @override
  void initState() {
    super.initState();
    widget.databaseService.slave1DataStream.listen((data) {
      setState(() {
        slave1Data = {
          'humidity': data['humidity']?.toDouble() ?? 0.0,
          'soil_moisture': data['soil_moisture']?.toDouble() ?? 0.0,
          'temperature': data['temperature']?.toDouble() ?? 0.0,
          'battery': data['battery']?.toDouble() ?? 0.0, // Đảm bảo cập nhật battery
        };
      });
    });
    widget.databaseService.slave2DataStream.listen((data) {
      setState(() {
        slave2Data = {
          'humidity': data['humidity']?.toDouble() ?? 0.0,
          'soil_moisture': data['soil_moisture']?.toDouble() ?? 0.0,
          'temperature': data['temperature']?.toDouble() ?? 0.0,
          'battery': data['battery']?.toDouble() ?? 0.0, // Đảm bảo cập nhật battery
        };
      });
    });
  }

  String checkWarnings(Map<String, double> data) {
    final warnings = <String>[];
    if (data['temperature']! < widget.thresholds.tempRangeMin || data['temperature']! > widget.thresholds.tempRangeMax) {
      warnings.add('Temperature out of range');
    }
    if (data['humidity']! < widget.thresholds.humidityRangeMin || data['humidity']! > widget.thresholds.humidityRangeMax) {
      warnings.add('Humidity out of range');
    }
    if (data['soil_moisture']! < widget.thresholds.soilMoistureRangeMin || data['soil_moisture']! > widget.thresholds.soilMoistureRangeMax) {
      warnings.add('Soil Moisture out of range');
    }
    if (data['battery']! < 30.0) {
      warnings.add('Low Battery');
    }
    return warnings.isEmpty ? 'No Warnings' : '⚠️ ' + warnings.join(', ');
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Current Sensor Readings', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          Text(
            checkWarnings(slave1Data),
            style: TextStyle(
              color: checkWarnings(slave1Data) == 'No Warnings' ? Colors.green : Colors.red,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          SensorCard(
            title: 'Slave 1',
            humidity: slave1Data['humidity'] ?? 0.0,
            soilMoisture: slave1Data['soil_moisture'] ?? 0.0,
            temperature: slave1Data['temperature'] ?? 0.0,
            battery: slave1Data['battery'] ?? 0.0,
          ),
          const SizedBox(height: 16),
          Text(
            checkWarnings(slave2Data),
            style: TextStyle(
              color: checkWarnings(slave2Data) == 'No Warnings' ? Colors.green : Colors.red,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          SensorCard(
            title: 'Slave 2',
            humidity: slave2Data['humidity'] ?? 0.0,
            soilMoisture: slave2Data['soil_moisture'] ?? 0.0,
            temperature: slave2Data['temperature'] ?? 0.0,
            battery: slave2Data['battery'] ?? 0.0,
          ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}