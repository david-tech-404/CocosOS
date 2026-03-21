local logo_path = "/cocosOS//assets/cocologo.png"
local ancho_barra = 400
local alto_barra = 20
local x_barra = 100
local y_barra = 300
local progreso = 0

draw_image(logo_path, 150, 100)

draw_text(100, 270, "Cargando Cocos OS...", "#FFFFFF")

while progreso <= 100 do draw_panel(x_barra, y_barra, ancho_barra, alto_barra, "#555555", 0.8)

draw_panel(x_barra, y_barra, (ancho_barra * progreso)/ 100, alto_barra, "FFFFFFFF", 0.9)
progreso = progreso + 1
os.execute("sleep 0.05")

end

draw_text(100, 330, "¡Listo!", "#00FF00")