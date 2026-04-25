# Flutter Weather App

## 1. Project description and features

Flutter Weather App là một ứng dụng thời tiết được xây dựng bằng Flutter. Ứng dụng sử dụng OpenWeatherMap API để hiển thị thông tin thời tiết theo thời gian thực, dự báo theo giờ và dự báo 5 ngày. Ngoài ra, ứng dụng còn hỗ trợ lấy thời tiết theo vị trí hiện tại, tìm kiếm thời tiết theo tên thành phố, lưu dữ liệu offline bằng cache, kéo để làm mới, quản lý thành phố yêu thích, màn hình cài đặt và chuyển đổi đơn vị nhiệt độ.

### Chức năng chính

- Hiển thị thời tiết hiện tại.
- Hiển thị tên thành phố và quốc gia.
- Hiển thị trạng thái thời tiết kèm biểu tượng.
- Hiển thị nhiệt độ hiện tại và nhiệt độ cảm giác như.
- Hiển thị độ ẩm, tốc độ gió, áp suất, tầm nhìn và độ che phủ mây.
- Hiển thị dự báo thời tiết theo giờ.
- Hiển thị dự báo thời tiết 5 ngày.
- Tìm kiếm thời tiết theo tên thành phố.
- Lấy thời tiết theo vị trí hiện tại của người dùng.
- Xử lý quyền truy cập vị trí.
- Lưu dữ liệu thời tiết gần nhất để hỗ trợ chế độ offline.
- Hiển thị dữ liệu cache khi không có mạng.
- Hỗ trợ kéo xuống để làm mới dữ liệu.
- Thay đổi màu nền theo điều kiện thời tiết.
- Quản lý thành phố yêu thích.
- Lưu lịch sử tìm kiếm gần đây.
- Có màn hình cài đặt.
- Chuyển đổi đơn vị nhiệt độ giữa độ C và độ F.
- Xử lý trạng thái loading và trạng thái lỗi.

## 2. API setup instructions (without exposing keys!)

Dự án này sử dụng OpenWeatherMap API.

### Bước 1: Lấy API Key

Tạo tài khoản miễn phí trên OpenWeatherMap và lấy API key.

### Bước 2: Tạo file `.env`

Tạo file `.env` trong thư mục gốc của dự án Flutter, cùng cấp với file `pubspec.yaml`.

Thêm API key theo mẫu sau:

```env
OPENWEATHER_API_KEY=your_actual_api_key_here
```

Lưu ý: Không ghi API key thật vào README.

### Bước 3: Sử dụng file `.env.example`

Repository chỉ đưa lên file `.env.example` để làm mẫu cấu hình.

Nội dung file `.env.example`:

```env
OPENWEATHER_API_KEY=your_api_key_here
```

### Bước 4: Không để lộ API Key

File `.env` thật không được đưa lên GitHub vì trong đó có API key thật.

File `.gitignore` cần có:

```gitignore
.env
build/
.dart_tool/
```

## 3. Screenshots of different weather conditions

### Màn hình chính / Thời tiết hiện tại
<img width="1885" height="1069" alt="Màn hình chính" src="https://github.com/user-attachments/assets/531de4fc-9b06-491a-a156-a7de67e539d5" />
### Màn hình tìm kiếm
<img width="1919" height="1071" alt="Màn hình tìm kiếm" src="https://github.com/user-attachments/assets/b84205e4-e4a2-466f-8636-5adaabb61f54" />
### Màn hình dự báo thời tiết
<img width="1919" height="1079" alt="Màn hình dự báo thời tiết" src="https://github.com/user-attachments/assets/3d1e4811-dfac-4f56-84e7-8d0de9d5a3ce" />
### Màn hình cài đặt
<img width="1919" height="1079" alt="Màn hình cài đặt" src="https://github.com/user-attachments/assets/c071fefe-5dc8-4956-a3a9-ce11bf5e246d" />
### Trạng thái đang tải dữ liệu
<img width="1919" height="1078" alt="Trạng thái đang tải dữ liệu" src="https://github.com/user-attachments/assets/8a03dcb7-02d1-4a2f-82dc-fd9ed9ac177c" />
### Trạng thái lỗi
<img width="1919" height="1079" alt="Trạng thái lỗi" src="https://github.com/user-attachments/assets/a81e6960-5bd0-47bb-a5f1-eded7469d615" />
### Dữ liệu offline đã lưu cache
<img width="1919" height="1079" alt="Dữ liệu offline đã lưu cache" src="https://github.com/user-attachments/assets/a3262d9e-5163-4ffe-965c-4a816d30e812" />
### Thời tiết mưa hoặc nhiều mây
<img width="1912" height="1078" alt="Thời tiết mưa hoặc nhiều mây" src="https://github.com/user-attachments/assets/bfcd42be-caff-4f22-9fb2-627f5d4d45bd" />

## 4. How to run the project

### Bước 1: Tải hoặc clone repository
```bash`
git clone https://github.com/Yoonsucute/flutter.git
###Bước 2: Mở thư mục dự án               :  cd flutter_weather_app_LeDucTien/weather_application
###Bước 3: Cài đặt các thư viện cần thiết :  flutter pub get
###Bước 4: Tạo file .env
"Tạo file .env trong thư 
mục gốc của project,
cùng cấp với file pubspec.yaml.
Sau đó thêm API key theo mẫu sau       :  OPENWEATHER_API_KEY=your_actual_api_key_here"
###Bước 5: Chạy ứng dụng                  :   flutter run
###Bước 6: Chạy unit test                 :  flutter test

## 5. Công nghệ sử dụng

Dự án này được xây dựng bằng các công nghệ và thư viện sau:

- **Flutter**: Dùng để xây dựng ứng dụng di động.
- **Dart**: Ngôn ngữ lập trình chính của dự án.
- **OpenWeatherMap API**: Dùng để lấy dữ liệu thời tiết hiện tại và dự báo thời tiết.
- **Provider**: Dùng để quản lý trạng thái của ứng dụng.
- **HTTP**: Dùng để gửi yêu cầu API và nhận dữ liệu phản hồi từ server.
- **Geolocator**: Dùng để lấy vị trí hiện tại của người dùng.
- **Geocoding**: Dùng để chuyển đổi tọa độ thành thông tin địa điểm.
- **Shared Preferences**: Dùng để lưu dữ liệu thời tiết tạm thời, hỗ trợ chế độ offline.
- **Flutter Dotenv**: Dùng để quản lý API key thông qua file `.env`.
- **Cached Network Image**: Dùng để hiển thị và cache biểu tượng thời tiết.
- **Intl**: Dùng để định dạng ngày giờ.
- **Android Emulator**: Dùng để chạy và kiểm thử ứng dụng.

## 6. Hạn chế của ứng dụng

- Ứng dụng phụ thuộc vào OpenWeatherMap API, nên nếu API gặp sự cố thì ứng dụng có thể không lấy được dữ liệu mới.
- Gói miễn phí của OpenWeatherMap có giới hạn số lần gọi API.
- API key mới tạo có thể cần một khoảng thời gian để được kích hoạt.
- Ứng dụng cần kết nối Internet để tải dữ liệu thời tiết mới.
- Chế độ offline chỉ hiển thị dữ liệu thời tiết đã được lưu cache gần nhất.
- Ứng dụng chưa hỗ trợ bản đồ thời tiết hoặc radar thời tiết.
- Ứng dụng chưa hỗ trợ cảnh báo thời tiết.
- Ứng dụng chưa hiển thị chỉ số chất lượng không khí.
- Ứng dụng chủ yếu được kiểm thử trên Android Emulator.
- Chưa kiểm thử trên iOS do không có thiết bị iOS.

## 7. Hướng phát triển trong tương lai

- Thêm chức năng cảnh báo thời tiết và thông báo cho người dùng.
- Thêm thông tin chỉ số chất lượng không khí.
- Thêm bản đồ thời tiết hoặc radar thời tiết.
- Thêm cơ chế dự phòng bằng nhiều API thời tiết khác nhau.
- Thêm hiệu ứng hoạt hình cho các trạng thái thời tiết.
- Hỗ trợ nhiều ngôn ngữ.
- Cải thiện giao diện bằng các biểu tượng thời tiết tùy chỉnh.
- Thêm widget thời tiết ngoài màn hình chính Android.
- Bổ sung thêm nhiều unit test để kiểm thử ứng dụng đầy đủ hơn.
- Cải thiện khả năng truy cập và trải nghiệm người dùng.
