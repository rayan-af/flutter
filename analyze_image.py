import sys
from PIL import Image

def analyze_image(path):
    try:
        img = Image.open(path)
        print(f"Format: {img.format}")
        print(f"Size: {img.size}")
        print(f"Mode: {img.mode}")
    except Exception as e:
        print(f"Error: {e}")

if __name__ == "__main__":
    analyze_image(sys.argv[1])
