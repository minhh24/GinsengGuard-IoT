const int analogPin = A1; // Sử dụng chân A1
const float referenceVoltage = 5.0; // Điện áp tham chiếu (5V hoặc 3.3V tùy board)
const float R1 = 10000; // Điện trở R1 (10kΩ)
const float R2 = 10000; // Điện trở R2 (10kΩ)

void setup() {
  Serial.begin(9600);
}

void loop() {
  int sensorValue = analogRead(analogPin); // Đọc giá trị ADC từ A1
  
  // Tính điện áp thực tế
  float voltage = sensorValue * (referenceVoltage / 1023.0); // Chuyển giá trị ADC thành điện áp
  float batteryVoltage = voltage * ((R1 + R2) / R2); // Tính điện áp pin (nếu dùng phân áp)
  
  // Ước tính phần trăm pin
  float percentage = mapBatteryPercentage(batteryVoltage);
  
  // In kết quả
  Serial.print("Điện áp: ");
  Serial.print(batteryVoltage);
  Serial.print("V, Phần trăm pin: ");
  Serial.print(percentage);
  Serial.println("%");
  
  delay(1000); // Đợi 1 giây
}

// Hàm ánh xạ điện áp thành phần trăm pin
float mapBatteryPercentage(float voltage) {
  if (voltage >= 4.2) return 100.0;
  if (voltage <= 3.7) return 0.0;
  return ((voltage - 3.7) / (4.2 - 3.7)) * 100.0;
}