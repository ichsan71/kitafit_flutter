# Quick Start Guide - Bottom Navigation

## 🚀 Getting Started

### 1. Run the App

```bash
flutter pub get
flutter run
```

### 2. Navigation Structure

#### Main App (with Bottom Nav):

- **Beranda** (`/`) - Dashboard utama
- **Mulai Literasi** (`/literation`) - Halaman pembelajaran
- **Saya** (`/profile`) - Profil pengguna

#### Auth (without Bottom Nav):

- **Sign In** (`/signin`) - Login
- **Sign Up** (`/signup`) - Register

## 📝 Common Tasks

### Navigate to a Page

```dart
import 'package:go_router/go_router.dart';
import 'package:todo_clean_bloc/core/navigation/router/app_router.dart';

// In your widget:
context.go(AppRouter.dashboard);   // Go to Dashboard
context.go(AppRouter.literation);  // Go to Literation
context.go(AppRouter.profile);     // Go to Profile
```

### Access Current Tab Index

```dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_clean_bloc/core/navigation/bloc/navigation_bloc.dart';
import 'package:todo_clean_bloc/core/navigation/bloc/navigation_state.dart';

// In your widget:
BlocBuilder<NavigationBloc, NavigationState>(
  builder: (context, state) {
    final currentIndex = state.selectedIndex;
    // Use currentIndex
    return YourWidget();
  },
)
```

### Change Tab Programmatically

```dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_clean_bloc/core/navigation/bloc/navigation_bloc.dart';
import 'package:todo_clean_bloc/core/navigation/bloc/navigation_event.dart';

// In your widget:
context.read<NavigationBloc>().add(NavigationTabChanged(0)); // Beranda
context.read<NavigationBloc>().add(NavigationTabChanged(1)); // Literasi
context.read<NavigationBloc>().add(NavigationTabChanged(2)); // Profile
```

### Add New Route

**Step 1:** Add route constant in `app_router.dart`

```dart
class AppRouter {
  // ... existing routes
  static const String newPage = '/new-page';
```

**Step 2:** Add route configuration

```dart
GoRoute(
  path: newPage,
  name: 'newPage',
  pageBuilder: (context, state) => NoTransitionPage(
    key: state.pageKey,
    child: const NewPage(),
  ),
),
```

**Step 3:** Navigate to new route

```dart
context.go(AppRouter.newPage);
```

### Add New Bottom Nav Tab

**Step 1:** Update `custom_bottom_nav_bar.dart`

```dart
Row(
  mainAxisAlignment: MainAxisAlignment.spaceAround,
  children: [
    _buildNavItem(context: context, index: 0, ...),
    _buildNavItem(context: context, index: 1, ...),
    _buildNavItem(context: context, index: 2, ...),
    _buildNavItem(context: context, index: 3, ...), // New tab
  ],
)
```

**Step 2:** Update navigation logic in `main_shell.dart`

```dart
void _onItemTapped(BuildContext context, int index) {
  context.read<NavigationBloc>().add(NavigationTabChanged(index));

  switch (index) {
    case 0:
      context.go(AppRouter.dashboard);
      break;
    case 1:
      context.go(AppRouter.literation);
      break;
    case 2:
      context.go(AppRouter.profile);
      break;
    case 3:
      context.go(AppRouter.newPage); // Add new case
      break;
  }
}
```

## 🎨 Customization

### Change Bottom Nav Colors

Edit `custom_bottom_nav_bar.dart`:

```dart
final Color primaryColor = AppPalette.primary;      // Active color
final Color inactiveColor = Colors.grey.shade600;   // Inactive color
```

### Change Tab Icons

Edit `custom_bottom_nav_bar.dart`:

```dart
_buildNavItem(
  context: context,
  index: 0,
  icon: Icons.your_icon_outlined,      // Inactive icon
  activeIcon: Icons.your_icon,         // Active icon
  label: 'Your Label',
),
```

### Remove Tab Transition Animation

Already implemented! Using `NoTransitionPage` in route configuration.

## 🐛 Troubleshooting

### Bottom Nav Not Showing

✅ Make sure your route is inside the `ShellRoute` in `app_router.dart`

### Wrong Tab Selected

✅ Check that you're using the correct index in `NavigationTabChanged` event

### Navigation Not Working

✅ Use `context.go()` instead of `Navigator.push()`
✅ Make sure route is defined in `app_router.dart`

### State Not Updating

✅ Ensure `NavigationBloc` is provided in `main.dart`
✅ Use `BlocBuilder` to listen to state changes

## 📚 Key Files Reference

| File                         | Purpose                     |
| ---------------------------- | --------------------------- |
| `app_router.dart`            | Route definitions           |
| `navigation_bloc.dart`       | Navigation state management |
| `main_shell.dart`            | Bottom nav wrapper          |
| `custom_bottom_nav_bar.dart` | Bottom nav UI               |
| `main.dart`                  | App entry point             |

## 🎯 Best Practices

1. ✅ Always use `context.go()` for navigation
2. ✅ Define route constants in `AppRouter` class
3. ✅ Use `NoTransitionPage` for tabs to avoid animation
4. ✅ Keep navigation logic in `main_shell.dart`
5. ✅ Keep UI in `custom_bottom_nav_bar.dart`
6. ✅ Use BLoC for state management
7. ✅ Follow Clean Architecture principles

## 🔗 Navigation Methods

| Method           | Use Case                | Example                    |
| ---------------- | ----------------------- | -------------------------- |
| `context.go()`   | Replace current route   | `context.go('/dashboard')` |
| `context.push()` | Add to navigation stack | `context.push('/detail')`  |
| `context.pop()`  | Go back                 | `context.pop()`            |

---

For more details, see `NAVIGATION_README.md`
