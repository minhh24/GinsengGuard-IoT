# GinsengGuard IoT - He Thong Giam Sat Sam Ngoc Linh

GinsengGuard IoT la giai phap giam sat moi truong thoi gian thuc danh rieng cho cac trai trong Sam Ngoc Linh. He thong su dung cong nghe truyen thong LoRa tam xa ket hop voi nen tang Firebase va ung dung da nen tang (Flutter) de giup nguoi nong dan theo doi va bao ve duoc lieu quy mot cach hieu qua.

## Tac gia va Don vi thuc hien

* Sinh vien thuc hien:
    * Nguyen Quang Minh (22139041) - Phan cung & Firmware
    * Ngo Dinh Thai Long (22139038) - App/Web & Firebase
* Giang vien huong dan: TS. Nguyen Van Phuc
* Don vi: Truong Dai hoc Su pham Ky thuat TP.HCM (HCMUTE)

## Tinh nang noi bat

He thong giai quyet van de kho khan trong canh tac Sam Ngoc Linh tai cac vung nui cao voi cac tinh nang chinh:

* Truyen tin tam xa (LoRa): Su dung cong nghe LoRa (RA-02 433MHz) giup truyen du lieu on dinh len den 1.6 km trong moi truong do thi (va xa hon o vung nui), khac phuc han che cua Wi-Fi/Bluetooth.
* Giam sat da diem (Multi-node): Ho tro 02 Node Slave hoat dong doc lap bang pin, thu thap du lieu tai cac vi tri khac nhau.
* Do luong toan dien:
    * Nhiet do (do C)
    * Do am khong khi (%)
    * Do am dat (%)
    * Dung luong Pin cua tram cam bien (%)
* Dong bo Cloud (Firebase): Du lieu duoc day len Firebase Realtime Database, dam bao toc do cap nhat tuc thi.
* Ung dung da nen tang (Flutter): Giam sat moi luc moi noi qua Android App va Web Dashboard. Ho tro bieu do lich su va canh bao vuot nguong.
* Canh bao thong minh: Tu dong phat canh bao tren giao dien khi cac chi so vuot nguong sinh thai ly tuong cua Sam Ngoc Linh (Nhiet do 15-25 do C, Do am KK 75-90%, Do am dat 60-70%).

## Kien truc he thong va Phan cung

He thong hoat dong theo mo hinh Master-Slave:

### 1. Node Cam bien (Slave Node)
* Vi dieu khien: Arduino Pro Mini (Tiet kiem nang luong).
* Truyen thong: Module LoRa RA-02 (Giao tiep SPI).
* Cam bien:
    * DHT11: Do nhiet do va do am khong khi.
    * Capacitive Soil Moisture Sensor: Do do am dat.
    * Mach phan ap: Do dung luong pin 18650.
* Nguon: Pin Li-ion 18650 + Mach tang ap SX1308 (3.7V len 5V).

### 2. Node Trung tam (Master Node)
* Vi dieu khien: ESP32 DevKit V1 (Xu ly trung tam va Ket noi Wi-Fi).
* Truyen thong: Module LoRa RA-02 (Nhan du lieu tu Slave).
* Hien thi: Man hinh LCD 1602 (I2C) hien thi thong so tai cho.
* Nguon: Su dung LM1117-3.3V va SX1308 de cap nguon on dinh cho cac module.

## Cong nghe phan mem

### Firmware (C/C++)
* Lap trinh tren Arduino IDE.
* Su dung thu vien LoRa de dong goi va giai ma goi tin (ID, Temp, Hum, Soil, Bat).
* Master (ESP32) hoat dong nhu mot Gateway: Nhan goi tin LoRa -> Xu ly JSON -> Gui HTTP Request len Firebase.

### App va Web (Dart/Flutter)
* Framework: Google Flutter (Build cho Android va Web).
* Backend: Firebase Realtime Database.
* Giao dien:
    * Dashboard: Hien thi the trang thai (Card) cho tung Node.
    * Chart: Bieu do duong (Line chart) theo doi bien dong moi truong theo thoi gian thuc.
    * Settings: Thanh truot (Slider) de cai dat nguong canh bao Min/Max.

## Ket qua thuc nghiem

* Ket qua thu nghiem thuc te cho thay he thong hoat dong on dinh o khoang cach 1.6 km trong moi truong do thi co vat can.
* Du lieu duoc dong bo len Web va App voi do tre thap.
* Canh bao hoat dong chinh xac khi cac thong so moi truong vuot nguong cai dat.

## Huong dan cai dat

1. Phan cung:
    * Nap code Slave.ino cho Arduino Pro Mini.
    * Nap code Master.ino cho ESP32 (Cau hinh SSID/Pass WiFi va Firebase Host/Auth).
    * Dau noi mach theo so do nguyen ly trong thu muc Schematic.

2. Phan mem:
    * Cai dat Flutter SDK.
    * Cau hinh google-services.json (Android) va firebase_options.dart (Web).
    * Chay lenh "flutter run" de khoi chay ung dung.

## Huong phat trien
* Toi uu hoa nang luong (Sleep mode) cho cac Node cam bien de keo dai thoi gian dung pin.
* Them cam bien anh sang va CO2 de giam sat toan dien hon.
* Tich hop AI de du bao sau benh va tu dong dieu khien he thong tuoi.
