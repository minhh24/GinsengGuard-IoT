# HỆ THỐNG GIÁM SÁT MÔI TRƯỜNG TRẠI TRỒNG SÂM NGỌC LINH (IOT & LORA)

## GIỚI THIỆU
[cite_start]Đồ án "Xây dựng hệ thống giám sát môi trường ứng dụng cho trại trồng Sâm Ngọc Linh" được thực hiện nhằm giải quyết bài toán giám sát các chỉ số sinh thái khắt khe (Nhiệt độ, độ ẩm đất, độ ẩm không khí) tại các vùng núi cao, nơi hạ tầng mạng kém ổn định[cite: 5, 49, 51].

[cite_start]Hệ thống sử dụng công nghệ truyền thông không dây LoRa (Long Range) để truyền dữ liệu tầm xa tiết kiệm năng lượng, kết hợp với nền tảng Firebase và ứng dụng đa nền tảng Flutter để quản lý và giám sát từ xa[cite: 56, 57].

Sinh viên thực hiện:
- [cite_start]Nguyễn Quang Minh - 22139041 [cite: 7]
- [cite_start]Ngô Đình Thái Long - 22139038 [cite: 8]
Giảng viên hướng dẫn: TS. [cite_start]Nguyễn Văn Phúc [cite: 6]
[cite_start]Đơn vị: Trường Đại học Sư phạm Kỹ thuật TP.HCM (HCMUTE) [cite: 2]

## TÍNH NĂNG NỔI BẬT
- [cite_start]Giám sát thời gian thực: Cập nhật liên tục nhiệt độ, độ ẩm không khí, độ ẩm đất và mức pin từ các node cảm biến[cite: 61, 201].
- [cite_start]Truyền thông LoRa tầm xa: Duy trì kết nối ổn định giữa các Node cảm biến và Gateway với khoảng cách thử nghiệm thực tế đạt 1.6 km trong môi trường đô thị[cite: 672].
- [cite_start]Hệ thống cảnh báo: Người dùng có thể tự cài đặt ngưỡng an toàn trên ứng dụng; hệ thống tự động gửi cảnh báo khi thông số môi trường vượt ngưỡng thiết lập[cite: 63, 741].
- [cite_start]Đa nền tảng: Ứng dụng điều khiển hoạt động đồng bộ trên cả Android và Web[cite: 57, 204].
- [cite_start]Lưu trữ và trực quan hóa dữ liệu: Biểu đồ trực quan giúp theo dõi xu hướng biến đổi của môi trường theo thời gian thực[cite: 205, 782].

## KIẾN TRÚC HỆ THỐNG VÀ CÔNG NGHỆ

### 1. Phần cứng
- Node Slave (Thiết bị đầu cuối):
  - [cite_start]Vi điều khiển: Arduino Pro Mini (Lựa chọn tối ưu năng lượng cho thiết bị chạy pin)[cite: 413, 417].
  - [cite_start]Module truyền thông: LoRa RA-02 (Tần số 433MHz)[cite: 338, 346].
  - [cite_start]Cảm biến: DHT11 (Đo nhiệt độ/Độ ẩm không khí) và Cảm biến độ ẩm đất[cite: 337, 348].
  - [cite_start]Nguồn: Pin 18650 kết hợp mạch tăng áp SX1308 và mạch phân áp giám sát dung lượng pin[cite: 336, 270].

- Node Master (Gateway trung tâm):
  - [cite_start]Vi điều khiển chính: ESP32 DevKit V1 (Nhận dữ liệu LoRa, xử lý và đẩy lên Firebase qua Wi-Fi)[cite: 562, 566].
  - [cite_start]Hiển thị: Màn hình LCD 16x2 giao tiếp I2C để theo dõi tại chỗ[cite: 464, 467].

### 2. Phần mềm
- [cite_start]Firmware: C/C++ (Arduino IDE)[cite: 147, 157].
- [cite_start]Mobile/Web App: Ngôn ngữ Dart trên nền tảng Flutter[cite: 152, 153].
- [cite_start]Backend/Database: Google Firebase Realtime Database[cite: 164, 165].
- [cite_start]Thiết kế mạch in (PCB): Altium Designer[cite: 171].

## KẾT QUẢ THỬ NGHIỆM
- [cite_start]Phạm vi truyền thông: Hệ thống hoạt động ổn định ở khoảng cách 1.6 km trong môi trường đô thị nhiều vật cản[cite: 672]. [cite_start]Mất kết nối ở khoảng cách trên 1.7 km[cite: 679].
- [cite_start]Độ chính xác: Dữ liệu từ 2 Node Slave gửi về Master đầy đủ, chính xác và được đồng bộ lên Firebase với độ trễ thấp[cite: 648, 673].
- [cite_start]Chức năng cảnh báo: Hệ thống cảnh báo hoạt động tức thời trên Dashboard khi phát hiện thông số vượt ngưỡng cài đặt[cite: 940].

## HƯỚNG DẪN CÀI ĐẶT
1. Nạp Firmware:
   - Sử dụng Arduino IDE để nạp code cho Arduino Pro Mini (Slave) và ESP32 (Master).
   - Cấu hình thông tin Wi-Fi và Firebase API Key trong code của ESP32.

2. Cài đặt ứng dụng:
   - Yêu cầu cài đặt Flutter SDK.
   - Chạy lệnh "flutter pub get" để tải các thư viện.
   - Chạy lệnh "flutter run" để khởi chạy ứng dụng trên máy ảo hoặc thiết bị thật.

## HƯỚNG PHÁT TRIỂN
- [cite_start]Tối ưu hóa năng lượng bằng chế độ Deep Sleep cho Node Slave để kéo dài thời gian hoạt động của pin[cite: 958].
- [cite_start]Tích hợp thêm các cảm biến môi trường khác như ánh sáng, nồng độ CO2 và độ pH đất[cite: 959].
- [cite_start]Áp dụng mô hình AI/Machine Learning để dự báo xu hướng thời tiết và đưa ra gợi ý chăm sóc cây trồng tự động[cite: 965].
- [cite_start]Mở rộng phát triển ứng dụng trên nền tảng iOS[cite: 966].

## LIÊN HỆ
- Nguyễn Quang Minh
- Email: [Email của bạn]
- LinkedIn: [Link Profile LinkedIn của bạn]
