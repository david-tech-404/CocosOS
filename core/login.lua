local json = require("json")

local USERS_FILE = "/system/users.json"
local SYSTEM_FILE = "/system/system.json"

local function cargarUsuarios()
    local f = io.open(USERS_FILE, "r")
    if not f then return {} end
    local data = f:read("*a")
    f:close()
    local ok, parsed = pcall(json.decode, data)
    return ok and parsed or {}
end

local function cargarSistema()
    local f = io.open(SYSTEM_FILE, "r")
    if not f then
        return { tutorial_completed = false }
    end
    local data = f:read("*a")
    f:close()
    local ok, parsed = pcall(json.decode, data)
    return ok and parsed or { tutorial_completed = false }
end

local function autenticar(usuario, password)
    local users = cargarUsuarios()
    local u = users[usuario]
    if not u then return false end
    return u.password == password
end

local function login()
    print("=== cocos os login ===")
    io.write("usuario (o 'guest'): ")
    local user = io.read()

    if user == "guest" then
        return { user = "guest", role = "guest" }
    end

    io.write("contraseña: ")
    local pass = io.read()

    if autenticar(user, pass) then
        return { user = user, role = "user" }
    else
        print("credenciales inválidas")
        return nil
    end
end

local session = nil
while not session do
    session = login()
end

print("bienvenido:", session.user)

local system = cargarSistema()
if not system.tutorial_completed then
    print("lanzar tutorial")
end