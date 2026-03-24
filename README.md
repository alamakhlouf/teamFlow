# 🚀 TeamFlow

A Flutter-based task and project management application designed to streamline collaboration between **Admins**, **Managers**, and **Employees**.

---

## 📱 Overview

**TeamFlow** allows organizations to:
- Manage users with different roles
- Create and assign projects
- Break projects into tasks
- Track task progress in real-time

The app is built using **Flutter**, **Firebase Authentication**, **Cloud Firestore**, and **BLoC architecture**.

---

## 🧩 Features

### 🔐 Authentication
- Email & password login
- User registration (Admin only)
- Logout
- First login password reset flow

---

### 👥 User Management (Admin)
- Create users
- Update user details
- Delete users
- Assign managers to users

---

### 📁 Project Management
- Managers can create projects
- Assign employees to projects
- Update and delete projects

#### Role-based visibility:
- **Admin** → sees all projects  
- **Manager** → sees owned projects  
- **User** → sees assigned projects  

---

### ✅ Task Management
- Create tasks inside projects
- Assign tasks to employees
- Update task details
- Delete tasks

#### Permissions:
- **Admin / Manager**
  - Create / Edit / Delete tasks
  - Assign tasks

- **User**
  - Can ONLY update task status

---

### 🔄 Real-time Updates
- All users, projects, and tasks update instantly using Firestore streams

---

### 👤 Profile
- View user info:
  - Name
  - Email
  - Role
  - Manager (if assigned)

---

## 🏗️ Architecture

The app follows Clean Architecture principles:

features/
 ├── auth/
 ├── users/
 ├── projects/
 ├── tasks/
 ├── profile/

Each feature contains:
- data → models  
- domain → repositories  
- presentation → UI + BLoC  

---

## 🔄 State Management

Uses BLoC (flutter_bloc):
- Clear separation between UI and business logic
- Event-driven architecture
- Scalable and maintainable

---

## ☁️ Firebase Structure

### users
users/{userId}
- uid
- email
- displayName
- role
- managerId
- firstLogin

### projects
projects/{projectId}
- id
- title
- description
- managerId
- employeeIds

### tasks
projects/{projectId}/tasks/{taskId}
- id
- title
- description
- assignedTo
- status
- createdAt

---

## 🛠️ Tech Stack

- Flutter
- Dart
- Firebase Auth
- Cloud Firestore
- flutter_bloc

---

## ▶️ Getting Started

git clone https://github.com/your-username/team_flow.git
cd team_flow
flutter pub get
flutter run

---

## 💡 Author

Developed by Ala Makhlouf
