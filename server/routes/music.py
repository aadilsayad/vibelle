import random
import requests
from fastapi import APIRouter, Depends
from middlewares.auth_middleware import validate_auth_token

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

# playlists/by_permalink/:handle/:slug
# CryptoMindset /playlist/ funky-hip-hop-and-rap-47454

# So I just confirmed that all Audius playlists have a permalink property of the form: "/{artist-handle}/playlist/{playlist-slug}"
# For example: "/CryptoMindset/playlist/funky-hip-hop-and-rap-47454"
# How do I extract the user-handle and playlist-slug values from the permalink now given that the leading '/' and the string '/playlist/' are the only separators between them?