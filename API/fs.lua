local fs = {}

function fs.exists(path)
    return
    lilcos_syscall("file_exists", path)
end

return fs