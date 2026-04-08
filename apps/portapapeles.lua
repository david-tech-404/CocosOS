local historial = {}
local maxHistorial = 20
local seleccionado = nil
local function agregarAlHistorial(texto)
    if not texto or texto == "" then return end
    if #historial > 0 and historial[1].texto == texto then
        return
    end
    table.insert(historial, 1, {
        texto = texto,
        timestamp = os.time(),
        tipo = "texto"
    })
    if #historial > maxHistorial then
        table.remove(historial, #historial)
    end
end
local function copiarAlPortapapeles(texto)
    draw_panel(150, 200, 300, 60, "#3C3C3C", 0.95)
    draw_text(170, 220, "copiado al portapapeles", "#4CAF50")
    return true
end
local function eliminarDelHistorial(indice)
    if indice >= 1 and indice <= #historial then
        table.remove(historial, indice)
        return true
    end
    return false
end
local function limpiarHistorial()
    historial = {}
end
local function formatearTiempo(timestamp)
    local diferencia = os.time() - timestamp
    if diferencia < 60 then
        return "hace " .. diferencia .. "s"
    elseif diferencia < 3600 then
        return "hace " .. math.floor(diferencia/60) .. "m"
    elseif diferencia < 86400 then
        return "hace " .. math.floor(diferencia/3600) .. "h"
    else
        return "hace " .. math.floor(diferencia/86400) .. "d"
    end
end
local function dibujarGUI()
    draw_panel(50, 50, 500, 450, "#2C2C2C", 0.95)
    draw_text(70, 70, "historial del portapapeles", "#FFFFFF")
    draw_panel(70, 90, 120, 25, "#4CAF50", 0.8)
    draw_text(80, 98, "+ agregar", "#FFFFFF")
    draw_panel(200, 90, 120, 25, "#F44336", 0.8)
    draw_text(210, 98, "limpiar todo", "#FFFFFF")
    draw_text(70, 125, "elementos: " .. #historial .. "/" .. maxHistorial, "#CCCCCC")
    draw_text(350, 125, "click para copiar", "#888888")
    if #historial == 0 then
        draw_text(70, 160, "el historial est vaco", "#888888")
        draw_text(70, 180, "agrega texto o copia algo", "#666666")
    else
        for i, item in ipairs(historial) do
            local y = 160 + (i-1) * 50
            local colorFondo = seleccionado == i and "#4C4C4C" or "#1A1A1A"
            draw_panel(70, y, 460, 45, colorFondo, 0.9)
            local textoMostrar = item.texto
            if #textoMostrar > 50 then
                textoMostrar = textoMostrar:sub(1, 47) .. "..."
            end
            draw_text(80, y + 10, textoMostrar, "#FFFFFF")
            local tiempo = formatearTiempo(item.timestamp)
            draw_text(80, y + 28, tiempo, "#888888")
            draw_panel(450, y + 10, 60, 25, "#00AEEF", 0.8)
            draw_text(460, y + 18, "copiar", "#FFFFFF")
            draw_panel(450, y + 35, 60, 15, "#F44336", 0.6)
            draw_text(460, y + 38, "borrar", "#FFFFFF")
        end
    end
    if seleccionado and historial[seleccionado] then
        draw_panel(70, 410, 460, 70, "#3C3C3C", 0.95)
        draw_text(80, 420, "vista previa:", "#CCCCCC")
        local textoPrev = historial[seleccionado].texto
        if #textoPrev > 70 then
            textoPrev = textoPrev:sub(1, 67) .. "..."
        end
        draw_text(80, 440, textoPrev, "#FFFFFF")
        draw_text(80, 460, "longitud: " .. #historial[seleccionado].texto .. " caracteres", "#888888")
    end
end
local function detectarClicks(x, y)
    if x >= 70 and x <= 190 and y >= 90 and y <= 115 then
        local textosPrueba = {
            "hello friend",
            "Sometimes I dream of saving the world. Saving everyone from the invisible hand, the one that marks us with an employee badge",
            "Is it that we collectively thought Steve Jobs was a great man, even when we knew he made billions off the sweat of children?",
            "Fuck society",
            "nmero: " .. math.random(1000, 9999),
            "fecha: " .. os.date("%Y-%m-%d")
        }
        agregarAlHistorial(textosPrueba[math.random(#textosPrueba)])
    elseif x >= 200 and x <= 320 and y >= 90 and y <= 115 then
        limpiarHistorial()
        seleccionado = nil
    end
    if #historial > 0 then
        for i, item in ipairs(historial) do
            local y = 160 + (i-1) * 50
            if x >= 450 and x <= 510 and y + 10 >= y and y + 35 <= y + 35 then
                copiarAlPortapapeles(item.texto)
                return
            end
            if x >= 450 and x <= 510 and y + 35 >= y and y + 50 <= y + 50 then
                eliminarDelHistorial(i)
                if seleccionado == i then
                    seleccionado = nil
                elseif seleccionado and seleccionado > i then
                    seleccionado = seleccionado - 1
                end
                return
            end
            if x >= 70 and x <= 530 and y >= y and y <= y + 45 then
                seleccionado = i
                return
            end
        end
    end
end
agregarAlHistorial("Bienvenido al historial del portapapeles")
agregarAlHistorial("Aqu se guardan tus textos copiados")
agregarAlHistorial("Haz click en un elemento para copiarlo")
while true do
    dibujarGUI()
    local x, y = leerclick()
    if x then detectarClicks(x, y) end
end