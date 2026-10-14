# SaloneRide

**A campus-based ride-hailing system for Sierra Leone**
PROG 202 Software Engineering, Assignment 1: Dart console prototype
Limkokwing University of Creative Technology, Sierra Leone (Group 3)

SaloneRide connects students, lecturers and staff with registered taxi,
kekeh and private vehicle drivers. This repository holds a single-file
console prototype that demonstrates the core logic of the system.

## Features

| User | What they can do |
|---|---|
| Passenger | Register, log in, compare vehicle options and fares, request a ride, view the current ride, cancel, rate the driver, view trip history |
| Driver | Register, log in, go online/offline, accept or reject requests, start and complete trips, view earnings and rating |
| Administrator | View all passengers, drivers and rides; suspend or reactivate accounts |

## How to run

You need the Dart SDK 3.0 or newer (it comes with Flutter).

```bash
cd saloneride
dart run main.dart
```

Use PowerShell or Command Prompt rather than Git Bash.

## Demo accounts

| Role | Login | Password |
|---|---|---|
| Passenger | 077111222 | pass123 |
| Driver (Kekeh) | 076123456 | driver123 |
| Driver (Taxi) | 077234567 | driver123 |
| Driver (Private Vehicle) | 078345678 | driver123 |
| Administrator | admin | admin123 |

## How the code is organised

`main.dart` is divided into eight labelled parts:

1. Data classes (Passenger, Driver, Ride)
2. System data and demo accounts
3. Main menu, registration and login
4. Passenger features
5. Driver features
6. Administrator features
7. Rules: checking input, fares and finding a driver
8. Small helpers for input and output

## Roadmap

| Stage | Deliverable |
|---|---|
| Assignment 1 | Single-file Dart console prototype (this repository) |
| Assignment 2 | Flutter app; driver approval, complaints and automatic reassignment added |
| Final Project | Supabase database, maps and live ride status |
