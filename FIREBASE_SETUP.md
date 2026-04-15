# Setup Firebase untuk KitaFit

Dokumentasi lengkap setup Firebase initialization di project Flutter KitaFit dari Supabase ke Firebase.

## ✅ Yang Sudah Dikonfigurasi

### 1. Firebase Initialization File

File `lib/firebase_options.dart` sudah di-generate oleh FlutterFire CLI dengan configuration untuk semua platform:

- **Web**: API Key dan Auth Domain
- **Android**: API Key
- **iOS**: API Key dan Bundle ID
- **macOS**: API Key dan Bundle ID
- **Windows**: API Key

**Project Firebase ID**: `kitafit-c0a1e`

### 2. Dependencies Update (`pubspec.yaml`)

✅ Supabase dihapus
✅ Firebase packages ditambahkan:

```yaml
firebase_core: ^4.2.1
firebase_auth: ^6.1.2
cloud_firestore: ^6.1.0
```

### 3. Main.dart Update

✅ Firebase initialization ditambahkan di `main()`:

```dart
import 'package:firebase_core/firebase_core.dart';
import 'package:todo_clean_bloc/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await initDependencies();
  // ...
}
```

### 4. Dependency Injection (`init_dependency.dart`)

✅ Firebase services diregistrasi:

```dart
serviceLocator.registerLazySingleton(() => FirebaseAuth.instance);
serviceLocator.registerLazySingleton(() => FirebaseFirestore.instance);
```

### 5. Auth Data Source Update

✅ `auth_remote_data_source.dart` diupdate untuk Firebase:

- `SignIn`: Menggunakan `FirebaseAuth.signInWithEmailAndPassword()`
- `SignUp`: Menggunakan `FirebaseAuth.createUserWithEmailAndPassword()`
- `SignOut`: Menggunakan `FirebaseAuth.signOut()`
- `GetCurrentUser`: Menggunakan Firestore untuk retrieve profile

### 6. Repository Update

✅ `auth_repository_impl.dart` diupdate untuk menangani Firebase exceptions

---

## 📱 Platform-Specific Setup

### Android Setup

File `google-services.json` sudah harus ada di `android/app/`

**Jika belum ada:**

1. Buka [Firebase Console](https://console.firebase.google.com)
2. Pilih project `kitafit-c0a1e`
3. Go to Settings → Download `google-services.json`
4. Copy ke `android/app/`

### iOS Setup

File `GoogleService-Info.plist` sudah harus ada di `ios/Runner/`

**Jika belum ada:**

1. Buka [Firebase Console](https://console.firebase.google.com)
2. Pilih project `kitafit-c0a1e`
3. Go to Settings → Download `GoogleService-Info.plist`
4. Copy ke `ios/Runner/` dan add ke Xcode project

---

## 🗄️ Firestore Database Structure

### Collections yang diperlukan:

#### `profiles` Collection

```
profiles/
├── {userId}/
│   ├── id: string (user ID)
│   ├── name: string
│   ├── email: string
│   └── createdAt: timestamp
```

**Security Rules:**

```json
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /profiles/{userId} {
      allow read, write: if request.auth.uid == userId;
    }
  }
}
```

---

## 🔄 Firestore Indexes (jika diperlukan)

Jika ada query kompleks, buat index di Firestore Console:

- Composite indexes untuk query dengan multiple conditions

---

## 🧪 Testing Firebase Setup

### 1. Test Sign Up

```dart
// Sign up baru user
await authBloc.add(UserSignUpEvent(
  name: 'Test User',
  email: 'test@example.com',
  password: 'password123',
));
```

### 2. Test Sign In

```dart
// Sign in existing user
await authBloc.add(UserSignInEvent(
  email: 'test@example.com',
  password: 'password123',
));
```

### 3. Check Current User

Setiap kali app di-launch, `AuthCheckCurrentUser()` akan otomatis check jika ada user yang logged in.

---

## 🔧 Konfigurasi Firebase Console

### Required Settings:

1. **Authentication**

   - ✅ Email/Password provider (sudah di-setup)
   - Optional: Google Sign-In, Facebook, dll

2. **Firestore Database**

   - ✅ Create database dengan production mode
   - ✅ Set Security Rules (lihat section diatas)

3. **Storage** (opsional, untuk profile picture)
   - Upload files user

---

## 📝 User Model Structure

Saat ini, `UserModel` menggunakan struktur:

```dart
class UserModel extends User {
  final String id;
  final String email;
  final String name;
}
```

Jika ingin menambah field di Firestore (contoh: age, bio, profile_picture_url):

1. Update `profiles` collection structure
2. Update `UserModel` dan `User` entity
3. Update `UserModel.fromJson()` method

---

## 🚀 Next Steps (Migrasi Data)

Untuk migrasi data dari Supabase ke Firestore:

1. **Export data dari Supabase**

   - Gunakan Supabase API/CLI

2. **Transform format data**

   - Sesuaikan dengan Firestore structure

3. **Import ke Firestore**
   - Gunakan Firebase Admin SDK atau bulk upload via Console

---

## ⚠️ Important Notes

1. **API Keys**: Sudah tersimpan di `firebase_options.dart`, aman untuk public usage
2. **Security Rules**: Pastikan sudah set dengan benar untuk protect user data
3. **User Profile**: Di-create otomatis di `profiles` collection saat sign up
4. **Session Persistence**: Firebase handle persistence otomatis (on-device)

---

## 🐛 Troubleshooting

### Error: "Unsupported Platform"

- Ensure semua platform (android/ios/macos/windows) sudah di-configure
- Jika tidak perlu semua platform, hapus folder yang tidak diperlukan

### Error: "Firebase initialization failed"

- Check network connection
- Verify `google-services.json` dan `GoogleService-Info.plist` ada di tempat yang benar
- Check Firebase Console credentials

### Error: "Permission denied" saat query Firestore

- Check Security Rules
- Verify user sudah authenticated
- Pastikan UID yang diakses sesuai dengan user yang logged in

---

## 📚 Useful Links

- [Firebase Flutter Documentation](https://firebase.flutter.dev/)
- [Firebase Console](https://console.firebase.google.com)
- [Firestore Best Practices](https://firebase.google.com/docs/firestore/best-practices)
- [Firebase Security Rules](https://firebase.google.com/docs/firestore/security/get-started)
