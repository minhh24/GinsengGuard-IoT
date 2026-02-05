import 'package:flutter/material.dart';
import '../models/thresholds.dart';

class SettingsTab extends StatefulWidget {
  final Thresholds thresholds;
  final Function(Thresholds) onThresholdChanged;
  final VoidCallback onToggleTheme; // Thêm callback này

  const SettingsTab({
    Key? key,
    required this.thresholds,
    required this.onThresholdChanged,
    required this.onToggleTheme, // Thêm trong constructor
  }) : super(key: key);

  @override
  State<SettingsTab> createState() => _SettingsTabState();
}

class _SettingsTabState extends State<SettingsTab> {
  late double _tempRangeMin;
  late double _tempRangeMax;
  late double _humidityRangeMin;
  late double _humidityRangeMax;
  late double _soilMoistureRangeMin;
  late double _soilMoistureRangeMax;

  @override
  void initState() {
    super.initState();
    _tempRangeMin = widget.thresholds.tempRangeMin;
    _tempRangeMax = widget.thresholds.tempRangeMax;
    _humidityRangeMin = widget.thresholds.humidityRangeMin;
    _humidityRangeMax = widget.thresholds.humidityRangeMax;
    _soilMoistureRangeMin = widget.thresholds.soilMoistureRangeMin;
    _soilMoistureRangeMax = widget.thresholds.soilMoistureRangeMax;
  }

  void _updateThresholds() {
    widget.onThresholdChanged(
      Thresholds(
        tempRangeMin: _tempRangeMin,
        tempRangeMax: _tempRangeMax,
        humidityRangeMin: _humidityRangeMin,
        humidityRangeMax: _humidityRangeMax,
        soilMoistureRangeMin: _soilMoistureRangeMin,
        soilMoistureRangeMax: _soilMoistureRangeMax,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 24),
          const Text(
            'Threshold Settings',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),

          // Nút chuyển đổi chế độ sáng/tối
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Chế độ tối', style: TextStyle(fontSize: 16)),
              Switch(
                value: Theme.of(context).brightness == Brightness.dark,
                onChanged: (_) => widget.onToggleTheme(),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Temperature Range
          const Text('Temperature Range (°C)'),
          const Text('Min'),
          Slider(
            value: _tempRangeMin,
            min: -20.0,
            max: 60.0,
            divisions: 80,
            label: _tempRangeMin.toStringAsFixed(1),
            onChanged: (value) {
              setState(() {
                _tempRangeMin = value;
                if (_tempRangeMin > _tempRangeMax) _tempRangeMax = _tempRangeMin;
              });
              _updateThresholds();
            },
          ),
          const Text('Max'),
          Slider(
            value: _tempRangeMax,
            min: -20.0,
            max: 60.0,
            divisions: 80,
            label: _tempRangeMax.toStringAsFixed(1),
            onChanged: (value) {
              setState(() {
                _tempRangeMax = value;
                if (_tempRangeMax < _tempRangeMin) _tempRangeMin = _tempRangeMax;
              });
              _updateThresholds();
            },
          ),

          // Humidity Range
          const Text('Humidity Range (%)'),
          const Text('Min'),
          Slider(
            value: _humidityRangeMin,
            min: 0.0,
            max: 100.0,
            divisions: 100,
            label: _humidityRangeMin.toStringAsFixed(1),
            onChanged: (value) {
              setState(() {
                _humidityRangeMin = value;
                if (_humidityRangeMin > _humidityRangeMax) _humidityRangeMax = _humidityRangeMin;
              });
              _updateThresholds();
            },
          ),
          const Text('Max'),
          Slider(
            value: _humidityRangeMax,
            min: 0.0,
            max: 100.0,
            divisions: 100,
            label: _humidityRangeMax.toStringAsFixed(1),
            onChanged: (value) {
              setState(() {
                _humidityRangeMax = value;
                if (_humidityRangeMax < _humidityRangeMin) _humidityRangeMin = _humidityRangeMax;
              });
              _updateThresholds();
            },
          ),

          // Soil Moisture Range
          const Text('Soil Moisture Range (%)'),
          const Text('Min'),
          Slider(
            value: _soilMoistureRangeMin,
            min: 0.0,
            max: 100.0,
            divisions: 100,
            label: _soilMoistureRangeMin.toStringAsFixed(1),
            onChanged: (value) {
              setState(() {
                _soilMoistureRangeMin = value;
                if (_soilMoistureRangeMin > _soilMoistureRangeMax) _soilMoistureRangeMax = _soilMoistureRangeMin;
              });
              _updateThresholds();
            },
          ),
          const Text('Max'),
          Slider(
            value: _soilMoistureRangeMax,
            min: 0.0,
            max: 100.0,
            divisions: 100,
            label: _soilMoistureRangeMax.toStringAsFixed(1),
            onChanged: (value) {
              setState(() {
                _soilMoistureRangeMax = value;
                if (_soilMoistureRangeMax < _soilMoistureRangeMin) _soilMoistureRangeMin = _soilMoistureRangeMax;
              });
              _updateThresholds();
            },
          ),

          const SizedBox(height: 24),
          const Text('Current Thresholds:', style: TextStyle(fontWeight: FontWeight.bold)),
          Text('Temperature Range: ${_tempRangeMin.toStringAsFixed(1)}°C - ${_tempRangeMax.toStringAsFixed(1)}°C'),
          Text('Humidity Range: ${_humidityRangeMin.toStringAsFixed(1)}% - ${_humidityRangeMax.toStringAsFixed(1)}%'),
          Text('Soil Moisture Range: ${_soilMoistureRangeMin.toStringAsFixed(1)}% - ${_soilMoistureRangeMax.toStringAsFixed(1)}%'),
        ],
      ),
    );
  }
}
