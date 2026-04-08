local function obtenerHora()
    return os.date("%H:%M:%S"), os.date("%d/%m/%Y")
end
local function dibujarReloj()
    local hora, fecha = obtenerHora()
    draw_panel(200, 100, 240, 100, "#1E1E1E", 0.95)
    draw_text(220, 120, "reloj", "#FFFFFF")
    draw_text(220, 150, "hora: " .. hora, "#00FF00")
    draw_text(220, 180, "fecha: " .. fecha, "#00FF00")
end
while true do
    dibujarReloj()
    os.execute("sleep 1")
end