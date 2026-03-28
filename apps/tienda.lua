local json = require("json")
local TIENDA_PATH = "/tiendaApps/"

local function draw_panel(x, y, w, h, color, alpha)
    os.execute(string.format("draw_panel %d %d %d %d %s %f", x, y, w, h, color, alpha))
end

local function draw_text(x, y, text, color)
    os.execute(string.format("draw_text %d %d '%s' %s", x, y, text, color))
end

local function asegurarCarpeta(path)
    local ok, err = os.execute("mkdir -p " .. path)
    if not ok then
        print("error al crear carpeta:", err)
    end
end

local function guardarApp(nombreApp, codigo, meta)
    local appPath = TIENDA_PATH .. nombreApp .. "/"
    asegurarCarpeta(appPath)

    local f = io.open(appPath .. "main.lua", "w")
    if f then
        f:write(codigo)
        f:close()
    else
        print("no se pudo guardar main.lua")
    end

    local metaF = io.open(appPath .. "meta.lua", "w")
    if metaF then
        metaF:write("return " .. tostring(meta))
        metaF:close()
    else
        print("no se pudo guardar meta.lua")
    end
end

local function probarApp(nombreApp)
    local appPath = TIENDA_PATH .. nombreApp .. "/main.lua"
    local env = {}
    local f, err = loadfile(appPath, "t", env)
    if f then
        local ok, res = pcall(f)
        if not ok then
            print("error al ejecutar app:", res)
        end
    else
        print("no se pudo cargar la app:", err)
    end
end

draw_panel(10, 10, 600, 400, "#1E1E1E", 0.85)
draw_text(20, 20, "=== Cocos OS tienda de apps ===", "#FFFFFF")
draw_text(25, 110, "CÓDIGO lua de la app (termina con línea vacia)", "#FFFFFF")

local codigo = ""
while true do
    local line = io.read()
    if line == "" then break end
    codigo = codigo .. line .. "\n"
end

io.write("nombre de la app: ")
local nombreApp = io.read()

local meta = string.format("{name = '%s', version = '1.0', description = 'app creada en tienda'}", nombreApp)

guardarApp(nombreApp, codigo, meta)

draw_panel(20, 300, 560, 40, "#2C2C2C", 0.9)
draw_text(25, 310, "¿probar app ahora?", "#FFFFFF")

draw_panel(200, 310, 50, 30, "#E95420", 0.8)
draw_text(210, 320, "sí", "#FFFFFF")
draw_panel(300, 310, 50, 30, "#AAAAAA", 0.8)
draw_text(310, 320, "no", "#FFFFFF")

io.write("¿probar app ahora? (s/n):")
local respuesta = io.read()

if respuesta:lower() == "s" then
    probarApp(nombreApp)
end

draw_panel(20, 360, 560, 30, "#2C2C2C", 0.9)
draw_text(25, 365, "app '" .. nombreApp .. "' agregada a la tienda correctamente.", "#FFFFFF")