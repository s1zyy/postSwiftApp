# postSwiftApp

A simple iOS app built with **Swift** and **UIKit**, demonstrating basic CRUD operations with a RESTful API backend.

---

## Features

- Fetch posts from a remote API
- Display posts in a list
- Create, update, and delete posts
- User authentication (login)
- Clean architecture with MVC pattern

---

## Tech Stack

- **Swift 5+**
- **UIKit**
- **URLSession** for networking
- **JSONDecoder** for parsing JSON
- **CoreData** for local storage
- JWT authentication with backend

---

## Getting Started

### Prerequisites

- Xcode 12 or newer
- An iOS device or simulator running iOS 14.0 or later

### Clone & Build

```bash
git clone https://github.com/s1zyy/postSwiftApp.git
cd postSwiftApp
```
                        
Open the project in Xcode:
```bash
                        xed .
                        ```
Build and run the app on a simulator or connected device.
                        
                        ### API Endpoints
                        | Method | Endpoint      | Description                         |
                        | ------ | ------------- | ----------------------------------- |
                        | GET    | `/posts`      | Fetch all posts                     |
                        | GET    | `/posts/{id}` | Fetch a post by ID                  |
                        | POST   | `/posts`      | Create a new post                   |
                        | PUT    | `/posts/{id}` | Update a post                       |
                        | DELETE | `/posts/{id}` | Delete a post                       |
                        | POST   | `/users`      | Create a new user                   |
                        | GET    | `/users/{id}` | Fetch a user by ID                  |
                        | PUT    | `/users/{id}` | Update a user                       |
                        | DELETE | `/users/{id}` | Delete a user                       |
                        | POST   | `/auth/login` | Authenticate a user / get JWT token |

### Project Structure

```bash
postSwiftApp
 ├── AppDelegate.swift
 ├── SceneDelegate.swift
 ├── Models
 │    ├──
 │    └──
 ├── Views
 │    ├──
 │    └──
 ├── Stores
 │    └──
 ├── Networking
 │    ├──
 │    └── AuthService.swift
 └── Resources
      ├── Assets.xcassets
      └── LaunchScreen.storyboard
```

### Author

Developed by Vladyslav Savkiv
