I18n = {}
local current = {}
local fallback = {}
local lang = "en"
function i18n.load(new_lang)
    lang = new_lang or "en"
    fallback = json_decode(read_file("locales/intl.json"))
    local path = "locales/" .. lang .. ".json"
if file_exists(path) then
    current = json_decode(read_file(path))
    else
        current = fallback
    end
end
function _(key)
    if current[key] then
        return current[key]
    end
    if fallback[key] then
        return fallback[key]
    end
    return key
end