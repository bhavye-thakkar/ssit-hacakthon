from fastapi import APIRouter, HTTPException
from typing import List
from models import Bin, BinCreate, BinUpdate
from database import get_bins, get_bin, create_bin, update_bin

router = APIRouter()

@router.get("/bins", response_model=List[Bin])
async def get_all_bins():
    """Get all waste bins"""
    return get_bins()

@router.get("/bins/{bin_id}", response_model=Bin)
async def get_single_bin(bin_id: str):
    """Get a specific bin by ID"""
    bin_data = get_bin(bin_id)
    if not bin_data:
        raise HTTPException(status_code=404, detail="Bin not found")
    return bin_data

@router.post("/bins", response_model=Bin)
async def create_new_bin(bin_data: BinCreate):
    """Create a new waste bin"""
    new_bin = create_bin(bin_data.dict())
    return new_bin

@router.put("/bins/{bin_id}", response_model=Bin)
async def update_existing_bin(bin_id: str, update_data: BinUpdate):
    """Update an existing bin"""
    updated_bin = update_bin(bin_id, update_data.dict(exclude_unset=True))
    if not updated_bin:
        raise HTTPException(status_code=404, detail="Bin not found")
    return updated_bin