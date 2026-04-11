local input = ""
local resultado = nil

local function dibujarGUI()
    draw_panel(100, 50, 300, 400, "#1E1E1E", 0.95)
    draw_text(120, 70, "calculadora", "#FFFFFF")

    draw_panel(120, 100, 260, 50, "#000000", 1)
    draw_text(130, 120, input, "#FFFFFF")

    local botones = {
        {"7",120,170},
        {"8",180,170},
        {"9",240,170},
        {"/",300,170},
        {"4",120,220},
        {"5", 180,220},
        {"6",240,220},
        {"*",300,220},
        {"1",120,270},
        {"2",180,270},
        {"3",240,270},
        {"-",300,270},
        {"0",120,320},
        {".",180,320},
        {"=",240,320},
        {"+",300,320},
    }
    for _, b in ipairs(botones) do
        draw_panel(b[2], b[3], 50, 40, "#333333", 0.9)
        draw_text(b[2]+18, b[3]+12, b[1], "#FFFFFF")
    end
end

local function click(x, y)
    local function dentro(bx, by)
        return x>=bx and x<=bx+50 and y>=by and y<=by+40
    end
    
    local botones = {
        {"7",120,170},
        {"8",180,170},
        {"9",240,170},
        {"/",300,170},
        {"4",120,220},
        {"5", 180,220},
        {"6",240,220},
        {"*",300,220},
        {"1",120,270},
        {"2",180,270},
        {"3",240,270},
        {"-",300,270},
        {"0",120,320},
        {".",180,320},
        {"=",240,320},
        {"+",300,320},
    }
    for _, b in ipairs(botones) do
        if dentro(b[2], b[3]) then
            if b[1] == "=" then
                local f = load("return " .. input)
                if f then
                    resultado = tostring(f())
                    input = resultado
                end
            else
                input = input .. b[1]
            end
        end
    end
end

while true do
    dibujarGUI()
    local x,y = leerclick()
    if x then click(x,y) end
end