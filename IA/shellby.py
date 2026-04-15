import json
import sys
import subprocess
import os

with open("request.json", "r") as f:
    request_data = json.load(f)

comando = request_data.get("command", "").lower()

def ejecutar_comando(cmd):
    try:
        resultado = subprocess.run(cmd, shell=True, capture_output=True, text=True)
        return resultado.stdout + resultado.stderr
    except Exception as e:
        return str(e)

if "ayuda" in comando or "help" in comando:
    resultado = """Shellby IA asistente:
Podes preguntarme por:
- sistema, estado, kernel
- cpm, paquetes, instalar
- wifi, red, internet
- archivos, carpetas
- ayuda, comandos disponibles
"""

elif "sistema" in comando or "estado" in comando or "kernel" in comando:
    resultado = ejecutar_comando("about")

elif "cpm" in comando or "paquete" in comando or "instalar" in comando:
    if "lista" in comando or "listar" in comando:
        resultado = ejecutar_comando("cpm list")
    elif "instalados" in comando:
        resultado = ejecutar_comando("cpm installed")
    else:
        resultado = ejecutar_comando("cpm help")

elif "wifi" in comando or "red" in comando or "internet" in comando:
    resultado = "Sistema de red listo. WiFi soportado."

elif "comandos" in comando:
    resultado = ejecutar_comando("help")

elif "limpiar" in comando or "borrar" in comando:
    ejecutar_comando("clear")
    resultado = "Pantalla limpiada"

else:
    import urllib.request
    import urllib.parse
    import re
    
    query = urllib.parse.quote(comando)
    url = f"https://html.duckduckgo.com/html/?q={query}"
    
    try:
        with urllib.request.urlopen(url, timeout=5) as response:
            html = response.read().decode("utf-8")
        resultados = re.findall(r'<a.*?class="result__a".*?>(.*?)</a>', html, re.DOTALL)
        if resultados:
            resultado = re.sub(r"<.*?>", "", resultados[0])
        else:
            resultado = "No encontre informacion al respecto."
    except:
        resultado = "No hay conexion a internet."

with open("response.json", "w") as f:
    json.dump({"result": resultado}, f)

print(resultado)