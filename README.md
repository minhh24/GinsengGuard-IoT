# HỆ THỐNG GIÁM SÁT MÔI TRƯỜNG TRẠI TRỒNG SÂM NGỌC LINH (IOT & LORA)

## GIỚI THIỆU
Đồ án "Xây dựng hệ thống giám sát môi trường ứng dụng cho trại trồng Sâm Ngọc Linh" được thực hiện nhằm giải quyết bài toán giám sát các chỉ số sinh thái khắt khe (Nhiệt độ, độ ẩm đất, độ ẩm không khí) tại các vùng núi cao, nơi hạ tầng mạng kém ổn định.

Hệ thống sử dụng công nghệ truyền thông không dây LoRa (Long Range) để truyền dữ liệu tầm xa tiết kiệm năng lượng, kết hợp với nền tảng Firebase và ứng dụng đa nền tảng Flutter để quản lý và giám sát từ xa.


## TÍNH NĂNG NỔI BẬT
- Giám sát thời gian thực: Cập nhật liên tục nhiệt độ, độ ẩm không khí, độ ẩm đất và mức pin từ các node cảm biến.
- Truyền thông LoRa tầm xa: Duy trì kết nối ổn định giữa các Node cảm biến và Gateway với khoảng cách thử nghiệm thực tế đạt 1.6 km trong môi trường đô thị.
- Hệ thống cảnh báo: Người dùng có thể tự cài đặt ngưỡng an toàn trên ứng dụng; hệ thống tự động gửi cảnh báo khi thông số môi trường vượt ngưỡng thiết lập.
- Đa nền tảng: Ứng dụng điều khiển hoạt động đồng bộ trên cả Android và Web.
- Lưu trữ và trực quan hóa dữ liệu: Biểu đồ trực quan giúp theo dõi xu hướng biến đổi của môi trường theo thời gian thực.

## KIẾN TRÚC HỆ THỐNG VÀ CÔNG NGHỆ

### 1. Phần cứng
- Node Slave (Thiết bị đầu cuối):
  - Vi điều khiển: Arduino Pro Mini (Lựa chọn tối ưu năng lượng cho thiết bị chạy pin).
  - Module truyền thông: LoRa RA-02 (Tần số 433MHz).
  - Cảm biến: DHT11 (Đo nhiệt độ/Độ ẩm không khí) và Cảm biến độ ẩm đất.
  - Nguồn: Pin 18650 kết hợp mạch tăng áp SX1308 và mạch phân áp giám sát dung lượng pin.

- Node Master (Gateway trung tâm):
  - Vi điều khiển chính: ESP32 DevKit V1 (Nhận dữ liệu LoRa, xử lý và đẩy lên Firebase qua Wi-Fi).
  - Hiển thị: Màn hình LCD 16x2 giao tiếp I2C để theo dõi tại chỗ.

### 2. Phần mềm
- Firmware: C/C++ (Arduino IDE).
- Mobile/Web App: Ngôn ngữ Dart trên nền tảng Flutter.
- Backend/Database: Google Firebase Realtime Database.
- Thiết kế mạch in (PCB): Altium Designer.

## KẾT QUẢ THỬ NGHIỆM
- Phạm vi truyền thông: Hệ thống hoạt động ổn định ở khoảng cách 1.6 km trong môi trường đô thị nhiều vật cản. Mất kết nối ở khoảng cách trên 1.7 km.
- Độ chính xác: Dữ liệu từ 2 Node Slave gửi về Master đầy đủ, chính xác và được đồng bộ lên Firebase với độ trễ thấp.
- Chức năng cảnh báo: Hệ thống cảnh báo hoạt động tức thời trên Dashboard khi phát hiện thông số vượt ngưỡng cài đặt.

## HƯỚNG DẪN CÀI ĐẶT
1. Nạp Firmware:
   - Sử dụng Arduino IDE để nạp code cho Arduino Pro Mini (Slave) và ESP32 (Master).
   - Cấu hình thông tin Wi-Fi và Firebase API Key trong code của ESP32.

2. Cài đặt ứng dụng:
   - Yêu cầu cài đặt Flutter SDK.
   - Chạy lệnh "flutter pub get" để tải các thư viện.
   - Chạy lệnh "flutter run" để khởi chạy ứng dụng trên máy ảo hoặc thiết bị thật.

## HƯỚNG PHÁT TRIỂN
- Tối ưu hóa năng lượng bằng chế độ Deep Sleep cho Node Slave để kéo dài thời gian hoạt động của pin.
- Tích hợp thêm các cảm biến môi trường khác như ánh sáng, nồng độ CO2 và độ pH đất.
- Áp dụng mô hình AI/Machine Learning để dự báo xu hướng thời tiết và đưa ra gợi ý chăm sóc cây trồng tự động.
- Mở rộng phát triển ứng dụng trên nền tảng iOS.

## BÁO CÁO ĐI KÈM
https://drive.google.com/file/d/11NgP2MwyQoGHBA3MrB6khCWWLzgGa7YN/view?usp=drive_link


## LIÊN HỆ
- Nguyễn Quang Minh
- Email: quangminh33971@gmail.com
- Sđt: 0916254336 (zalo)
