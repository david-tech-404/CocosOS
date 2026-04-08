local gui = require("API.gui")

local pantalla_ancho = screen_get_width()
local pantalla_alto = screen_get_height()

clear_screen("#000000")

local logo_path = "/cocosOS/assets/cocologo.png"
local logo_ancho = 256
local logo_alto = 256
local logo_x = (pantalla_ancho - logo_ancho) / 2
local logo_y = (pantalla_alto - logo_alto) / 2 - 60

draw_image(logo_path, logo_x, logo_y)

local ancho_barra = 420
local alto_barra = 18
local x_barra = (pantalla_ancho - ancho_barra) / 2
local y_barra = logo_y + logo_alto + 40

draw_text(pantalla_ancho / 2, y_barra - 25, "Cargando Cocos OS", "#FFFFFF", true)

local progreso = 0

while progreso <= 100 do
    draw_panel(x_barra, y_barra, ancho_barra, alto_barra, "#222222", 1)
    draw_panel(x_barra + 2, y_barra + 2, (ancho_barra - 4) * progreso / 100, alto_barra - 4, "#00AAFF", 1)
    
    update_screen()
    progreso = progreso + 1
    sleep(20)
end

draw_text(pantalla_ancho / 2, y_barra + alto_barra + 20, "Sistema listo", "#00DD55", true)
update_screen()
sleep(500)
