import re

with open('lib/core/models/dish_model.dart', 'r', encoding='utf-8') as f:
    content = f.read()

def replacer(m):
    import hashlib
    seed = int(hashlib.md5(m.group(0).encode('utf-8')).hexdigest(), 16) % 1000
    return "imageUrl: 'https://picsum.photos/seed/" + str(seed) + "/800/800'"

content = re.sub(r"imageUrl:\s*'https://(images\.unsplash\.com|loremflickr\.com)[^']+'", replacer, content)

with open('lib/core/models/dish_model.dart', 'w', encoding='utf-8') as f:
    f.write(content)
