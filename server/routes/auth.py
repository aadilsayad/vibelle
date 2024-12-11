from fastapi import Depends, HTTPException, APIRouter
from middlewares.auth_middleware import validate_auth_token
from pydantic_schemas.user_signup import UserSignup
from pydantic_schemas.user_login import UserLogin
from models.user import User
from database import get_db
from sqlalchemy.orm import Session
import uuid
import bcrypt
import jwt

router = APIRouter()


@router.post('/signup', status_code=201)
def signup_user(signup_request: UserSignup, db: Session=Depends(get_db)):
    # check if user already exists in the db
    existing_user = db.query(User).filter(User.email == signup_request.email).first()
    if existing_user:
        raise HTTPException(400, 'User with the same email already exists!')
    
    # add user to the db
    hashed_password = bcrypt.hashpw(password=signup_request.password.encode(), salt=bcrypt.gensalt())
    created_user = User(id=str(uuid.uuid4()), name=signup_request.name, email=signup_request.email, password=hashed_password)
    db.add(created_user)
    db.commit()
    db.refresh(created_user)

    return created_user


@router.post('/login')
def login_user(login_request: UserLogin, db: Session=Depends(get_db)):
    # check whether user with same email already exists, else show error
    existing_user = db.query(User).filter(User.email == login_request.email).first()
    if not existing_user:
        raise HTTPException(400, 'User with this email does not exist!')

    # then check if password matches, else show error
    is_password_match = bcrypt.checkpw(password=login_request.password.encode(), hashed_password=existing_user.password)
    if not is_password_match:
        raise HTTPException(400, 'Incorrect password!')

    # then return user data and access token
    access_token = jwt.encode(payload={'id': existing_user.id}, key='secret_key')
    return {'access_token': access_token, 'user': existing_user}


@router.get('/')
def get_current_user(db: Session=Depends(get_db), auth_data=Depends(validate_auth_token)):
    user = db.query(User).filter(User.id == auth_data['user_id']).first()
    if not user:
        raise HTTPException(404, 'User not found.')
    
    return user