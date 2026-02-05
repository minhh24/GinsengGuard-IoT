import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:rxdart/rxdart.dart';
import '../models/data_point.dart';
import '../models/thresholds.dart';

class DatabaseService {
  final FirebaseDatabase _database = FirebaseDatabase.instance;

  final _slave1DataController = StreamController<Map<String, dynamic>>.broadcast();
  final _slave2DataController = StreamController<Map<String, dynamic>>.broadcast();

  final List<DataPoint> slave1HumidityData = [];
  final List<DataPoint> slave1SoilMoistureData = [];
  final List<DataPoint> slave1TemperatureData = [];
  final List<DataPoint> slave2HumidityData = [];
  final List<DataPoint> slave2SoilMoistureData = [];
  final List<DataPoint> slave2TemperatureData = [];

  Map<String, double> _lastSlave1Data = {'humidity': 0.0, 'soil_moisture': 0.0, 'temperature': 0.0, 'battery': 0.0};
  Map<String, double> _lastSlave2Data = {'humidity': 0.0, 'soil_moisture': 0.0, 'temperature': 0.0, 'battery': 0.0};

  Stream<Map<String, dynamic>> get slave1DataStream => _slave1DataController.stream;
  Stream<Map<String, dynamic>> get slave2DataStream => _slave2DataController.stream;

  late final Stream<void> combinedSensorStream;

  final _alertController = StreamController<String>.broadcast();
  Stream<String> get alertStream => _alertController.stream;

  Thresholds? _thresholds;

  DatabaseService() {
    _initListeners();

    combinedSensorStream = Rx.merge([
      slave1DataStream,
      slave2DataStream,
    ]).map((_) => null).asBroadcastStream();

    // Luôn bắn stream đều đặn mỗi 1 giây dù Firebase không thay đổi
    Timer.periodic(Duration(seconds: 1), (_) {
      _slave1DataController.add(_lastSlave1Data);
      _slave2DataController.add(_lastSlave2Data);
    });
  }

  void updateThresholds(Thresholds thresholds) {
    _thresholds = thresholds;
  }

  void _initListeners() {
    _database.ref('sensors/slave1').onValue.listen((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>?;

      if (data != null) {
        final sensorData = <String, double>{
          'humidity': double.tryParse(data['humidity']?.toString() ?? '0.0') ?? 0.0,
          'soil_moisture': double.tryParse(data['soil_moisture']?.toString() ?? '0.0') ?? 0.0,
          'temperature': double.tryParse(data['temperature']?.toString() ?? '0.0') ?? 0.0,
          'battery': double.tryParse(data['battery']?.toString() ?? '0.0') ?? 0.0,
        };

        _lastSlave1Data = sensorData;

        final timestamp = DateTime.now();
        slave1HumidityData.add(DataPoint(timestamp, sensorData['humidity']!));
        slave1SoilMoistureData.add(DataPoint(timestamp, sensorData['soil_moisture']!));
        slave1TemperatureData.add(DataPoint(timestamp, sensorData['temperature']!));

        if (slave1HumidityData.length > 100) {
          slave1HumidityData.removeAt(0);
          slave1SoilMoistureData.removeAt(0);
          slave1TemperatureData.removeAt(0);
        }

        _checkThresholds(sensorData, 'Slave 1');
      }
    });

    _database.ref('sensors/slave2').onValue.listen((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>?;

      if (data != null) {
        final sensorData = <String, double>{
          'humidity': double.tryParse(data['humidity']?.toString() ?? '0.0') ?? 0.0,
          'soil_moisture': double.tryParse(data['soil_moisture']?.toString() ?? '0.0') ?? 0.0,
          'temperature': double.tryParse(data['temperature']?.toString() ?? '0.0') ?? 0.0,
          'battery': double.tryParse(data['battery']?.toString() ?? '0.0') ?? 0.0,
        };

        _lastSlave2Data = sensorData;

        final timestamp = DateTime.now();
        slave2HumidityData.add(DataPoint(timestamp, sensorData['humidity']!));
        slave2SoilMoistureData.add(DataPoint(timestamp, sensorData['soil_moisture']!));
        slave2TemperatureData.add(DataPoint(timestamp, sensorData['temperature']!));

        if (slave2HumidityData.length > 100) {
          slave2HumidityData.removeAt(0);
          slave2SoilMoistureData.removeAt(0);
          slave2TemperatureData.removeAt(0);
        }

        _checkThresholds(sensorData, 'Slave 2');
      }
    });
  }

  void _checkThresholds(Map<String, double> sensorData, String label) {
    if (_thresholds != null) {
      if (sensorData['temperature']! < _thresholds!.tempRangeMin ||
          sensorData['temperature']! > _thresholds!.tempRangeMax) {
        _alertController.add('$label: Temperature out of range: ${sensorData['temperature']}°C');
      }
      if (sensorData['humidity']! < _thresholds!.humidityRangeMin ||
          sensorData['humidity']! > _thresholds!.humidityRangeMax) {
        _alertController.add('$label: Humidity out of range: ${sensorData['humidity']}%');
      }
      if (sensorData['soil_moisture']! < _thresholds!.soilMoistureRangeMin ||
          sensorData['soil_moisture']! > _thresholds!.soilMoistureRangeMax) {
        _alertController.add('$label: Soil Moisture out of range: ${sensorData['soil_moisture']}%');
      }
      if (sensorData['battery']! < 30.0) {
        _alertController.add('$label: Low battery: ${sensorData['battery']}%');
      }
    }
  }

  void dispose() {
    _slave1DataController.close();
    _slave2DataController.close();
    _alertController.close();
  }
}
