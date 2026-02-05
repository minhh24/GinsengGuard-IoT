#include <SPI.h>
#include <LoRa.h>
#include <Wire.h>
#include <LiquidCrystal_I2C.h>
#include <WiFi.h>
#include <FirebaseESP32.h>

// Thông tin WiFi
#define WIFI_SSID ".."
#define WIFI_PASS "33333333"z

// Firebase Config và Auth
#define FIREBASE_HOST "doan1-4e33f-default-rtdb.firebaseio.com"
#define FIREBASE_AUTH "LwwthjLImnnSNBolto5lfXxzD92GWWBUlt0lG3lv"

// Cấu hình chân LoRa
const int csPin = 5;
const int resetPin = 26;
const int dio0Pin = 33;
const long frequency = 433E6; // Tần số LoRa
int tam = 4;

// LCD I2C
LiquidCrystal_I2C lcd(0x27, 16, 2);

// Biến lưu dữ liệu từ Slave
float tempSlave1 = 0.0, humSlave1 = 0.0, soilSlave1 = 0.0, batterySlave1 = 0.0;
float tempSlave2 = 0.0, humSlave2 = 0.0, soilSlave2 = 0.0, batterySlave2 = 0.0;
bool dataSlave1Received = false;
bool dataSlave2Received = false;
unsigned long lastUpdateTime = 0;
const unsigned long updateInterval = 1000; // Cập nhật mỗi 1 giây

// Firebase
FirebaseData firebaseData;
FirebaseConfig config;
FirebaseAuth auth;

void setup() {
  Serial.begin(9600);
  while (!Serial);
  Serial.println("LoRa Master Receiver");

  // Khởi tạo LoRa
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

  // Khởi tạo LCD
  Wire.begin(21, 22); // I2C cho ESP32
  lcd.init();
  lcd.backlight();
  lcd.print("LoRa Master Ready");

  // Kết nối WiFi
  WiFi.begin(WIFI_SSID, WIFI_PASS);
  Serial.print("Connecting to WiFi");
  while (WiFi.status() != WL_CONNECTED) {
    Serial.print(".");
    delay(500);
    tam = tam + 1;
    if (tam == 15) break;
  }
  Serial.println("\nWiFi connected!");

  // Cấu hình Firebase
  config.host = FIREBASE_HOST;
  config.signer.tokens.legacy_token = FIREBASE_AUTH;
  Firebase.begin(&config, &auth);
  Serial.println("Connected to Firebase!");
}

void loop() {
  // Nhận dữ liệu từ LoRa
  int packetSize = LoRa.parsePacket();
  if (packetSize) {
    String receivedData = "";
    while (LoRa.available()) {
      receivedData += (char)LoRa.read();
    }
    Serial.println("Received packet: " + receivedData);
    parseData(receivedData);
  }

  // Cập nhật Firebase mỗi 1 giây
  if (millis() - lastUpdateTime >= updateInterval) {
    displayData();
    sendToFirebase();
    lastUpdateTime = millis();
  }
}

void parseData(String data) {
  int idIndex = data.indexOf("ID:");
  int tempIndex = data.indexOf(",TEMP:");
  int humIndex = data.indexOf(",HUM:");
  int soilIndex = data.indexOf(",SOIL:");
  int batIndex = data.indexOf(",BAT:");

  if (idIndex != -1 && tempIndex != -1 && humIndex != -1 && soilIndex != -1 && batIndex != -1) {
    int id = data.substring(idIndex + 3, tempIndex).toInt();
    float temp = data.substring(tempIndex + 6, humIndex).toFloat();
    float hum = data.substring(humIndex + 5, soilIndex).toFloat();
    float soil = data.substring(soilIndex + 6, batIndex).toFloat();
    float battery = data.substring(batIndex + 5).toFloat();

    if (id == 1) {
      tempSlave1 = temp;
      humSlave1 = hum;
      soilSlave1 = soil;
      batterySlave1 = battery;
      dataSlave1Received = true;
    } else if (id == 2) {
      tempSlave2 = temp;
      humSlave2 = hum;
      soilSlave2 = soil;
      batterySlave2 = battery;
      dataSlave2Received = true;
    }
  }
}

void displayData() {
  lcd.clear();
  lcd.setCursor(0, 0);
  if (dataSlave1Received) {
    lcd.print("1T");
    lcd.print(tempSlave1, 1);
    lcd.print(" H");
    lcd.print(humSlave1, 1);
    lcd.print(" D");
    lcd.print(soilSlave1, 1);
    Serial.println("Slave 1 - Temp: " + String(tempSlave1) + "C, Hum: " + String(humSlave1) + "%, Soil: " + String(soilSlave1) + "%, Battery: " + String(batterySlave1) + "%");
  } else {
    lcd.print("S1: Waiting...");
  }

  lcd.setCursor(0, 1);
  if (dataSlave2Received) {
    lcd.print("2T");
    lcd.print(tempSlave2, 1);
    lcd.print(" H");
    lcd.print(humSlave2, 1);
    lcd.print(" D");
    lcd.print(soilSlave2, 1);
    Serial.println("Slave 2 - Temp: " + String(tempSlave2) + "C, Hum: " + String(humSlave2) + "%, Soil: " + String(soilSlave2) + "%, Battery: " + String(batterySlave2) + "%");
  } else {
    lcd.print("S2: Waiting...");
  }
}

void sendToFirebase() {
  if (dataSlave1Received) {
    FirebaseJson json1;
    json1.set("temperature", tempSlave1);
    json1.set("humidity", humSlave1);
    json1.set("soil_moisture", soilSlave1);
    json1.set("battery", batterySlave1);
    if (Firebase.setJSON(firebaseData, "/sensors/slave1", json1)) {
      Serial.println("Slave 1 data sent to Firebase");
    } else {
      Serial.println("Failed to send Slave 1 data: " + firebaseData.errorReason());
    }
  }

  if (dataSlave2Received) {
    FirebaseJson json2;
    json2.set("temperature", tempSlave2);
    json2.set("humidity", humSlave2);
    json2.set("soil_moisture", soilSlave2);
    json2.set("battery", batterySlave2);
    if (Firebase.setJSON(firebaseData, "/sensors/slave2", json2)) {
      Serial.println("Slave 2 data sent to Firebase");
    } else {
      Serial.println("Failed to send Slave 2 data: " + firebaseData.errorReason());
    }
  }
}