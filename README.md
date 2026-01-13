# 🧘 Samma Sati (Meditation App)
Developed in 2024 as part of the CP213 Mobile Programming course. Samma Sati is a comprehensive mobile application designed to assist users in their spiritual and mental well-being through guided prayers, meditation timers, and relaxing soundscapes.

## 📹 Demo Video

[![Watch the Samma Sati demo](https://img.youtube.com/vi/cUGQF1c3bpQ/0.jpg)](https://youtu.be/cUGQF1c3bpQ)


## 🌟 Key Features
**1. Prayers & Chants (Guided Reading & Listening)**
* **Audio Library:** A collection of prayers and chants for users to listen to.
* **Reading Mode:** Digital prayer books for users to read along while listening or in silence.
* **Favorites System:** Users can "Like" their favorite prayers for quick access later.

**2. Advanced Meditation Timer**
* **Customizable Sessions:** A dedicated timer for meditation practice.
* **Ambient Soundscapes:** Choose from a variety of relaxing background music tracks to enhance focus and relaxation.
* **Mindful Intervals:** An interval bell system that can be configured to ring every few minutes to bring the user's attention back to the present.

**3. Progress Tracking**
* **Meditation History:** Automatically records every session, allowing users to track their consistency and total time spent in meditation.

**4. User Account & Security**
* **Secure Login:** Integrated Firebase Authentication for secure sign-in and account management.
* **Cloud Sync:** User data, favorites, and history are synced across devices via Cloud Firestore.

## 🛠 Tech Stack
* **Framework:** Flutter (Dart)
* **Backend as a Service (BaaS):** Firebase
* **FireAuth:** For user authentication (Sign-in/Sign-up).
* **Cloud Firestore:** For real-time NoSQL database storage (History & Favorites).

## ⚙️ How to Run
1. **Clone the project:**

```
git clone https://github.com/your-username/meditate-app.git
```

2. **Install Dependencies:**

```
flutter pub get
```

3. **Firebase Setup:**
* Create a new project in the Firebase Console.
* Add an Android/iOS app to your Firebase project.
* Download `google-services.json` (for Android) or `GoogleService-Info.plist` (for iOS) and place them in the respective directories.
* Enable Anonymous or Email/Password Auth in Firebase.
* Create a Firestore Database in test mode.

4. **Run the App:**

```
flutter run
```

