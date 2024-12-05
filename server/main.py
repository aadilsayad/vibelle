from fastapi import FastAPI
from pydantic import BaseModel
from sqlalchemy import TEXT, VARCHAR, Column, LargeBinary, create_engine
from sqlalchemy.orm import sessionmaker
from sqlalchemy.ext.declarative import declarative_base

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
    # extract the data from request body
    print(signup_request.name)
    print(signup_request.email)
    print(signup_request.password)
    # check if useer already exists in the db
    # add user to the db
    pass


Base.metadata.create_all(engine)