import random
import requests
from fastapi import APIRouter

router = APIRouter()
# get random host url from Audius to use for subsequent requests
host = random.choice((requests.get('https://api.audius.co')).json()['data'])


@router.get('/tracks/trending')
def get_trending_tracks():
    headers = {
    'Accept': 'application/json'
    }

    api_response = requests.get(f'{host}/v1/tracks/trending', params={}, headers = headers)
    trending_tracks = api_response.json()
    return trending_tracks