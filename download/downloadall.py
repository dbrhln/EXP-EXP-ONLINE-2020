# Imports the Google Cloud client library
from google.cloud import datastore

# json library
import json

import os
credential_path = "/my/credential/path/here"
os.environ['GOOGLE_APPLICATION_CREDENTIALS'] = credential_path

# Instantiates a client
datastore_client = datastore.Client()

# make query
query = datastore_client.query(kind='DataObject')
results = list(query.fetch())
print(json.dumps(results, indent=4, sort_keys=True, default=str))

# system call: pass it to a text file
# python downloadall.py > mydata.json
