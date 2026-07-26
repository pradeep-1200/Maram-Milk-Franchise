# Maram Milk Franchise Management System

A comprehensive solution to streamline morning operations and distribution management for Maram Milk franchises. This repository contains both the mobile application (`manager_app`) and the backend API service (`Backend`).

## Project Overview

The **Maram Milk Franchise Management System** is designed to handle the daily logistics of milk delivery franchises. It assists franchise managers with:
- **Delivery Person (DP) Attendance**: Tracking daily check-ins, absences, and standbys.
- **Route Allocation**: Assigning daily delivery routes to present delivery personnel.
- **Milk Allocation & Inventory**: Tracking 1L and 500ml milk packet inventory and allocating them to routes based on customer demands.
- **Petrol Allowances**: Managing and logging fixed petrol payouts or shortages.
- **Empty Bottle Return Tracking**: Logging returned bottles after the morning delivery runs (Evening Checks).
- **Transactions Ledger**: Maintaining detailed financial ledgers for delivery persons, including petrol allowances, shortages, and extra payouts.
- **Performance Reports**: Generating comprehensive reports on litres delivered, routes handled, attendance rates, and bottles returned.

---

## 📱 Manager App (Frontend)

The `manager_app` is a cross-platform mobile application built to provide a seamless interface for franchise managers on the go.

### Tech Stack
- **Framework**: Flutter (Dart SDK `^3.8.1`)
- **State Management**: Riverpod (`flutter_riverpod: ^3.3.2`)
- **Routing**: go_router (`^17.0.0`)
- **Data Serialization**: freezed (`^3.1.0`), json_serializable (`^4.9.0`)
- **Network**: Dio (`^5.10.0`)
- **Security**: local_auth (Biometrics)

### Key Features
- **Dashboard**: High-level overview of daily operations, top delivery personnel, and pending actions.
- **Dispatch Workflow**: A step-by-step wizard for attendance, inventory verification, and route allocation.
- **Evening Check**: Dedicated screens to log empty bottle returns and any route-specific issues post-delivery.
- **Ledger & Reports**: Detailed views and exportable CSV reports to track DP performance and financial transactions.

*(For full frontend architectural details, refer to `manager_app/project_context_and_master_prompt.md`)*

---

## ⚙️ Backend API Service (Backend)

The `Backend` handles all business logic, data persistence, and API endpoints consumed by the Manager App.

### Tech Stack
- **Runtime**: Node.js
- **Language**: TypeScript
- **Framework**: Express.js
- **Database**: PostgreSQL
- **ORM**: Prisma Client
- **Authentication**: JWT (JSON Web Tokens)

### Core Modules
- **Attendance Module**: Marks and tracks daily DP attendance.
- **Dispatch Module**: Manages the overarching workflow states (Attendance Complete -> Routes Complete -> Inventory Complete).
- **Inventory Module**: Handles stock decrements, daily stock initialization, and tracking.
- **Ledger Module**: Records financial interactions like petrol allowances and ledger adjustments.
- **Reports Module**: Aggregates data across routes, inventory, and attendance to provide performance metrics.
- **Routes Module**: Handles the complex logic of allocating stock to a route and deducting from daily inventory, enforcing stock limits.

---

## Getting Started

### Prerequisites
- [Flutter SDK](https://docs.flutter.dev/get-started/install) (`>=3.0.0`)
- [Node.js](https://nodejs.org/) (`>=18.0.0`)
- [PostgreSQL](https://www.postgresql.org/)

### Setting up the Backend
1. Navigate to the backend directory:
   ```bash
   cd Backend
   ```
2. Install dependencies:
   ```bash
   npm install
   ```
3. Set up environment variables by copying `.env.example` to `.env` and configuring your Postgres connection string.
4. Run Prisma migrations and seed the database:
   ```bash
   npx prisma migrate dev
   npm run seed
   ```
5. Start the development server:
   ```bash
   npm run dev
   ```

### Setting up the Manager App
1. Navigate to the app directory:
   ```bash
   cd manager_app
   ```
2. Install dependencies:
   ```bash
   flutter pub get
   ```
3. Generate Freezed/JSON models (if making modifications):
   ```bash
   flutter pub run build_runner build -d
   ```
4. Run the app:
   ```bash
   flutter run
   ```

---

## License

This project is proprietary and confidential. Unauthorized copying of files from this repository, via any medium, is strictly prohibited.
