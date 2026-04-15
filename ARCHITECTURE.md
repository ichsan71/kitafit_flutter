# Architecture Diagram

## 📐 Navigation Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                         main.dart                           │
│  ┌───────────────────────────────────────────────────────┐  │
│  │          MultiBlocProvider                            │  │
│  │  - AppUserCubit                                       │  │
│  │  - AuthBloc                                           │  │
│  │  - NavigationBloc ◄── Registered in GetIt            │  │
│  └───────────────────────────────────────────────────────┘  │
│                           │                                 │
│                           ▼                                 │
│                   MaterialApp.router                        │
│                  routerConfig: AppRouter.router             │
└─────────────────────────────────────────────────────────────┘
                            │
                            ▼
┌─────────────────────────────────────────────────────────────┐
│                     app_router.dart                         │
│                                                             │
│  Auth Routes (No Shell)                                    │
│  ┌─────────────────────────┐                               │
│  │ /signin → SigninPage    │                               │
│  │ /signup → SignupPage    │                               │
│  └─────────────────────────┘                               │
│                                                             │
│  Main Routes (With Shell)                                  │
│  ┌─────────────────────────────────────────┐               │
│  │         ShellRoute                      │               │
│  │  ┌────────────────────────────────┐     │               │
│  │  │ / → DashboardPage              │     │               │
│  │  │ /literation → LiterationPage   │     │               │
│  │  │ /profile → ProfilePage         │     │               │
│  │  └────────────────────────────────┘     │               │
│  └─────────────────────────────────────────┘               │
└─────────────────────────────────────────────────────────────┘
                            │
                            ▼
┌─────────────────────────────────────────────────────────────┐
│                     main_shell.dart                         │
│  ┌────────────────────────────────────────────────────┐    │
│  │              MainShell Widget                       │    │
│  │                                                     │    │
│  │  Scaffold(                                          │    │
│  │    body: child, ◄── Current page from router       │    │
│  │    bottomNavigationBar: ┐                          │    │
│  │  )                      │                          │    │
│  └─────────────────────────┼──────────────────────────┘    │
│                            │                                │
│  _onItemTapped() ──────────┤                                │
│    │                       │                                │
│    ├─ Dispatch NavigationTabChanged event                  │
│    └─ context.go(route)    │                                │
└────────────────────────────┼────────────────────────────────┘
                             │
                             ▼
┌─────────────────────────────────────────────────────────────┐
│              custom_bottom_nav_bar.dart                     │
│  ┌────────────────────────────────────────────────────┐    │
│  │         CustomBottomNavBar Widget                  │    │
│  │                                                     │    │
│  │  BlocBuilder<NavigationBloc, NavigationState>      │    │
│  │    │                                               │    │
│  │    └─► Rebuild when state changes                 │    │
│  │                                                     │    │
│  │  Row(                                              │    │
│  │    ┌─────────────────────────────────────┐        │    │
│  │    │ [0] Beranda       (Dashboard)       │        │    │
│  │    │ [1] Mulai Literasi (Literation) ★   │        │    │
│  │    │ [2] Saya          (Profile)         │        │    │
│  │    └─────────────────────────────────────┘        │    │
│  │  )                                                 │    │
│  │                                                     │    │
│  │  onTap: (index) → callback to MainShell           │    │
│  └────────────────────────────────────────────────────┘    │
└─────────────────────────────────────────────────────────────┘
                             │
                             ▼
┌─────────────────────────────────────────────────────────────┐
│                 navigation_bloc.dart                        │
│  ┌────────────────────────────────────────────────────┐    │
│  │          NavigationBloc                            │    │
│  │                                                     │    │
│  │  State: NavigationState(selectedIndex: int)        │    │
│  │                                                     │    │
│  │  Event: NavigationTabChanged(tabIndex: int)        │    │
│  │                                                     │    │
│  │  on<NavigationTabChanged> {                        │    │
│  │    emit(NavigationState(selectedIndex: event.tabIndex)) │
│  │  }                                                 │    │
│  └────────────────────────────────────────────────────┘    │
└─────────────────────────────────────────────────────────────┘
```

## 🔄 Navigation Flow

```
User taps on tab
     │
     ▼
CustomBottomNavBar receives tap
     │
     ▼
MainShell._onItemTapped(index)
     │
     ├─► NavigationBloc.add(NavigationTabChanged(index))
     │       │
     │       ▼
     │   NavigationBloc emits new state
     │       │
     │       ▼
     │   CustomBottomNavBar rebuilds with new selectedIndex
     │
     └─► context.go(AppRouter.route)
             │
             ▼
         go_router navigates to new page
             │
             ▼
         MainShell shows new page in body
             │
             ▼
         Bottom nav stays persistent
```

## 🏗️ Clean Architecture Layers

```
┌──────────────────────────────────────────┐
│         Presentation Layer               │
│  ┌────────────────────────────────────┐  │
│  │  Pages                             │  │
│  │  - DashboardPage                   │  │
│  │  - LiterationPage                  │  │
│  │  - ProfilePage                     │  │
│  └────────────────────────────────────┘  │
│  ┌────────────────────────────────────┐  │
│  │  Widgets                           │  │
│  │  - CustomBottomNavBar              │  │
│  │  - MainShell                       │  │
│  └────────────────────────────────────┘  │
│  ┌────────────────────────────────────┐  │
│  │  BLoC                              │  │
│  │  - NavigationBloc                  │  │
│  │  - NavigationEvent                 │  │
│  │  - NavigationState                 │  │
│  └────────────────────────────────────┘  │
└──────────────────────────────────────────┘
                 │
                 ▼
┌──────────────────────────────────────────┐
│            Core Layer                    │
│  ┌────────────────────────────────────┐  │
│  │  Router                            │  │
│  │  - AppRouter (go_router config)   │  │
│  └────────────────────────────────────┘  │
│  ┌────────────────────────────────────┐  │
│  │  Dependency Injection              │  │
│  │  - init_dependency.dart            │  │
│  │  - GetIt service locator           │  │
│  └────────────────────────────────────┘  │
└──────────────────────────────────────────┘
```

## 📱 Screen Flow Diagram

```
                    ┌──────────────┐
                    │  App Start   │
                    └──────┬───────┘
                           │
                    Check Auth State
                           │
              ┌────────────┴────────────┐
              │                         │
         Not Logged In             Logged In
              │                         │
              ▼                         ▼
      ┌──────────────┐         ┌──────────────┐
      │  SigninPage  │         │ DashboardPage│
      │              │         │ (Beranda)    │
      │  No Bottom   │         │              │
      │  Navigation  │         │ With Bottom  │
      └──────┬───────┘         │ Navigation   │
             │                 └──────┬───────┘
             │                        │
      Login Success          ┌────────┴────────┐
             │               │                 │
             └───────────────┤                 │
                             │                 │
                    ┌────────▼───────┐  ┌──────▼──────┐
                    │ LiterationPage │  │ ProfilePage │
                    │                │  │             │
                    │ With Bottom    │  │ With Bottom │
                    │ Navigation     │  │ Navigation  │
                    └────────────────┘  └─────────────┘
                             │                  │
                             └────────┬─────────┘
                                      │
                                  Logout
                                      │
                                      ▼
                              ┌──────────────┐
                              │  SigninPage  │
                              └──────────────┘
```

## 🎯 SOLID Principles Applied

### Single Responsibility Principle (SRP)

```
AppRouter          → Only handles route configuration
NavigationBloc     → Only manages navigation state
CustomBottomNavBar → Only renders bottom navigation UI
MainShell          → Only wraps pages with bottom nav
```

### Open/Closed Principle (OCP)

```
Easy to extend with new routes:
1. Add route constant
2. Add route configuration
3. No modification to existing code needed
```

### Dependency Inversion Principle (DIP)

```
High-level modules (Pages) don't depend on low-level (Navigation)
Both depend on abstractions (BLoC, Router)

NavigationBloc ← GetIt Service Locator → Dependency Injection
```

## 🔑 Key Components

| Component          | Responsibility       | Pattern         |
| ------------------ | -------------------- | --------------- |
| AppRouter          | Route configuration  | Singleton       |
| NavigationBloc     | Tab state management | BLoC            |
| MainShell          | Shell wrapper        | Composite       |
| CustomBottomNavBar | UI rendering         | Presentation    |
| GetIt              | Dependency injection | Service Locator |

---

This architecture ensures:

- ✅ Separation of concerns
- ✅ Testability
- ✅ Maintainability
- ✅ Scalability
- ✅ Type safety
- ✅ SOLID principles
