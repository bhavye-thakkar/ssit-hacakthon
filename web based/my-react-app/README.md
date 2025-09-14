# SwachhGrid - Smart Waste Management System

A comprehensive smart waste management system with real-time monitoring, AI-powered route optimization, and an intuitive web interface for managing urban waste collection.

## 🚀 Features

### Frontend Features
- **Interactive Map**: Real-time visualization of waste bins using Leaflet
- **Dashboard**: Comprehensive statistics and analytics
- **Route Optimization**: AI-powered collection route planning
- **Real-time Alerts**: Live notifications for bin status changes
- **Admin Panel**: Bin management and user request handling
- **Dark Mode**: Theme switching capability
- **Responsive Design**: Mobile-friendly interface
- **Role-based Access**: Admin and user permissions

### Backend Features
- **RESTful API**: Complete API with FastAPI
- **WebSocket Support**: Real-time data streaming
- **In-memory Database**: Fast data storage simulation
- **Route Optimization**: Nearest neighbor algorithm
- **Demo Data Generation**: Automated test data creation
- **CORS Support**: Cross-origin resource sharing

## 🏗️ Architecture

```
SwachhGrid/
├── frontend/          # React application
│   ├── src/
│   │   ├── components/    # UI components
│   │   ├── App.js         # Main application
│   │   └── ...
│   └── public/
├── backend/           # FastAPI backend
│   ├── main.py            # FastAPI application
│   ├── models.py          # Pydantic models
│   ├── database.py        # Data management
│   ├── routes/            # API endpoints
│   └── utils/             # Utilities
└── README.md
```

## 📋 Prerequisites

- **Python 3.8+** for backend
- **Node.js 16+** for frontend
- **npm** or **yarn** package manager

## 🚀 Quick Start

### 1. Backend Setup

```bash
# Navigate to backend directory
cd my-react-app/backend

# Create virtual environment
python -m venv venv

# Activate virtual environment
# On Windows:
venv\Scripts\activate
# On macOS/Linux:
source venv/bin/activate

# Install dependencies
pip install -r requirements.txt

# Start the backend server
python main.py
```

The backend will start on `http://localhost:8000`

### 2. Frontend Setup

```bash
# Navigate to frontend directory (in a new terminal)
cd my-react-app

# Install dependencies
npm install

# Start the development server
npm start
```

The frontend will start on `http://localhost:3000`

## 🔧 Configuration

### Environment Variables

Create a `.env` file in the frontend directory:

```env
REACT_APP_BACKEND_URL=http://localhost:8000
```

## 📡 API Endpoints

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/` | Root endpoint |
| POST | `/api/initialize-demo-data` | Initialize demo data |
| GET | `/api/bins` | Get all bins |
| GET | `/api/bins/{id}` | Get single bin |
| POST | `/api/bins` | Create new bin |
| PUT | `/api/bins/{id}` | Update bin |
| GET | `/api/dashboard/stats` | Get dashboard stats |
| GET | `/api/route/optimize` | Optimize collection route |
| GET | `/api/alerts` | Get all alerts |
| PUT | `/api/alerts/{id}/acknowledge` | Acknowledge alert |
| WS | `/ws` | WebSocket for real-time updates |

## 🎮 Demo Usage

1. **Start both servers** (backend and frontend)
2. **Login** using demo credentials:
   - **Admin**: Click "Admin Demo" button
   - **User**: Click "User Demo" button
3. **Initialize Demo Data**: Click the demo mode button to load sample data
4. **Explore Features**:
   - View bins on the interactive map
   - Check dashboard statistics
   - Optimize collection routes
   - Monitor real-time alerts

## 🛠️ Development

### Backend Development

```bash
# Run with auto-reload
uvicorn main:app --reload --host 0.0.0.0 --port 8000

# Access API documentation
# Visit: http://localhost:8000/docs
```

### Frontend Development

```bash
# Start development server
npm start

# Build for production
npm run build

# Run tests
npm test
```

## 📊 Data Models

### Bin Model
```json
{
  "id": "bin-001",
  "name": "Bin-001",
  "latitude": 40.7580,
  "longitude": -73.9855,
  "capacity": 150,
  "fill_level": 75.5,
  "status": "warning",
  "location_type": "street",
  "description": "Waste bin description",
  "last_updated": "2024-01-01T12:00:00Z",
  "predicted_full_time": "2024-01-01T18:00:00Z"
}
```

### Alert Model
```json
{
  "id": "alert-001",
  "message": "Bin Bin-001 is 90% full",
  "severity": "high",
  "bin_id": "bin-001",
  "created_at": "2024-01-01T12:00:00Z",
  "acknowledged": false
}
```

## 🔒 Authentication

The application uses a simple demo authentication system:
- **Admin Role**: Full access to all features including bin management
- **User Role**: Limited access, can request new bins but cannot manage existing ones

## 🌟 Key Features Explained

### Real-time Monitoring
- Live bin status updates via WebSocket
- Automatic alert generation based on fill levels
- Predictive analytics for collection timing

### Route Optimization
- AI-powered route planning using nearest neighbor algorithm
- Distance and time calculations
- Visual route display on map

### Smart Alerts
- Critical alerts for bins ≥90% full
- Warning alerts for bins ≥75% full
- Acknowledgment system for alert management

## 🚀 Deployment

### Backend Deployment
```bash
# Production server
uvicorn main:app --host 0.0.0.0 --port 8000
```

### Frontend Deployment
```bash
# Build for production
npm run build

# Serve static files
npx serve -s build -l 3000
```

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 📞 Support

For questions or issues:
- Check the API documentation at `/docs`
- Review the console logs for error messages
- Ensure all dependencies are properly installed

---

**SwachhGrid** - Making cities cleaner, smarter, and more sustainable! 🌱
