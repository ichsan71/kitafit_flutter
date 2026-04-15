# 🔧 Firebase Initialization Guide - Step by Step

Panduan lengkap setup Firebase initialization seperti yang ditunjukkan di gambar dokumentasi Firebase.

---

## 📝 Langkah 1: Import Required Packages

Di file `lib/main.dart`, tambahkan import berikut:

```dart
import 'package:firebase_core/firebase_core.dart';
import 'package:todo_clean_bloc/firebase_options.dart';
```

**Penjelasan:**

- `firebase_core`: Package utama Firebase untuk Dart/Flutter
- `firebase_options.dart`: File konfigurasi yang di-generate oleh FlutterFire CLI

---

## 📝 Langkah 2: Initialize Firebase di main()

Update function `main()` untuk initialize Firebase:

```dart
void main() async {
  // 1. Ensure Flutter bindings initialized
  WidgetsFlutterBinding.ensureInitialized();

  // 2. Initialize Firebase with platform-specific options
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // 3. Initialize app dependencies
  await initDependencies();

  // 4. Run the app
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => serviceLocator<AppUserCubit>()),
        BlocProvider(create: (_) => serviceLocator<AuthBloc>()),
        BlocProvider(create: (_) => serviceLocator<NavigationBloc>()),
      ],
      child: const MyApp(),
    ),
  );
}
```

**Penjelasan Setiap Step:**

1. **WidgetsFlutterBinding.ensureInitialized()**

   - Memastikan Flutter bindings sudah siap sebelum Firebase init
   - WAJIB di-call sebelum semua async operations

2. **Firebase.initializeApp()**

   - Melakukan inisialisasi Firebase dengan konfigurasi platform
   - `DefaultFirebaseOptions.currentPlatform` secara otomatis memilih config yang tepat berdasarkan platform yang sedang berjalan (Android, iOS, Web, dll)

3. **await initDependencies()**

   - Melakukan dependency injection setup setelah Firebase siap

4. **runApp()**
   - Menjalankan Flutter app dengan bloc providers

---

## 📝 Langkah 3: Firebase Options File

File `lib/firebase_options.dart` sudah di-generate dan berisi:

```dart
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        return windows;
      case TargetPlatform.linux:
        throw UnsupportedError(...);
      default:
        throw UnsupportedError(...);
    }
  }

  static const FirebaseOptions web = FirebaseOptions(...);
  static const FirebaseOptions android = FirebaseOptions(...);
  static const FirebaseOptions ios = FirebaseOptions(...);
  static const FirebaseOptions macos = FirebaseOptions(...);
  static const FirebaseOptions windows = FirebaseOptions(...);
}
```

**Fungsi:**

- Menyimpan API keys dan configuration untuk setiap platform
- Secara otomatis memilih config yang benar saat runtime
- File ini di-generate oleh `flutterfire configure` command

---

## 📝 Langkah 4: Register Firebase Services di Dependency Injection

Update `lib/init_dependency.dart`:

```dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> initDependencies() async {
  _initAuth();
  _initNavigation();

  // Register Firebase services untuk diakses di seluruh app
  serviceLocator.registerLazySingleton(() => FirebaseAuth.instance);
  serviceLocator.registerLazySingleton(() => FirebaseFirestore.instance);

  // Register AppUserCubit
  serviceLocator.registerLazySingleton(() => AppUserCubit());
}
```

**Penjelasan:**

- `FirebaseAuth.instance` - Singleton instance untuk Firebase Authentication
- `FirebaseFirestore.instance` - Singleton instance untuk Firestore Database
- `registerLazySingleton` - Service hanya di-instantiate saat pertama kali diakses
- Konsistensi: Gunakan instance yang sama di seluruh app

---

## 📝 Langkah 5: Using Firebase Services

### Menggunakan FirebaseAuth:

```dart
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final FirebaseAuth firebaseAuth;

  AuthRemoteDataSourceImpl({required this.firebaseAuth});

  // Sign up
  Future<UserModel> signUpWithEmailAndPassword(...) async {
    final response = await firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    return UserModel(...);
  }

  // Sign in
  Future<UserModel> signInWithEmailAndPassword(...) async {
    final response = await firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return UserModel(...);
  }

  // Sign out
  Future<void> signOut() async {
    await firebaseAuth.signOut();
  }

  // Get current user
  User? get currentUser => firebaseAuth.currentUser;
}
```

### Menggunakan Firestore:

```dart
class AuthRemoteDataSourceImpl {
  final FirebaseFirestore firebaseFirestore;

  // Create user profile
  Future<void> createUserProfile({
    required String userId,
    required String name,
    required String email,
  }) async {
    await firebaseFirestore
        .collection('profiles')
        .doc(userId)
        .set({
          'id': userId,
          'name': name,
          'email': email,
          'createdAt': FieldValue.serverTimestamp(),
        });
  }

  // Get user profile
  Future<Map<String, dynamic>?> getUserProfile(String userId) async {
    final doc = await firebaseFirestore
        .collection('profiles')
        .doc(userId)
        .get();

    if (doc.exists) {
      return doc.data();
    }
    return null;
  }
}
```

---

## 🔄 Complete Application Flow

```
main()
  ↓
WidgetsFlutterBinding.ensureInitialized()
  ↓
Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform
)
  ↓ (Reads firebase_options.dart)
  ├─ Web? → Use Web config
  ├─ Android? → Use Android config
  ├─ iOS? → Use iOS config
  └─ ...
  ↓
initDependencies()
  ↓
  ├─ Register FirebaseAuth.instance
  ├─ Register FirebaseFirestore.instance
  └─ Register other services
  ↓
runApp()
  ↓
  ├─ BlocProvider(AppUserCubit)
  ├─ BlocProvider(AuthBloc)
  ├─ BlocProvider(NavigationBloc)
  └─ MyApp()
```

---

## ⚙️ Configuration Files Required

### 1. **android/app/google-services.json**

```json
{
  "type": "service_account",
  "project_id": "kitafit-c0a1e",
  "private_key_id": "...",
  "private_key": "...",
  "client_email": "...",
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://oauth2.googleapis.com/token",
  "auth_provider_x509_cert_url": "...",
  "client_x509_cert_url": "..."
}
```

**Dari mana download?**

- Firebase Console → Project Settings → Service Accounts → Generate New Private Key
- Atau: Project Settings → General → Scroll down → Download google-services.json

### 2. **ios/Runner/GoogleService-Info.plist**

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>CLIENT_ID</key>
  <string>...</string>
  <key>REVERSED_CLIENT_ID</key>
  <string>...</string>
  <key>GOOGLE_APP_ID</key>
  <string>...</string>
  <key>PLIST_VERSION</key>
  <string>1</string>
  <key>BUNDLE_ID</key>
  <string>com.example.todoCleanBloc</string>
  <key>PROJECT_ID</key>
  <string>kitafit-c0a1e</string>
  <key>STORAGE_BUCKET</key>
  <string>kitafit-c0a1e.firebasestorage.app</string>
  <key>IS_GCM_ENABLED</key>
  <true/>
  <key>IS_SIGNIN_ENABLED</key>
  <true/>
  <key>GCM_SENDER_ID</key>
  <string>...</string>
  <key>GOOGLE_APP_ID</key>
  <string>...</string>
</dict>
</plist>
```

---

## 🧪 Testing Firebase Initialization

### Test 1: Verify Firebase Initialized

```dart
import 'package:firebase_core/firebase_core.dart';

void testFirebaseInitialization() {
  final isInitialized = Firebase.apps.isNotEmpty;
  print('Firebase initialized: $isInitialized');

  if (isInitialized) {
    final app = Firebase.apps.first;
    print('App name: ${app.name}');
  }
}
```

### Test 2: Verify Services Registered

```dart
void testServiceLocator() {
  final auth = serviceLocator<FirebaseAuth>();
  final firestore = serviceLocator<FirebaseFirestore>();

  print('FirebaseAuth: $auth');
  print('FirebaseFirestore: $firestore');
}
```

### Test 3: Test Sign Up Flow

```dart
Future<void> testSignUp() async {
  try {
    final auth = serviceLocator<FirebaseAuth>();
    final firestore = serviceLocator<FirebaseFirestore>();

    // Create user
    final userCredential = await auth.createUserWithEmailAndPassword(
      email: 'test@example.com',
      password: 'Test@12345',
    );

    // Create profile
    await firestore
        .collection('profiles')
        .doc(userCredential.user!.uid)
        .set({
          'email': 'test@example.com',
          'name': 'Test User',
          'createdAt': FieldValue.serverTimestamp(),
        });

    print('✅ Sign up successful');
  } catch (e) {
    print('❌ Sign up failed: $e');
  }
}
```

---

## 🚨 Common Issues & Solutions

### Issue 1: "Firebase not initialized"

**Cause**: Firebase.initializeApp() tidak di-call di main()
**Solution**:

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // ...
}
```

### Issue 2: "google-services.json not found"

**Cause**: File tidak di-copy ke android/app/
**Solution**: Copy dari Firebase Console ke android/app/google-services.json

### Issue 3: "GoogleService-Info.plist not found"

**Cause**: File tidak di-add ke Xcode project
**Solution**:

1. Copy file dari Firebase Console
2. Buka Xcode
3. Right-click Runner folder
4. "Add Files to Runner"
5. Select GoogleService-Info.plist
6. Check "Copy if needed"

### Issue 4: "Unsupported Platform"

**Cause**: Platform belum di-configure di firebase_options.dart
**Solution**: Run `flutterfire configure` lagi atau manually update firebase_options.dart

---

## 📚 Useful Commands

### Re-generate Firebase Options

```bash
cd /Users/ichsa/mandiri/kitafit/kitafit_flutter
flutterfire configure --project=kitafit-c0a1e
```

### Check Firebase CLI Installation

```bash
firebase --version
```

### List Firebase Projects

```bash
firebase projects:list
```

### Test Firebase Connection

```bash
firebase auth:export debug_users.json --project=kitafit-c0a1e
```

---

## ✅ Checklist

- [x] Firebase packages added to pubspec.yaml
- [x] firebase_options.dart generated
- [x] Firebase.initializeApp() called in main()
- [x] FirebaseAuth dan Firestore registered di DI
- [ ] google-services.json copied to android/app/
- [ ] GoogleService-Info.plist added to ios/Runner/
- [ ] Firestore database created
- [ ] Security rules configured
- [ ] Test sign up/sign in flow
- [ ] Monitor Firebase Console

---

**Next**: Lanjutkan dengan FIREBASE_SETUP.md untuk konfigurasi lebih lanjut!
