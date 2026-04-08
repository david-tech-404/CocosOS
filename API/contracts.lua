Kernel = {}
Kernel = nil
GUI = {}
function GUI:draw_text(x, y, text) end
function GUI:draw_panel(x, y, w, h, color) end
function GUI:clear(color) end
GUI = GUI
function lilcos_syscall(id, a, b, c) end
nombreApp = nombreApp
TIENDA = {}
function TIENDA:instalar(appId)
end
function TIENDA:desinstalar(appId) end
function TIENDA:listar()
    return {}
end
TIENDA = nil
function enviarMensaje(user, message) end
Repo = {}
function Repo:get(name) end
function Repo:save(name, data)
end
repo = nil
DataStore = {}
function DataStore:get(key) end
function DataStore:set(key, value) end
_G.I18N = {}
function I18N:t(key)
    return key
end
i18n = nil
function read_file(path) end
User =  {}
function User:getName()
    return ""
end
function User:isAdmin()
    return false
end
user = nil
leerInput = nil
clickX = 0
clickY = 0
appPath = ""
listarCarpeta = nil
leerclick = nil
lilcos_syscall = lilcos_syscall or {}
lilcos_syscall = {}