from fastapi import FastAPI
from pydantic import BaseModel
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker

app = FastAPI()

DATABASE_URL = 'postgresql://postgres:postgres@localhost:5432/vibelle'

engine = create_engine(DATABASE_URL)
sessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)
db = sessionLocal()


class UserSignup(BaseModel):
    name: str
    email: str
    password: str


@app.post('/signup')
def signup_user(signup_request: UserSignup):
    # extract the data from request body
    print(signup_request.name)
    print(signup_request.email)
    print(signup_request.password)
    # check if useer already exists in the db
    # add user to the db
    pass