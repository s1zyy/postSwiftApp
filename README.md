# 📱 PostSwiftApp: Secure iOS Client with RESTful CRUD

**PostSwiftApp** is a robust native iOS application built with **Swift** and **UIKit**, showcasing professional skills in client-server interaction, user authentication, and persistent data storage.

## ✨ Key Features & Functionality

This project demonstrates core competencies essential for a professional iOS Developer:

* **Full CRUD Operations:** Seamless creation, reading, updating, and deletion (CRUD) of post entities via a remote RESTful API.
* **JWT Authentication:** Implementation of a secure user login system, handling **JSON Web Tokens (JWT)** for protected API routes and session management.
* **Data Persistence:** Uses **Core Data** for efficient local storage and caching of post data, enhancing the user experience and demonstrating robust data management.
* **Networking Layer:** Custom implementation of a dedicated **Service Layer** using native `URLSession` for clean, reusable, and error-handled API calls.
* **Programmatic UI:** User interface built entirely with **UIKit** and **Auto Layout** (without Storyboards), reflecting a modern, code-centric development approach.

## 📐 Architecture & Design

| Element | Pattern/Technology | Description |
| :--- | :--- | :--- |
| **Main Architecture** | **MVCS** (Model-View-Controller-Store) | A modular extension of MVC where dedicated **Store/Manager** layers isolate networking, authentication, and data persistence logic, leading to better **Separation of Concerns**. |
| **Networking** | **Generic API Client** | Utilizes **Generics** and `JSONDecoder` to create a type-safe and reusable network client for handling various API response models. |
| **Data Management** | **Core Data Stack** | Demonstrates proficiency in setting up and managing the Core Data stack (NSPersistentContainer, NSManagedObjectContext) for local caching. |
| **Code Style** | **Swift Idioms** | Adherence to modern Swift language idioms, including use of property wrappers, generics, and error handling. |

## 🛠️ Technology Stack

[![Swift](https://img.shields.io/badge/Swift-5.0%2B-FA7343?style=for-the-badge&logo=swift&logoColor=white)](https://www.swift.org)
[![UIKit](https://img.shields.io/badge/UIKit-iOS%2014%2B-blueviolet?style=for-the-badge&logo=apple&logoColor=white)](https://developer.apple.com/documentation/uikit)
[![Core Data](https://img.shields.io/badge/Core%20Data-Persistence-4a90e2?style=for-the-badge&logo=apple&logoColor=white)](https://developer.apple.com/documentation/coredata)
[![URLSession](https://img.shields.io/badge/Networking-URLSession-007AFF?style=for-the-badge&logo=apple&logoColor=white)](https://developer.apple.com/documentation/foundation/urlsession)
[![JWT](https://img.shields.io/badge/Security-JWT-F05340?style=for-the-badge)](https://jwt.io/)

---

## 🚀 Getting Started

### Prerequisites

* Xcode 14 or newer
* An iOS device or simulator running iOS 14.0 or later

### Installation and Setup

1.  **Clone the Repository:**

    ```bash
    git clone [https://github.com/s1zyy/postSwiftApp.git](https://github.com/s1zyy/postSwiftApp.git)
    cd postSwiftApp
    ```

2.  **Open the Project in Xcode:**

    ```bash
    xed .
    ```

3.  **Configure API (Important):**
    * This app requires a running backend API. Ensure your backend server (e.g., your `post-api` project) is accessible.
    * You may need to update the base URL constant in the Networking layer (e.g., in a `Constants.swift` file) to point to your local or deployed API endpoint (e.g., `http://localhost:8080/api/v1`).

4.  **Build and Run:** Select a simulator and click the "Run" button ($\triangleright$).

## 🛣️ Future Enhancements (Roadmap)

I plan to continue improving this project by implementing:

* **Comprehensive Testing:** Implementing **Unit and UI Testing** to ensure the reliability of critical paths, such as authentication and all CRUD operations, ensuring code quality and stability.
* **Architecture Refactoring:** Migrating the existing MVC structure to a more testable pattern like **MVVM (Model-View-ViewModel)** to separate the UI logic from the business logic, which is essential for scalable development.

---
## 🎥 Video Demonstration (2:11)

See the application's core functionality in action, including JWT login, CRUD operations, and data persistence.

<p align="center">
    <a href="https://www.youtube.com/watch?v=sZ4cPI1NX_U" target="_blank">
        <img 
            src="https://img.youtube.com/vi/sZ4cPI1NX_U/maxresdefault.jpg" 
            alt="PostSwiftApp - Full CRUD & JWT Demo"
            width="600"
            style="border-radius: 8px; border: 1px solid #ccc;"
        />
    </a>
</p>
---

## 🔗 Related Projects

* **[post-api](https://github.com/s1zyy/post-api)**: The Spring Boot backend API used to power this application, demonstrating end-to-end client-server understanding.

## 👤 Author

**Vladyslav Savkiv** – iOS Developer

* [LinkedIn Profile](https://www.linkedin.com/in/vladyslav-savkiv/)
* [GitHub Profile](https://github.com/s1zyy)
