# Mutual Fund Watchlist

A Flutter application that helps users track and monitor their mutual fund investments with real-time updates and detailed analytics.

## Features

- 🔐 Secure Authentication with Phone Number
- 📊 Real-time Mutual Fund Tracking
- 📈 Interactive Charts and Analytics
- 📱 Watchlist Management
- 🌙 Dark Mode Interface
- 📱 Cross-platform Support (iOS, Android, Web)

## Getting Started

### Prerequisites

- Flutter SDK (latest version)
- Dart SDK
- Supabase Account (for backend services)
- Android Studio / VS Code with Flutter extensions

### Installation

1. Clone the repository:
```bash
git clone https://github.com/yourusername/mutual_fund_watchlist.git
```

2. Navigate to the project directory:
```bash
cd mutual_fund_watchlist
```

3. Install dependencies:
```bash
flutter pub get
```

4. Create a `.env` file in the root directory with your Supabase credentials:
```
SUPABASE_URL=your_supabase_url
SUPABASE_ANON_KEY=your_supabase_anon_key
```

5. Run the application:
```bash
flutter run
```

## Application Walkthrough

### 1. Welcome Screen
- The app starts with a welcome screen introducing the application
- Users can proceed to sign in using their phone number

### 2. Authentication
- Enter your phone number to receive an OTP
- Verify your phone number using the OTP
- Secure authentication powered by Supabase

### 3. Main Dashboard
- View your watchlist of mutual funds
- Access quick statistics and performance metrics
- Navigate to different sections using the bottom navigation bar

### 4. Watchlist Management
- Add mutual funds to your watchlist
- Track fund performance
- Set price alerts and notifications
- View detailed fund information

### 5. Charts and Analytics
- Interactive charts showing fund performance
- Historical data analysis
- Compare multiple funds
- Export data for further analysis

### 6. Settings and Profile
- Customize your watchlist preferences
- Manage notifications
- Update profile information
- Theme customization

## Navigation Guide

1. **Bottom Navigation Bar**
   - Home: Main dashboard
   - Watchlist: Your tracked mutual funds
   - Charts: Analytics and performance graphs
   - Profile: User settings and preferences

2. **Screen Navigation**
   - Swipe between screens or use the bottom navigation bar
   - Use the back button to return to previous screens
   - Access detailed views by tapping on fund cards

3. **Quick Actions**
   - Search funds using the search bar
   - Filter and sort your watchlist

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Support

For support, please open an issue in the GitHub repository or contact the development team.
