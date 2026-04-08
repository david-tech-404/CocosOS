local input = {}
function input.wait_click()
    return lilcos_syscall("wait_click")
end
return input