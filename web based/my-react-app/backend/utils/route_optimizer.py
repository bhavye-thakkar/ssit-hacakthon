import random
from typing import List
from database import get_bins
from models import RouteOptimization

def calculate_distance(coord1: List[float], coord2: List[float]) -> float:
    """Calculate distance between two coordinates using Haversine formula"""
    lat1, lon1 = coord1
    lat2, lon2 = coord2

    # Convert to radians
    lat1_rad = lat1 * 3.14159 / 180
    lon1_rad = lon1 * 3.14159 / 180
    lat2_rad = lat2 * 3.14159 / 180
    lon2_rad = lon2 * 3.14159 / 180

    # Haversine formula
    dlat = lat2_rad - lat1_rad
    dlon = lon2_rad - lon1_rad

    a = (dlat/2).sin()**2 + lat1_rad.cos() * lat2_rad.cos() * (dlon/2).sin()**2
    c = 2 * a.sqrt().asin()

    # Earth's radius in kilometers
    r = 6371
    return c * r

def optimize_collection_route() -> RouteOptimization:
    """Optimize collection route using a simple nearest neighbor algorithm"""
    bins = get_bins()

    if not bins:
        return RouteOptimization(
            bin_ids=[],
            total_distance=0.0,
            estimated_time=0.0,
            coordinates=[]
        )

    # Filter bins that need collection (fill level >= 75%)
    bins_to_collect = [bin for bin in bins if bin["fill_level"] >= 75]

    if not bins_to_collect:
        return RouteOptimization(
            bin_ids=[],
            total_distance=0.0,
            estimated_time=0.0,
            coordinates=[]
        )

    # Simple nearest neighbor algorithm starting from first bin
    route = [bins_to_collect[0]]
    remaining_bins = bins_to_collect[1:]

    while remaining_bins:
        current_bin = route[-1]
        current_coords = [current_bin["latitude"], current_bin["longitude"]]

        # Find nearest remaining bin
        nearest_bin = min(remaining_bins,
                         key=lambda b: calculate_distance(
                             current_coords,
                             [b["latitude"], b["longitude"]]
                         ))

        route.append(nearest_bin)
        remaining_bins.remove(nearest_bin)

    # Calculate total distance and time
    total_distance = 0.0
    coordinates = []

    for i in range(len(route)):
        bin_data = route[i]
        coordinates.append([bin_data["latitude"], bin_data["longitude"]])

        if i > 0:
            prev_coords = [route[i-1]["latitude"], route[i-1]["longitude"]]
            current_coords = [bin_data["latitude"], bin_data["longitude"]]
            total_distance += calculate_distance(prev_coords, current_coords)

    # Estimate time (assuming 30 km/h average speed + 5 minutes per bin)
    estimated_time = (total_distance / 30) * 60 + (len(route) * 5)

    return RouteOptimization(
        bin_ids=[bin["id"] for bin in route],
        total_distance=round(total_distance, 2),
        estimated_time=round(estimated_time, 1),
        coordinates=coordinates
    )