# ☕ Starbucks App

A modern Flutter demo application simulating the Starbucks coffee ordering experience. Built with clean architecture, smooth animations, and intuitive UI/UX.

## Features

- **Browse Menu** - Explore coffee drinks by category with featured items carousel
- **Product Details** - View drink information, customize size and options
- **Shopping Cart** - Add items, adjust quantities, view pricing with tax calculation
- **Favorites** - Save your favorite drinks for quick access
- **Rewards System** - Track points and view available rewards
- **Order Tracking** - Monitor order status from preparation to pickup
- **Store Locator** - Find nearby Starbucks locations with map integration
- **Dark Mode** - Full light/dark theme support
- **User Profile** - Manage account settings and view order history

## Tech Stack

- **Framework**: Flutter 3.11.0+
- **State Management**: Provider (ChangeNotifier pattern)
- **Navigation**: go_router with ShellRoute for bottom tabs
- **Animations**: flutter_animate, Lottie
- **UI Components**: 
  - Cached Network Images with shimmer loading
  - Custom animations (scale tap, fade in, slide)
  - Smooth page indicators
- **Maps**: flutter_map with latlong2
- **Fonts**: Google Fonts (Sora)

## Project Structure

```
lib/
├── core/               # Theme, colors, typography, constants
├── data/
│   ├── models/         # Data models (immutable with copyWith)
│   └── mock/           # Mock data for development
├── providers/          # State management (6 providers)
├── router/             # go_router configuration
├── screens/            # Feature screens (organized by feature)
└── widgets/
    ├── animations/     # Reusable animation wrappers
    ├── cards/          # Card components
    └── common/         # Shared UI components
```

## Getting Started

### Prerequisites

- Flutter SDK 3.11.0 or higher
- Dart SDK 3.11.0 or higher
- iOS Simulator / Android Emulator / Physical device

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd starbuck_app
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   flutter run
   ```

### Development Commands

```bash
# Run tests
flutter test

# Run specific test
flutter test test/widget_test.dart

# Analyze code
flutter analyze

# Clean build files
flutter clean
```

## Key Design Patterns

### State Management
- **Provider with ChangeNotifier**: All app state managed through dedicated providers
- **Consumer pattern**: Reactive UI updates in specific sections
- **context.read()**: One-time reads for callbacks

### Navigation
- **Declarative routing**: Type-safe routes with go_router
- **Shell navigation**: Persistent bottom nav bar across tabs
- **Custom transitions**: Page-specific animations (fade, slide, bottom sheet)

### Models
- **Immutable data classes**: All models use `const` constructors
- **copyWith pattern**: State updates without mutation
- **Computed properties**: Derived values (e.g., `totalPrice`)

### UI/UX
- **ScaleTapWidget**: Press animations on interactive elements
- **Shimmer loading**: Skeleton screens during data fetch
- **flutter_animate**: Declarative animation composition

## Dependencies

| Package | Purpose |
|---------|---------|
| `provider` | State management |
| `go_router` | Declarative routing |
| `flutter_animate` | Declarative animations |
| `cached_network_image` | Image loading & caching |
| `google_fonts` | Custom typography (Sora) |
| `shimmer` | Loading state skeletons |
| `flutter_map` | Store location maps |
| `lottie` | JSON-based animations |
| `intl` | Internationalization |

## Testing

Currently, includes basic widget tests. Run with:

```bash
flutter test
```

## App Flow

1. **Splash Screen** → Onboarding
2. **Home** → Browse featured drinks & categories
3. **Product Detail** → Customize & add to cart
4. **Cart** → Review items & proceed to checkout
5. **Order Confirmation** → Track order status
6. **Rewards/Profile** → Manage account & preferences

## State Providers

- **CartProvider** - Shopping cart operations
- **FavoritesProvider** - Drink favorites management
- **AuthProvider** - User authentication state
- **OrderProvider** - Order history & tracking
- **ThemeProvider** - Light/dark mode switching
- **RewardsProvider** - Points & rewards tracking

## Contributing

This is a demo project for learning purposes. Feel free to fork and experiment with new features!

## License

Licensed under the MIT License. See [LICENSE](LICENSE) for details.
This project follows the standard MIT license wording, granting broad reuse rights with attribution.
