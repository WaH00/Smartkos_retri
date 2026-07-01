# SmartKos Mobile

Flutter client untuk pencarian kos berbasis FastAPI. Aplikasi menggunakan GetX
untuk state management dan Dio untuk komunikasi HTTP. Flutter hanya mengakses
FastAPI dan tidak terhubung langsung ke database.

## Arsitektur

```text
Flutter UI -> GetX Controller -> Repository -> API Provider -> FastAPI
```

Pencarian menggunakan `POST /api/v1/search-kos`. Status backend diperiksa melalui
`GET /api/v1/health`. URL server diatur saat menjalankan aplikasi dengan
`--dart-define=API_BASE_URL=...`.

## Menjalankan Backend di Laptop

Buka terminal PowerShell atau Command Prompt:

```powershell
cd C:\Users\LENOVO\SmartKost-IR
.venv\Scripts\activate
python -m uvicorn app.main:app --reload --host 0.0.0.0 --port 8000
```

Periksa health endpoint:

```bash
curl http://localhost:8000/api/v1/health
```

Uji endpoint pencarian:

```bash
curl -X POST http://localhost:8000/api/v1/search-kos \
  -H "Content-Type: application/json" \
  -d '{
    "kueri": "kos putri AC kamar mandi dalam dekat kampus",
    "latitude": -6.1862,
    "longitude": 106.8348,
    "top_k": 5,
    "n_candidates": 20
  }'
```

Di PowerShell, request yang sama dapat dijalankan dengan:

```powershell
$body = @{
  kueri = 'kos putri AC kamar mandi dalam dekat kampus'
  latitude = -6.1862
  longitude = 106.8348
  top_k = 5
  n_candidates = 20
} | ConvertTo-Json

Invoke-RestMethod `
  -Method Post `
  -Uri 'http://localhost:8000/api/v1/search-kos' `
  -ContentType 'application/json' `
  -Body $body
```

## Menjalankan di Android Fisik

Cari IP laptop melalui Windows CMD:

```cmd
ipconfig
```

Ambil `IPv4 Address` dari adapter Wi-Fi, misalnya `192.168.1.12`. Sebelum
menjalankan Flutter, buka URL berikut melalui browser HP:

```text
http://192.168.1.12:8000/api/v1/health
```

Jika health endpoint terbuka, jalankan Flutter menggunakan IP tersebut:

```powershell
flutter pub get
flutter run --dart-define=API_BASE_URL=http://192.168.1.12:8000
```

Nilai IP hanya diberikan melalui `--dart-define` dan tidak disimpan di source
code. Laptop dan HP harus berada pada jaringan Wi-Fi yang sama.

## Menjalankan di Android Emulator

Android emulator memakai `10.0.2.2` untuk mengakses backend pada laptop host:

```bash
flutter run --dart-define=API_BASE_URL=http://10.0.2.2:8000
```

## Troubleshooting Koneksi HP

- Pastikan laptop dan HP berada pada Wi-Fi yang sama.
- Jalankan backend dengan `--host 0.0.0.0`, bukan hanya `127.0.0.1`.
- Izinkan Python atau inbound TCP port `8000` pada Windows Firewall.
- Gunakan IP laptop pada `API_BASE_URL`, bukan `localhost`, `127.0.0.1`, atau
  `10.0.2.2`. Alamat `10.0.2.2` hanya digunakan oleh Android emulator.
- Uji `/api/v1/health` dari browser HP sebelum menjalankan aplikasi.

## Alur Demo Tim

1. Push perubahan Flutter ke GitHub, lalu teammate menjalankan `git pull`.
2. Teammate menjalankan FastAPI pada `0.0.0.0:8000`.
3. Pastikan `/api/v1/health` dapat diakses dari perangkat target.
4. Jalankan Flutter dengan `API_BASE_URL` yang sesuai emulator atau IP LAN.
5. Masukkan kueri pada halaman Explore dan tekan **Cari Kos**.

Konfigurasi endpoint ada di
`lib/app/core/constants/api_constants.dart`. Panggilan Dio ada di
`lib/app/core/api/api_client.dart` dan payload pencarian ada di
`lib/app/data/providers/search_api_provider.dart`.

Filter harga, fasilitas, dan radius masih ditampilkan untuk menjaga mockup UI,
tetapi belum dikirim ke backend karena schema pencarian saat ini belum menerima
field tersebut. Saved disimpan dalam memori aplikasi sampai endpoint favorit
tersedia.
