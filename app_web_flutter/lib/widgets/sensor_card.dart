import 'package:flutter/material.dart';

class SensorCard extends StatelessWidget {
  final String title;
  final double humidity;
  final double soilMoisture;
  final double temperature;
  final double battery;

  const SensorCard({
    super.key,
    required this.title,
    required this.humidity,
    required this.soilMoisture,
    required this.temperature,
    required this.battery,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Tiêu đề + phần trăm pin
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title.replaceAll('Slave', 'Trạm'),
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Row(
                  children: [
                    const Icon(Icons.battery_std, color: Colors.green),
                    const SizedBox(width: 4),
                    Text(
                      '${battery.toStringAsFixed(0)}%',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildSensorRow(Icons.water_drop, 'Độ ẩm không khí', humidity, '%', Colors.blue),
            const Divider(),
            _buildSensorRow(Icons.grass, 'Độ ẩm đất', soilMoisture, '%', Colors.brown),
            const Divider(),
            _buildSensorRow(Icons.thermostat, 'Nhiệt độ', temperature, '°C', Colors.red),
          ],
        ),
      ),
    );
  }

  Widget _buildSensorRow(IconData icon, String label, double value, String unit, Color color) {
    return Row(
      children: [
        Icon(icon, color: color),
        const SizedBox(width: 12),
        Expanded(
          child: Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
        ),
        Text(
          '${value.toStringAsFixed(2)}$unit',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: color),
        ),
      ],
    );
  }
}
