#!/usr/bin/env python3
import requests

r = requests.get("https://ya.ru")
print(r.status_code, r.headers)
