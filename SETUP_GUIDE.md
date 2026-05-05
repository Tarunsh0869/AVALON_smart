# AVALON Quiz App - Complete Setup Guide

## Project Overview
A professional quiz application migrated from Firebase to **ASP.NET Core + SQL Server + Flutter**.

### Architecture
```
Flutter App (Provider + Repository pattern)
    ↓ HTTP + JWT
ASP.NET Core Web API (port 5000)
    ↓ Entity Framework Core
SQL Server (AvalonDB)
```

---

## Prerequisites

### Backend
- .NET 8 SDK
- SQL Server (LocalDB or full instance)
- Visual Studio Code or Visual Studio 2022

### Frontend
- Flutter SDK 3.10+
- Dart 3.10+
- Android Studio / VS Code with Flutter extension

---

## Part 1: Backend Setup

### Step 1: Navigate to backend folder
```bash
cd f:\desktop_3-9-26\AVALON_smart\avalon_backend
```

### Step 2: Restore NuGet packages
```bash
dotnet restore
```

### Step 3: Update connection string (if needed)
Edit `appsettings.json`:
```json
"ConnectionStrings": {
  "DefaultConnection": "Server=localhost;Database=AvalonDB;Trusted_Connection=True;TrustServerCertificate=True;"
}
```

### Step 4: Create database migration for seed questions
```bash
dotnet ef migrations add SeedQuestions
```

### Step 5: Apply migrations to SQL Server
```bash
dotnet ef database update
```

This creates:
- `AvalonDB` database
- 5 tables: Users, Categories, Questions, QuizAttempts, Leaderboards
- 4 categories: Python, SQL, UI/UX, Data Science
- 40 questions (10 per category)

### Step 6: Run the API
```bash
dotnet run
```

API will start at:
- HTTP: `http://localhost:5000`
- HTTPS: `https://localhost:5001`

---

## Part 2: Flutter Setup

### Step 1: Navigate to Flutter project
```bash
cd f:\desktop_3-9-26\AVALON_smart\quizproflutter
```

### Step 2: Install dependencies
```bash
flutter pub get
```

### Step 3: Update API base URL (if needed)
Edit `lib\core\constants\api_constants.dart`:
```dart
static const String baseUrl = 'http://localhost:5000/api';
// For Android emulator, use: 'http://10.0.2.2:5000/api'
```

### Step 4: Run the app
```bash
flutter run
```

---

## Part 3: Testing with Postman

### 1. Register a new user
```
POST http://localhost:5000/api/auth/register
Content-Type: application/json

{
  "name": "Tarun Sharma",
  "email": "tarun@test.com",
  "password": "password123"
}
```

**Expected Response:**
```json
{
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "name": "Tarun Sharma",
  "userId": 1
}
```

### 2. Login
```
POST http://localhost:5000/api/auth/login
Content-Type: application/json

{
  "email": "tarun@test.com",
  "password": "password123"
}
```

**Expected Response:**
```json
{
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "name": "Tarun Sharma",
  "userId": 1
}
```

**Copy the token** — you'll need it for protected endpoints.

### 3. Get Categories (no auth required)
```
GET http://localhost:5000/api/categories
```

**Expected Response:**
```json
[
  {"id": 1, "name": "Python", "iconName": "code"},
  {"id": 2, "name": "SQL", "iconName": "storage"},
  {"id": 3, "name": "UI/UX", "iconName": "palette"},
  {"id": 4, "name": "Data Science", "iconName": "analytics"}
]
```

### 4. Get Questions (JWT required)
```
GET http://localhost:5000/api/questions/1
Authorization: Bearer YOUR_TOKEN_HERE
```

**Expected Response:**
```json
[
  {
    "id": 1,
    "questionText": "What is the output of print(2 ** 3)?",
    "options": ["6", "8", "9", "12"]
  },
  {
    "id": 2,
    "questionText": "Which keyword is used to define a function in Python?",
    "options": ["func", "def", "function", "define"]
  }
  // ... 8 more questions
]
```

**Note:** `correctOption` is NOT included — answers stay on the server.

### 5. Submit Quiz (JWT required)
```
POST http://localhost:5000/api/quiz/submit
Authorization: Bearer YOUR_TOKEN_HERE
Content-Type: application/json

{
  "categoryId": 1,
  "answers": [
    {"questionId": 1, "selectedOption": "8"},
    {"questionId": 2, "selectedOption": "def"},
    {"questionId": 3, "selectedOption": "float"}
  ]
}
```

**Expected Response:**
```json
{
  "score": 3,
  "total": 3,
  "message": "Perfect score! 🎉"
}
```

### 6. Get Leaderboard
```
GET http://localhost:5000/api/leaderboard
```

**Expected Response:**
```json
[
  {
    "rank": 1,
    "userName": "Tarun Sharma",
    "category": "Python",
    "bestScore": 10
  }
]
```

---

## Part 4: Database Verification

### Check tables in SQL Server
```sql
USE AvalonDB;

-- View all categories
SELECT * FROM Categories;

-- View all questions
SELECT Id, CategoryId, QuestionText, CorrectOption FROM Questions;

-- View users
SELECT Id, Name, Email, CreatedAt FROM Users;

-- View leaderboard
SELECT L.Id, U.Name, C.Name AS Category, L.BestScore, L.UpdatedAt
FROM Leaderboards L
JOIN Users U ON L.UserId = U.Id
JOIN Categories C ON L.CategoryId = C.Id
ORDER BY L.BestScore DESC;

-- View quiz attempts
SELECT QA.Id, U.Name, C.Name AS Category, QA.Score, QA.TotalQuestions, QA.AttemptedAt
FROM QuizAttempts QA
JOIN Users U ON QA.UserId = U.Id
JOIN Categories C ON QA.CategoryId = C.Id
ORDER BY QA.AttemptedAt DESC;
```

---

## Part 5: Key Security Features

### 1. Password Hashing
Passwords are hashed using **BCrypt** before storage:
```csharp
PasswordHash = BCrypt.Net.BCrypt.HashPassword(dto.Password)
```

### 2. JWT Authentication
- Token expires in 7 days
- Contains: `userId`, `email`, `name`
- Protected endpoints require `[Authorize]` attribute

### 3. Correct Answers Hidden
- `QuestionDto` does NOT include `CorrectOption`
- Flutter never sees correct answers
- Score calculated only on backend

### 4. No Duplicate Leaderboard
- Unique constraint: `(UserId, CategoryId)`
- Only best score is stored per user per category

### 5. Server-Side Score Calculation
```csharp
var score = questions.Count(q =>
{
    var answer = dto.Answers.FirstOrDefault(a => a.QuestionId == q.Id);
    return answer != null &&
           answer.SelectedOption.Trim().Equals(q.CorrectOption.Trim(), 
               StringComparison.OrdinalIgnoreCase);
});
```

---

## Part 6: Flutter App Flow

### 1. Splash Screen → Login/Register
- User enters email + password
- Backend returns JWT token
- Token saved in `SharedPreferences`

### 2. Home Screen
- Shows 4 category cards
- Displays logged-in user's name from `UserViewModel`

### 3. Quiz Screen
- Fetches questions from `/api/questions/{categoryId}`
- User selects answers (stored locally)
- On completion, submits all answers to `/api/quiz/submit`
- Backend calculates score and updates leaderboard

### 4. Leaderboard Screen
- Fetches top 20 from `/api/leaderboard`
- Shows rank, name, category, best score

---

## Part 7: Common Issues & Fixes

### Issue 1: "Connection refused" from Flutter
**Fix:** Change `localhost` to `10.0.2.2` in `api_constants.dart` for Android emulator.

### Issue 2: SQL Server connection failed
**Fix:** Ensure SQL Server is running:
```bash
# Check service status
sc query MSSQLSERVER
```

### Issue 3: JWT token expired
**Fix:** Login again to get a new token. Tokens expire after 7 days.

### Issue 4: CORS error
**Fix:** Backend already has `app.UseCors()` with `AllowAnyOrigin()`.

---

## Part 8: Project Structure

### Backend
```
avalon_backend/
├── Controllers/        # API endpoints
├── Data/              # DbContext + migrations
├── DTOs/              # Request/response models
├── Entities/          # Database models
├── Services/          # JWT service
├── appsettings.json   # Configuration
└── Program.cs         # App startup
```

### Flutter
```
quizproflutter/lib/
├── core/
│   ├── constants/     # API URLs
│   ├── services/      # HTTP client
│   └── storage/       # Token storage
├── data/
│   ├── models/        # JSON serialization
│   └── repositories/  # API calls
├── domain/
│   ├── entities/      # Business models
│   └── usecases/      # Business logic
├── screens/           # UI pages
└── view_models/       # State management (Provider)
```

---

## Part 9: Sample Questions Added

| Category | Count | Sample |
|---|---|---|
| Python | 10 | `print(2**3)`, `def`, `try/except`, `append()` |
| SQL | 10 | `SELECT`, `WHERE`, `PRIMARY KEY`, `FULL OUTER JOIN` |
| UI/UX | 10 | wireframes, prototypes, Figma, personas |
| Data Science | 10 | Pandas, Histogram, Decision Tree, K-Means |

---

## Part 10: BCA Viva Questions & Answers

### Q1: Why migrate from Firebase to SQL Server?
**A:** Firebase is NoSQL and charges per read/write. SQL Server gives us:
- Free for local development
- ACID transactions
- Complex queries with JOINs
- Better control over data structure

### Q2: How do you prevent duplicate leaderboard entries?
**A:** Unique constraint on `(UserId, CategoryId)` in SQL Server. EF Core enforces this at database level.

### Q3: How is the score calculated securely?
**A:** Flutter sends `{questionId, selectedOption}`. Backend loads correct answers from DB and compares. Flutter never sees correct answers.

### Q4: What is JWT and why use it?
**A:** JSON Web Token — a signed token containing user info. Backend verifies signature to authenticate requests without storing sessions.

### Q5: What is BCrypt?
**A:** A password hashing algorithm with built-in salt. Even if database is leaked, passwords cannot be reversed.

---

## Conclusion

Your app is now fully migrated with:
- ✅ ASP.NET Core backend with JWT auth
- ✅ SQL Server with 40 seed questions
- ✅ Flutter frontend with Provider pattern
- ✅ Secure score calculation on backend
- ✅ No duplicate leaderboard entries
- ✅ BCrypt password hashing

**Next Steps:**
1. Run backend: `dotnet run`
2. Run Flutter: `flutter run`
3. Test with Postman
4. Present to your BCA panel! 🎓
