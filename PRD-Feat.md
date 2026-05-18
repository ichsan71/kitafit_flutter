# Product Requirements Document (PRD)

# Kita Fit — Backend API

**Versi:** 1.0  
**Tanggal:** 18 Mei 2026  
**Status:** In Development  
**Tim:** Backend

---

## 1. Ringkasan Produk

**Kita Fit** (Physical Application of Literacy) adalah platform mobile yang bertujuan meningkatkan literasi fisik masyarakat Indonesia. Backend ini menyediakan REST API untuk aplikasi mobile serta admin panel berbasis web untuk pengelolaan konten.

---

## 2. Tujuan Produk

| Tujuan                                                               | Ukuran Keberhasilan                                     |
| -------------------------------------------------------------------- | ------------------------------------------------------- |
| Menyediakan konten edukatif literasi fisik (artikel, wawasan, video) | Konten tersedia dan terpaginasi dengan baik             |
| Mendorong pengguna untuk memahami materi melalui kuis interaktif     | Pengguna dapat mengikuti dan melihat riwayat kuis       |
| Membantu pengguna merencanakan aktivitas fisik                       | Pengguna dapat membuat jadwal literasi pribadi          |
| Menghubungkan pengguna dengan ahli kebugaran/kesehatan               | Pengguna dapat mengakses kontak WhatsApp ahli           |
| Memungkinkan personalisasi melalui fitur favorit                     | Pengguna dapat menyimpan konten favorit lintas kategori |

---

## 3. Pengguna (Stakeholders)

### 3.1 End User (Mobile App)

- Pengguna umum yang ingin meningkatkan literasi fisik
- Dapat membaca artikel, menonton video, mengikuti kuis, dan mengatur jadwal

### 3.2 Admin (Web Panel)

- Pengelola konten: membuat dan mempublikasikan artikel, wawasan, video, kuis
- Mengelola data ahli dan memantau aktivitas pengguna

---

## 4. Ruang Lingkup

### 4.1 Fitur Dalam Cakupan (v1.0)

| Modul               | Fitur                                                         |
| ------------------- | ------------------------------------------------------------- |
| **Autentikasi**     | Registrasi, Login, Logout, Lihat & Update Profil              |
| **Artikel**         | Daftar artikel publik, Detail artikel, Filter & Pencarian     |
| **Wawasan**         | Daftar wawasan publik, Detail wawasan, Filter & Pencarian     |
| **Video**           | Daftar video publik, Detail video, Pencarian                  |
| **Kuis**            | Daftar kuis, Detail + soal & pilihan, Submit jawaban, Riwayat |
| **Jadwal Literasi** | CRUD jadwal pribadi per-user, Filter tanggal & upcoming       |
| **Chat Ahli**       | Daftar ahli aktif, Detail ahli + link WhatsApp                |
| **Favorit**         | Toggle favorit (tambah/hapus), Daftar favorit per tipe        |
| **Admin Panel**     | CRUD semua konten via Filament, Manajemen user                |

### 4.2 Fitur Di Luar Cakupan (v1.0)

- Push notification / reminder jadwal
- Live chat atau forum diskusi
- Rating / review konten
- Sosial fitur (follow user, feed)
- Pembayaran / langganan premium
- Analitik dashboard untuk admin

---

## 5. Spesifikasi Teknis

### 5.1 Tech Stack

| Komponen    | Teknologi                           |
| ----------- | ----------------------------------- |
| Framework   | Laravel 13 (PHP 8.3)                |
| Autentikasi | Laravel Sanctum (Bearer Token)      |
| Admin Panel | Filament v5                         |
| Database    | MySQL                               |
| Storage     | Laravel Storage (local/public disk) |

### 5.2 Arsitektur API

- **Base URL:** `http://localhost:8000/api/v1`
- **Format Response:** JSON seragam `{ success, message, data }`
- **Autentikasi:** Bearer Token via header `Authorization`
- **Pagination:** Semua listing menggunakan cursor/offset pagination

---

## 6. Spesifikasi Fitur

### 6.1 Autentikasi

**Registrasi**

- Input: name, email (unique), password (min 8, confirmed), phone (opsional)
- Output: user object + Bearer token
- HTTP: `POST /api/v1/register` → `201 Created`

**Login**

- Input: email, password
- Validasi: credentials mismatch → 401
- Output: user object + Bearer token
- HTTP: `POST /api/v1/login` → `200 OK`

**Logout**

- Menghapus token aktif saat ini saja (bukan semua token)
- Memerlukan autentikasi
- HTTP: `POST /api/v1/logout` → `200 OK`

**Profil**

- Lihat profil: `GET /api/v1/profile`
- Update profil: `POST /api/v1/profile` (multipart/form-data)
- Field dapat diupdate: name, phone, avatar (image, max 2MB), password
- Avatar disimpan di `storage/avatars/`

---

### 6.2 Konten Publik (Artikel, Wawasan, Video)

**Artikel & Wawasan:**

- Hanya konten berstatus `published` yang dikembalikan
- Filter tersedia: `search` (judul), `category` (slug kategori), `per_page`
- Response listing tidak menyertakan field `content` (hanya di detail)
- Relasi: belongs to `category` dan `author` (user)

**Video:**

- Hanya konten berstatus `published`
- Filter: `search`, `per_page`
- Field utama: title, slug, description, thumbnail, video_url, duration

---

### 6.3 Kuis

**Listing & Detail:**

- Listing menampilkan `questions_count`
- Detail memuat semua pertanyaan dan pilihan jawaban (termasuk `is_correct`)

> ⚠️ **Catatan Keamanan:** Field `is_correct` saat ini ditampilkan pada GET detail kuis. Untuk produksi, pertimbangkan menyembunyikan field ini dari response publik dan hanya mengembalikan hasil setelah submit.

**Submit:**

- Input: array `answers` berisi `question_id` dan `option_id`
- Validasi: masing-masing option harus ada di database
- Logika: menghitung skor berdasarkan `is_correct` pada `QuizOption`
- Disimpan ke `quiz_attempts` dan `quiz_answers`
- Dibungkus dalam database transaction

**Riwayat:**

- Menampilkan semua attempt milik user yang sedang login
- Diurutkan terbaru

---

### 6.4 Jadwal Literasi

- Data bersifat **privat per-user** (tidak dapat diakses user lain)
- Ownership check di setiap endpoint (show, update, destroy) → 403 jika bukan milik user
- Filter: `date` (format Y-m-d), `upcoming` (boolean, jadwal >= hari ini)
- Urutan: ascending berdasarkan `scheduled_date` kemudian `scheduled_time`
- Field wajib saat store: title, scheduled_date, scheduled_time
- Field opsional: description

---

### 6.5 Chat Ahli

- Hanya ahli berstatus `active` yang dikembalikan
- Response menyertakan `whatsapp_url` (format: `https://wa.me/{number}`) yang siap digunakan untuk deep link

---

### 6.6 Favorit

- Bersifat **polymorphic**: dapat menyimpan referensi ke article, wawasan, video, atau quiz
- Toggle logic: jika sudah ada → hapus (return `is_favorited: false`), jika belum → tambah (return `is_favorited: true`)
- Verifikasi existensi model sebelum disimpan (`findOrFail`)
- Filter listing: `type` (article | wawasan | video | quiz)

---

## 7. Admin Panel (Filament v5)

| Resource           | Kemampuan                                                 |
| ------------------ | --------------------------------------------------------- |
| Users              | Lihat, edit role (admin/user)                             |
| Categories         | CRUD, digunakan untuk artikel & wawasan                   |
| Articles           | CRUD dengan rich text editor, upload thumbnail, auto-slug |
| Wawasan            | CRUD dengan rich text editor, upload thumbnail, auto-slug |
| Videos             | CRUD, input video_url                                     |
| Quizzes            | CRUD, nested management pertanyaan & pilihan jawaban      |
| Experts            | CRUD, input nomor WhatsApp                                |
| Literacy Schedules | Lihat & kelola jadwal seluruh user                        |

**Fitur umum admin:** Auto-slug dari judul, image upload, search & filter, bulk delete.

---

## 8. Database Schema

```
users
├── id, name, email, password, phone, avatar, role (admin|user)
categories
├── id, name, slug, type (article|wawasan)
articles
├── id, category_id, author_id (→ users), title, slug, excerpt, content, thumbnail, status, published_at
wawasans
├── id, category_id, author_id (→ users), title, slug, excerpt, content, thumbnail, status, published_at
videos
├── id, title, slug, description, thumbnail, video_url, duration, status, published_at
quizzes
├── id, title, slug, description, status, published_at
    quiz_questions
    └── id, quiz_id, question (order)
        quiz_options
        └── id, quiz_question_id, option_text, is_correct
quiz_attempts
├── id, user_id, quiz_id, score, total_questions, completed_at
    quiz_answers
    └── id, quiz_attempt_id, quiz_question_id, quiz_option_id, is_correct
literacy_schedules
├── id, user_id, title, description, scheduled_date, scheduled_time
experts
├── id, name, specialization, avatar, whatsapp_number, is_active
favorites (polymorphic)
└── id, user_id, favoritable_type, favoritable_id
```

---

## 9. Keamanan & Validasi

| Area                 | Implementasi                                          |
| -------------------- | ----------------------------------------------------- |
| Autentikasi          | Laravel Sanctum Bearer Token                          |
| Otorisasi            | Middleware `auth:sanctum` pada semua protected routes |
| Ownership            | Manual check `user_id === auth user id` di controller |
| Input validation     | Form Request classes per endpoint                     |
| File upload          | Validasi tipe (`image`) dan ukuran (`max:2048`)       |
| Database transaction | Digunakan pada quiz submit untuk konsistensi data     |
| SQL Injection        | Terlindungi via Eloquent ORM                          |

---

## 10. API Endpoint Summary

### Public Endpoints (24 total)

| Method | Endpoint                  | Deskripsi       |
| ------ | ------------------------- | --------------- |
| `POST` | `/api/v1/register`        | Registrasi user |
| `POST` | `/api/v1/login`           | Login           |
| `GET`  | `/api/v1/articles`        | Daftar artikel  |
| `GET`  | `/api/v1/articles/{slug}` | Detail artikel  |
| `GET`  | `/api/v1/wawasan`         | Daftar wawasan  |
| `GET`  | `/api/v1/wawasan/{slug}`  | Detail wawasan  |
| `GET`  | `/api/v1/videos`          | Daftar video    |
| `GET`  | `/api/v1/videos/{slug}`   | Detail video    |
| `GET`  | `/api/v1/quizzes`         | Daftar kuis     |
| `GET`  | `/api/v1/quizzes/{slug}`  | Detail kuis     |
| `GET`  | `/api/v1/experts`         | Daftar ahli     |
| `GET`  | `/api/v1/experts/{id}`    | Detail ahli     |

### Protected Endpoints (requires Bearer Token)

| Method   | Endpoint                        | Deskripsi      |
| -------- | ------------------------------- | -------------- |
| `POST`   | `/api/v1/logout`                | Logout         |
| `GET`    | `/api/v1/profile`               | Lihat profil   |
| `POST`   | `/api/v1/profile`               | Update profil  |
| `POST`   | `/api/v1/quizzes/{slug}/submit` | Submit kuis    |
| `GET`    | `/api/v1/quiz-history`          | Riwayat kuis   |
| `GET`    | `/api/v1/schedules`             | Daftar jadwal  |
| `POST`   | `/api/v1/schedules`             | Buat jadwal    |
| `GET`    | `/api/v1/schedules/{id}`        | Detail jadwal  |
| `PUT`    | `/api/v1/schedules/{id}`        | Update jadwal  |
| `DELETE` | `/api/v1/schedules/{id}`        | Hapus jadwal   |
| `GET`    | `/api/v1/favorites`             | Daftar favorit |
| `POST`   | `/api/v1/favorites/toggle`      | Toggle favorit |

---

## 11. Potensi Peningkatan (Future Backlog)

| Prioritas | Item                                                                            |
| --------- | ------------------------------------------------------------------------------- |
| Tinggi    | Sembunyikan `is_correct` dari response detail kuis (hanya kirim setelah submit) |
| Tinggi    | Rate limiting pada endpoint auth (throttle)                                     |
| Sedang    | Email verification setelah registrasi                                           |
| Sedang    | Filter video berdasarkan kategori (saat ini tidak ada kategori di video)        |
| Sedang    | Endpoint search global lintas konten                                            |
| Rendah    | Caching pada konten publik (articles, videos)                                   |
| Rendah    | API versioning strategy (v2)                                                    |
| Rendah    | Webhook / push notification untuk reminder jadwal                               |

---

## 12. Kriteria Penerimaan (Definition of Done)

- [x] Semua endpoint terdaftar di `routes/api.php`
- [x] Setiap endpoint memiliki controller method yang teriimplementasi
- [x] Form Request validation untuk semua input
- [x] API Resource transformers untuk semua model respons
- [x] Autentikasi Sanctum diterapkan pada semua protected route
- [x] Ownership check pada resource private (schedule, favorite)
- [x] Database transaction pada operasi multi-tabel (quiz submit)
- [x] Admin panel (Filament) untuk semua 8 resource konten
- [x] README terdokumentasi lengkap dengan contoh request/response
- [ ] Unit & Feature tests untuk semua endpoint
- [ ] Environment production dikonfigurasi (APP_ENV, DB, queue)
