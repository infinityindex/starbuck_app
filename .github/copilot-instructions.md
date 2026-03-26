# Starbucks App - Copilot Instructions

A Flutter demo app simulating a Starbucks coffee ordering experience with Provider state management and go_router navigation.

## Commands

```bash
# Run the app
flutter run

# Run tests
flutter test
flutter test test/widget_test.dart   # Single test file

# Analyze code
flutter analyze

# Get dependencies
flutter pub get
```

## Architecture

### Project Structure

```
lib/
├── core/           # Theme, colors, typography, constants
├── data/
│   ├── models/     # Data models (DrinkModel, CartItemModel, etc.)
│   └── mock/       # Mock data for development
├── providers/      # State management (ChangeNotifier classes)
├── router/         # go_router configuration and route names
├── screens/        # Feature screens (one folder per screen)
└── widgets/
    ├── animations/ # Reusable animation wrappers
    ├── cards/      # Card components (DrinkCard, FeaturedDrinkCard)
    └── common/     # Shared UI components (buttons, inputs, nav)
```

### State Management

Uses **Provider** with ChangeNotifier pattern:
- `CartProvider` - Shopping cart state with quantity and pricing
- `FavoritesProvider` - Drink favorites (toggle by drink ID)
- `AuthProvider` - User authentication state
- `OrderProvider` - Order history and tracking
- `ThemeProvider` - Light/dark theme switching

All providers are registered in `main.dart` via `MultiProvider`.

### Navigation

Uses **go_router** with:
- `ShellRoute` for bottom navigation tabs (home, menu, rewards, favorites, profile)
- Custom page transitions (fade, slide, bottom sheet)
- Route names defined in `lib/router/route_names.dart`
- Pass data to routes via `extra` parameter (e.g., `context.push(RouteNames.productDetail, extra: drink)`)

## Conventions

### Theming

- Use `AppColors` from `core/theme/app_colors.dart` for all colors
- Use `AppTypography` for text styles (Sora font via Google Fonts)
- Use `AppConstants` for spacing and border radius values
- Support both light and dark themes via `AppTheme`

### Widgets

- Stateless widgets with private constructors for utility classes (e.g., `AppColors._()`)
- Wrap tappable items with `ScaleTapWidget` for press animations
- Use `ShimmerWrapper`/`ShimmerBox` for loading states
- Image loading via `CachedNetworkImage` with shimmer placeholders

### Animations

- Use `flutter_animate` package for declarative animations
- Animation durations defined in `core/constants/animation_durations.dart`
- Common pattern: `.animate().fadeIn(delay: 100.ms).slideY(begin: 0.2)`

### Models

- Immutable data classes with `const` constructors
- Use `copyWith` pattern for state updates (see `CartItemModel`)
- Mock data in `lib/data/mock/` files prefixed with `mock_`
