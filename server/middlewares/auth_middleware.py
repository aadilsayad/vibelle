from fastapi import HTTPException, Header
import jwt


def validate_auth_token(x_auth_token=Header()):
    try:
        if not x_auth_token:
            raise HTTPException(401, 'No access token. Access denied.')
        
        # decode the token from header
        token_payload = jwt.decode(jwt=x_auth_token, key='secret_key', algorithms='HS256')
        
        # get user id from the token_payload {'id': user_id}
        user_id = token_payload.get('id')
        return {'user_id': user_id}
    
    except jwt.PyJWTError:
        raise HTTPException(401, 'Invalid token. Authorization failed.')