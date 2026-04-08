local appName = "bloc de notas"
local appPath = "/apps/" .. appName
os.execute("mkdir -p " .. appPath)
local texto = ""
local archivoActual = nil
local modoEdicion = false
local function dibujarGUI()
    draw_panel(10, 10, 580, 380, "#2C2C2C")
    draw_text(20, 20, "bloc de notas - " .. (archivoActual or "nuevo"), "#FFFFFF")
    if modoEdicion then
        draw_panel(20, 45, 560, 280, "#1A1A1A", 1)
        draw_text(25, 50, 550, 270, texto .. "_", "#E95420", 0.8)
    else
        draw_panel(20, 45, 560, 280, "#1A1A1A", 1)
        draw_text(25, 50, 550, 270, texto, "#E95420", 0.8)
    end
    draw_panel(60, 340, 80, 30, "#00AEEF", 0.8)
    draw_text(70, 350, "guardar", "#FFFFFF")
    draw_panel(150, 340, 80, 30, "#6A0DAD", 0.8)
    draw_text(160, 350, "abrir", "#FFFFFF")
    draw_panel(240, 340, 80, 30, "#4CAF50", 0.8)
    draw_text(250, 350, "nuevo", "#FFFFFF")
    draw_panel(330, 340, 80, 30, "#FF9800", 0.8)
    draw_text(340, 350, "editar", "#FFFFFF")
    if modoEdicion then
        draw_text(430, 350, "Modo edicin activo", "#FFCC00")
    end
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
local function nuevoArchivo()
    texto = ""
    archivoActual = nil
    modoEdicion = false
end
local function abrirArchivo()
    draw_panel(100, 100, 400, 200, "#3C3C3C", 0.95)
    draw_text(120, 120, "abrir archivo", "#FFFFFF")
    draw_text(120, 150, "nota.txt", "#00FF00")
    draw_panel(120, 180, 80, 30, "#4CAF50", 0.8)
    draw_text(130, 190, "abrir", "#FFFFFF")
    draw_panel(210, 180, 80, 30, "#F44336", 0.8)
    draw_text(220, 190, "cancelar", "#FFFFFF")
    local f = io.open("/cocosOS/notas/nota.txt", "r")
    if f then
        texto = f:read("*a")
        f:close()
        archivoActual = "nota.txt"
    end
end
local function toggleEdicion()
    modoEdicion = not modoEdicion
end
local function detectarClicks(x, y)
    if x >= 60 and x <= 140 and y >= 340 and y <= 370 then
        guardarArchivo()
    elseif x >= 150 and x <= 230 and y >= 340 and y <= 370 then
        abrirArchivo()
    elseif x >= 240 and x <= 320 and y >= 340 and y <= 370 then
        nuevoArchivo()
    elseif x >= 330 and x <= 410 and y >= 340 and y <= 370 then
        toggleEdicion()
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