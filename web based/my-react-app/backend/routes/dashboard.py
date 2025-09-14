from fastapi import APIRouter
from models import DashboardStats
from database import get_dashboard_stats

router = APIRouter()

@router.get("/dashboard/stats", response_model=DashboardStats)
async def get_dashboard_statistics():
    """Get dashboard statistics"""
    return get_dashboard_stats()