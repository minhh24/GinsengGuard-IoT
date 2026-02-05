# GinsengGuard IoT - Hệ Thống Giám Sát Sâm Ngọc Linh

**GinsengGuard IoT** là giải pháp giám sát môi trường thời gian thực dành riêng cho các trại trồng Sâm Ngọc Linh. [cite_start]Hệ thống sử dụng công nghệ truyền thông LoRa tầm xa kết hợp với nền tảng Firebase và ứng dụng đa nền tảng (Flutter) để giúp người nông dân theo dõi và bảo vệ "quốc bảo" dược liệu một cách hiệu quả nhất[cite: 1747, 1750].




##  Tính năng nổi bật
Hệ thống giải quyết vấn đề khó khăn trong canh tác Sâm Ngọc Linh tại các vùng núi cao, hiểm trở:

* [cite_start]**Truyền tin tầm xa (LoRa):** Sử dụng công nghệ LoRa (RA-02 433MHz) giúp truyền dữ liệu ổn định lên đến **1.6 km** trong môi trường đô thị (và xa hơn ở vùng núi), khắc phục hạn chế của Wi-Fi/Bluetooth[cite: 2361, 2363].
* [cite_start]**Giám sát đa điểm (Multi-node):** Hỗ trợ 02 Node Slave hoạt động độc lập bằng pin, thu thập dữ liệu tại các vị trí khác nhau[cite: 1914].
* **Đo lường toàn diện:**
    * Nhiệt độ ($^{\circ}C$)
    * Độ ẩm không khí (%)
    * Độ ẩm đất (%)
    * [cite_start]Dung lượng Pin của trạm cảm biến (%) [cite: 1890, 1926]
* [cite_start]**Đồng bộ Cloud (Firebase):** Dữ liệu được đẩy lên Firebase Realtime Database, đảm bảo tốc độ cập nhật tức thì[cite: 1907].
* **Ứng dụng đa nền tảng (Flutter):** Giám sát mọi lúc mọi nơi qua **Android App** và **Web Dashboard**. [cite_start]Hỗ trợ biểu đồ lịch sử và cảnh báo vượt ngưỡng[cite: 1893, 1902].
* [cite_start]**Cảnh báo thông minh:** Tự động phát cảnh báo trên giao diện khi các chỉ số vượt ngưỡng sinh thái lý tưởng của Sâm Ngọc Linh (Nhiệt độ $15-25^{\circ}C$, Độ ẩm KK 75-90%, Độ ẩm đất 60-70%)[cite: 1772, 1775, 1778, 2431].

---

##  Kiến trúc hệ thống & Phần cứng


Hệ thống hoạt động theo mô hình **Master-Slave**:

### 1. Node Cảm biến (Slave Node)
* [cite_start]**Vi điều khiển:** Arduino Pro Mini (Tiết kiệm năng lượng)[cite: 2102].
* [cite_start]**Truyền thông:** Module LoRa RA-02 (SPI)[cite: 2027].
* **Cảm biến:**
    * [cite_start]DHT11: Đo nhiệt độ & độ ẩm không khí[cite: 2026].
    * [cite_start]Capacitive Soil Moisture Sensor: Đo độ ẩm đất[cite: 2026].
    * [cite_start]Mạch phân áp: Đo dung lượng pin 18650[cite: 1959].
* [cite_start]**Nguồn:** Pin Li-ion 18650 + Mạch tăng áp SX1308 (3.7V lên 5V)[cite: 2025].

### 2. Node Trung tâm (Master Node)
* [cite_start]**Vi điều khiển:** ESP32 DevKit V1 (Xử lý trung tâm & Kết nối Wi-Fi)[cite: 2251].
* **Truyền thông:** Module LoRa RA-02 (Nhận dữ liệu từ Slave).
* [cite_start]**Hiển thị:** Màn hình LCD 1602 (I2C) hiển thị thông số tại chỗ[cite: 2153].
* [cite_start]**Nguồn:** Sử dụng LM1117-3.3V và SX1308 để cấp nguồn ổn định cho các module[cite: 2245].

---

##  Công nghệ phần mềm

### Firmware (C/C++)
* Lập trình trên **Arduino IDE**.
* [cite_start]Sử dụng thư viện LoRa để đóng gói và giải mã gói tin (ID, Temp, Hum, Soil, Bat)[cite: 2320].
* [cite_start]Master (ESP32) hoạt động như một Gateway: Nhận gói tin LoRa -> Xử lý JSON -> Gửi HTTP Request lên Firebase[cite: 1943].

### App & Web (Dart/Flutter)
* [cite_start]**Framework:** Google Flutter (Build cho Android & Web)[cite: 1841].
* **Backend:** Firebase Realtime Database.
* **Giao diện:**
    * **Dashboard:** Hiển thị thẻ trạng thái (Card) cho từng Node.
    * [cite_start]**Chart:** Biểu đồ đường (Line chart) theo dõi biến động môi trường theo thời gian thực[cite: 2470].
    * [cite_start]**Settings:** Thanh trượt (Slider) để cài đặt ngưỡng cảnh báo Min/Max[cite: 2605].

---

##  Hình ảnh thực tế & Kết quả

| Master Node | Slave Node |
|:---:|:---:|
| *(Chèn hình 4.1)* | *(Chèn hình 4.2)* |

| Web Dashboard | App Mobile |
|:---:|:---:|
| *(Chèn hình 4.5)* | *(Chèn hình 4.6)* |

*Kết quả thử nghiệm tại TP.HCM cho thấy hệ thống hoạt động ổn định ở khoảng cách **1.6 km**. [cite_start]Khi vượt quá 1.7 km trong môi trường nhiều vật cản, tín hiệu bắt đầu suy hao*[cite: 2361, 2368].

---

##  Hướng dẫn cài đặt (Sơ lược)

1.  **Phần cứng:**
    * Nạp code `Slave.ino` cho Arduino Pro Mini.
    * Nạp code `Master.ino` cho ESP32 (Cấu hình SSID/Pass WiFi và Firebase Host/Auth).
    * Đấu nối mạch theo sơ đồ nguyên lý trong thư mục `Schematic`.
2.  **Phần mềm:**
    * Cài đặt Flutter SDK.
    * Cấu hình `google-services.json` (Android) và `firebase_options.dart` (Web).
    * Chạy lệnh `flutter run` để khởi chạy ứng dụng.

---

##  Hướng phát triển (Future Work)
* [cite_start]Tối ưu hóa năng lượng (Sleep mode) cho các Node cảm biến[cite: 2647].
* [cite_start]Thêm cảm biến ánh sáng và CO2 để giám sát toàn diện hơn[cite: 2648].
* [cite_start]Tích hợp AI để dự báo sâu bệnh và tự động điều khiển hệ thống tưới[cite: 2654].

