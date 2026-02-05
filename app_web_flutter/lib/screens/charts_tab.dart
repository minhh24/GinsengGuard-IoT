import 'dart:async';
import 'package:flutter/material.dart';
import '../services/database_service.dart';
import '../widgets/sensor_chart.dart';

class ChartsTab extends StatefulWidget {
  final DatabaseService databaseService;

  const ChartsTab({super.key, required this.databaseService});

  @override
  State<ChartsTab> createState() => _ChartsTabState();
}

class _ChartsTabState extends State<ChartsTab> with AutomaticKeepAliveClientMixin {
  late final Stream<void> _combinedStream;
  late final StreamSubscription _streamSubscription;

  @override
  void initState() {
    super.initState();

    _combinedStream = widget.databaseService.combinedSensorStream;

    _streamSubscription = _combinedStream.listen((_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _streamSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return DefaultTabController(
      length: 3,
      child: Column(
        children: [
          const TabBar(
            tabs: [
              Tab(text: 'Humidity'),
              Tab(text: 'Soil Moisture'),
              Tab(text: 'Temperature'),
            ],
          ),
          Expanded(
            child: TabBarView(
              children: [
                _buildChart(
                  title: 'Humidity (%)',
                  slave1Data: widget.databaseService.slave1HumidityData,
                  slave2Data: widget.databaseService.slave2HumidityData,
                  slave1Color: Colors.blue.shade300,
                  slave2Color: Colors.red.shade700,
                ),
                _buildChart(
                  title: 'Soil Moisture (%)',
                  slave1Data: widget.databaseService.slave1SoilMoistureData,
                  slave2Data: widget.databaseService.slave2SoilMoistureData,
                  slave1Color: Colors.orange.shade300,
                  slave2Color: Colors.green.shade700,
                ),
                _buildChart(
                  title: 'Temperature (°C)',
                  slave1Data: widget.databaseService.slave1TemperatureData,
                  slave2Data: widget.databaseService.slave2TemperatureData,
                  slave1Color: Colors.purple.shade300,
                  slave2Color: Colors.orange.shade700,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChart({
    required String title,
    required List slave1Data,
    required List slave2Data,
    required Color slave1Color,
    required Color slave2Color,
  }) {
    return SensorChart(
      title: title,
      slave1Data: List.from(slave1Data),
      slave2Data: List.from(slave2Data),
      slave1Color: slave1Color,
      slave2Color: slave2Color,
    );
  }

  @override
  bool get wantKeepAlive => true;
}
