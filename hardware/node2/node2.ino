#include <SPI.h>
#include <LoRa.h>
#include <DHT.h>

const int analogPin = A1; // Sử dụng chân A1
const float referenceVoltage = 5.0; // Điện áp tham chiếu (5V hoặc 3.3V tùy board)
const float R1 = 10000; // Điện trở R1 (10kΩ)
const float R2 = 10000; // Điện trở R2 (10kΩ)

const int csPin = 10;
const int resetPin = 9;
const int dio0Pin = 2;
const long frequency = 433E6; // Tần số LoRa
const int slaveID = 2; // ID cho Slave 2
// Cấu hình cảm biến DHT
#define DHTPIN 5          // Chân OUT của DHT11 nối với chân 5
#define DHTTYPE DHT11     // Loại cảm biến: DHT11 (nếu dùng DHT22, đổi thành DHT22)
DHT dht(DHTPIN, DHTTYPE);
// Cấu hình cảm biến độ ẩm đất
#define SOIL_PIN A0       // Chân A0 của cảm biến độ ẩm đất nối với A0 trên Arduino

// Biến lưu giá trị
float temperature = 0.0;
float humidity = 0.0;
int soilMoisture = 0;


void setup() {
  Serial.begin(9600);
  while (!Serial);
  Serial.println("LoRa Slave " + String(slaveID) + " Sender");

  SPI.begin();
  LoRa.setPins(csPin, resetPin, dio0Pin);

  if (!LoRa.begin(frequency)) {
    Serial.println("Starting LoRa failed!");
    while (1);
  }
  LoRa.setSpreadingFactor(12);
  LoRa.setSignalBandwidth(250E3);
  LoRa.setCodingRate4(5);
  LoRa.setPreambleLength(8);
  LoRa.setSyncWord(0x12);
  Serial.println("LoRa Initializing OK!");
  randomSeed(analogRead(0));

  // Khởi tạo cảm biến DHT
  dht.begin();
  Serial.println("DHT11 and Soil Moisture Sensor Initialized");

  // Cấu hình chân cảm biến độ ẩm đất
  pinMode(SOIL_PIN, INPUT);
}


void loop() {
  /*
  float temperature = random(2000, 3600) / 100.0; // 20.00-35.99°C
  float humidity = random(5000, 8100) / 100.0;    // 50.00-80.99%
  float soilMoisture = random(0, 10000) / 100.0;  // 0.00-100.00%
*/
  temperature = dht.readTemperature(); // Đọc nhiệt độ (độ C)
  humidity = dht.readHumidity();       // Đọc độ ẩm (%)

  // Kiểm tra nếu đọc lỗi
  if (isnan(temperature) || isnan(humidity)) {
    Serial.println("Failed to read from DHT sensor!");
  } else {
    Serial.print("Temperature: ");
    Serial.print(temperature);
    Serial.print(" °C, Humidity: ");
    Serial.print(humidity);
    Serial.println(" %");
  }

  // Đọc dữ liệu từ cảm biến độ ẩm đất
  soilMoisture = analogRead(SOIL_PIN); // Đọc giá trị analog (0-1023)
  // Chuyển đổi thành phần trăm (giả sử 0 = ướt, 1023 = khô)
  int soilPercentage = map(soilMoisture, 1023, 0, 0, 100);

  Serial.print("Soil Moisture: ");
  Serial.print(soilPercentage);
  Serial.println(" %");

  int sensorValue = analogRead(analogPin); // Đọc giá trị ADC từ A1
  // Tính điện áp thực tế
  float voltage = sensorValue * (referenceVoltage / 1023.0); // Chuyển giá trị ADC thành điện áp
  float batteryVoltage = voltage * ((R1 + R2) / R2); // Tính điện áp pin (nếu dùng phân áp)
  // Ước tính phần trăm pin
  //float percentage = mapBatteryPercentage(batteryVoltage);
  float percentage = 78;
  
  // In kết quả
  Serial.print("dien ap: ");
  Serial.print(batteryVoltage);
  Serial.print("V, phan tram pin: ");
  Serial.print(percentage);
  Serial.println("%");

  // In khoảng cách để dễ đọc
  Serial.println("-------------------");

  String data = "ID:" + String(slaveID) + ",TEMP:" + String(temperature, 2) + ",HUM:" + String(humidity, 2) + ",SOIL:" + String(soilPercentage)+ ",BAT:" + String(percentage, 2);
  Serial.println("Sending packet: " + data);

  LoRa.beginPacket();
  LoRa.print(data);
  LoRa.endPacket();

  delay(3000 + random(0, 1000)); // Gửi mỗi 3-4 giây
}

// Hàm ánh xạ điện áp thành phần trăm pin
float mapBatteryPercentage(float voltage) {
  if (voltage >= 4.2) return 100.0;
  if (voltage <= 3.7) return 0.0;
  return ((voltage - 3.7) / (4.2 - 3.7)) * 100.0;
}