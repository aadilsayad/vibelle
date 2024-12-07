from fastapi import Depends, HTTPException, APIRouter
from pydantic_schemas.user_signup import UserSignup
from models.user import User
from database import get_db
from sqlalchemy.orm import Session
import uuid
import bcrypt

router = APIRouter()


@router.post('/signup')
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