local busqueda = ""
local resultados = {}
local seleccionado = nil
local modoBusqueda = false
local archivosSistema = {
    {nombre = "calculadora.lua", ruta = "/apps/calculadora.lua", tipo = "app", contenido = "calculadora matemtica"},
    {nombre = "bloc-de-notas.lua", ruta = "/apps/bloc-de-notas.lua", tipo = "app", contenido = "editor de texto simple"},
    {nombre = "reloj.lua", ruta = "/apps/reloj.lua", tipo = "app", contenido = "reloj en tiempo real"},
    {nombre = "calendario.lua", ruta = "/apps/calendario.lua", tipo = "app", contenido = "calendario mensual"},
    {nombre = "explorador.lua", ruta = "/apps/explorador.lua", tipo = "app", contenido = "explorador de archivos"},
    {nombre = "notificaciones.lua", ruta = "/apps/notificaciones.lua", tipo = "app", contenido = "centro de notificaciones"},
    {nombre = "portapapeles.lua", ruta = "/apps/portapapeles.lua", tipo = "app", contenido = "historial del portapapeles"},
    {nombre = "tienda.lua", ruta = "/apps/tienda.lua", tipo = "app", contenido = "tienda de aplicaciones"},
    {nombre = "config.lua", ruta = "/apps/config.lua", tipo = "app", contenido = "configuracin del sistema"},
    {nombre = "readme.txt", ruta = "/documentos/readme.txt", tipo = "documento", contenido = "gua de usuario"},
    {nombre = "notas.txt", ruta = "/documentos/notas.txt", tipo = "documento", contenido = "notas personales"},
    {nombre = "config.json", ruta = "/cocosOS/config.json", tipo = "config", contenido = "configuracin principal"},
    {nombre = "sistema.log", ruta = "/cocosOS/sistema.log", tipo = "log", contenido = "registro del sistema"}
}
local function buscarArchivos(termino)
    resultados = {}
    if not termino or termino == "" then
        return
    end
    termino = termino:lower()
    for _, archivo in ipairs(archivosSistema) do
        local coincide = false
        if archivo.nombre:lower():find(termino, 1, true) then
            coincide = true
        end
        if archivo.ruta:lower():find(termino, 1, true) then
            coincide = true
        end
        if archivo.contenido and archivo.contenido:lower():find(termino, 1, true) then
            coincide = true
        end
        if archivo.tipo:lower():find(termino, 1, true) then
            coincide = true
        end
        if coincide then
            table.insert(resultados, archivo)
        end
    end
end
local function obtenerIconoPorTipo(tipo)
    if tipo == "app" then
        return "[APP]"
    elseif tipo == "documento" then
        return "[DOC]"
    elseif tipo == "config" then
        return "[CFG]"
    elseif tipo == "log" then
        return "[LOG]"
    else
        return "[FILE]"
    end
end
local function obtenerColorPorTipo(tipo)
    if tipo == "app" then
        return "#4CAF50"
    elseif tipo == "documento" then
        return "#00AEEF"
    elseif tipo == "config" then
        return "#FF9800"
    elseif tipo == "log" then
        return "#9C27B0"
    else
        return "#FFFFFF"
    end
end
local function dibujarGUI()
    draw_panel(50, 50, 500, 450, "#2C2C2C", 0.95)
    draw_text(70, 70, "buscador de archivos", "#FFFFFF")
    draw_panel(70, 90, 460, 30, "#1A1A1A", 1)
    if modoBusqueda then
        draw_text(80, 100, "buscar: " .. busqueda .. "_", "#00FF00")
    else
        draw_text(80, 100, "buscar: " .. (busqueda or ""), "#FFFFFF")
    end
    draw_panel(70, 130, 80, 25, "#4CAF50", 0.8)
    draw_text(80, 138, "buscar", "#FFFFFF")
    draw_panel(160, 130, 80, 25, "#F44336", 0.8)
    draw_text(170, 138, "limpiar", "#FFFFFF")
    draw_text(260, 138, "filtrar:", "#CCCCCC")
    draw_panel(310, 130, 50, 25, "#4CAF50", 0.8)
    draw_text(315, 138, "apps", "#FFFFFF")
    draw_panel(370, 130, 60, 25, "#00AEEF", 0.8)
    draw_text(375, 138, "docs", "#FFFFFF")
    draw_panel(440, 130, 60, 25, "#FF9800", 0.8)
    draw_text(445, 138, "config", "#FFFFFF")
    draw_text(70, 165, "resultados: " .. #resultados, "#CCCCCC")
    if busqueda == "" then
        draw_text(70, 190, "escribe algo para buscar", "#888888")
        draw_text(70, 210, "busca por nombre, ruta, contenido o tipo", "#666666")
    elseif #resultados == 0 then
        draw_text(70, 190, "no se encontraron resultados", "#888888")
        draw_text(70, 210, "intent con otros trminos", "#666666")
    else
        for i, archivo in ipairs(resultados) do
            local y = 190 + (i-1) * 60
            local colorFondo = seleccionado == i and "#4C4C4C" or "#1A1A1A"
            local colorTipo = obtenerColorPorTipo(archivo.tipo)
            local icono = obtenerIconoPorTipo(archivo.tipo)
            draw_panel(70, y, 460, 55, colorFondo, 0.9)
            draw_text(80, y + 8, icono .. " " .. archivo.nombre, colorTipo)
            draw_text(110, y + 25, archivo.ruta, "#CCCCCC")
            draw_text(400, y + 25, archivo.tipo, "#888888")
            draw_panel(450, y + 5, 60, 20, "#4CAF50", 0.8)
            draw_text(460, y + 10, "abrir", "#FFFFFF")
            draw_panel(450, y + 30, 60, 20, "#00AEEF", 0.8)
            draw_text(455, y + 35, "ver", "#FFFFFF")
        end
    end
    draw_text(70, 430, "click en resultado para seleccionar", "#888888")
end
local function detectarClicks(x, y)
    if x >= 70 and x <= 530 and y >= 90 and y <= 120 then
        modoBusqueda = not modoBusqueda
    elseif x >= 70 and x <= 150 and y >= 130 and y <= 155 then
        buscarArchivos(busqueda)
    elseif x >= 160 and x <= 240 and y >= 130 and y <= 155 then
        busqueda = ""
        resultados = {}
        seleccionado = nil
        modoBusqueda = false
    elseif x >= 310 and x <= 360 and y >= 130 and y <= 155 then
        busqueda = "app"
        buscarArchivos(busqueda)
    elseif x >= 370 and x <= 430 and y >= 130 and y <= 155 then
        busqueda = "documento"
        buscarArchivos(busqueda)
    elseif x >= 440 and x <= 500 and y >= 130 and y <= 155 then
        busqueda = "config"
        buscarArchivos(busqueda)
    end
    if #resultados > 0 then
        for i, archivo in ipairs(resultados) do
            local y = 190 + (i-1) * 60
            if x >= 450 and x <= 510 and y + 5 >= y and y + 25 <= y + 25 then
                draw_panel(150, 200, 300, 80, "#3C3C3C", 0.95)
                draw_text(170, 220, "abriendo: " .. archivo.nombre, "#FFFFFF")
                if archivo.tipo == "app" then
                    draw_text(170, 240, "iniciando aplicacin...", "#00FF00")
                else
                    draw_text(170, 240, "abriendo archivo...", "#00FF00")
                end
                return
            end
            if x >= 450 and x <= 510 and y + 30 >= y and y + 50 <= y + 50 then
                draw_panel(150, 200, 300, 80, "#3C3C3C", 0.95)
                draw_text(170, 220, "ubicacin: " .. archivo.ruta, "#FFFFFF")
                draw_text(170, 240, "tipo: " .. archivo.tipo, "#00FF00")
                return
            end
            if x >= 70 and x <= 530 and y >= y and y <= y + 55 then
                seleccionado = i
                return
            end
        end
    end
end
buscarArchivos("")
while true do
    dibujarGUI()
    local x, y = leerclick()
    if x then detectarClicks(x, y) end
end