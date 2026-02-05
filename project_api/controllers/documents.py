import os
from pymongo import MongoClient
from bson.objectid import ObjectId
from dotenv import load_dotenv

load_dotenv()  

# MongoDB Connection
MONGO_URI = os.getenv("MONGO_URI")
MONGO_DB = os.getenv("MONGO_DB")

client = MongoClient(MONGO_URI)
db = client[MONGO_DB]

# Collections
documents_collection = db["documents"]


# -------------------
# CREATE
# -------------------
def create_document(
    name,
    doc_type,
    version,
    file_path,
    status,
    uploaded_by,
    uploaded_date,
    project_id=None,
    client_id=None,
    approved_by=None,
    approval_date=None,
    comments=None
):
    document_data = {
        "name": name,
        "type": doc_type,
        "version": version,
        "file_path": file_path,
        "status": status,
        "uploaded_by": uploaded_by,
        "uploaded_date": uploaded_date,
        "project_id": project_id,   # optional
        "client_id": client_id,     # optional
        "approved_by": approved_by,
        "approval_date": approval_date,
        "comments": comments
    }
    result = documents_collection.insert_one(document_data)
    return str(result.inserted_id)

# -------------------
# READ
# -------------------
def get_document_by_id(document_id):
    document = documents_collection.find_one({"_id": ObjectId(document_id)})
    if document:
        document["_id"] = str(document["_id"])
    return document

def get_documents(filter=None):
    query = filter if filter else {}
    result = []
    for d in documents_collection.find(query):
        d["_id"] = str(d["_id"])
        result.append(d)
    return result

def get_documents_by_project(project_id):
    return get_documents({"project_id": project_id})

def get_documents_by_client(client_id):
    return get_documents({"client_id": client_id})

def count_documents():
    return documents_collection.count_documents({})

# -------------------
# UPDATE
# -------------------
def update_document(document_id, updates):
    result = documents_collection.update_one(
        {"_id": ObjectId(document_id)},
        {"$set": updates}
    )
    return result.modified_count

# -------------------
# DELETE
# -------------------
def delete_document(document_id):
    result = documents_collection.delete_one({"_id": ObjectId(document_id)})
    return result.deleted_count

# -------------------
# EXTRAS
# -------------------
def get_recent_documents_by_project(project_id, limit=10):
    """
    Retourne les derniers documents uploadés pour un projet
    """
    result = []
    cursor = documents_collection.find(
        {"project_id": project_id}
    ).sort("uploaded_date", -1).limit(limit)

    for d in cursor:
        d["_id"] = str(d["_id"])
        result.append(d)

    return result

def get_recent_documents_by_client(client_id, limit=10):
    """
    Retourne les derniers documents uploadés pour un client
    """
    result = []
    cursor = documents_collection.find(
        {"client_id": client_id}
    ).sort("uploaded_date", -1).limit(limit)

    for d in cursor:
        d["_id"] = str(d["_id"])
        result.append(d)

    return result
