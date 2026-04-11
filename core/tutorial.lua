local function marcarTutorialCompleto()
    local config = cargarSistema()
    config.tutorial_completed = true
    gurdarConfig(config)
end

local function paso(texto)
    draw_panel(50, 80, 540, 80, "#1E1E1E", 0.9)
    draw_text(60, 110, texto, "#FFFFFF")
    esperarClick()    
end

paso("Hola user de Cocos OS")
paso("bienvenido a cocos os")
paso("todo el sistema se basa en apps simples y rápidas")
paso("el proyecto es de código abierto y por el momento solo se encarga una persona únicamente y la persona que se encarga de todo el proyecto es David Fernandez y ese soy yo si el creador de cocos os y en reddit es u/daviddandadan y no, yo no estoy loco, bueno pero por el momento")
paso("usá la tienda para crear o instalar aplicaciones o con cpm (root cpm get <y la app>)")
paso("la terminal te da control total del sistema y mas con root")
paso("podés personlizar todos desde configuracion")
paso("cocos os tiene IA de solo texto con gui liamado shellby y es local")
paso("el creador de Cocos OS es un proyecto open-source creado por Davidavid fernandez")
paso("comunidad y contacto: reddit: u/daviddandadan")
paso(" contacto en discord: https://discord.gg/2P9fVeQsPY")
marcarTutorialCompleto()

draw_text(60, 220, "Tutorial completo. Disfrutá cocos OS.", "#00FF00")