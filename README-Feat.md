# Kita Fit — Backend API

REST API backend untuk aplikasi mobile **Kita Fit** (Physical Application of Literacy), dibangun dengan Laravel 13 dan Filament v5 untuk admin panel.

## Tech Stack

| Layer          | Technology                     |
| -------------- | ------------------------------ |
| Framework      | Laravel 13 (PHP 8.3)           |
| Authentication | Laravel Sanctum (Bearer Token) |
| Admin Panel    | Filament v5                    |
| Database       | MySQL                          |

## Instalasi

```bash
# Clone repository
git clone <repo-url> kitafit-be && cd kitafit-be

# Install dependencies
composer install

# Setup environment
cp .env.example .env
php artisan key:generate

# Konfigurasi database di .env
DB_CONNECTION=mysql
DB_HOST=127.0.0.1
DB_PORT=3306
DB_DATABASE=kitafit
DB_USERNAME=root
DB_PASSWORD=

# Jalankan migrasi & seeder
php artisan migrate --seed

# Buat symbolic link untuk storage
php artisan storage:link

# Jalankan server
php artisan serve
```

### Default Admin

| Email               | Password   |
| ------------------- | ---------- |
| `admin@kitafit.com` | `password` |

---

## Arsitektur API

### Base URL

```
http://localhost:8000/api/v1
```

### Response Format

Semua response menggunakan format konsisten:

```json
{
  "success": true,
  "message": "Success",
  "data": { ... }
}
```

Error response:

```json
{
  "success": false,
  "message": "Error message",
  "errors": { ... }
}
```

### Authentication

API menggunakan **Bearer Token** via Laravel Sanctum. Sertakan header berikut untuk endpoint yang memerlukan autentikasi:

```
Authorization: Bearer {token}
```

---

## API Endpoints

### Auth

| Method | Endpoint    | Auth | Deskripsi              |
| ------ | ----------- | ---- | ---------------------- |
| `POST` | `/register` | —    | Registrasi user baru   |
| `POST` | `/login`    | —    | Login & dapatkan token |
| `POST` | `/logout`   | ✅   | Logout & hapus token   |
| `GET`  | `/profile`  | ✅   | Lihat profil user      |
| `POST` | `/profile`  | ✅   | Update profil user     |

#### POST `/register`

**Request Body:**

```json
{
    "name": "John Doe",
    "email": "john@example.com",
    "password": "password123",
    "password_confirmation": "password123",
    "phone": "081234567890"
}
```

**Response (201):**

```json
{
    "success": true,
    "message": "Registration successful",
    "data": {
        "user": {
            "id": 1,
            "name": "John Doe",
            "email": "john@example.com",
            "phone": "081234567890",
            "avatar": null,
            "role": "user"
        },
        "token": "1|abc123..."
    }
}
```

#### POST `/login`

**Request Body:**

```json
{
    "email": "john@example.com",
    "password": "password123"
}
```

**Response (200):**

```json
{
  "success": true,
  "message": "Login successful",
  "data": {
    "user": { ... },
    "token": "2|xyz789..."
  }
}
```

#### POST `/profile` (Update)

**Headers:** `Authorization: Bearer {token}`, `Content-Type: multipart/form-data`

| Field      | Type   | Rules                      |
| ---------- | ------ | -------------------------- |
| `name`     | string | opsional, max 255          |
| `phone`    | string | opsional, max 20           |
| `avatar`   | file   | opsional, image, max 2MB   |
| `password` | string | opsional, min 8, confirmed |

---

### Artikel

| Method | Endpoint           | Auth | Deskripsi          |
| ------ | ------------------ | ---- | ------------------ |
| `GET`  | `/articles`        | —    | List semua artikel |
| `GET`  | `/articles/{slug}` | —    | Detail artikel     |

#### GET `/articles`

**Query Parameters:**

| Param      | Type    | Deskripsi                        |
| ---------- | ------- | -------------------------------- |
| `search`   | string  | Cari berdasarkan judul           |
| `category` | string  | Filter berdasarkan category slug |
| `per_page` | integer | Jumlah per halaman (default: 15) |

**Response (200):**

```json
{
  "success": true,
  "message": "Success",
  "data": {
    "data": [
      {
        "id": 1,
        "title": "Pentingnya Literasi Fisik",
        "slug": "pentingnya-literasi-fisik",
        "excerpt": "...",
        "thumbnail": "http://localhost:8000/storage/articles/image.jpg",
        "category": { "id": 1, "name": "Kesehatan" },
        "author": { "id": 1, "name": "Admin" },
        "published_at": "2024-01-15T10:00:00.000000Z"
      }
    ],
    "links": { ... },
    "meta": { "current_page": 1, "last_page": 2, "total": 20 }
  }
}
```

> **Catatan:** Field `content` hanya muncul pada endpoint detail (`/articles/{slug}`).

---

### Wawasan (Insights)

| Method | Endpoint          | Auth | Deskripsi          |
| ------ | ----------------- | ---- | ------------------ |
| `GET`  | `/wawasan`        | —    | List semua wawasan |
| `GET`  | `/wawasan/{slug}` | —    | Detail wawasan     |

**Query Parameters:** Sama seperti Artikel (`search`, `category`, `per_page`).

---

### Video

| Method | Endpoint         | Auth | Deskripsi        |
| ------ | ---------------- | ---- | ---------------- |
| `GET`  | `/videos`        | —    | List semua video |
| `GET`  | `/videos/{slug}` | —    | Detail video     |

**Query Parameters:**

| Param      | Type    | Deskripsi                        |
| ---------- | ------- | -------------------------------- |
| `search`   | string  | Cari berdasarkan judul           |
| `per_page` | integer | Jumlah per halaman (default: 15) |

**Response item:**

```json
{
    "id": 1,
    "title": "Tutorial Stretching Pagi",
    "slug": "tutorial-stretching-pagi",
    "description": "...",
    "thumbnail": "http://localhost:8000/storage/videos/thumb.jpg",
    "video_url": "https://youtube.com/watch?v=...",
    "duration": 300,
    "published_at": "2024-01-15T10:00:00.000000Z"
}
```

---

### Kuis

| Method | Endpoint                 | Auth | Deskripsi                       |
| ------ | ------------------------ | ---- | ------------------------------- |
| `GET`  | `/quizzes`               | —    | List semua kuis                 |
| `GET`  | `/quizzes/{slug}`        | —    | Detail kuis + pertanyaan & opsi |
| `POST` | `/quizzes/{slug}/submit` | ✅   | Submit jawaban kuis             |
| `GET`  | `/quiz-history`          | ✅   | Riwayat kuis user               |

#### GET `/quizzes/{slug}`

**Response (200):**

```json
{
    "success": true,
    "data": {
        "id": 1,
        "title": "Kuis Literasi Fisik",
        "slug": "kuis-literasi-fisik",
        "description": "...",
        "questions": [
            {
                "id": 1,
                "question": "Apa manfaat olahraga rutin?",
                "options": [
                    {
                        "id": 1,
                        "option_text": "Meningkatkan stamina",
                        "is_correct": true
                    },
                    {
                        "id": 2,
                        "option_text": "Mengurangi waktu tidur",
                        "is_correct": false
                    }
                ]
            }
        ]
    }
}
```

#### POST `/quizzes/{slug}/submit`

**Request Body:**

```json
{
    "answers": [
        { "question_id": 1, "option_id": 1 },
        { "question_id": 2, "option_id": 5 }
    ]
}
```

**Response (200):**

```json
{
    "success": true,
    "message": "Quiz submitted",
    "data": {
        "id": 1,
        "quiz": { "id": 1, "title": "Kuis Literasi Fisik" },
        "score": 4,
        "total_questions": 5,
        "completed_at": "2024-01-15T10:30:00.000000Z"
    }
}
```

---

### Jadwal Literasi

| Method   | Endpoint          | Auth | Deskripsi        |
| -------- | ----------------- | ---- | ---------------- |
| `GET`    | `/schedules`      | ✅   | List jadwal user |
| `POST`   | `/schedules`      | ✅   | Buat jadwal baru |
| `GET`    | `/schedules/{id}` | ✅   | Detail jadwal    |
| `PUT`    | `/schedules/{id}` | ✅   | Update jadwal    |
| `DELETE` | `/schedules/{id}` | ✅   | Hapus jadwal     |

#### GET `/schedules`

**Query Parameters:**

| Param      | Type         | Deskripsi                        |
| ---------- | ------------ | -------------------------------- |
| `date`     | date (Y-m-d) | Filter berdasarkan tanggal       |
| `upcoming` | boolean      | Tampilkan jadwal mendatang saja  |
| `per_page` | integer      | Jumlah per halaman (default: 15) |

#### POST `/schedules`

**Request Body:**

```json
{
    "title": "Latihan Yoga",
    "description": "Yoga pagi di taman",
    "scheduled_date": "2024-02-01",
    "scheduled_time": "07:00"
}
```

---

### Chat Ahli (Experts)

| Method | Endpoint        | Auth | Deskripsi                   |
| ------ | --------------- | ---- | --------------------------- |
| `GET`  | `/experts`      | —    | List semua ahli aktif       |
| `GET`  | `/experts/{id}` | —    | Detail ahli + link WhatsApp |

**Response item:**

```json
{
    "id": 1,
    "name": "Dr. Siti Rahmawati",
    "specialization": "Fisioterapi",
    "avatar": "http://localhost:8000/storage/experts/avatar.jpg",
    "whatsapp_number": "6281234567890",
    "whatsapp_url": "https://wa.me/6281234567890",
    "is_active": true
}
```

> Gunakan `whatsapp_url` untuk redirect langsung ke WhatsApp.

---

### Favorit

| Method | Endpoint            | Auth | Deskripsi                     |
| ------ | ------------------- | ---- | ----------------------------- |
| `GET`  | `/favorites`        | ✅   | List favorit user             |
| `POST` | `/favorites/toggle` | ✅   | Toggle favorit (tambah/hapus) |

#### GET `/favorites`

**Query Parameters:**

| Param  | Type   | Deskripsi                                     |
| ------ | ------ | --------------------------------------------- |
| `type` | string | Filter: `article`, `wawasan`, `video`, `quiz` |

#### POST `/favorites/toggle`

**Request Body:**

```json
{
    "favoritable_type": "article",
    "favoritable_id": 1
}
```

**Response:**

```json
{
    "success": true,
    "message": "Added to favorites",
    "data": { "is_favorited": true }
}
```

Kirim request yang sama untuk menghapus dari favorit (toggle).

---

## Admin Panel (Filament)

### Akses

```
http://localhost:8000/admin
```

Login menggunakan akun admin.

### Resource Management

| Resource           | Path                        | Deskripsi                            |
| ------------------ | --------------------------- | ------------------------------------ |
| Users              | `/admin/users`              | Kelola user & role (admin/user)      |
| Categories         | `/admin/categories`         | Kelola kategori artikel & wawasan    |
| Articles           | `/admin/articles`           | CRUD artikel dengan rich text editor |
| Wawasan            | `/admin/wawasans`           | CRUD wawasan/insights                |
| Videos             | `/admin/videos`             | Kelola konten video                  |
| Quizzes            | `/admin/quizzes`            | Kelola kuis & pertanyaan (nested)    |
| Experts            | `/admin/experts`            | Kelola data ahli & nomor WhatsApp    |
| Literacy Schedules | `/admin/literacy-schedules` | Lihat & kelola jadwal user           |

### Fitur Admin

- **Auto-slug generation** — Slug otomatis di-generate dari judul
- **Rich Text Editor** — Editor WYSIWYG untuk konten artikel & wawasan
- **Image Upload** — Upload thumbnail & avatar via Filament
- **Nested Relations** — Pertanyaan kuis dikelola langsung dari halaman kuis
- **Search & Filter** — Pencarian dan filter di setiap tabel
- **Bulk Actions** — Hapus massal di semua resource

---

## Database Schema

```
users
├── categories (type: article/wawasan)
├── articles → belongs to category, author (user)
├── wawasans → belongs to category, author (user)
├── videos
├── quizzes
│   ├── quiz_questions
│   │   └── quiz_options
│   └── quiz_attempts → belongs to user
│       └── quiz_answers
├── literacy_schedules → belongs to user
├── experts
└── favorites (polymorphic: article/wawasan/video/quiz)
```

## Struktur Folder

```
app/
├── Filament/Resources/          # 8 Filament admin resources
├── Http/
│   ├── Controllers/Api/         # 8 API controllers
│   ├── Requests/                # 7 form request validators
│   └── Resources/               # 12 API resource transformers
├── Models/                      # 13 Eloquent models
database/
├── factories/                   # 8 model factories
├── migrations/                  # 11 migration files
└── seeders/                     # Database seeder
routes/
└── api.php                      # 24 API endpoints
```

## Testing

```bash
php artisan test
```

## License

[MIT](https://opensource.org/licenses/MIT)
