from fastapi import APIRouter, HTTPException, status
from models import UserCreate, UserLogin, LoginResponse, User
from database import create_user, authenticate_user, get_user_by_email, init_demo_users
import uuid

router = APIRouter()

@router.post("/auth/register", response_model=LoginResponse)
async def register_user(user_data: UserCreate):
    """Register a new user"""
    # Check if user already exists
    existing_user = get_user_by_email(user_data.email)
    if existing_user:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="User with this email already exists"
        )
    
    # Create new user
    new_user = create_user(user_data.dict())
    
    # Generate a simple token (in production, use JWT)
    token = str(uuid.uuid4())
    
    return LoginResponse(
        user=User(**{k: v for k, v in new_user.items() if k != "password"}),
        token=token,
        message="User registered successfully"
    )

@router.post("/auth/login", response_model=LoginResponse)
async def login_user(login_data: UserLogin):
    """Authenticate user and return user data"""
    user = authenticate_user(login_data.email, login_data.password)
    
    if not user:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Invalid email or password"
        )
    
    # Generate a simple token (in production, use JWT)
    token = str(uuid.uuid4())
    
    return LoginResponse(
        user=User(**user),
        token=token,
        message="Login successful"
    )

@router.post("/auth/init-demo-users")
async def initialize_demo_users():
    """Initialize demo users for the system"""
    try:
        count = init_demo_users()
        return {
            "message": f"Demo users initialized successfully",
            "users_created": count,
            "demo_credentials": {
                "admin": {"email": "admin@swachhgrid.com", "password": "admin123"},
                "user": {"email": "user@swachhgrid.com", "password": "user123"},
                "demo_admin": {"email": "demo@admin.com", "password": "demo123"},
                "demo_user": {"email": "demo@user.com", "password": "demo123"}
            }
        }
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"Failed to initialize demo users: {str(e)}"
        )
