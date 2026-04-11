lilcos_syscall = lilcos_syscall or {}

Kernel = {}
Kernel.services = {}
Kernel.listeners = {}
Kernel.apps = {}
Kernel.booted = false
Kernel.tickCount = 0

function Kernel.registerService(name, service)
    if not name or not service then return false end
    Kernel.services[name] = service
    return true
end

function Kernel.getService(name)
    return Kernel.services[name]
end

function Kernel.registerApp(name, initFn)
    if not name or not initFn then return false end
    Kernel.apps[name] = {init = initFn, running = false}
    return true
end

function Kernel.runApp(name)
    local app = Kernel.apps[name]
    if app and not app.running then
        app.running = true
        app.init()
        return true
    end
    return false
end

function Kernel.on(event, fn)
    if not Kernel.listeners[event] then
        Kernel.listeners[event] = {}
    end
    table.insert(Kernel.listeners[event], fn)
end

function Kernel.emit(event, data)
    if Kernel.listeners[event] then
        for _, fn in pairs(Kernel.listeners[event]) do
            fn(data)
        end
    end
end

function Kernel.print(msg)
    if lilcos_syscall and lilcos_syscall.print then
        lilcos_syscall.print(msg)
    end
end

function Kernel.boot()
    if Kernel.booted then return end
    Kernel.booted = true
    
    Kernel.emit("boot")
    
    Kernel.print("lil-cos kernel logico iniciado")
    
    for name, app in pairs(Kernel.apps) do
        if not app.running then
            app.init()
            app.running = true
        end
    end
end

function Kernel.tick()
    Kernel.tickCount = Kernel.tickCount + 1
    Kernel.emit("tick")
end

print = function(msg)
    Kernel.print(msg)
end

return Kernel