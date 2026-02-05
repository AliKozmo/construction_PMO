import os
from pymongo import MongoClient
from bson.objectid import ObjectId
from dotenv import load_dotenv
import sys


load_dotenv()  

# Add controllers path for SQL procedures
sys.path.append(os.path.join(os.path.dirname(__file__), 'sql_procedures.py'))
from .sql_procedures import update_budget_add_to_spent_amount

# MongoDB Connection
MONGO_URI = os.getenv("MONGO_URI")
MONGO_DB = os.getenv("MONGO_DB")

client = MongoClient(MONGO_URI)
db = client[MONGO_DB]

# Collections
payments_collection = db["payments"]



# -------------------
# CREATE
# -------------------
def create_payment(project_id,budget_id, amount, payment_date, payment_type, status, remarks=None):
    payment_data = {
        "project_id": project_id,  # on garde string (plus simple & safe)
        "budget_id" : budget_id,
        "amount": amount,
        "payment_date": payment_date,
        "payment_type": payment_type,
        "status": status,
        "remarks": remarks,
        
    }
    update_budget_add_to_spent_amount(budget_id, spent_amount=amount)
    result = payments_collection.insert_one(payment_data)
    return str(result.inserted_id)

# -------------------
# READ ONE
# -------------------
def get_payment_by_id(payment_id):
    payment = payments_collection.find_one({"_id": ObjectId(payment_id)})
    if payment:
        payment["_id"] = str(payment["_id"])
    return payment

# -------------------
# READ MANY
# -------------------
def get_payments(filter=None):
    query = filter if filter else {}
    result = []

    for p in payments_collection.find(query):
        p["_id"] = str(p["_id"])
        result.append(p)

    return result

# -------------------
# UPDATE
# -------------------
def update_payment(payment_id, updates):  
    # Step 1: Fetch the existing payment from MongoDB
    payment = payments_collection.find_one({"_id": ObjectId(payment_id)})  
      
    if not payment:  
        raise ValueError("Payment not found")  # If payment is not found, raise an exception

    old_amount = payment.get("amount", 0.0)  # Default to 0 if 'amount' doesn't exist  
    new_amount = updates.get("amount", old_amount)  # Get the new amount from updates, default to old_amount if not provided
    
    # Step 2: Calculate the difference in amounts
    amount_difference = new_amount - old_amount  # This is how much the amount has increased/decreased
    
    # Step 3: Call the function to update the budget with the difference as the spent amount
    budget_id = payment.get("budget_id")  # Retrieve the associated budget ID from the payment
    if budget_id:
        update_budget_add_to_spent_amount(budget_id, spent_amount=amount_difference)  # Update the budget with the difference
    else:
        raise ValueError("Budget ID not found in the payment")  # Handle the case where budget_id is missing
    
    # Step 4: Update the payment in MongoDB
    result = payments_collection.update_one(  
        {"_id": ObjectId(payment_id)},  # Find the payment by its ID
        {"$set": updates}  # Apply the updates (amount, status, remarks, etc.)
    )  
    return result.modified_count  # Return the number of documents modified


# -------------------
# DELETE
# -------------------
def delete_payment(payment_id):
    result = payments_collection.delete_one({"_id": ObjectId(payment_id)})
    return result.deleted_count


# -------------------
# sum by project
# -------------------

def get_total_payments_by_project(project_id):
    pipeline = [
        {"$match": {"project_id": project_id}},
        {"$group": {
            "_id": "$project_id",
            "total_amount": {"$sum": "$amount"}
        }}
    ]

    result = list(payments_collection.aggregate(pipeline))
    return result[0]["total_amount"] if result else 0
