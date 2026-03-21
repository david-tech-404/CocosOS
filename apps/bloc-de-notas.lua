local appName = "bloc de notas"
local appPath = "/apps/" .. appPath
os.execute("mkdir -p" .. appPath)

local texto = ""
local archivoActual = nil

local function dibujarGUI()
    draw_panel(10, 10, 580, 380, "#2C2C2C")
    draw_text(20, 20, "bloc de notas - " .. (archivoActual or "nuevo"), "#FFFFFF")
    draw_text(20, 50, 560, 300, texto, "#E95420", 0,8)
    draw_text(30, 370, "nuevo",  "#FFFFFF")
    draw_panel(110, 360, 80, 30, "#00AEEF", 0.8)
    draw_text(120, 370, "abrir", "#FFFFFF")
    draw_panel(200, 360, 80, 30, "#6A0DAD")
    draw_text(210, 370, "guardar", "#FFFFFF")
end

local function capturarEntrada()
    local entrada = leerInput()
    if entrada then
        texto = entrada
    end   
end

local function guardarArchivo()
    local f = io.open("/cocosOS/notas/nota.txt", "w")
    if f then
        f:write(texto)
        f:close()
        Gurdado = true
    end
end

local function detectarClicks(x, y)
if x >= 60 and x <= 160 and y >= 400 and y <= 430 then
    guardarArchivo()    
    end
end

while true do
dibujarGUI()
capturarEntrada()
    local clickX, clickY = leerclick()
    if clickX and clickY then
        detectarClicks(clickX, clickY)
    end
end