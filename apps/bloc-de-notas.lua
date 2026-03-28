local appName = "bloc de notas"
local appPath = "/apps/" .. appName
os.execute("mkdir -p " .. appPath)

local texto = ""
local archivoActual = nil

local function dibujarGUI()
    draw_panel(10, 10, 580, 380, "#2C2C2C")
    draw_text(20, 20, "bloc de notas - " .. (archivoActual or "nuevo"), "#FFFFFF")
    draw_text(20, 50, 560, 300, texto, "#E95420", 0.8)
    draw_panel(60, 360, 80, 30, "#00AEEF", 0.8)
    draw_text(70, 370, "guardar", "#FFFFFF")
    draw_panel(150, 360, 80, 30, "#6A0DAD", 0.8)
    draw_text(160, 370, "abrir", "#FFFFFF")
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
        archivoActual = "nota.txt"
    end
end

local function detectarClicks(x, y)
    if x >= 60 and x <= 140 and y >= 360 and y <= 390 then
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