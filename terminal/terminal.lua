print("Cocos OS Shell")

while true do
    io.write("cocos> ")
    local cmd = io.read()

    if cmd == "help" then
        print("Comandos")
        print("help")
        print("clear")
        print("about")

    elseif cmd == "about" then
        print("Cocos OS alfa v1, Kernel lilcos v1")

    else
        print("comando no encontrado")
    end
end