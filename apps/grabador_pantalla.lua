local Grabador = {}
Grabador.grabando = false
Grabador.frames = 0
Grabador.tiempo_inicio = 0

function Grabador.iniciar()
    Grabador.grabando = true
    Grabador.frames = 0
    Grabador.tiempo_inicio = tiempo.ahora()
end

function Grabador.detener()
    Grabador.grabando = false
    local duracion = tiempo.ahora() - Grabador.tiempo_inicio
    fs.escribir("grabacion_"..os.time()..".cap", "GRABACION: "..Grabador.frames.." cuadros en "..duracion.." segundos")
end

function Grabador.capturar_cuadro()
    if Grabador.grabando then
        pantalla.capturar("frame_"..Grabador.frames..".raw")
        Grabador.frames = Grabador.frames + 1
    end
end

function Grabador.dibujar()
    gui.limpiar()
    gui.texto(20, 20, "Grabador de Pantalla")
    
    if Grabador.grabando then
        gui.texto(20, 60, "ESTADO: GRABANDO")
        gui.texto(20, 90, "Cuadros: "..Grabador.frames)
        gui.boton(20, 130, "Detener Grabacion", Grabador.detener)
    else
        gui.texto(20, 60, "ESTADO: Detenido")
        gui.boton(20, 130, "Iniciar Grabacion", Grabador.iniciar)
    end
end

return Grabador