import google.generativeai as genai
import os, requests, json
import typing_extensions as typing

from dotenv import load_dotenv
from bs4 import BeautifulSoup


class Recipe(typing.TypedDict):
    dish_name: str
    ingredients: str
    instructions: str

def get_title_from_url(url):
    try:
        response = requests.get(url)
        soup = BeautifulSoup(response.text, 'html.parser')
        # titleタグを取得
        title_tag = soup.find('title')
        # titleタグが存在するか確認
        if title_tag:
            return title_tag.text.strip()
        else:
            print("Title tag not found")
            return ""
    except Exception as e:
        print(f"An error occurred: {str(e)}")
        return ""

def get_recipe_auto_generated_by_ai(prompt: str, api_key: str):
    genai.configure(api_key=api_key)
    model = genai.GenerativeModel("gemini-1.5-flash")
    result = model.generate_content(
        prompt,
        generation_config=genai.GenerationConfig(
            response_mime_type="application/json",response_schema=Recipe
        )
    )
    result_jsonified = json.loads(result.text)
    return result_jsonified

if __name__ == "__main__":
    # .envファイルを読み込む
    load_dotenv()

    # APIキーを設定
    api_key = os.getenv("API_KEY")

    # レシピを生成
    url = "https://delishkitchen.tv/recipes/197913982130979872"
    url_title = get_title_from_url(url)
    prompt = f"次のサイトからレシピを引っ張ってきて．タイトルは，{url_title}です．：{url}"
    result = get_recipe_auto_generated_by_ai(prompt, api_key)
    print("here is the response from gemini: ")
    print(result["instructions"])

