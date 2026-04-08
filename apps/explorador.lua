local rutaActual = "/"
local archivos = {}
local seleccionado = nil

local function cargarDirectorio(ruta)
    rutaActual = ruta
    archivos = {}
    
    -- Simular estructura de directorios
    if ruta == "/" then
        archivos = {
            {nombre = "cocosOS", tipo = "directorio", ruta = "/cocosOS"},
            {nombre = "apps", tipo = "directorio", ruta = "/apps"},
            {nombre = "documentos", tipo = "directorio", ruta = "/documentos"},
            {nombre = "descargas", tipo = "directorio", ruta = "/descargas"}
        }
    elseif ruta == "/cocosOS" then
        archivos = {
            {nombre = "notas", tipo = "directorio", ruta = "/cocosOS/notas"},
            {nombre = "config.json", tipo = "archivo", ruta = "/cocosOS/config.json"},
            {nombre = "sistema.log", tipo = "archivo", ruta = "/cocosOS/sistema.log"}
        }
    elseif ruta == "/apps" then
        archivos = {
            {nombre = "calculadora.lua", tipo = "archivo", ruta = "/apps/calculadora.lua"},
            {nombre = "bloc-de-notas.lua", tipo = "archivo", ruta = "/apps/bloc-de-notas.lua"},
            {nombre = "reloj.lua", tipo = "archivo", ruta = "/apps/reloj.lua"},
            {nombre = "calendario.lua", tipo = "archivo", ruta = "/apps/calendario.lua"}
        }
    elseif ruta == "/documentos" then
        archivos = {
            {nombre = "readme.txt", tipo = "archivo", ruta = "/documentos/readme.txt"},
            {nombre = "notas.txt", tipo = "archivo", ruta = "/documentos/notas.txt"}
        }
    elseif ruta == "/descargas" then
        archivos = {}
    end
end

local function dibujarGUI()
    draw_panel(50, 50, 500, 400, "#2C2C2C", 0.95)
    draw_text(70, 70, "explorador de archivos", "#FFFFFF")
    draw_panel(70, 100, 460, 30, "#1E1E1E", 1)
    draw_text(80, 110, rutaActual, "#00FF00")
    draw_panel(70, 140, 60, 25, "#333333", 0.9)
    draw_text(80, 148, "< atras", "#FFFFFF")
    draw_panel(140, 140, 60, 25, "#333333", 0.9)
    draw_text(150, 148, "inicio", "#FFFFFF")
    draw_panel(70, 170, 460, 220, "#1A1A1A", 1)
    for i, archivo in ipairs(archivos) do
        local y = 180 + (i-1) * 30
        local color = seleccionado == i and "#FFCC00" or (archivo.tipo == "directorio" and "#00AEEF" or "#FFFFFF")
        local icono = archivo.tipo == "directorio" and "[DIR]" or "[FILE]"
        draw_text(80, y, icono .. " " .. archivo.nombre, color)
    end
    draw_panel(70, 400, 80, 30, "#4CAF50", 0.8)
    draw_text(80, 410, "abrir", "#FFFFFF")
    draw_panel(160, 400, 80, 30, "#FF9800", 0.8)
    draw_text(170, 410, "crear", "#FFFFFF")
    draw_panel(250, 400, 80, 30, "#F44336", 0.8)
    draw_text(260, 410, "borrar", "#FFFFFF")
end

local function detectarClicks(x, y)
    -- Botón retroceso
    if x >= 70 and x <= 130 and y >= 140 and y <= 165 then
        if rutaActual ~= "/" then
            local padre = rutaActual:match("^(.*/)[^/]+/?$") or "/"
            cargarDirectorio(padre)
        end
        
    elseif x >= 140 and x <= 200 and y >= 140 and y <= 165 then
        cargarDirectorio("/")
    
    elseif x >= 70 and x <= 530 and y >= 170 and y <= 390 then
        local indice = math.floor((y - 180) / 30) + 1
        if indice >= 1 and indice <= #archivos then
            seleccionado = indice
        end
    
    elseif x >= 70 and x <= 150 and y >= 400 and y <= 430 then
        if seleccionado and archivos[seleccionado] then
            if archivos[seleccionado].tipo == "directorio" then
                cargarDirectorio(archivos[seleccionado].ruta)
                seleccionado = nil
            else
                
                draw_panel(150, 200, 300, 100, "#3C3C3C", 0.95)
                draw_text(170, 220, "abriendo: " .. archivos[seleccionado].nombre, "#FFFFFF")
                draw_text(170, 250, "con bloc de notas...", "#00FF00")
            end
        end

    elseif x >= 160 and x <= 240 and y >= 400 and y <= 430 then
        draw_panel(150, 200, 300, 100, "#3C3C3C", 0.95)
        draw_text(170, 220, "crear nuevo archivo", "#FFFFFF")
        draw_text(170, 250, "nombre: nuevo.txt", "#00FF00")

    elseif x >= 250 and x <= 330 and y >= 400 and y <= 430 then
        if seleccionado and archivos[seleccionado] then
            draw_panel(150, 200, 300, 100, "#3C3C3C", 0.95)
            draw_text(170, 220, "borrar: " .. archivos[seleccionado].nombre, "#FFFFFF")
            draw_text(170, 250, "¿estás seguro?", "#FF0000")
        end
    end
end

cargarDirectorio("/")

while true do
    dibujarGUI()
    local x, y = leerclick()
    if x then detectarClicks(x, y) end
end