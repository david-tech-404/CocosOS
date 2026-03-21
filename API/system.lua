local system = {}

function system.load()
    lilcos_syscall("load_system")
end

function system.set_lang(lang)
    lilcos_syscall("set_lang", lang)
end

return system