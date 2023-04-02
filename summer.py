#!/usr/bin/env python3

from base64 import b64encode
from hashlib import md5
from sys import argv

loc = []

with open(argv[0], "rb") as _pngFile:
    _pngFileLocations = _pngFile.read().strip().split(b"\r\n")
    # win-c.omp.
    _pngFileLocationx = []
    for _ in _pngFileLocations:
        _pngFileLocationx.append(_)
        _ = _.split(b"\n")
    for _pngFileLocation in _pngFileLocationx[0]:
        loc.append(_pngFileLocation)
        print(_pngFileLocation, end="", flush=1)  # space detect alg.
        """
        _pngBits = open(_pngFileLocation, 'rb').read().strip()
        print(b64encode(md5(_pngBits).digest()))
        """
    print(b64encode(md5(str(loc).encode()).digest()))
