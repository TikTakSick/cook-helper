import google.generativeai as genai
import os, json
from dotenv import load_dotenv

json_open = open('vertex-ai-421614-0980ca35d895.json', 'r')
credentials = json.load(json_open)
# print(credentials)
# credentials = credentials
genai.configure(api_key=os.environ.get('GEMINI_API_KEY'))

model = genai.GenerativeModel('gemini')
response = model.generate_content('おはよう')

print(response.text)