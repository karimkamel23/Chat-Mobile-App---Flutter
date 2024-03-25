# Chat App with Firebase, Firestore DB and Firebase Cloud Messaging (FCM) in Flutter

In this project I created a chat app which lets you create an account and chat with other users of the app. I utilized firebase for the authentication and firestore database for storing user and chat information including messages. Also, I used Firebase Cloud Messaging (FCM) in order to implement push notifications when sending and receiving messages.

## Table of Contents

- [Installation](#installation)
- [Project Structure](#project-structure)
- [Contact](#contact)

## Installation

1. Make sure all Flutter and Dart dependencies are installed on your device.
2. Clone the repository.
3. Navigate to the project directory.
4. Enter 'flutter run' in the terminal to run the application.
5. Choose the desired emulator if any.

## Project Structure

- lib/: Main source code directory
- main.dart: Entry point of the Flutter app.
- firebase_options.dart: An auto generated file when connecting app with firebase, stores options for operating Firebase.
- pages/: Stores the pages used in the Flutter app.
- home_page.dart: The app's main page which loads all the apps users in a list except the current user so the user can choose his desired chat. Also, includes an app bar to navigate to the settings page or logout.
- chat_page.dart: This acts as the chat between 2 users by loading their messages on their respective sides, including their messages and timestamps. Also, includes implementation for sending messages and notification by calling other services.
- settings_page.dart: Allows user to toggle between light mode and dark mode.
- login_page.dart and signup_page.dart: Contains the respective UIs and implementations of each of the login and signup functionalities, including error handling.
- themes/: Stores theme information for both light and dark modes, as well as the ThemeProvider.
- dark_mode.dart: Defines the theme data and colors for dark mode.
- light_mode.dart: Defines the theme data and colors for light mode.
- theme_provider.dart: Provides the theme data for the rest of the app as a Change Notifier by using the needed setters and getters.
- models/: Stores the models used in creating the app.
- message.dart: Contains the model for the Message object which stores: senderID, senderEmail, receiverID, message, timestamp.
- services/: Stores the services which are utilized by various aspects of the app.
- auth/: Stores services relating to Authentication with Firebase.
- auth_page.dart: Page that checks if user is logged in and directs him accordingly (to home page or login).
- auth_service.dart: Main auth service class that uses Firebase and Firestore to login, logout, signup, store and retreive users' info.
- login_or_register.dart: Acts as a toggle between the login and signup pages.
- chat/: Stores Services relating to sending and handling chats with Firestore.
- chat_service.dart: Main chat service class that uses Firestore to create, send, and retreive messages.
- notification/: Stores Services relating to sending, receiving and handling notifications with Firebase Cloud Messaging (FCM).
- notification_service: Main notification service that uses FCM to retreive user device tokens, send notifications, receive notifications and handle notifications.
- components/: Stores all the components and widgets utilized by pages in the app.
- chat_bubble.dart: Creates chat bubble widgets that display messages and timestamps.
- main_drawer.dart: Provides the implementation of the main drawer used in the application.
- mybutton.dart: Provides the implementation for the main buttons used in the login and signup pages.
- mytext_field.dart: Provides the implementation for the main text fields used in the login and signup pages.
- user_tile: Provides the implementation for the user tiles that are used to display the user names (chats) of other users in the home page.

Firestore Structure:

Collection : Users
~for each user
Fields: uid, email, username, token(if logged in on a device)

Collection : chats
~for every 2 users with an ongoing chat
Contains: messages collection

Collection : messages:
~for each message
Fields: message, receiverID, senderEmail, senderID, timestamp

## Contact

  If you have any questions or feedback, feel free to contact me at karimkamel23@gmail.com
