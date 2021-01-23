#export GOOGLE_APPLICATION_CREDENTIALS="C:/users/alanw/Desktop/Exp-App-TEST-7bdd7c483097.json"

# Imports the Google Cloud client library
from google.cloud import datastore

# json library
import json

import os
credential_path = "/Users/deborahlin/Desktop/Exp-Exp-190f0e3e405b.json"
os.environ['GOOGLE_APPLICATION_CREDENTIALS'] = credential_path

# Instantiates a client
datastore_client = datastore.Client()

# make query
query = datastore_client.query(kind='DataObject')
results = list(query.fetch())
print(json.dumps(results, indent=4, sort_keys=True, default=str))

# system call: pass it to a text file
# python downloadall.py > mydata.json
