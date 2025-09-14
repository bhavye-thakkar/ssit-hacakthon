from fastapi import APIRouter, HTTPException
from typing import List
from models import Alert
from database import get_alerts, acknowledge_alert

router = APIRouter()

@router.get("/alerts", response_model=List[Alert])
async def get_all_alerts():
    """Get all system alerts"""
    return get_alerts()

@router.put("/alerts/{alert_id}/acknowledge", response_model=Alert)
async def acknowledge_system_alert(alert_id: str):
    """Acknowledge a system alert"""
    acknowledged_alert = acknowledge_alert(alert_id)
    if not acknowledged_alert:
        raise HTTPException(status_code=404, detail="Alert not found")
    return acknowledged_alert