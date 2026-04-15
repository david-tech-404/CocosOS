local Snake = {}
Snake.cuerpo = {{x=10,y=10}}
Snake.dx = 1
Snake.dy = 0
Snake.comida = {x=20,y=15}
Snake.puntos = 0

function Snake.actualizar()
    local cabeza = {
        x = Snake.cuerpo[1].x + Snake.dx,
        y = Snake.cuerpo[1].y + Snake.dy
    }
    
    table.insert(Snake.cuerpo, 1, cabeza)
    
    if cabeza.x == Snake.comida.x and cabeza.y == Snake.comida.y then
        Snake.puntos = Snake.puntos + 10
        Snake.comida.x = math.random(0,39)
        Snake.comida.y = math.random(0,24)
    else
        table.remove(Snake.cuerpo)
    end
end

function Snake.dibujar()
    gui.limpiar()
    gui.texto(10,10, "Puntos: "..Snake.puntos)
    
    for i,p in ipairs(Snake.cuerpo) do
        gui.rectangulo(p.x*16, p.y*16, 15,15)
    end
    
    gui.rectangulo(Snake.comida.x*16, Snake.comida.y*16,15,15)
end

function Snake.tecla(c)
    if c == 'w' then Snake.dx=0 Snake.dy=-1 end
    if c == 's' then Snake.dx=0 Snake.dy=1 end
    if c == 'a' then Snake.dx=-1 Snake.dy=0 end
    if c == 'd' then Snake.dx=1 Snake.dy=0 end
end

return Snake