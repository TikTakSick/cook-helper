import firebase_admin
from firebase_admin import credentials
from firebase_admin import firestore

# # local environment
# cred = credentials.Certificate("service-account-for-fibase-admin.json")

# app = firebase_admin.initialize_app(cred)
# db = firestore.client()

# google cloud environment
app = firebase_admin.initialize_app()
db = firestore.client()


# Function triggered by deletion of user
def delete_firestore_by_user_deletion(data, context):
    uid = data["uid"]
    print(f"Function triggered by deletion of user: {uid}")
    
    user_ref = db.collection("users").document(uid)
    print("making refrence data to user_ref")
    recipes_collection_ref = user_ref.collection("recipes")
    print("making refrence data to recipes_collection_ref")
    print(f"In delete_firestore_by_user_deletion, user_ref: {user_ref}, recipes_collection_ref: {recipes_collection_ref}")

    # delete recipes collection
    try:
        delete_recipes_collection(recipes_collection_ref, 100)
        print(f"Recipes collection deleted.")
    except firebase_admin.exceptions.FirebaseError as e:
        print(f"Error deleting recipes collection: {e}")
    
    # delete user document
    try:
        delete_user(user_ref)
        print(f"User document deleted.")
    except firebase_admin.exceptions.FirebaseError as e:
        print(f"Error deleting user document: {e}")


def delete_recipes_collection(coll_ref, batch_size):
    docs = coll_ref.list_documents(page_size=batch_size)
    deleted = 0

    for doc in docs:
        print(f"Deleting doc {doc.id} => {doc.get().to_dict()}")
        doc.delete()
        deleted = deleted + 1

    if deleted >= batch_size:
        return delete_recipes_collection(coll_ref, batch_size)
    

def delete_user(user_ref):
    user_ref.delete()

if __name__ == "__main__":
    data = {"uid": "Ort5FYo1jtWvOAjVem2CizbeNyI3"}
    context = None
    delete_firestore_by_user_deletion(data, context)