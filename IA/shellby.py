import json
import urllib.request
import urllib.parse
import re

with open("request.json", "r") as f:
    request_data = json.load(f)

question = request_data.get("command", "")

query = urllib.parse.quote(question)
url = f"https://html.duckduckgo.com/html/?q={query}"

try:
    with urllib.request.urlopen(url) as response:
        html = response.read().decode("utf-8")
except Exception as e:
    html = ""
    result = f"no se pudo acceder a la web: {e}"

if html:
    parragraphs = re.findall(r'<a.*?class="result__a".*?>(.*?)</a>', html, re.DOTALL)
    if parragraphs:
        clean_text = re.sub(r"<.*?>", "", parragraphs[0])
        result = clean_text
    else:
        result = "No se encontró resultado en duckduckgo, que lamentable."

with open("response.json", "w") as f:
    json.dump({"result": result}, f)

print(f"respuesta generada: {result}")
