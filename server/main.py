import bcrypt
from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
from sqlalchemy import TEXT, VARCHAR, Column, LargeBinary, create_engine
from sqlalchemy.orm import sessionmaker
from sqlalchemy.ext.declarative import declarative_base
import uuid

app = FastAPI()

DATABASE_URL = 'postgresql://postgres:postgres@localhost:5432/vibelle'

engine = create_engine(DATABASE_URL)
sessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)
db = sessionLocal()


class UserSignup(BaseModel):
    name: str
    email: str
    password: str


Base = declarative_base()

class User(Base):
    __tablename__ = 'users'
    
    id = Column(TEXT, primary_key=True)
    name = Column(VARCHAR(100))
    email = Column(VARCHAR(100))
    password = Column(LargeBinary)


@app.post('/signup')
def signup_user(signup_request: UserSignup):
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


Base.metadata.create_all(engine)