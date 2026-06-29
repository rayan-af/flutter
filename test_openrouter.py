import os
from openai import OpenAI
from dotenv import load_dotenv

load_dotenv()

client = OpenAI(
    base_url="https://openrouter.ai/api/v1",
    api_key=os.getenv("OPENROUTER_API_KEY")
)

try:
    response = client.chat.completions.create(
        # This auto-selects whichever free model is currently available and responsive
        model="openrouter/free", 
        messages=[
            {
                "role": "user",
                "content": "Write a short paragraph explaining API speed."
            }
        ],
        # 1. Turn streaming ON
        stream=True 
    )

    # 2. Iterate through the incoming chunks in real-time
    for chunk in response:
        if chunk.choices[0].delta.content:
            print(chunk.choices[0].delta.content, end="", flush=True)
    print() # Prints a clean newline at the very end

except Exception as e:
    print(f"Connection issue: {e}")
