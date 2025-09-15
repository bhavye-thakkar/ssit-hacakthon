from pydantic import BaseModel
from typing import List, Optional, Dict, Any
from datetime import datetime
from fastapi import WebSocket

class Bin(BaseModel):
    id: str
    name: str
    latitude: float
    longitude: float
    capacity: int
    fill_level: float
    status: str  # 'normal', 'warning', 'critical'
    location_type: str
    description: Optional[str] = None
    last_updated: datetime
    predicted_full_time: Optional[datetime] = None

class Alert(BaseModel):
    id: str
    message: str
    severity: str  # 'low', 'medium', 'high', 'critical'
    bin_id: Optional[str] = None
    created_at: datetime
    acknowledged: bool = False

class DashboardStats(BaseModel):
    total_bins: int
    critical_bins: int
    warning_bins: int
    normal_bins: int
    average_fill_level: float
    bins_needing_collection: int

class RouteOptimization(BaseModel):
    bin_ids: List[str]
    total_distance: float
    estimated_time: float  # in minutes
    coordinates: List[List[float]]

class BinCreate(BaseModel):
    name: str
    latitude: float
    longitude: float
    capacity: int
    location_type: str
    description: Optional[str] = None

class BinUpdate(BaseModel):
    fill_level: Optional[float] = None
    status: Optional[str] = None
    description: Optional[str] = None

# Authentication Models
class User(BaseModel):
    id: str
    name: str
    email: str
    role: str  # 'admin' or 'user'
    avatar: Optional[str] = None
    created_at: datetime

class UserCreate(BaseModel):
    name: str
    email: str
    password: str
    role: str = 'user'

class UserLogin(BaseModel):
    email: str
    password: str

class LoginResponse(BaseModel):
    user: User
    token: str
    message: str

class ConnectionManager:
    def __init__(self):
        self.active_connections: List[WebSocket] = []

    async def connect(self, websocket: WebSocket):
        await websocket.accept()
        self.active_connections.append(websocket)

    def disconnect(self, websocket: WebSocket):
        self.active_connections.remove(websocket)

    async def broadcast(self, message: str):
        for connection in self.active_connections:
            try:
                await connection.send_text(message)
            except:
                self.disconnect(connection)