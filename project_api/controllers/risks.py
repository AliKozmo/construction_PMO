import os
from pymongo import MongoClient
from bson.objectid import ObjectId
from dotenv import load_dotenv

# Load environment variables from .env
load_dotenv()  # Looks for .env in project root

# Get MongoDB connection info from environment
MONGO_URI = os.getenv("MONGO_URI")
MONGO_DB = os.getenv("MONGO_DB")

# Connect to MongoDB
client = MongoClient(MONGO_URI)
db = client[MONGO_DB]

# Collections
risks_collection = db["risks"]

# -------------------
# CREATE
# -------------------
def create_risk(
    project_id,
    description,
    category,
    likelihood,
    impact,
    mitigation_plan,
    status,
    identified_by,
    date_identified,
    date_resolved=None
):
    risk_data = {
        "project_id": project_id,
        "description": description,
        "category": category,
        "likelihood": likelihood,
        "impact": impact,
        "mitigation_plan": mitigation_plan,
        "status": status,
        "identified_by": identified_by,
        "date_identified": date_identified,
        "date_resolved": date_resolved
    }
    result = risks_collection.insert_one(risk_data)
    return str(result.inserted_id)

# -------------------
# READ
# -------------------
def get_risk_by_id(risk_id):
    risk = risks_collection.find_one({"_id": ObjectId(risk_id)})
    if risk:
        risk["_id"] = str(risk["_id"])
    return risk

def get_risks(filter=None):
    query = filter if filter else {}
    result = []
    for r in risks_collection.find(query):
        r["_id"] = str(r["_id"])
        result.append(r)
    return result

def get_risks_by_project(project_id):
    return get_risks({"project_id": project_id})

def count_risks():
    return risks_collection.count_documents({})

# -------------------
# UPDATE
# -------------------
def update_risk(risk_id, updates):
    result = risks_collection.update_one(
        {"_id": ObjectId(risk_id)},
        {"$set": updates}
    )
    return result.modified_count

# -------------------
# DELETE
# -------------------
def delete_risk(risk_id):
    result = risks_collection.delete_one({"_id": ObjectId(risk_id)})
    return result.deleted_count

# -------------------
# EXTRAS
# -------------------
def get_open_risks_by_project(project_id):
    """
    Retourne tous les risques ouverts pour un projet
    """
    return get_risks({"project_id": project_id, "status": "Open"})

def get_recent_risks_by_project(project_id, limit=10):
    """
    Retourne les derniers risques identifiés pour un projet
    """
    result = []
    cursor = risks_collection.find({"project_id": project_id}).sort("date_identified", -1).limit(limit)
    for r in cursor:
        r["_id"] = str(r["_id"])
        result.append(r)
    return result
