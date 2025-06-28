# Doofie - Food Waste Management

Doofie is a mobile application designed to help users manage their food inventory, track expiration dates, and ultimately reduce household food waste. By providing a simple way to log and monitor food items, Doofie aims to tackle food spoilage head-on, contributing to more sustainable consumption habits.

## Purpose & SDG Alignment

This project directly supports **Sustainable Development Goal (SDG) #2: Zero Hunger**.

**Justification:**
A crucial pillar of achieving Zero Hunger is improving food efficiency and reducing loss at all levels, including the consumer level. Household food waste is a significant contributor to this problem.

The Doofie app addresses this challenge by:

1.  **Raising Awareness:** Giving users a clear overview of the food they own and its expiration timeline.
2.  **Preventing Spoilage:** Empowering users to consume food before it goes bad through scheduled notifications.
3.  **Enabling Waste Repurposing:** Data on food waste recorded by the app can serve as a basis for further processing. Conceptually, this organic waste could be repurposed using methods like **Reep** (e.g., Recycle-Eco-Process) to be converted into compost or other valuable products, thus closing the consumption loop.

## Tech Stack

* **Framework:** Flutter
* **Programming Language:** Dart
* **Database:** Cloud Firestore (Firebase)
* **File Storage (Images):** Supabase Storage
* **Local Notifications:** `flutter_local_notifications`

## Key Features

* Full CRUD operations (Create, Read, Update, Delete) for food items.
* Image uploads for each food item for easy visual identification.
* Expiration date tracking with scheduled notifications.
* Recipe browsing and saving functionality.
* A clean, intuitive, and user-friendly interface.

## Setup & Installation

To get this project up and running on your local machine, follow these steps.

1.  **Prerequisites:**
    * Ensure you have the [Flutter SDK](https://flutter.dev/docs/get-started/install) installed.
    * Git version control.

2.  **Clone the Repository:**
    ```bash
    git clone [https://github.com/MuhammadSuheil/Doofie-App.git](https://github.com/MuhammadSuheil/Doofie-App.git)
    cd Doofie-App
    ```

3.  **Firebase Setup:**
    * Create a new project on the [Firebase Console](https://console.firebase.google.com/).
    * Add an Android application with the package name `com.sumhel.doofie`.
    * Download the `google-services.json` file and place it in the `android/app/` directory.
    * In the Firebase Console, enable **Cloud Firestore**.

4.  **Supabase Setup & Environment Variables (IMPORTANT):**
    * Create a new project on [Supabase](https://supabase.com/).
    * Navigate to **Storage**, create a new bucket named `food_images`, and set it to **Public**.
    * Ensure you have configured the **Policies** for `INSERT` and `SELECT` operations on this bucket.
    * In the root of the project, find the file named `.env.example`. Rename it to `.env`.
    * Open the new `.env` file and fill in your Supabase credentials. You can find these in your Supabase project's **Settings > API**.
        ```env
        SUPABASE_URL=YOUR_SUPABASE_PROJECT_URL
        SUPABASE_ANON_KEY=YOUR_SUPABASE_ANON_KEY
        ```
    * **Note:** The `.env` file is listed in `.gitignore` and will not be committed for security reasons.

5.  **Install Dependencies:**
    ```bash
    flutter pub get
    ```

6.  **Run the Application:**
    ```bash
    flutter run
    ```

## How to Use & Contribution Guidelines

### How to Use the App

1.  Launch the app. The home screen displays your list of food items.
2.  Tap the `+` button to add a new food item.
3.  Fill in the name, select a type, set the expiration date, and upload an image.
4.  Save the item, and it will appear on the home screen.
5.  To check recipes, go to the recipe page via the bottom navigation bar.
6.  Save a recipe you like or one that's relevant to your current fridge items!
7.  You can also view your saved recipes on your profile page.

### Contribution Guidelines

Contributions are welcome! If you'd like to help improve Doofie, please:

1.  **Fork** this repository.
2.  Create a new feature branch (`git checkout -b feature/AmazingFeature`).
3.  Make your changes and commit them (`git commit -m 'Add some AmazingFeature'`).
4.  Push to the branch (`git push origin feature/AmazingFeature`).
5.  Open a **Pull Request**.

## Firebase Usage

This project uses **Firebase Cloud Firestore** as its cloud-based NoSQL database. It stores all structured data for food items, including their name, type, ID, and expiration date. The public URL of the image uploaded to Supabase is also stored here for reference.

## Download The App (APK)

You can download and install the application directly using the APK files provided in the [**Releases Section**](https://github.com/MuhammadSuheil/Doofie-App/releases/tag/v1.0.0) of this repository.

---
*Crafted with the goal of reducing food waste, one kitchen at a time.*
