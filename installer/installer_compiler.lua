local json = require("dkjson")
local f = io.open("installer/installer_ui.json", "r")
if not f then error("No se pudo abrir installer_ui.json") end
local content = f:read("*a")
f:close()
local data = json.decode(content)
local out = io.open("installer/InstallerUI.c", "w")
out:write("#include \"InstallerUI.h\"\n\n")
out:write("const char* INSTALLER_TITLE = \"" .. data.title .. "\";\n")
out:write("const char* INSTALLER_BG = \"" .. data.color.background .. "\";\n")
out:write("const char* INSTALLER_ACCENT = \"" .. data.color.accent .. "\";\n")
out:write("const char* INSTALLER_TEXT = \"" .. data.color.text .. "\";\n")
out:write("const char* INSTALLER_BUTTON = \"" .. data.color.button .. "\";\n")
out:write("const char* INSTALLER_BUTTON_HOVER = \"" .. data.color.button_hover .. "\";\n\n")
out:write("const int INSTALLER_PANEL_W = " .. data.panel.width .. ";\n")
out:write("const int INSTALLER_PANEL_H = " .. data.panel.height .. ";\n\n")
out:write("void init_installer_ui() {\n")
out:write("    set_window_title(INSTALLER_TITLE);\n")
out:write("    set_window_size(INSTALLER_PANEL_W, INSTALLER_PANEL_H);\n")
out:write("    set_background_color(INSTALLER_BG);\n")
out:write("}\n\n")
if data.components then
    out:write("void render_installer_ui() {\n")
    for i = 1, #data.components do
        local c = data.components[i]
        if c.type == "label" then
            out:write("    draw_text(" .. (c.x or 0) .. ", " .. (c.y or 0) .. ", \"" .. (c.text or "") .. "\", \"" .. (c.color or "#ffffff") .. "\", " .. (c.font_size or 12) .. ");\n")
        elseif c.type == "button" then
            out:write("    draw_button(" .. (c.x or 0) .. ", " .. (c.y or 0) .. ", " .. (c.w or 50) .. ", " .. (c.h or 20) .. ", \"" .. (c.text or "") .. "\", \"" .. (c.action or "") .. "\");\n")
        elseif c.type == "listbox" then
            out:write("    draw_listbox(" .. (c.x or 0) .. ", " .. (c.y or 0) .. ", " .. (c.w or 100) .. ", " .. (c.h or 100) .. ", \"" .. (c.id or "") .. "\");\n")
        elseif c.type == "radio" then
            out:write("    draw_radio_group(" .. (c.x or 0) .. ", " .. (c.y or 0) .. ", \"" .. (c.id or "") .. "\");\n")
        elseif c.type == "checkbox" then
            out:write("    draw_checkbox(" .. (c.x or 0) .. ", " .. (c.y or 0) .. ", \"" .. (c.text or "") .. "\", " .. (c.checked and "true" or "false") .. ");\n")
        elseif c.type == "progress" then
            out:write("    draw_progress_bar(" .. (c.x or 0) .. ", " .. (c.y or 0) .. ", " .. (c.w or 100) .. ", " .. (c.h or 20) .. ", " .. (c.value or 0) .. ", " .. (c.max or 100) .. ");\n")
        end
    end
    out:write("}\n")
end
out:write("\nvoid handle_installer_action(const char* action) {\n")
out:write("    if (strcmp(action, \"start_install\") == 0) {\n")
out:write("        start_installation();\n")
out:write("    } else if (strcmp(action, \"show_advanced\") == 0) {\n")
out:write("        show_advanced_options();\n")
out:write("    } else if (strcmp(action, \"exit\") == 0) {\n")
out:write("        exit_installer();\n")
out:write("    } else if (strcmp(action, \"back\") == 0) {\n")
out:write("        go_back();\n")
out:write("    } else if (strcmp(action, \"next\") == 0) {\n")
out:write("        go_next();\n")
out:write("    }\n")
out:write("}\n")
out:close()
print("InstallerUI.c generado exitosamente")