from fastapi import FastAPI
from routes import auth, music
from models.base import Base
from database import engine

app = FastAPI()
app.include_router(auth.router, prefix='/auth')
app.include_router(music.router, prefix='/music')

Base.metadata.create_all(engine)