from groq import Client
import os
from groq import Groq
from dotenv import load_dotenv
load_dotenv()

GROQ_API_KEY = os.getenv("groq_api_key")
client = Groq(api_key=GROQ_API_KEY)

chat_completion = client.chat.completions.create(
    messages=[
        {
            "role": "user",
            "content" : "do you subramani in linked who lived in bengaluru"
        }
    ],
    model="llama-3.1-8b-instant",   
)
print(chat_completion.choices[0].message.content)
print(chat_completion.choices[0].to_json())