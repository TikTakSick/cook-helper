import google.generativeai as genai
import os
from dotenv import load_dotenv

def prompt_gemini(prompt, api_key):
    genai.configure(api_key=api_key)
    model = genai.GenerativeModel("gemini-1.5-flash")
    response = model.generate_content(prompt)
    return response.text

if __name__ == "__main__":
    # .envファイルを読み込む
    load_dotenv()

    # APIキーを設定
    api_key = os.getenv("API_KEY")
    res = prompt_gemini("What is the meaning of life?", api_key)
    print("here is the response from gemini: ")
    print(res)

