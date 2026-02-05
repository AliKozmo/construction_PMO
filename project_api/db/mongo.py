from pymongo import MongoClient
import os

MONGO_URI = os.getenv("MONGO_URI", "mongodb://localhost:27017")
client = MongoClient(MONGO_URI)

db = client["PMO_DB"]

clients_collection = db["clients"]
payments_collection = db["payments"]
tasks_collection = db["tasks"]
reports_collection = db["reports"]
documents_collection = db["documents"]
risks_collection = db["risks"]
