# pyrefly: ignore [missing-import]
from openai import OpenAI

client = OpenAI(
    base_url="http://127.0.0.1:3001/v1",
    api_key="freellmapi-56049cf21dd8794429989fc926b647b6c9f7c9ec4554874e"
)

try:
    print("Sending request to LLM (auto llm)...")
    response = client.chat.completions.create(
        model="auto",
        messages=[
            {"role": "user", "content": "can you tell me about quantum computing including image"}
        ]
    )

    print("\n--- LLM Response ---")
    print(response.choices[0].message.content)

except Exception as e:
    print(f"\n[Error] Failed to get response: {e}")
