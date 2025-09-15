import uuid
import hashlib
from datetime import datetime, timedelta
from typing import Dict, List, Optional
import random
import math

# In-memory database simulation
bins_db: Dict[str, Dict] = {}
alerts_db: Dict[str, Dict] = {}
users_db: Dict[str, Dict] = {}

def generate_demo_bins():
    """Generate demo waste bins data"""
    locations = [
        {"name": "Central Park", "lat": 40.7829, "lng": -73.9654},
        {"name": "Times Square", "lat": 40.7580, "lng": -73.9855},
        {"name": "Brooklyn Bridge", "lat": 40.7061, "lng": -73.9969},
        {"name": "Empire State", "lat": 40.7484, "lng": -73.9857},
        {"name": "Wall Street", "lat": 40.7074, "lng": -74.0113},
        {"name": "Union Square", "lat": 40.7359, "lng": -73.9911},
        {"name": "Grand Central", "lat": 40.7527, "lng": -73.9772},
        {"name": "Columbus Circle", "lat": 40.7680, "lng": -73.9819},
        {"name": "Washington Square", "lat": 40.7308, "lng": -73.9973},
        {"name": "Bryant Park", "lat": 40.7536, "lng": -73.9832},
    ]

    bins = []
    for i, location in enumerate(locations):
        # Add some random variation to coordinates
        lat_offset = random.uniform(-0.002, 0.002)
        lng_offset = random.uniform(-0.002, 0.002)

        fill_level = random.uniform(10, 95)
        capacity = random.choice([100, 150, 200, 300])

        # Determine status based on fill level
        if fill_level >= 90:
            status = "critical"
        elif fill_level >= 75:
            status = "warning"
        else:
            status = "normal"

        # Calculate predicted full time
        if fill_level < 90:
            hours_to_full = random.uniform(2, 48)
            predicted_full_time = datetime.now() + timedelta(hours=hours_to_full)
        else:
            predicted_full_time = datetime.now() + timedelta(hours=1)

        bin_data = {
            "id": f"bin-{i+1:03d}",
            "name": f"Bin-{i+1:03d}",
            "latitude": location["lat"] + lat_offset,
            "longitude": location["lng"] + lng_offset,
            "capacity": capacity,
            "fill_level": round(fill_level, 1),
            "status": status,
            "location_type": random.choice(["street", "park", "commercial", "residential"]),
            "description": f"Waste bin at {location['name']}",
            "last_updated": datetime.now(),
            "predicted_full_time": predicted_full_time
        }
        bins.append(bin_data)

    return bins

def generate_demo_alerts(bins):
    """Generate demo alerts based on bin status"""
    alerts = []
    alert_id = 1

    for bin in bins:
        if bin["status"] == "critical":
            alerts.append({
                "id": f"alert-{alert_id}",
                "message": f"🚨 CRITICAL: Bin {bin['name']} is {bin['fill_level']}% full and needs immediate collection!",
                "severity": "critical",
                "bin_id": bin["id"],
                "created_at": datetime.now() - timedelta(minutes=random.randint(5, 60)),
                "acknowledged": False
            })
            alert_id += 1
        elif bin["status"] == "warning":
            alerts.append({
                "id": f"alert-{alert_id}",
                "message": f"⚠️ WARNING: Bin {bin['name']} is {bin['fill_level']}% full and should be collected soon.",
                "severity": "high",
                "bin_id": bin["id"],
                "created_at": datetime.now() - timedelta(minutes=random.randint(30, 120)),
                "acknowledged": False
            })
            alert_id += 1

    # Add some general alerts
    alerts.append({
        "id": f"alert-{alert_id}",
        "message": "🟢 System Status: All collection routes optimized for today",
        "severity": "low",
        "created_at": datetime.now() - timedelta(hours=2),
        "acknowledged": True
    })

    return alerts

def init_demo_data():
    """Initialize demo data"""
    global bins_db, alerts_db

    bins = generate_demo_bins()
    alerts = generate_demo_alerts(bins)

    # Store in database
    for bin in bins:
        bins_db[bin["id"]] = bin

    for alert in alerts:
        alerts_db[alert["id"]] = alert

    return {
        "bins_count": len(bins),
        "alerts_count": len(alerts),
        "message": "Demo data initialized successfully"
    }

def get_bins():
    """Get all bins"""
    return list(bins_db.values())

def get_bin(bin_id: str):
    """Get a specific bin"""
    return bins_db.get(bin_id)

def create_bin(bin_data: Dict):
    """Create a new bin"""
    bin_id = f"bin-{len(bins_db) + 1:03d}"
    new_bin = {
        "id": bin_id,
        "name": bin_data["name"],
        "latitude": bin_data["latitude"],
        "longitude": bin_data["longitude"],
        "capacity": bin_data["capacity"],
        "fill_level": 0.0,
        "status": "normal",
        "location_type": bin_data["location_type"],
        "description": bin_data.get("description", ""),
        "last_updated": datetime.now(),
        "predicted_full_time": datetime.now() + timedelta(days=7)
    }
    bins_db[bin_id] = new_bin
    return new_bin

def update_bin(bin_id: str, update_data: Dict):
    """Update a bin"""
    if bin_id not in bins_db:
        return None

    bin_data = bins_db[bin_id]
    for key, value in update_data.items():
        if key in bin_data:
            bin_data[key] = value

    bin_data["last_updated"] = datetime.now()
    return bin_data

def get_alerts():
    """Get all alerts"""
    return list(alerts_db.values())

def acknowledge_alert(alert_id: str):
    """Acknowledge an alert"""
    if alert_id in alerts_db:
        alerts_db[alert_id]["acknowledged"] = True
        return alerts_db[alert_id]
    return None

def get_dashboard_stats():
    """Calculate dashboard statistics"""
    bins = list(bins_db.values())
    if not bins:
        return {
            "total_bins": 0,
            "critical_bins": 0,
            "warning_bins": 0,
            "normal_bins": 0,
            "average_fill_level": 0.0,
            "bins_needing_collection": 0
        }

    total_bins = len(bins)
    critical_bins = len([b for b in bins if b["status"] == "critical"])
    warning_bins = len([b for b in bins if b["status"] == "warning"])
    normal_bins = len([b for b in bins if b["status"] == "normal"])
    average_fill_level = sum(b["fill_level"] for b in bins) / total_bins
    bins_needing_collection = len([b for b in bins if b["fill_level"] >= 75])

    return {
        "total_bins": total_bins,
        "critical_bins": critical_bins,
        "warning_bins": warning_bins,
        "normal_bins": normal_bins,
        "average_fill_level": round(average_fill_level, 1),
        "bins_needing_collection": bins_needing_collection
    }

# User Authentication Functions
def hash_password(password: str) -> str:
    """Simple password hashing for demo purposes"""
    return hashlib.sha256(password.encode()).hexdigest()

def verify_password(password: str, hashed: str) -> bool:
    """Verify password against hash"""
    return hash_password(password) == hashed

def create_user(user_data: Dict) -> Dict:
    """Create a new user"""
    user_id = str(uuid.uuid4())
    hashed_password = hash_password(user_data["password"])
    
    new_user = {
        "id": user_id,
        "name": user_data["name"],
        "email": user_data["email"],
        "password": hashed_password,
        "role": user_data.get("role", "user"),
        "avatar": f"https://api.dicebear.com/7.x/avataaars/svg?seed={user_data['email']}",
        "created_at": datetime.now()
    }
    
    users_db[user_id] = new_user
    return new_user

def get_user_by_email(email: str) -> Optional[Dict]:
    """Get user by email"""
    for user in users_db.values():
        if user["email"] == email:
            return user
    return None

def authenticate_user(email: str, password: str) -> Optional[Dict]:
    """Authenticate user with email and password"""
    user = get_user_by_email(email)
    if user and verify_password(password, user["password"]):
        # Return user without password
        return {k: v for k, v in user.items() if k != "password"}
    return None

def init_demo_users():
    """Initialize demo users for the system"""
    demo_users = [
        {
            "name": "Admin User",
            "email": "admin@swachhgrid.com",
            "password": "admin123",
            "role": "admin"
        },
        {
            "name": "Regular User",
            "email": "user@swachhgrid.com", 
            "password": "user123",
            "role": "user"
        },
        {
            "name": "Demo Admin",
            "email": "demo@admin.com",
            "password": "demo123",
            "role": "admin"
        },
        {
            "name": "Demo User",
            "email": "demo@user.com",
            "password": "demo123",
            "role": "user"
        }
    ]
    
    for user_data in demo_users:
        if not get_user_by_email(user_data["email"]):
            create_user(user_data)
    
    return len(demo_users)