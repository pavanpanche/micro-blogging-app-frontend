# 📣 Micro Blogging App (Pulsar)

A full-stack micro-blogging application (similar to Twitter), built  using **Spring Boot** (backend) and **Flutter** (frontend).  
This project demonstrates secure authentication, tweet management, real-time search, a follow system, and a clean mobile/web interface.


---

## 🧰 Tech Stack

### 💻 Frontend

- Flutter (for mobile & web UI)
- Bloc or Provider for state management 

### 🚀 Backend

- Java 17+
- Spring Boot
- Spring Web
- Spring Data JPA
- Spring Security (JWT)
- MySQL
- Lombok
- Swagger (for Api documentation)
- Maven or Gradle
- Postman (for API testing)

### ✍️ Design Tools

- Hand-drawn diagrams on pan & paper (for system design & DB schema)

---

## 📦 Core Features

### 1. 👤 User Registration & Login

- Register via email, username & password using Flutter frontend.
- Passwords securely hashed using **BCrypt**.
- JWT-based authentication system implemented.
- All protected API endpoints require valid tokens.
- Flutter frontend has clean forms for registration & login.

### 2. 📝 Tweeting

- Users can **create, update, delete** their tweets.
- Tweets are text-only with timestamps.
- Only the **tweet owner** can edit or delete their tweet.
- Tweets are displayed in a clean, scrollable Flutter interface.

### 3. 🔗 Follow System

- Follow or unfollow other users.
- Displays follower & following counts per profile.
- Flutter frontend offers simple controls to manage relationships.

### 4. 📰 Timeline / Feed

- Users see their own tweets + tweets from followed users.
- Feed is sorted by **most recent first**.
- Supports **pagination** or infinite scrolling on frontend.

### 5. ❤️ Like / Unlike Tweets

- Users can like or unlike any tweet.
- Tweet cards show total like count.
- UI updates instantly with visual feedback on like/unlike.

### 6. 🔍 Search Functionality

- Search tweets by **keywords** or **hashtags**.
- Search users by **username** (supports partial match).
- Flutter UI includes search bar with real-time results.

### 7. 🕒 Recent Tweets

- Browse most recent tweets across the platform.
- Available in a dedicated section in the app.

---

### 🔖 Hashtag Support

- Hashtags (e.g., `#flutter`) are automatically extracted from tweet content.
- Hashtags are stored and indexed.
- Tweets can be searched or filtered by hashtags.
- Hashtags are **clickable** and visually highlighted in the frontend.

---

## 🛡️ Authentication Details

No Auth Required this endpoint

```http
GET /api/auth

Login returns a Access and refresh token stored in local storage on the frontend.

```

All protected routes require JWT authentication.

```http
GET /api/tweets
GET /api/follow
GET /api/likes
GET /api/Users

Authorization: Bearer <your_jwt_token>

```
#### 📄 API Documentation - Swagger UI

```http
http://localhost:8080/swagger-ui/index.html
```
#### 🧪 Testing
All APIs tested via Postman.
Postman collection:
📂 Google Drive Link



📁 Folder Structure Overview (Backend)

```file 
pulsar-blog-app/
├── src/
│   ├── main/
│   │   ├── java/com/blogging/subtxt/
│   │   │   ├── controller/
│   │   │   ├── dto/
│   │   │   ├── models/
│   │   │   ├── repository/
│   │   │   ├── services/
│   │   │   └── SubtxtApplication.java
│   │   └── resources/
│   │       └── application.properties
└── pom.xml

```
---

#### 🚀 Getting Started
Backend Setup
```bash
Clone the repo

git clone https://github.com/pavanpanche/micro-blogging-app-backend.git
cd micro-blogging-app-backend

```
#### Configure application.properties
- Set up your DB credentials, secret key, and session time according to your requirements.
  
- Run the app
  
```java
mvn spring-boot:run
```

#### 🧑‍💻 Author
Pavan Panche
📧 pavanpanche2@gmail.com
