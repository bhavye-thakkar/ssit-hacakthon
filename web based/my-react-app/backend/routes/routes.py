from fastapi import APIRouter
from models import RouteOptimization
from utils.route_optimizer import optimize_collection_route

router = APIRouter()

@router.get("/route/optimize", response_model=RouteOptimization)
async def optimize_collection_route_endpoint():
    """Optimize collection route for waste bins"""
    return optimize_collection_route()