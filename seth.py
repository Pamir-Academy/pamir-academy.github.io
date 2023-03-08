#!/usr/bin/env python3

import json
from hashlib import sha512
from base64 import b64encode
from random import randbytes  # for iv?=...
from datetime import datetime, timedelta, timezone
from fastapi import FastAPI, WebSocket, WebSocketDisconnect, HTTPException
from fastapi.responses import JSONResponse, HTMLResponse, RedirectResponse, FileResponse

from jwt import (
    JWT,
    jwk_from_dict,
    jwk_from_pem,
)
from jwt.utils import get_int_from_datetime


instance = JWT()

message = {
    'iss': 'https://pamir-academy.github.io/',
    'sub': 'npub1fx6036g40wq40c2nqgrssa0xxx8jx4hawgks8uujwxhjaa9scwysshkwcg',
    'iat': get_int_from_datetime(datetime.now(timezone.utc)),
    'exp': get_int_from_datetime(
        datetime.now(timezone.utc) + timedelta(hours=2)),
}

"""
Encode the message to JWT(JWS).
"""

# Load a RSA key from a JWK dict.
signing_key = jwk_from_dict({
    'kty': 'RSA',
    'e': 'AQAB',
    'n': '...',
    'd': '...'})
# Or load a RSA key from a PEM file.
with open('rsa_private_key.pem', 'rb') as fh:
    signing_key = jwk_from_pem(fh.read())
# You can also load an octet key in the same manner as the RSA.
# signing_key = jwk_from_dict({'kty': 'oct', 'k': '...'})

compact_jws = instance.encode(message, signing_key, alg='RS256')

"""
Decode the JWT with verifying the signature.
"""

# Load a public key from PEM file corresponding to the signing private key.
with open('rsa_public_key.json', 'r') as fh:
    verifying_key = jwk_from_dict(json.load(fh))

message_received = instance.decode(
    compact_jws, verifying_key, do_time_check=True)

"""
Successfuly retrieved the `message` from the `compact_jws`
"""
assert message == message_received
api = FastAPI()

@api.get('/')
def app():
    # logic..[Thinking..]
    return RedirectResponse('/#home') # inject TS here.
