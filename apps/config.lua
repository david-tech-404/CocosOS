local json = require("json")
local UI_PATH = "/GUI/UI.json"

local function cargarConfig()
    local f = io.open(UI_PATH, "r")
    if not f then return {} end

    local data = f:read("*a")
    f:close()
    local ok, parsed = pcall(json.decode, data)
    return ok and parsed or {}
end

local function guardarConfig(config)
    local f = io.open(UI_PATH, "w")
    if f then
        f:write(json.encode(config))
        f:close()
    end
end

local config = cargarConfig()
config.tema = "MaterialDark"

guardarConfig(config)
print("configuración guardada:", config)