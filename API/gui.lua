local gui = {}

function screen_get_width()
    return lilcos_syscall("screen_get_width")
end

function screen_get_height()
    return lilcos_syscall("screen_get_height")
end

function clear_screen(color)
    lilcos_syscall("clear_screen", color)
end

function update_screen()
    lilcos_syscall("update_screen")
end

function sleep(ms)
    lilcos_syscall("sleep", ms)
end

function draw_text(x, y, texto, color, centrar)
    if centrar then
        local ancho_texto = lilcos_syscall("get_text_width", texto)
        x = x - (ancho_texto / 2)
    end
    lilcos_syscall("draw_text", texto, x, y, color)
end

function draw_image(ruta, x, y)
    return lilcos_syscall("draw_image", ruta, x, y)
end

function draw_panel(x, y, ancho, alto, color, opacidad)
    lilcos_syscall("draw_panel", x, y, ancho, alto, color, opacidad)
end

return gui