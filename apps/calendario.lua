local function obtenerFecha()
    local dia = tonumber(os.date("%d"))
    local mes = tonumber(os.date("%m"))
    local ano = tonumber(os.date("%Y"))
    return dia, mes, ano
end
local function dibujarCalendario()
    local dia, mes, ano = obtenerFecha()
    draw_panel(150, 100, 300, 250, "#1E1E1E", 0.95)
    draw_text(170, 120, "calendario", "#FFFFFF")
    draw_text(170, 150, "fecha actual: " .. dia .. "/" .. mes .. "/" .. ano, "#00FF00")
    draw_text(170, 180, "dias del mes:", "#AAAAAA")
    local y = 200
    for d = 1, 31 do
        draw_text(170 + ((d-1)%7)*30, y + math.floor((d-1)/7)*20, tostring(d), "#FFFFFF")
    end
end
while true do
    dibujarCalendario()
    os.execute("sleep 1")
end