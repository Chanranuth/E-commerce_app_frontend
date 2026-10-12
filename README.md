# E-commerce Flutter MVP

This Flutter app connects to the existing Laravel backend under the sibling project at [backend](../backend). It follows the live API routes and validation rules in the backend rather than hardcoded mock data.

## Setup

1. Start the Laravel API from the backend project.
2. Ensure the database is available and the Laravel app is running locally.
3. From the frontend project, run:

```bash
flutter pub get
flutter run
```

## API configuration

The API base URL is centralized in [lib/core/config/app_config.dart](lib/core/config/app_config.dart).

Default value:

```dart
http://10.0.2.2:8000/api
```

Use this for Android emulators. For a physical device, replace it with your machine's LAN IP, for example:

```dart
http://192.168.1.20:8000/api
```

## Auth and backend contract

This app targets the real Laravel endpoints:

- POST /api/register
- POST /api/login
- GET /api/user
- GET /api/categories
- GET /api/products
- GET /api/products/{id}
- GET /api/cart-items
- POST /api/cart-items
- PUT /api/cart-items/{id}
- DELETE /api/cart-items/{id}
- POST /api/checkout
- GET /api/orders
- GET /api/orders/{id}
- PUT /api/orders/{id}

Authentication uses Laravel Sanctum and Bearer tokens stored with `flutter_secure_storage`.

## Current completed features

- App shell and provider-based state management
- Login and registration screens
- Secure token storage and session restore
- Product browsing with category filter and search
- Product detail screen
- Cart read, add, update, and remove flows
- Checkout flow connected to the Laravel checkout endpoint
- Order history and detail screens
- Simple loading, error, and empty states

## Not completed

- Optional seller workflow (seller access request, seller product management) was intentionally left out because the core customer purchase flow was the priority and the request required customer-first MVP completion.

## Implementation log

- Phase 1: backend contract inspection and Flutter foundation setup
- Phase 2: auth flow and secure token management
- Phase 3: product catalog and category browsing
- Phase 4: cart operations and checkout integration
- Phase 5: order history and status handling
- Phase 6: final analysis and validation

## Test accounts

No verified seeded test accounts were provided in the workspace. Use the Laravel registration flow to create a customer account. For seller/admin testing, use your existing backend database or the Laravel seeder if available.

## Notes

- Product images are not provided by the backend, so the app uses a tasteful placeholder icon.
- The app does not bypass backend authorization; UI is only a client layer over the Laravel rules.
