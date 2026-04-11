local gui = {}

function gui.draw_text(text, x, y)
    lilcos_syscall("draw_text", text, x, y)
end

function gui.draw_image(path, x, y)
    lilcos_syscall("draw_text_image", path, x, y)
end

return gui
