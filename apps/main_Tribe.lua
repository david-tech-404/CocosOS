---@type boolean
existeUsuario = false

---@type string
contrasena = ""

---@type table<string,any>

data = {}

---@type table<string,any>
config = {}

---@type table<string,any>
usuarios = {}

local json = require("json")
local DATA_PATH  = "/Tribe/"
local FILE_JSON = DATA_PATH .. "tribe.json"

local function asegurarCarpeta(path)
    os.execute("mkdir -p" .. path)
end
asegurarCarpeta(DATA_PATH)

local function cargarDatos()
    local  f = io.open(FILE_JSON, "r")
    if not f then
        return {usuarios={}, publicaciones={}}
    end
    local data = f:read("*a")
    f:close()
    local ok, parsed = pcall(json.decode, data)
    return ok and parsed or {usuarios{}, publicaciones={}}
end

local function gurdarDatos(datos)
    local f = io.open(FILE_JSON, "w")
    if f then
        f:write(json.encode(datos))
        f:close()
    end
end

local function publicar(datos, usuario, texto)
    table.insert(datos.publicaciones, {usuario=usuario, texto=texto})
    gurdarDatos(datos)
end

draw_panel(100, 200, 400, 150, "#2C2C2C", 0.9)
draw_text(120, 210, "Usuario:", "#ffffff")
draw_panel(200, 205, 200, 25, "#FFFFFF", 0.5)
draw_text(120, 245, "Contraseña:", "#ffffff", 0,5)
draw_panel(180, 280, 80, 30, "#E95420", 0.8)
draw_text(190, 290, "Entrar", "#FFFFFF")
draw_panel(300, 280, 80, 30, "#AAAAAA",0.8)
draw_text(310, 290, "Registrar", "#ffffff")

local usuario = leerInput()

local Contrasena = leerInput()
local loginExitoso = false

if existeUsuario(usuario, contrasena) then
    loginExitoso = true
else
    print("EEROR: Usuario o contraseña incorrectos")
end

draw_panel(50, 100, 590, 380, "#1E1E1E", 0.8)

draw_text(60, 110, "Bienvenido a tribe, " .. usuario, "#FFFFFF")

local mensaje = leerInput()
if mensaje and mensaje ~= nil then 
    enviarMensaje(usuario, mensaje)
end