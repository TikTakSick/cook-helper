import vertexai
import os, requests

from vertexai.generative_models import GenerativeModel, Part
from dotenv import load_dotenv
from bs4 import BeautifulSoup

# `.env` ファイルを読み込む
load_dotenv()

# 環境変数を利用する
PROJECT_ID = os.environ.get('PROJECT_ID')
LOCATION = os.environ.get('LOCATION')

def get_response_text_from(prompt):
    vertexai.init(project=PROJECT_ID, location=LOCATION)

    model = GenerativeModel("gemini-1.0-pro")
    chat = model.start_chat()
    
    response = chat.send_message(prompt)
    return response.text

def get_title_from_url(url):
    try:
        # URLからHTMLを取得
        response = requests.get(url)
        # HTMLをBeautifulSoupで解析
        soup = BeautifulSoup(response.text, 'html.parser')
        # titleタグを取得
        title_tag = soup.find('title')
        # titleタグが存在するか確認
        if title_tag:
            # タイトルを返す
            return title_tag.text.strip()
        else:
            print("Title tag not found")
            return ""
    except Exception as e:
        print(f"An error occurred: {str(e)}")
        return ""

def main():
    url = "https://www.youtube.com/watch?v=7zSfi2kqjjw"
    url_title = get_title_from_url(url)
    prompt = f"次のサイトからレシピを引っ張ってきて．タイトルは，{url_title}です．：{url}"
    print(get_response_text_from(prompt))
    

main()

