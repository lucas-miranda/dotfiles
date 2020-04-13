local naughty = naughty

-- checking
if type(naughty) ~= "table" then
    if naughty_config_handler.verbose then
        print("[Error] When checking naughty instance, expected 'table', but got '" .. type(naughty) .. "'")
    end

    return
end

-- configure
print("Configuring naughty...")

naughty.config.defaults = {
    width = 400,
    height = 170,
    icon_size = 160,
    timeout = 3,
    text = "",
    screen = 1,
    ontop = true,
    margin = 5,
    padding = 1,
    border_width = 1,
    position = "top_right"
}

print("Done!")
