---@class Kernel
Kernel = {}

---@type Kernel
Kernel = nil

---@class GUI
GUI = {}

---@param x number
---@param y number
---@param text string
function GUI:draw_text(x, y, text) end

---@param x number
---@param y number
---@param w number
---@param h number
---@param color number|nil
function GUI:draw_panel(x, y, w, h, color) end

function GUI:clear(color) end

---@type GUI
GUI = GUI

---@param id number
---@param a any
---@param b any 
---@param c any
---@return any
function lilcos_syscall(id, a, b, c) end


---@type string
nombreApp = nombreApp

---@class TIENDA
TIENDA = {}

---@param appId string
function TIENDA:instalar(appId)
end

---@param appId string
function TIENDA:desinstalar(appId) end

---@return table
function TIENDA:listar()
    return {}
end

---@type TIENDA
TIENDA = nil

---@param user string
---@param message string
function enviarMensaje(user, message) end

---@class repo
Repo = {}

function Repo:get(name) end
function Repo:save(name, data)
end

---@type repo
repo = nil

---@class DataStore
DataStore = {}

function DataStore:get(key) end
function DataStore:set(key, value) end

---@class I18N
_G.I18N = {}

---@param key string
---@return string
function I18N:t(key)
    return key
end
---@type I18N
i18n = nil

---@param path string
---@return string|nil
function read_file(path) end

---@class User
User =  {}

---@return string
function User:getName()
    return ""
end

---@return boolean
function User:isAdmin()
    return false
end

---@type User
user = nil

---@type fun():string
leerInput = nil

---@type number
clickX = 0

---@type number
clickY = 0

---@type string
appPath = ""

listarCarpeta = nil

---@type fun():table
leerclick = nil

---@type table
lilcos_syscall = lilcos_syscall or {}

lilcos_syscall = {}

