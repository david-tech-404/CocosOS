---@type table<string,fun(...)>
lilcos_syscall = lilcos_syscall or {}

---@type fun(msg:string)
print = function(msg)
    local f = lilcos_syscall.print
        if f then f(msg) end
end
---@type Kernel
Kernel = Kernel

Kernel =  {}
Kernel.services = {}
Kernel.listeners = {}
Kernel.apps = {}
Kernel.booted = false

function Kernel.regiterService(name, service)
    if not name or not service then return false end
    Kernel.services[name] = service
    return true
end

function Kernel.getService(name)
    return
Kernel.services[name]
end

function Kernel.regiterApp(name, initFn)
    if not name or not initFn then return false end
    Kernel.apps[name] = {init = initFn, running = false}
    return true
end

function Kernel.runApp(name)
    local app = Kernel.apps[name]
    if app and not app.running
    then
        app.running = true
        app.init()
        return true
    end
    return false
end

function Kernel.on(event, fn)
    if not
    Kernel.listeners[event] then
        Kernel.listeners[event] = {}
    end
    
table.insert(Kernel.listeners[event], fn)
end

function Kernel.emit(event, data)
    if Kernel.listeners[event]
then
    for _, fn in pairs(Kernel.listeners[event]) do
        fn(data)
        end
    end
end

function Kernel.boot()
    if Kernel.booted then
    return end
    Kernel.booted = true

    Kernel.emit("boot")

    if lilcos_syscall and lilcos_syscall.print then
        lilcos_syscall.print("lil-cos kernel lógico iniciado")
    end
    for name, app in pairs(Kernel.apps) do
        if app.init then
            app.init() end
        end
---@type fun()
function Kernel.tick()
    Kernel.tickCount = Kernel.tickCount + 1
    Kernel.emit("tick")
end

Kernel.print = function (msg)
    if lilcos_syscall and lilcos_syscall.print then
    end
        if lilcos_syscall.print then
            
        lilcos_syscall.print(msg)
        end

function lilcos_syscall(name, ...)
    
    return nil
end

return Kernel
    end
end