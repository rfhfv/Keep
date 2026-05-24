# Keep

iOS flashcard app for learning foreign words built with Swift + MVVM + Coordinator. Create collections of cards with translations, practice memorization with training mode, and listen to pronunciation via Voice RSS API. Supports light/dark mode.

## Screenshots

<img width="1300" height="782" alt="Image" src="https://github.com/user-attachments/assets/d32d2929-1461-4c37-918c-9eacc51791f7" />

## Features

- **Create Collections:** Organize cards into custom collections
- **Flashcards:** Create cards with foreign words and translations
- **Text-to-Speech:** Listen to pronunciation via Voice RSS API
- **Training Mode:** Practice memorization with interactive sessions
- **Dark/Light Mode:** Full support for both themes

## Tech Stack

- **Swift** + **UIKit**
- **MVVM** + **Coordinator** architecture
- **Core Data** for local persistence
- **Voice RSS API** for pronunciation
- **AVFoundation** for audio playback

## Architecture

The project follows MVVM + Coordinator architecture:

- **View:** UIKit views, programmatic layout
- **ViewModel:** Business logic, state management
- **Model:** Core Data entities
- **Coordinator:** Navigation and flow management

## Installation

- git clone https://github.com/rfhfv/Keep.git
- cd Keep
- open Keep.xcodeproj
