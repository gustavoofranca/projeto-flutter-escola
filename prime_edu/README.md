# Prime Edu

Prime Edu is an educational platform designed for students and teachers to manage academic content, announcements, and learning materials. The application provides a comprehensive solution for educational institutions to facilitate communication and learning.

## Features

- User authentication with role-based access (student, teacher, admin)
- Educational materials management with Google Books integration
- Announcement system for teacher-to-student communication
- Profile management with personalized dashboards
- Demo screens showcasing API integration and form handling

## Architecture

The application follows a clean architecture pattern with:

- State management using Provider
- Service layer for API interactions
- Model-View pattern for UI components
- Atomic Design principles for component organization

## Atomic Design Implementation

The project implements Atomic Design principles through a structured component hierarchy:

### Atoms

- CustomButton: Reusable button component with multiple variants
- CustomTextField: Form input field with validation and styling
- CustomTypography: Text components with consistent styling

### Molecules

- FormFieldGroup: Group of related form fields
- InfoCard: Information display card with icon and text
- SectionTitle: Section header with title and subtitle

These components are reusable across the application and follow consistent design patterns.

## APIs Used

### Google Books API

Used for educational materials search and display:

- Endpoint: https://www.googleapis.com/books/v1
- Integration in materials screens for book search functionality
- Provides access to educational books and literature

### JSONPlaceholder API

Used in demo screens to showcase API integration:

- Endpoint: https://jsonplaceholder.typicode.com
- Demonstrates REST API consumption with posts and users
- Used in API demo screen for educational purposes

## Project Structure

```
lib/
├── components/
│   ├── atoms/
│   └── molecules/
├── constants/
├── models/
├── providers/
├── services/
└── views/
    ├── announcements/
    ├── auth/
    ├── demo/
    ├── home/
    ├── materials/
    ├── profile/
    └── shared/
```

## Getting Started

### Prerequisites

- Flutter SDK 3.8.1 or higher
- Dart SDK 3.8.1 or higher

### Installation

1. Clone the repository
2. Navigate to the project directory
3. Run `flutter pub get` to install dependencies
4. Run `flutter run` to start the application

### Supported Platforms

- Android
- iOS
- Web (enable with `flutter config --enable-web`)
- Windows (enable with `flutter config --enable-windows-desktop`)

## Development

The project follows standard Flutter development practices with:

- Provider for state management
- Custom component library for UI consistency
- Service-oriented architecture for business logic
- Mock data for demonstration purposes

## Dependencies

Key dependencies include:

- provider: State management
- http: HTTP client for API requests
- google_fonts: Typography management
- url_launcher: External link handling
- shared_preferences: Local data storage

## Contributing

This is a demonstration project for educational purposes. Contributions are welcome for learning and improvement.

## License

This project is proprietary and intended for educational demonstration purposes.
