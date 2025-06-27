# Doofie - Food Waste Management

Doofie is a mobile application designed to help users manage their food inventory, track expiration dates, and ultimately reduce household food waste. By providing a simple way to log and monitor food items, Doofie aims to tackle food spoilage head-on, contributing to more sustainable consumption habits.

## Purpose & SDG Alignment

This project directly supports **Sustainable Development Goal (SDG) #2: Zero Hunger**.

**Justification:**
A crucial pillar of achieving Zero Hunger is improving food efficiency and reducing loss at all levels, including the consumer level. Household food waste is a significant contributor to this problem.

The Doofie app addresses this challenge by:

1. **Raising Awareness:** Giving users a clear overview of the food they own and its expiration timeline.

2. **Preventing Spoilage:** Empowering users to consume food before it goes bad. (Future feature: push notifications).

3. **Enabling Waste Repurposing:** Data on food waste recorded by the app can serve as a basis for further processing. Conceptually, this organic waste could be repurposed using methods like **Reep** (e.g., Recycle-Eco-Process) to be converted into compost or other valuable products, thus closing the consumption loop.

## Tech Stack

* **Framework:** Flutter

* **Programming Language:** Dart

* **Database:** Cloud Firestore (Firebase)

* **File Storage (Images):** Supabase Storage

* **State Management:** GetX

## Key Features

* Full CRUD operations (Create, Read, Update, Delete) for food items.

* Image uploads for each food item for easy visual identification.

* Expiration date tracking.

* A clean, intuitive, and user-friendly interface.

## Setup & Installation

To get this project up and running on your local machine, follow these steps.

1. **Prerequisites:**

   * Ensure you have the [Flutter SDK](https://flutter.dev/docs/get-started/install) installed.

   * Git version control.

2. **Clone the Repository:**

   ```
   git clone [https://github.com/](https://github.com/)[YOUR_USERNAME]/[YOUR_REPO_NAME].git
   cd [YOUR_REPO_NAME]
   ```

3. **Firebase Setup:**

   * Create a new project on the [Firebase Console](https://console.firebase.google.com/).

   * Add an Android application with the package name `com.sumhel.doofie`.

   * Download the `google-services.json` file and place it in the `android/app/` directory.

   * In the Firebase Console, enable **Cloud Firestore**.

4. **Supabase Setup:**

   * Create a new project on [Supabase](https://supabase.com/).

   * Navigate to **Storage**, create a new bucket named `food_images`, and set it to **Public**.

   * Ensure you have configured the **Policies** for `INSERT` and `SELECT` operations on this bucket.

   * Copy the **URL** and **Anon Key** from your Supabase project settings and place them in your application's configuration file (e.g., inside `lib/app/controllers/food_controller.dart`).

5. **Install Dependencies:**

   ```
   flutter pub get
   ```

6. **Run the Application:**

   ```
   flutter run
   ```

## How to Use & Contribution Guidelines

### How to Use the App

1. Launch the app. The home screen displays your list of food items.

2. Tap the `+` button to add a new food item.

3. Fill in the name, select a type, set the expiration date, and upload an image.

4. Save the item, and it will appear on the home screen.

5. To check recipes, go the the recipe page by the bottom navigation bar

6. Save the recipe you like or something related to your fridge right now!

7. You can also check your saved recipe by check into your profile page by the bottom navigation bar

### Contribution Guidelines

Contributions are welcome! If you'd like to help improve Doofie, please:

1. **Fork** this repository.

2. Create a new feature branch (`git checkout -b feature/AmazingFeature`).

3. Make your changes and commit them (`git commit -m 'Add some AmazingFeature'`).

4. Push to the branch (`git push origin feature/AmazingFeature`).

5. Open a **Pull Request**.

## Firebase Usage

This project uses **Firebase Cloud Firestore** as its cloud-based NoSQL database. It stores all structured data for food items, including their name, type, ID, and expiration date. The public URL of the image uploaded to Supabase is also stored here for reference.

## Download The App (APK)

You can download and install the application directly using the APK files provided in the [**Releases Section**](https://github.com/[YOUR_USERNAME]/[YOUR_REPO_NAME]/releases) of this repository.


*Crafted with the goal of reducing food waste, one kitchen at a time.*