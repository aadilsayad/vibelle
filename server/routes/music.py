import random
import requests
from fastapi import APIRouter, Depends, HTTPException
from middlewares.auth_middleware import validate_auth_token
from pydantic_schemas.stream_request import StreamRequest

router = APIRouter()
# get random host url from Audius to use for subsequent requests
host = random.choice((requests.get('https://api.audius.co')).json()['data'])


@router.get('/tracks/trending')
def get_trending_tracks(auth_data=Depends(validate_auth_token)):
    headers = {
        'Accept': 'application/json'
    }

    api_response = requests.get(f'{host}/v1/tracks/trending', params={}, headers = headers)
    trending_tracks_detailed = api_response.json()
    trending_tracks_compact = []
    for track in trending_tracks_detailed['data']:
        trending_tracks_compact.append(
            {
                'id': track['id'],
                'title': track['title'],
                'artist': track['user']['name'],
                'artwork_url': track['artwork']['150x150'],
                'song_url': track['permalink'],
                'primary_color': 'FFFFFF',
                'secondary_color': '000000',
            }
        )
    return trending_tracks_compact


@router.post('/tracks/stream')
def get_stream_url(stream_request: StreamRequest, auth_data=Depends(validate_auth_token)):
    headers = {
        'Accept': 'application/json'
    }
    api_response = requests.get(f'{host}/v1/tracks/{stream_request.track_id}/stream', params={'no_redirect': True}, headers = headers)
    stream_data = api_response.json()
    if not stream_data:
        raise HTTPException(404, 'Track not found!')
    stream_url = stream_data['data']
    return {'stream_url': stream_url}
