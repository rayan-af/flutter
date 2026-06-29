<h1 align="center">
  <br>
  <img src="assets/images/app_logo.png" alt="RestoManager" width="200">
  <br>
  RestoManager
  <br>
</h1>

<h4 align="center">A futuristic, cross-platform restaurant management system built with Flutter and Firebase.</h4>

<p align="center">
  <a href="#features">Features</a> •
  <a href="#tech-stack">Tech Stack</a> •
  <a href="#nfc-table-seating">NFC Integration</a> •
  <a href="#getting-started">Getting Started</a>
</p>

## Overview
**RestoManager** is an end-to-end management solution designed for modern restaurants. It features real-time synchronization between the kitchen, waitstaff, and customers, streamlining operations from the moment a guest sits down to the moment their food is served.

## Features

- 📱 **Cross-Platform:** Runs natively on Web, Android, iOS, Windows, and macOS from a single codebase.
- 📡 **NFC Table Seating:** Customers can tap their phones on physical NFC chips at their tables to instantly trigger a backend event, automatically assigning them to the table and notifying waitstaff in real-time.
- 🛎️ **Real-Time Waiter Dashboard:** Waiters receive instant, color-coded updates via Firebase when tables are seated, orders are placed, or food is ready.
- 🧑‍🍳 **Chef Interface:** Dedicated real-time view for the kitchen staff to monitor incoming orders and update food statuses instantly.
- 🎨 **Premium UI/UX:** Built with a custom, sleek dark-mode aesthetic utilizing Material 3 design paradigms.

## Interface Showcases

### 📱 Customer Menu (NFC)
<p align="center">
  <img src="assets/images/client1.jpg" width="200">
  <img src="assets/images/client2.jpg" width="200">
  <img src="assets/images/client3.jpg" width="200">
  <img src="assets/images/client4.jpg" width="200">
  <img src="assets/images/client5.jpg" width="200">
  <img src="assets/images/client6.jpg" width="200">
  <img src="assets/images/client7.jpg" width="200">
</p>
<p align="center">
  <i>Customers simply tap their phone on the table's NFC tag. A beautiful digital menu opens instantly without any app installation, allowing them to browse and order directly.</i>
</p>

### 🛎️ Waiter Dashboard
<p align="center">
  <img src="assets/images/waiter1.jpg" width="200">
  <img src="assets/images/waiter2.jpg" width="200">
  <img src="assets/images/waiter3.jpg" width="200">
  <img src="assets/images/waiter4.jpg" width="200">
</p>
<p align="center">
  <i>Waiters get a real-time overview of their assigned tables, incoming customer orders, and instant notifications when the chef marks a dish as ready.</i>
</p>

### 🧑‍🍳 Chef Interface (KDS)
<p align="center">
  <img src="assets/images/chef.png" width="400">
</p>
<p align="center">
  <i>A completely paperless Kitchen Display System. Incoming orders appear instantly. Chefs can manage tickets and mark items as "Preparing" or "Ready" with a single tap.</i>
</p>

### 🏢 Reception / Front Desk
<p align="center">
  <img src="assets/images/recp1.png" width="200">
  <img src="assets/images/recp2.png" width="200">
  <img src="assets/images/recp3.png" width="200">
</p>
<p align="center">
  <i>The command center at the restaurant entrance. The receptionist can view real-time table occupancy, manage reservations, and seamlessly assign walk-in customers to available tables.</i>
</p>

### 📊 Manager Dashboard
<p align="center">
  <img src="assets/images/manager1.jpg" width="200">
  <img src="assets/images/manager2.jpg" width="200">
  <img src="assets/images/manager3.jpg" width="200">
  <img src="assets/images/manager4.png" width="200">
  <img src="assets/images/manager5.png" width="200">
</p>
<p align="center">
  <i>The administrative heart of the app. Managers can access financial analytics, track gross profit margins, modify the menu and pricing in real-time, and manage staff roles.</i>
</p>

### 🤖 AI Predictive Features
<p align="center">
  <img src="assets/images/ai1.jpg" width="300">
  <img src="assets/images/ai2.jpg" width="300">
</p>
<p align="center">
  <i>Leveraging the data collected by the Manager dashboard, the AI predictive models forecast inventory depletion and provide personalized dish recommendations for customers.</i>
</p>

### 📅 Employee Shifts (Work Time)
<p align="center">
  <img src="assets/images/worktime.png" width="300"> 
</p>
<p align="center">
  <i>A dedicated scheduling screen where employees can check their upcoming work shifts, specific hours, and daily roles (e.g., Main floor, Hosts Stand).</i>
</p>

## Tech Stack

- **Frontend:** [Flutter](https://flutter.dev/) (Dart)
- **Backend/Database:** [Firebase Firestore](https://firebase.google.com/docs/firestore)
- **State Management:** [Riverpod](https://riverpod.dev/)
- **Deep Linking:** [App Links](https://pub.dev/packages/app_links) (for NFC capability)
- **Routing:** Deeply integrated dynamic URL processing (`onGenerateRoute`)

## NFC Table Seating
To utilize the NFC feature, program your NFC tags with the following URL structure:
```
restomanager://table/{table_id}
```
*(Or point to your hosted web domain: `https://your-domain.com/#/table/{table_id}`)*

When a guest taps the tag, their device will automatically open the RestoManager app (or web portal), seat them at `{table_id}`, and instantly push a real-time notification to the Waiter Dashboard.

## Getting Started

1. Clone the repository:
```bash
git clone https://github.com/rayan-af/flutter.git
```

2. Install dependencies:
```bash
flutter pub get
```

3. Run the app:
```bash
flutter run
```

---
*Built with ❤️ using Flutter.*
