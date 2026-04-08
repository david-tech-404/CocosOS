local procesos = {}
local seleccionado = nil
local modoVista = "lista" -- lista, detalles

-- Procesos simulados del sistema
local procesosSimulados = {
    {nombre = "kernel.lua", pid = 1, cpu = 2.5, memoria = 15, estado = "ejecutando", tipo = "sistema"},
    {nombre = "gui.lua", pid = 2, cpu = 5.2, memoria = 25, estado = "ejecutando", tipo = "sistema"},
    {nombre = "calculadora.lua", pid = 101, cpu = 0.1, memoria = 8, estado = "activo", tipo = "app"},
    {nombre = "bloc-de-notas.lua", pid = 102, cpu = 0.3, memoria = 12, estado = "activo", tipo = "app"},
    {nombre = "reloj.lua", pid = 103, cpu = 1.2, memoria = 6, estado = "ejecutando", tipo = "app"},
    {nombre = "explorador.lua", pid = 104, cpu = 0.5, memoria = 18, estado = "inactivo", tipo = "app"},
    {nombre = "notificaciones.lua", pid = 105, cpu = 0.2, memoria = 10, estado = "activo", tipo = "app"},
    {nombre = "shellby.py", pid = 201, cpu = 3.8, memoria = 45, estado = "ejecutando", tipo = "ia"},
    {nombre = "vfs.c", pid = 301, cpu = 0.8, memoria = 22, estado = "ejecutando", tipo = "driver"},
    {nombre = "scheduler.c", pid = 302, cpu = 1.5, memoria = 18, estado = "ejecutando", tipo = "sistema"}
}

local function cargarProcesos()
    procesos = {}
    for _, proc in ipairs(procesosSimulados) do
        table.insert(procesos, proc)
    end
end

local function obtenerColorEstado(estado)
    if estado == "ejecutando" then
        return "#4CAF50"
    elseif estado == "activo" then
        return "#00AEEF"
    elseif estado == "inactivo" then
        return "#FF9800"
    elseif estado == "detenido" then
        return "#F44336"
    else
        return "#FFFFFF"
    end
end

local function obtenerColorTipo(tipo)
    if tipo == "sistema" then
        return "#FF9800"
    elseif tipo == "app" then
        return "#4CAF50"
    elseif tipo == "ia" then
        return "#9C27B0"
    elseif tipo == "driver" then
        return "#00AEEF"
    else
        return "#FFFFFF"
    end
end

local function calcularUsoTotal()
    local cpuTotal = 0
    local memoriaTotal = 0
    local procesosActivos = 0
    
    for _, proc in ipairs(procesos) do
        cpuTotal = cpuTotal + proc.cpu
        memoriaTotal = memoriaTotal + proc.memoria
        if proc.estado ~= "detenido" then
            procesosActivos = procesosActivos + 1
        end
    end
    
    return cpuTotal, memoriaTotal, procesosActivos
end

local function terminarProceso(pid)
    for i, proc in ipairs(procesos) do
        if proc.pid == pid then
            if proc.tipo == "sistema" then
                draw_panel(150, 200, 300, 60, "#3C3C3C", 0.95)
                draw_text(170, 220, "no se puede terminar proceso del sistema", "#F44336")
                return false
            end
            proc.estado = "detenido"
            proc.cpu = 0
            proc.memoria = 0
            return true
        end
    end
    return false
end

local function dibujarGUI()
    -- Panel principal
    draw_panel(50, 50, 500, 450, "#2C2C2C", 0.95)
    draw_text(70, 70, "gestor de tareas", "#FFFFFF")
    
    -- Estadísticas del sistema
    local cpuTotal, memoriaTotal, procesosActivos = calcularUsoTotal()
    draw_text(70, 95, "cpu: " .. string.format("%.1f%%", cpuTotal) .. " | memoria: " .. memoriaTotal .. "mb | procesos: " .. procesosActivos, "#CCCCCC")
    
    -- Botones de control
    draw_panel(70, 115, 80, 25, "#4CAF50", 0.8)
    draw_text(80, 123, "actualizar", "#FFFFFF")
    
    draw_panel(160, 115, 80, 25, "#F44336", 0.8)
    draw_text(170, 123, "terminar", "#FFFFFF")
    
    draw_panel(250, 115, 80, 25, "#00AEEF", 0.8)
    draw_text(260, 123, "detalles", "#FFFFFF")
    
    -- Modo vista
    draw_text(360, 123, "vista: " .. modoVista, "#888888")
    
    -- Encabezados de la tabla
    local yInicio = 150
    draw_panel(70, yInicio, 460, 20, "#333333", 0.9)
    draw_text(80, yInicio + 5, "nombre", "#FFFFFF")
    draw_text(200, yInicio + 5, "pid", "#FFFFFF")
    draw_text(240, yInicio + 5, "cpu%", "#FFFFFF")
    draw_text(290, yInicio + 5, "mem(mb)", "#FFFFFF")
    draw_text(360, yInicio + 5, "estado", "#FFFFFF")
    draw_text(430, yInicio + 5, "tipo", "#FFFFFF")
    
    -- Lista de procesos
    if #procesos == 0 then
        draw_text(70, yInicio + 30, "no hay procesos", "#888888")
    else
        for i, proc in ipairs(procesos) do
            local y = yInicio + 25 + (i-1) * 30
            local colorFondo = seleccionado == i and "#4C4C4C" or (i % 2 == 0 and "#1A1A1A" or "#252525")
            
            -- Fondo de fila
            draw_panel(70, y, 460, 25, colorFondo, 0.9)
            
            -- Nombre del proceso
            local nombreCorto = proc.nombre
            if #nombreCorto > 15 then
                nombreCorto = nombreCorto:sub(1, 12) .. "..."
            end
            draw_text(80, y + 5, nombreCorto, "#FFFFFF")
            
            -- PID
            draw_text(200, y + 5, tostring(proc.pid), "#CCCCCC")
            
            -- CPU
            draw_text(240, y + 5, string.format("%.1f", proc.cpu), "#CCCCCC")
            
            -- Memoria
            draw_text(290, y + 5, tostring(proc.memoria), "#CCCCCC")
            
            -- Estado
            local colorEstado = obtenerColorEstado(proc.estado)
            draw_text(360, y + 5, proc.estado, colorEstado)
            
            -- Tipo
            local colorTipo = obtenerColorTipo(proc.tipo)
            draw_text(430, y + 5, proc.tipo, colorTipo)
        end
    end
    
    -- Panel de detalles si hay selección
    if seleccionado and procesos[seleccionado] and modoVista == "detalles" then
        local proc = procesos[seleccionado]
        draw_panel(70, 380, 460, 100, "#3C3C3C", 0.95)
        draw_text(80, 390, "detalles del proceso", "#FFFFFF")
        draw_text(80, 410, "nombre: " .. proc.nombre, "#CCCCCC")
        draw_text(80, 425, "pid: " .. proc.pid .. " | estado: " .. proc.estado, "#CCCCCC")
        draw_text(80, 440, "cpu: " .. string.format("%.1f%%", proc.cpu) .. " | memoria: " .. proc.memoria .. " mb", "#CCCCCC")
        draw_text(80, 455, "tipo: " .. proc.tipo, "#CCCCCC")
    end
end

local function detectarClicks(x, y)
    -- Botón actualizar
    if x >= 70 and x <= 150 and y >= 115 and y <= 140 then
        cargarProcesos()
        draw_panel(150, 200, 200, 60, "#3C3C3C", 0.95)
        draw_text(170, 220, "procesos actualizados", "#4CAF50")
    -- Botón terminar
    elseif x >= 160 and x <= 240 and y >= 115 and y <= 140 then
        if seleccionado and procesos[seleccionado] then
            terminarProceso(procesos[seleccionado].pid)
        end
    -- Botón detalles
    elseif x >= 250 and x <= 330 and y >= 115 and y <= 140 then
        modoVista = modoVista == "lista" and "detalles" or "lista"
    end
    
    if #procesos > 0 then
        local yInicio = 150
        for i, proc in ipairs(procesos) do
            local y = yInicio + 25 + (i-1) * 30
            if x >= 70 and x <= 530 and y >= y and y <= y + 25 then
                seleccionado = i
                return
            end
        end
    end
end

cargarProcesos()

while true do
    dibujarGUI()
    local x, y = leerclick()
    if x then detectarClicks(x, y) end
end