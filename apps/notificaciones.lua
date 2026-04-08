local notificaciones = {}
local maxNotificaciones = 5
local idCounter = 0
local function agregarNotificacion(titulo, mensaje, tipo)
    idCounter = idCounter + 1
    local notif = {
        id = idCounter,
        titulo = titulo,
        mensaje = mensaje,
        tipo = tipo or "info",
        timestamp = os.time(),
        leida = false
    }
    table.insert(notificaciones, 1, notif)
    if #notificaciones > maxNotificaciones then
        table.remove(notificaciones, #notificaciones)
    end
    return notif.id
end
local function eliminarNotificacion(id)
    for i, notif in ipairs(notificaciones) do
        if notif.id == id then
            table.remove(notificaciones, i)
            return true
        end
    end
    return false
end
local function marcarComoLeida(id)
    for _, notif in ipairs(notificaciones) do
        if notif.id == id then
            notif.leida = true
            return true
        end
    end
    return false
end
local function obtenerColorPorTipo(tipo)
    if tipo == "info" then
        return "#00AEEF"
    elseif tipo == "warning" then
        return "#FF9800"
    elseif tipo == "error" then
        return "#F44336"
    elseif tipo == "success" then
        return "#4CAF50"
    else
        return "#FFFFFF"
    end
end
local function dibujarGUI()
    draw_panel(100, 50, 400, 450, "#2C2C2C", 0.95)
    draw_text(120, 70, "centro de notificaciones", "#FFFFFF")
    draw_panel(120, 90, 120, 25, "#4CAF50", 0.8)
    draw_text(130, 98, "+ agregar", "#FFFFFF")
    draw_panel(250, 90, 120, 25, "#F44336", 0.8)
    draw_text(260, 98, "limpiar todo", "#FFFFFF")
    draw_text(120, 125, "notificaciones: " .. #notificaciones, "#CCCCCC")
    if #notificaciones == 0 then
        draw_text(120, 160, "no hay notificaciones", "#888888")
    else
        for i, notif in ipairs(notificaciones) do
            local y = 160 + (i-1) * 70
            local colorFondo = notif.leida and "#1A1A1A" or "#3C3C3C"
            local colorBorde = obtenerColorPorTipo(notif.tipo)
            draw_panel(120, y, 360, 60, colorFondo, 0.9)
            draw_panel(120, y, 5, 60, colorBorde, 1)
            local titulo = notif.titulo
            if not notif.leida then
                titulo = " " .. titulo
            end
            draw_text(135, y + 10, titulo, "#FFFFFF")
            draw_text(135, y + 30, notif.mensaje, "#CCCCCC")
            draw_panel(450, y + 5, 20, 20, "#F44336", 0.8)
            draw_text(455, y + 10, "X", "#FFFFFF")
            if not notif.leida then
                draw_panel(420, y + 35, 50, 15, "#00AEEF", 0.6)
                draw_text(425, y + 38, "leer", "#FFFFFF")
            end
        end
    end
end
local function detectarClicks(x, y)
    if x >= 120 and x <= 240 and y >= 90 and y <= 115 then
        local tipos = {"info", "warning", "error", "success"}
        local tipo = tipos[math.random(#tipos)]
        local mensajes = {
            {titulo = "Sistema", mensaje = "CocosOS iniciado correctamente"},
            {titulo = "App", mensaje = "Calculadora abierta"},
            {titulo = "Alerta", mensaje = "Espacio en disco bajo"},
            {titulo = "Error", mensaje = "No se pudo conectar a la red"},
            {titulo = "xito", mensaje = "Archivo guardado correctamente"}
        }
        local msg = mensajes[math.random(#mensajes)]
        agregarNotificacion(msg.titulo, msg.mensaje, tipo)
    elseif x >= 250 and x <= 370 and y >= 90 and y <= 115 then
        notificaciones = {}
    end
    if #notificaciones > 0 then
        for i, notif in ipairs(notificaciones) do
            local y = 160 + (i-1) * 70
            if x >= 450 and x <= 470 and y + 5 >= y and y + 25 <= y + 25 then
                eliminarNotificacion(notif.id)
                return
            end
            if not notif.leida and x >= 420 and x <= 470 and y + 35 >= y and y + 50 <= y + 50 then
                marcarComoLeida(notif.id)
                return
            end
        end
    end
end
agregarNotificacion("Bienvenido", "Centro de notificaciones activado", "success")
while true do
    dibujarGUI()
    local x, y = leerclick()
    if x then detectarClicks(x, y) end
end