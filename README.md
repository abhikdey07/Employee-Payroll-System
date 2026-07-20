# 🏢 Carelink Ai Payroll — Employee Payroll Management System

A full-stack Java Spring Boot application with cloud PostgreSQL database, modern animated UI, PDF payslip generation with email delivery, admin authentication, and session management.

![Java](https://img.shields.io/badge/Java-17-orange) ![Spring Boot](https://img.shields.io/badge/Spring%20Boot-3.2.5-green) ![PostgreSQL](https://img.shields.io/badge/PostgreSQL-Cloud-blue) ![License](https://img.shields.io/badge/License-MIT-yellow)

## ✨ Features

| Feature | Description |
|---------|-------------|
| 🔐 Admin Login | Secure authentication with BCrypt-hashed passwords |
| ⏱️ Session Tracking | 30-min session timeout with countdown + auto-logout |
| 👥 Employee CRUD | Full create, read, update, delete with search |
| 💰 Salary Management | Configurable salary components per employee |
| 📄 Payslip Generation | Auto-calculate with month/year selection |
| 📋 PDF Download | Professional payslip PDF via OpenPDF |
| 📧 Email Payslip | Beautiful HTML email + PDF attachment via Gmail |
| 🔔 Toast Notifications | Animated slide-in toasts for all actions |
| 🌙 Modern Dark UI | Glassmorphism, animations, responsive design |
| 🚀 Cloud Ready | Neon PostgreSQL + Docker for instant deployment |

## 🚀 Quick Start

### Prerequisites
- **Java 17** (JDK)
- **Maven** (or use the Maven wrapper)
- **PostgreSQL** database (local or cloud)

### 1. Clone & Configure

```bash
# Copy environment template
cp .env.example .env

# Edit .env with your credentials
```

### 2. Set Up Database (Neon - Free Cloud PostgreSQL)

1. Go to [neon.tech](https://neon.tech) and create a free account
2. Create a new project → copy the connection string
3. Update your `.env` file:

```env
DB_URL=jdbc:postgresql://ep-xxx.us-east-2.aws.neon.tech/neondb?sslmode=require
DB_USERNAME=your-username
DB_PASSWORD=your-password
```

### 3. Set Up Email (Gmail SMTP)

1. Enable **2-Step Verification** on your Google account
2. Go to [Google App Passwords](https://myaccount.google.com/apppasswords)
3. Create a new app password for "Mail"
4. Update your `.env`:

```env
MAIL_USERNAME=your-email@gmail.com
MAIL_PASSWORD=your-16-char-app-password
```

### 4. Run Locally

**Option A: With Maven**
```bash
# Set environment variables from .env (Linux/Mac)
export $(cat .env | xargs)

# Build and run
mvn clean package -DskipTests
java -jar target/employee-payroll-system-1.0.0.jar
```

**Option B: With Maven Spring Boot plugin**
```bash
mvn spring-boot:run
```

**Option C: With Docker**
```bash
docker build -t payrollpro .
docker run -p 8080:8080 --env-file .env payrollpro
```

### 5. Access the Application

Open [http://localhost:8080](http://localhost:8080)

**Default Admin Credentials:**
- **Username:** `admin`
- **Password:** `Admin@123`

## 🏗️ Architecture

```
┌──────────────────────────────────────────────────┐
│           Browser (Modern SPA Frontend)          │
│  Login → Dashboard → Employees → Payslips        │
└──────────────────┬───────────────────────────────┘
                   │ REST API (JSON)
┌──────────────────▼───────────────────────────────┐
│            Spring Boot Application                │
│  Security │ Controllers │ Services │ PDF │ Email  │
└──────────────────┬───────────────────────────────┘
                   │ JPA / Hibernate
┌──────────────────▼───────────────────────────────┐
│         Neon PostgreSQL (Cloud Database)          │
│    admins │ employees │ departments │ payslips    │
└──────────────────────────────────────────────────┘
```

## 📁 Project Structure

```
employee-payroll-system/
├── pom.xml                          # Maven dependencies
├── Dockerfile                       # Multi-stage Docker build
├── .env.example                     # Environment template
├── src/main/
│   ├── java/com/payroll/
│   │   ├── PayrollApplication.java  # Main entry point
│   │   ├── config/
│   │   │   ├── SecurityConfig.java  # Spring Security 6.x
│   │   │   └── DataInitializer.java # Seeds admin + departments
│   │   ├── controller/
│   │   │   ├── AuthController.java  # Login/Logout/Session
│   │   │   ├── DashboardController.java
│   │   │   ├── EmployeeController.java
│   │   │   └── PayslipController.java
│   │   ├── model/                   # JPA Entities
│   │   ├── repository/              # Spring Data JPA
│   │   ├── service/
│   │   │   ├── PdfService.java      # OpenPDF payslip generation
│   │   │   ├── EmailService.java    # Gmail SMTP + Thymeleaf
│   │   │   └── ...
│   │   └── dto/                     # Data Transfer Objects
│   └── resources/
│       ├── application.properties
│       ├── static/                  # Frontend SPA
│       │   ├── index.html
│       │   ├── css/style.css        # Dark mode design system
│       │   └── js/app.js            # Vanilla JS SPA
│       └── templates/
│           └── email-payslip.html   # Thymeleaf email template
```

## 🌐 Deploy to Cloud

### Deploy to Render (Free)

1. Push this project to a GitHub repository
2. Go to [render.com](https://render.com) → New Web Service
3. Connect your GitHub repo
4. Set:
   - **Build Command:** `mvn clean package -DskipTests`
   - **Start Command:** `java -jar target/employee-payroll-system-1.0.0.jar`
5. Add all environment variables from `.env.example`
6. Deploy!

### Deploy to Railway ($5/mo)

1. Push to GitHub
2. Go to [railway.app](https://railway.app) → New Project
3. Connect GitHub repo
4. Add environment variables
5. Deploy automatically!

## 🔧 Tech Stack

| Component | Technology |
|-----------|-----------|
| Backend | Spring Boot 3.2.5, Java 17 |
| Database | PostgreSQL (Neon Cloud) |
| ORM | Spring Data JPA / Hibernate |
| Auth | Spring Security 6.x (Sessions) |
| PDF | OpenPDF 1.4.2 |
| Email | Spring Mail + Gmail SMTP |
| Frontend | HTML5 + CSS3 + Vanilla JS |
| Templates | Thymeleaf (emails only) |
| Deploy | Docker + Render/Railway |

## 📝 API Endpoints

| Method | Endpoint | Description |
|--------|----------|-------------|
| POST | `/api/auth/login` | Admin login |
| POST | `/api/auth/logout` | Logout |
| GET | `/api/auth/session` | Check session |
| GET | `/api/dashboard/stats` | Dashboard statistics |
| GET | `/api/departments` | List departments |
| GET | `/api/employees` | List employees (with search/filter) |
| POST | `/api/employees` | Add employee |
| PUT | `/api/employees/{id}` | Update employee |
| DELETE | `/api/employees/{id}` | Delete employee |
| POST | `/api/payslips/generate` | Generate payslip |
| GET | `/api/payslips/{id}/pdf` | Download PDF |
| POST | `/api/payslips/{id}/email` | Email payslip |

## 📜 License

MIT License — feel free to use for any purpose.
