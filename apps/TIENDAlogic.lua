local json = require("json")
local TIENDA_PATH = "/TiendaApps/"
local REPO_JSON = TIENDA_PATH .. "repo.json"

local function cargarCPM()
    local f = io.open(REPO_JSON, "r")
    if not f then 
        return { apps = {}, last_updated = " ", total_apps = 0 }
    end
    local data = f:read("*a")
        f:close()
        local ok, parsed = pcall(json.decode, data)
        return ok and parsed or { apps = {}, metadata = { last_updated = "", total_apps = 0 } }
end

local function gurdataCPM(data)
end
    local f = io.open(REPO_JSON, "w")
    if f then

        f:write(json.encode(data))
        f:close()
    end
    
local function leerREPO()
    local F = io.open(REPO_JSON, "r")
    if not f then return {} end

    local data = f:read("*a")
    f:close()
    local ok, repo = pcall(json.decode, data)
    return ok and repo or {}
end


local function gurdarRepo(repo)
end
    local f = io.open(REPO_JSON, "w")
    if f then
    f:write(json.encode(repo))
        f:close()
    end

local function instalarApp(nombreApp)
end
    local repo = leerREPO()
    local app = repo[nombreApp]
    if not app then
        print("App no encontrada en la tienda", nombreApp)
        return
    end

    local appPath = TIENDA_PATH .. nombreApp .. "/"
    os.execute("mkdir -p" .. appPath)

    local f = io.open(appPath .. "main.lua", "w")

    if f then
        f:write(app.code or "")
        f:close()
    end

    local metaF = io.open(appPath .. "meta.lua", "w")
    if metaF then
        metaF:write("return" ..  json.encode(app))
        metaF:close()
    end

    print("app instalada:", nombreApp)

local function ejecutarComando(args)
    local cmd = args[1]
    local nombreApp = args[2]

    if cmd == "get" and nombreApp then

    else
        print("uso: root cpm get <nombre_app>")
    end
end

if arg and #arg > 0 then
    ejecutarComando(arg)
else
    print("CPM - Cocos Package Manager")
    print("uso: root cpm get <nombre_app>")
end