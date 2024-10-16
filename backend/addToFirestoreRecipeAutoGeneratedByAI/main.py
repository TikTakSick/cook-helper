import firebase_admin, functions_framework
import os
from firebase_admin import credentials, firestore, auth
from query_gemini import get_recipe_auto_generated_by_ai, get_title_from_url

# # local environment
# cred = credentials.Certificate("service-account-for-firebase-admin.json")

# app = firebase_admin.initialize_app(cred)
# db = firestore.client()

# google cloud environment
app = firebase_admin.initialize_app()
db = firestore.client()

def get_uid_from_id_token(id_token):
    try:
        decoded_token = auth.verify_id_token(id_token)
        uid = decoded_token['uid']
        return uid
    except Exception as e:
        return None

def make_data_for_adding_to_firestore_from(recipe_data, recipe_type, url):
    return {
        "dishName": recipe_data["dish_name"],
        "ingredients": recipe_data["ingredients"],
        "instructions": recipe_data["instructions"],
        "recipeType": recipe_type,
        "url": url,
    }

@functions_framework.http
def add_to_firestore_recipe_auto_generated_by_ai(request):
    
    # idTokenを取得し，uidを抽出する
    id_token = request.headers["Authorization"].split('Bearer ')[1]
    print("id_token:",id_token)
    uid = get_uid_from_id_token(id_token)
    if uid is None:
        return ({"error": "Invalid id token"}, 400)

    # requestから，url,recipeTypeを取得する
    request = request.get_json()
    print("request:",request)
    recipe_type = request["recipeType"]
    url = request["url"]

    # urlからタイトルを取得する
    url_title = get_title_from_url(url)

    # APIキーを設定
    api_key = os.environ.get("API_KEY", "Specified environment variable is not set.")

    # 生成aiによるレシピを取得する
    prompt = f"次のサイトからレシピを引っ張ってきて．タイトルは，{url_title}です．：{url}"
    recipe_auto_generated_by_ai = get_recipe_auto_generated_by_ai(prompt, api_key)

    # 生成aiによるレシピをfirestoreに保存する
    firestore_recipe_data = make_data_for_adding_to_firestore_from(recipe_auto_generated_by_ai, recipe_type, url)
    recipes_collection_ref = db.collection("users").document(uid).collection("recipes")
    try:
        update_time, recipe_ref = recipes_collection_ref.add(firestore_recipe_data)
        print(f"Recipe document added.")
        return  ({"message": "Recipe document added."}, 200)
    except firebase_admin.exceptions.FirebaseError as e:
        print(f"Error adding recipes collection: {e}")
        return ({"error": "Error adding recipes collection"}, 500)


if __name__ == "__main__":
    request = {
        "url": "https://cookpad.com/recipe/5882741",
        "recipeType": "Web Recipe Auto Generated By AI",
    }
    add_to_firestore_recipe_auto_generated_by_ai(request)