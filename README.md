# Setup

This project includes:

- **Backend:** Node.js + Express server connected to SQL Server database  
- **Frontend:** Flutter app for managing products
## Installation

### Backend Setup

```bash
cd backend
```
```bash
npm install
```
```bash
node server.js
```

### Database Setup

```
sqlcmd -S YOUR_SERVER -U YOUR_USERNAME -P YOUR_PASSWORD -i setup_db.sql
```
### Frontend Setup

```bash
cd frontend
```
```bash
flutter pub get
```
```bash
flutter run
```
### API Base url

```bash
http://192.168.1.10:2000
```
