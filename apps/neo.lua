local function neo()
    print("")
    print("  ════════════════════════════════════")
    print("  Cocos OS System Information")
    print("  ════════════════════════════════════")
    print("  Cocos OS Alpha v1")
    print("")
    print("  Kernel:     lilcos v1")
    print("  Shell:      csh")
    print("  Packages:   "..#fs.list("/.cpm/packages"))
    print("  Uptime:     "..tiempo.activo().." segundos")
    print("  RAM:        "..memoria.usada().." / "..memoria.total().." Mb")
    print("  CPU:        x86_64")
    print("  Resolucion: "..pantalla.ancho().."x"..pantalla.alto())
    print("  Idioma:     "..idioma.actual())
    print("")
end

return neo