local gui = require("API.gui")
local net = require("API.network")

local ventana = {
    x = 50,
    y = 50,
    ancho = 700,
    alto = 500,
    visible = true,
    titulo = "idk Web"
}

local url = ""
local historial = {}
local posicion_historial = 0
local cargando = false
local contenido = ""
local desplazamiento = 0

local boton_atras = { x = 10, y = 40, ancho = 30, alto = 24, texto = "<" }
local boton_adelante = { x = 45, y = 40, ancho = 30, alto = 24, texto = ">" }
local barra_url = { x = 80, y = 40, ancho = 540, alto = 24, texto = "" }
local boton_ir = { x = 625, y = 40, ancho = 65, alto = 24, texto = "IR" }
local area_contenido = { x = 10, y = 70, ancho = 680, alto = 420 }

local function cargar_pagina(direccion)
    if direccion == "" then return end
    
    cargando = true
    contenido = "Cargando " .. direccion .. "..."
    
    if not direccion:find("://") then
        direccion = "http://" .. direccion
    end
    
    url = direccion
    barra_url.texto = direccion
    
    table.insert(historial, direccion)
    posicion_historial = #historial
    
    for i=1, 10 do
        update_screen()
        sleep(50)
    end
    
    contenido = net.http_get(direccion) or "Error al cargar la pagina"
    cargando = false
end

local function dibujar_navegador()
    draw_panel(ventana.x, ventana.y, ventana.ancho, ventana.alto, "#1e1e1e", 1)
    draw_text(ventana.x + 10, ventana.y + 12, ventana.titulo, "#FFFFFF")
    draw_panel(ventana.x + ventana.ancho - 30, ventana.y + 8, 20, 20, "#ff5555", 1)
    
    
    draw_panel(ventana.x + boton_atras.x, ventana.y + boton_atras.y, boton_atras.ancho, boton_atras.alto, "#333333", 1)
    draw_text(ventana.x + boton_atras.x + 11, ventana.y + boton_atras.y + 6, boton_atras.texto, "#FFFFFF")
    
    draw_panel(ventana.x + boton_adelante.x, ventana.y + boton_adelante.y, boton_adelante.ancho, boton_adelante.alto, "#333333", 1)
    draw_text(ventana.x + boton_adelante.x + 11, ventana.y + boton_adelante.y + 6, boton_adelante.texto, "#FFFFFF")
    
    draw_panel(ventana.x + barra_url.x, ventana.y + barra_url.y, barra_url.ancho, barra_url.alto, "#2a2a2a", 1)
    draw_text(ventana.x + barra_url.x + 8, ventana.y + barra_url.y + 6, barra_url.texto, "#FFFFFF")
    
    draw_panel(ventana.x + boton_ir.x, ventana.y + boton_ir.y, boton_ir.ancho, boton_ir.alto, "#007acc", 1)
    draw_text(ventana.x + boton_ir.x + 22, ventana.y + boton_ir.y + 6, boton_ir.texto, "#FFFFFF")
    
    draw_panel(ventana.x + area_contenido.x, ventana.y + area_contenido.y, area_contenido.ancho, area_contenido.alto, "#FFFFFF", 1)
    
    local y_pos = ventana.y + area_contenido.y + 10
    local lineas = contenido:split("\n")
    
    for i = desplazamiento + 1, #lineas do
        if y_pos > ventana.y + area_contenido.y + area_contenido.alto - 20 then break end
        draw_text(ventana.x + area_contenido.x + 10, y_pos, lineas[i], "#000000")
        y_pos = y_pos + 16
    end
end

local function click_boton(x, y)
    local rx = x - ventana.x
    local ry = y - ventana.y
    
    if rx >= boton_atras.x and rx <= boton_atras.x + boton_atras.ancho and ry >= boton_atras.y and ry <= boton_atras.y + boton_atras.alto then
        if posicion_historial > 1 then
            posicion_historial = posicion_historial - 1
            cargar_pagina(historial[posicion_historial])
        end
    end
    
    if rx >= boton_adelante.x and rx <= boton_adelante.x + boton_adelante.ancho and ry >= boton_adelante.y and ry <= boton_adelante.y + boton_adelante.alto then
        if posicion_historial < #historial then
            posicion_historial = posicion_historial + 1
            cargar_pagina(historial[posicion_historial])
        end
    end
    
    if rx >= boton_ir.x and rx <= boton_ir.x + boton_ir.ancho and ry >= boton_ir.y and ry <= boton_ir.y + boton_ir.alto then
        cargar_pagina(barra_url.texto)
    end
end

function navegador_main()
    while ventana.visible do
        dibujar_navegador()
        update_screen()
        
        local evento = get_event()
        if evento.tipo == EVENTO_MOUSE_CLICK then
            click_boton(evento.x, evento.y)
        elseif evento.tipo == EVENTO_TECLA then
            if evento.tecla == TECLA_ESCAPE then
                ventana.visible = false
            end
        end
        
        sleep(16)
    end
end

return navegador_main