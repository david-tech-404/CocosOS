local json = require("dkjson")

local f = io.open("GUI/UI.json", "r")
if not f then error("No se pudo abrir UI.json") end
local content = f:read("*a")
f:close()

local data = json.decode(content)
local out = io.open("UI.c", "w")

out:write("#include \"UI.h\"\n\n")

out:write("const char* UI_BG = \"" .. data.color.background .. "\";\n")
out:write("const char* UI_ACCENT = \"" .. data.color.accent .. "\";\n")
out:write("const int PANEL_H = " .. data.panel.height .. ";\n\n")

out:write("void init_ui_settings() {\n")
out:write("    set_wallpaper(\"" .. data.wallpaper.path .. "\");\n")
out:write("    set_cursor(\"" .. data.cursor.path .. "\", " .. data.cursor.size .. ");\n")
out:write("}\n\n")

if data.components then
    out:write("void render_ui() {\n")
    for i = 1, #data.components do
        local c = data.components[i]
        if c.type == "label" then
            out:write("    draw_text(" .. (c.x or 0) .. ", " .. (c.y or 0) .. ", \"" .. (c.text or "") .. "\");\n")
        elseif c.type == "button" then
            out:write("    draw_button(" .. (c.x or 0) .. ", " .. (c.y or 0) .. ", " .. (c.w or 50) .. ", " .. (c.h or 20) .. ", \"" .. (c.text or "") .. "\");\n")
        end
    end
    out:write("}\n")
end

out:close()