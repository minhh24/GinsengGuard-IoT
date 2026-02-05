class Thresholds {
  double tempRangeMin;
  double tempRangeMax;
  double humidityRangeMin;
  double humidityRangeMax;
  double soilMoistureRangeMin;
  double soilMoistureRangeMax;

  Thresholds({
    required this.tempRangeMin,
    required this.tempRangeMax,
    required this.humidityRangeMin,
    required this.humidityRangeMax,
    required this.soilMoistureRangeMin,
    required this.soilMoistureRangeMax,
  });

  static Thresholds defaultValues() {
    return Thresholds(
      tempRangeMin: 20.0,
      tempRangeMax: 30.0,
      humidityRangeMin: 40.0,
      humidityRangeMax: 80.0,
      soilMoistureRangeMin: 5.0,
      soilMoistureRangeMax: 50.0,
    );
  }
}