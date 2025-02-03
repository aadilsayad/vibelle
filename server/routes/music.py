import random
import requests
from fastapi import APIRouter, Depends, HTTPException
from middlewares.auth_middleware import validate_auth_token
from pydantic_schemas.stream_request import StreamRequest
from utils.color_picker import extract_track_colors

router = APIRouter()
# get random host url from Audius to use for subsequent requests
host = random.choice((requests.get('https://api.audius.co')).json()['data'])


@router.get('/tracks/trending')
def get_trending_tracks(auth_data=Depends(validate_auth_token)):
    headers = {
        'Accept': 'application/json'
    }

    api_response = requests.get(f'{host}/v1/tracks/trending', params={}, headers = headers)
    trending_tracks = api_response.json()
    trending_tracks_compact = []
    trending_tracks_detailed = trending_tracks['data']
    for track in trending_tracks_detailed:
        trending_tracks_compact.append(
            {
                'id': track['id'],
                'title': track['title'],
                'artist': track['user']['name'],
                'artwork_url': track['artwork']['480x480'],
                'primary_color': '',
                'secondary_color': '',
            }
        )
    return trending_tracks_compact


@router.post('/tracks/stream')
def get_stream_url(stream_request: StreamRequest, auth_data=Depends(validate_auth_token)):
    headers = {
        'Accept': 'application/json'
    }
    track_response = requests.get(f'{host}/v1/tracks/{stream_request.track_id}', headers=headers)
    track_details = track_response.json()['data']
    artwork_url = track_details['artwork']['480x480']
    colors = extract_track_colors(artwork_url)


    api_response = requests.get(f'{host}/v1/tracks/{stream_request.track_id}/stream', params={'no_redirect': True}, headers = headers)
    stream_data = api_response.json()
    if not stream_data:
        raise HTTPException(404, 'Track not found!')
    stream_url = stream_data['data']
    
    return {
        'stream_url': stream_url,
        'primary_color': colors['primary_color'],
        'secondary_color': colors['secondary_color']
    }


@router.get('/playlists/trending')
def get_trending_playlists(auth_data=Depends(validate_auth_token)):
    headers = {
        'Accept': 'application/json'
    }

    api_response = requests.get(f'{host}/v1/full/playlists/trending', params={'limit': 20, 'time': 'year'}, headers = headers)
    trending_playlists = api_response.json()
    trending_playlists_detailed = trending_playlists['data']
    trending_playlists_compact = []
    for playlist in trending_playlists_detailed:
        trending_playlists_compact.append(
            {
                'id': playlist['id'],
                'title': playlist['playlist_name'],
                'artist': playlist['user']['name'],
                'artwork_url': playlist['artwork']['480x480'],
                'tracks': [
                    {
                        'id': track['id'],
                        'title': track['title'],
                        'artist': track['user']['name'],
                        'artwork_url': track['artwork']['480x480'],
                        'primary_color': '',
                        'secondary_color': '',
                    } for track in playlist['tracks']
                ]
            }
        )
    return trending_playlists_compact
