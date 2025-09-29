# Flutter Movie Search App

A responsive and feature-rich movie search application built with Flutter. This project was developed as a technical assignment, demonstrating a wide range of modern app development practices, from state management with BLoC to advanced, polished UI/UX design. The app uses the TMDb API for fetching movie data.

## 🎬 Demo & Screenshots

A short video demonstrating the app's features, responsiveness, and animations.

**(Link to your YouTube, Loom, or Google Drive video demonstration goes here)**
![search_screen](https://github.com/user-attachments/assets/a500028d-59c7-4a97-b1f8-97bb65a23898)
![search_screen2](https://github.com/user-attachments/assets/157b5860-f789-4152-a28a-67c2deb63d36)
![detail_screen](https://github.com/user-attachments/assets/9c514252-9507-4f59-a9e0-70709fe41020)

---
## ✨ Features

* ✅ **Real-time Search:** Fetches movie results as you type with debouncing to prevent excessive API calls.
* ✅ **BLoC/Cubit State Management:** Predictable and robust state management for handling loading, success, and error states.
* ✅ **Fully Responsive UI:** The layout fluidly adapts to different screen sizes and orientations (phones, tablets, portrait, and landscape).
* ✅ **Cinematic Detail Screen:** An immersive detail screen with a collapsing image header that works seamlessly on all aspect ratios.
* ✅ **Polished UI & Animations:**
    * **Shimmer Effect:** An elegant loading state for the movie grid.
    * **Staggered Animations:** Results animate into view with a staggered fade-in and scale effect.
    * **"Frosted Glass" Effect:** Modern UI effect on the detail screen's info chips.
    * **Interactive Feedback:** Movie cards provide a subtle scaling animation on tap.
* ✅ **Graceful Error Handling:** Displays user-friendly messages for network errors (e.g., no internet) with a functional "Retry" button.
* ✅ **Secure API Key Management:** Uses a `.env` file to keep the TMDb API key secure and out of version control.
* ✅ **Custom Theme & Font:** A unique, professional theme with a custom color palette and typography from Google Fonts.

---
## 🛠️ Tech Stack & Key Packages
* **Flutter version used:** `Flutter 3.32.0`
* **State Management:** `flutter_bloc`
* **API & Networking:** `http`, `flutter_dotenv`
* **UI & Animations:** `cached_network_image`, `google_fonts`, `shimmer`, `flutter_staggered_animations`, `intl`
* **Architecture:** Clean architecture separating UI (Presentation), business logic (BLoC), and data layers.

---
## 🚀 Setup and Installation

To run this project locally, follow these steps:

1.  **Clone the repository:**
    ```bash
    git clone [https://github.com/your-username/your-repo-name.git](https://github.com/your-username/your-repo-name.git)
    cd your-repo-name
    ```
2.  **Create a `.env` file** in the root of the project and add your TMDb API key:
    ```
    TMDB_API_KEY=your_actual_api_key_goes_here
    ```
3.  **Install dependencies:**
    ```bash
    flutter pub get
    ```
4.  **Run the app:**
    ```bash
    flutter run
    ```
---
## 📂 Project Structure

The project is organized into a clean, scalable architecture:
lib/
├── bloc/         # BLoC/Cubit logic for state management
├── data/         # Repository, API services, and data models
├── presentation/ # All UI-related files (screens, widgets)
└── main.dart     # App entry point and theme configuration
---
## 🙏 Acknowledgements

* This project uses the [TMDb API](https://www.themoviedb.org/documentation/api).
* Icons and fonts sourced from Google.
