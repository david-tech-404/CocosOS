local fuentes = {}
fuentes["Inter-Regular"] = load_font("GUI/fonts/Inter-Regular.ttf", 14)
fuentes["Inter-bold"] = load_font("GUI/fonts/InterDisplay-Bold.ttf", 18)
function SetFont(tipo)
    if tipo == "regular" then
gui.setFont(fuentes["Inter-Regular"])
    elseif tipo == "bold" then
gui.setFont(fuentes["Inter-bold"])
        else
gui.setFont(fuentes["Inter-Regular"])
    end
end
setFont("regular")