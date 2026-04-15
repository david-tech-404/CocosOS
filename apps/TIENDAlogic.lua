local json = require("json")
local TIENDA_PATH = "/TiendaApps/"
local REPO_JSON = TIENDA_PATH .. "repo.json"
local INSTALLED_JSON = TIENDA_PATH .. "installed.json"
local REMOTE_REPO_URL = "https://raw.githubusercontent.com/david-tech-404/CocosOS/main/repo/index.json"

local function initDirs()
    os.execute("mkdir -p " .. TIENDA_PATH)
end

local function cargarArchivo(path)
    local f = io.open(path, "r")
    if not f then return {} end
    local data = f:read("*a")
    f:close()
    local ok, parsed = pcall(json.decode, data)
    return ok and parsed or {}
end

local function guardarArchivo(path, data)
    local f = io.open(path, "w")
    if f then
        f:write(json.encode(data))
        f:close()
    end
end

local function cargarRepo() return cargarArchivo(REPO_JSON) end
local function guardarRepo(data) guardarArchivo(REPO_JSON, data) end
local function cargarInstaladas() return cargarArchivo(INSTALLED_JSON) end
local function guardarInstaladas(data) guardarArchivo(INSTALLED_JSON, data) end

local function instalarApp(nombreApp)
    local repo = cargarRepo()
    local app = repo.apps and repo.apps[nombreApp]
    
    if not app then
        print("App no encontrada: " .. nombreApp)
        return false
    end
    
    local appPath = TIENDA_PATH .. nombreApp .. "/"
    os.execute("mkdir -p " .. appPath)
    
    local f = io.open(appPath .. "main.lua", "w")
    if f then
        f:write(app.code)
        f:close()
    end
    
    guardarArchivo(appPath .. "meta.json", app)
    
    local instaladas = cargarInstaladas()
    instaladas[nombreApp] = {
        version = app.version,
        installed_at = os.date("%d/%m/%Y %H:%M"),
        path = appPath
    }
    guardarInstaladas(instaladas)
    
    print("Instalada: " .. nombreApp .. " v" .. app.version)
    return true
end

local function desinstalarApp(nombreApp)
    local instaladas = cargarInstaladas()
    if not instaladas[nombreApp] then
        print("App no esta instalada")
        return false
    end
    
    os.execute("rm -rf " .. instaladas[nombreApp].path)
    instaladas[nombreApp] = nil
    guardarInstaladas(instaladas)
    
    print("Desinstalada: " .. nombreApp)
    return true
end

local function listarDisponibles()
    local repo = cargarRepo()
    if not repo.apps or next(repo.apps) == nil then
        print("No hay apps disponibles. Ejecuta 'cpm sync' primero.")
        return
    end
    
    print("\nApps disponibles en repositorio:")
    print("------------------------------------")
    
    for name, app in pairs(repo.apps) do
        print(string.format(" %-16s v%-8s | %s", name, app.version, app.description))
    end
    print()
end

local function listarInstaladas()
    local instaladas = cargarInstaladas()
    
    if next(instaladas) == nil then
        print("No hay apps instaladas")
        return
    end
    
    print("\nApps instaladas:")
    print("--------------------")
    
    for name, info in pairs(instaladas) do
        print(string.format(" %-16s v%-8s | %s", name, info.version, info.installed_at))
    end
    print()
end

local function buscarApp(termino)
    local repo = cargarRepo()
    if not repo.apps then return end
    
    print("\nResultados para '" .. termino .. "':")
    print("----------------------------------------")
    
    for name, app in pairs(repo.apps) do
        if name:lower():find(termino:lower()) or app.description:lower():find(termino:lower()) then
            print(string.format(" %-16s v%-8s | %s", name, app.version, app.description))
        end
    end
    print()
end

local function infoApp(nombreApp)
    local repo = cargarRepo()
    local app = repo.apps and repo.apps[nombreApp]
    
    if not app then
        print("App no encontrada")
        return
    end
    
    print("\nInformacion de " .. nombreApp)
    print("--------------------------")
    print(" Version:     " .. app.version)
    print(" Autor:       " .. (app.author or "Desconocido"))
    print(" Descripcion: " .. app.description)
    print(" Tamaño:      " .. (app.size or "---") .. " bytes")
    print()
end

local function sincronizarRepo()
    print("Sincronizando repositorio remoto...")
    
    local repo = {
        apps = {},
        last_updated = os.date("%d/%m/%Y %H:%M"),
        total_apps = 0
    }
    
    guardarRepo(repo)
    print("Repositorio actualizado")
end

local function mostrarAyuda()
    print("\nCPM - Cocos Package Manager v1.0")
    print("=====================================")
    print(" Comandos disponibles:")
    print("")
    print("  cpm list              Listar apps disponibles")
    print("  cpm installed         Listar apps instaladas")
    print("  cpm get <app>         Instalar aplicacion")
    print("  cpm remove <app>      Desinstalar aplicacion")
    print("  cpm search <texto>    Buscar apps")
    print("  cpm info <app>        Ver informacion de app")
    print("  cpm sync              Actualizar repositorio")
    print("  cpm help              Mostrar esta ayuda")
    print("")
end

local function ejecutarComando(args)
    initDirs()
    
    local cmd = args[1]
    
    if cmd == "get" and args[2] then
        instalarApp(args[2])
    elseif cmd == "remove" and args[2] then
        desinstalarApp(args[2])
    elseif cmd == "list" then
        listarDisponibles()
    elseif cmd == "installed" then
        listarInstaladas()
    elseif cmd == "search" and args[2] then
        buscarApp(args[2])
    elseif cmd == "info" and args[2] then
        infoApp(args[2])
    elseif cmd == "sync" then
        sincronizarRepo()
    elseif cmd == "help" then
        mostrarAyuda()
    else
        mostrarAyuda()
    end
end

if arg and #arg > 0 then
    ejecutarComando(arg)
else
    mostrarAyuda()
end