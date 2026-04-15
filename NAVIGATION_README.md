# Bottom Navigation Implementation

## Overview

Implementasi bottom navigation bar menggunakan **go_router** dengan prinsip **Clean Architecture** dan **BLoC pattern**.

## Tech Stack

- **Navigation Framework**: `go_router` v17.0.0
- **Architecture**: Clean Architecture (Presentation Layer)
- **State Management**: BLoC untuk UI state (NavigationBloc)
- **Pattern**: ShellRoute + BottomNavigationBar

## Struktur Folder

```
lib/
├── core/
│   └── navigation/
│       ├── bloc/
│       │   ├── navigation_bloc.dart      # BLoC untuk mengelola navigation state
│       │   ├── navigation_event.dart     # Navigation events
│       │   └── navigation_state.dart     # Navigation states
│       ├── router/
│       │   └── app_router.dart           # Konfigurasi routing aplikasi
│       └── widgets/
│           ├── custom_bottom_nav_bar.dart # Widget bottom navigation
│           └── main_shell.dart           # Shell wrapper untuk main screens
├── features/
│   ├── dashboard/
│   │   └── presentation/
│   │       └── pages/
│   │           └── dashboard_page.dart   # Halaman Beranda
│   ├── literation/
│   │   └── presentation/
│   │       └── pages/
│   │           └── literation_page.dart  # Halaman Mulai Literasi
│   └── profile/
│       └── presentation/
│           └── pages/
│               └── profile_page.dart     # Halaman Saya (Profile)
```

## Fitur Utama

### 1. Navigation BLoC

- Mengelola state tab yang sedang aktif
- Mengikuti prinsip SOLID (Single Responsibility)
- Terpisah dari logic bisnis lainnya

### 2. Router Configuration (`app_router.dart`)

- Menggunakan `ShellRoute` untuk persistent bottom navigation
- Pemisahan route auth dan route main app
- No transition animation untuk smooth navigation
- Routes:
  - `/` - Dashboard (Beranda)
  - `/literation` - Mulai Literasi
  - `/profile` - Saya (Profile)
  - `/signin` - Login (tanpa bottom nav)
  - `/signup` - Register (tanpa bottom nav)

### 3. Custom Bottom Navigation Bar

- Desain sesuai dengan gambar referensi
- 3 tab: Beranda, Mulai Literasi, Saya
- Highlighted icon untuk tab "Mulai Literasi"
- Icon dengan background rounded untuk tab aktif
- Smooth transitions

### 4. Main Shell

- Wrapper untuk semua halaman dengan bottom navigation
- Menangani navigation logic
- Integration dengan NavigationBloc

## Cara Penggunaan

### Navigation

```dart
// Navigate to a route
context.go(AppRouter.dashboard);
context.go(AppRouter.literation);
context.go(AppRouter.profile);

// Navigate dengan parameter
context.push('/detail/${id}');
```

### Menambah Route Baru

1. Tambahkan route constant di `app_router.dart`:

```dart
static const String newRoute = '/new-route';
```

2. Tambahkan route configuration:

```dart
GoRoute(
  path: newRoute,
  name: 'newRoute',
  pageBuilder: (context, state) => NoTransitionPage(
    key: state.pageKey,
    child: const NewPage(),
  ),
),
```

3. Update navigation logic di `main_shell.dart` jika perlu menambah tab baru.

## Prinsip SOLID yang Diimplementasikan

1. **Single Responsibility Principle**

   - Router: hanya menangani routing
   - NavigationBloc: hanya menangani state navigasi
   - CustomBottomNavBar: hanya menampilkan UI bottom nav

2. **Open/Closed Principle**

   - Mudah menambahkan route baru tanpa mengubah kode existing

3. **Dependency Inversion Principle**
   - Menggunakan dependency injection (GetIt)
   - NavigationBloc diregistrasi di service locator

## Dependency Injection

NavigationBloc didaftarkan di `init_dependency.dart`:

```dart
void _initNavigation() {
  serviceLocator.registerLazySingleton(() => NavigationBloc());
}
```

Dan di-provide di `main.dart`:

```dart
MultiBlocProvider(
  providers: [
    BlocProvider(create: (_) => serviceLocator<NavigationBloc>()),
    // ... other blocs
  ],
  child: const MyApp(),
)
```

## Authentication Flow

1. App start → check auth state
2. Authenticated → Dashboard (dengan bottom nav)
3. Not authenticated → SignIn page (tanpa bottom nav)
4. After login → Navigate to Dashboard dengan `context.go(AppRouter.dashboard)`

## Catatan

- `NoTransitionPage` digunakan untuk menghilangkan animasi transisi antar tab
- Shell route memastikan bottom navigation tetap terlihat di semua main screens
- Auth pages (signin/signup) tidak menggunakan shell, sehingga tidak menampilkan bottom nav
