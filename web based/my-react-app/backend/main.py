from fastapi import FastAPI, WebSocket, WebSocketDisconnect
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import JSONResponse
import asyncio
import json
from datetime import datetime
import uvicorn

from routes import bins, alerts, dashboard, routes, auth
from database import init_demo_data
from models import ConnectionManager

app = FastAPI(title="SwachhGrid API", version="1.0.0")

# CORS middleware
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # In production, specify your frontend URL
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# WebSocket connection manager
manager = ConnectionManager()

# Include routers
app.include_router(auth.router, prefix="/api", tags=["authentication"])
app.include_router(bins.router, prefix="/api", tags=["bins"])
app.include_router(alerts.router, prefix="/api", tags=["alerts"])
app.include_router(dashboard.router, prefix="/api", tags=["dashboard"])
app.include_router(routes.router, prefix="/api", tags=["routes"])

@app.get("/")
async def root():
    return {"message": "SwachhGrid Smart Waste Management API", "status": "running"}

@app.post("/api/initialize-demo-data")
async def initialize_demo_data():
    """Initialize demo data for the application"""
    try:
        from database import init_demo_users
        # Initialize both demo data and demo users
        result = init_demo_data()
        user_count = init_demo_users()
        return {
            "message": "Demo data and users initialized successfully", 
            "data": result,
            "users_created": user_count
        }
    except Exception as e:
        return JSONResponse(
            status_code=500,
            content={"error": f"Failed to initialize demo data: {str(e)}"}
        )

@app.websocket("/ws")
async def websocket_endpoint(websocket: WebSocket):
    await manager.connect(websocket)
    try:
        while True:
            data = await websocket.receive_text()
            # Echo the received data (you can implement more complex logic here)
            await manager.broadcast(f"Message received: {data}")
    except WebSocketDisconnect:
        manager.disconnect(websocket)

if __name__ == "__main__":
    uvicorn.run(app, host="0.0.0.0", port=8000)