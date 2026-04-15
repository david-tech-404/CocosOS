local Editor = {}
Editor.lineas = {""}
Editor.cursor_x = 1
Editor.cursor_y = 1
Editor.nombre_archivo = "nuevo.txt"

function Editor.dibujar()
    gui.limpiar()
    gui.texto(10, 10, "Editor de Texto - "..Editor.nombre_archivo)
    
    for i, linea in ipairs(Editor.lineas) do
        gui.texto(10, 30 + i * 16, linea)
    end
    
    gui.cursor(10 + (Editor.cursor_x-1)*8, 30 + (Editor.cursor_y-1)*16)
end

function Editor.tecla(c)
    if c == '\n' then
        table.insert(Editor.lineas, Editor.cursor_y + 1, "")
        Editor.cursor_y = Editor.cursor_y + 1
        Editor.cursor_x = 1
    elseif c == '\b' then
        if Editor.cursor_x > 1 then
            Editor.lineas[Editor.cursor_y] = string.sub(Editor.lineas[Editor.cursor_y], 1, Editor.cursor_x-2) .. string.sub(Editor.lineas[Editor.cursor_y], Editor.cursor_x)
            Editor.cursor_x = Editor.cursor_x - 1
        end
    else
        Editor.lineas[Editor.cursor_y] = string.sub(Editor.lineas[Editor.cursor_y], 1, Editor.cursor_x-1) .. c .. string.sub(Editor.lineas[Editor.cursor_y], Editor.cursor_x)
        Editor.cursor_x = Editor.cursor_x + 1
    end
end

function Editor.guardar()
    fs.escribir(Editor.nombre_archivo, table.concat(Editor.lineas, "\n"))
end

return Editor