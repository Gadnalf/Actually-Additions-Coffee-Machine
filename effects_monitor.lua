server = 51
order_effect = {}
order = {}

effects = {
    [2] = "Fire Resistance",
    [3] = "Speed",
    [4] = "Night Vision",
    [5] = "Water Breathing",
    [6] = "Invisibility",
    [7] = "Regeneration",
    [8] = "Strength"
}

durations = {
    [2] = 20,
    [3] = 30,
    [4] = 30,
    [5] = 10,
    [6] = 25,
    [7] = 5,
    [8] = 15
}

effect_color = {
    [2] = colors.orange,
    [3] = colors.white,
    [4] = colors.blue,
    [5] = colors.lightBlue,
    [6] = colors.lightGray,
    [7] = colors.pink,
    [8] = colors.red
}

function update_order_effect()
    order_effect = {}
    for i = 1, getTableSize(order) do
        effect = order[i]
        if effects[effect] then
            if order_effect[effect] then 
                order_effect[effect][1] = order_effect[effect][1] + 1
            else
                order_effect[effect] = {[1] = 1, [2] = durations[effect]}
            end
        else
            for j=2,8 do
                if order_effect[j] then 
                    order_effect[j][2] = order_effect[j][2] + 120
                    order_effect[j][1] = order_effect[j][1] - 1
                    if order_effect[j][1] == 0 then order_effect[j] = nil end
                end
            end
        end
    end
end

function write_effects()
    bg = colors.black
    color_print(colors.black, colors.white, "Effect Preview:")
    -- Write 8 lines
    if getTableSize(order_effect) == 0 then 
        color_print(bg, colors.white, "No effect")
        print("")
    end
        for i, v in pairs(order_effect) do
            color_print(bg, effect_color[i], 
            effects[i].." "..v[1].." ("..v[2].."s)")
        end
        for i=1, 7-#order_effect do
            color_print(bg, colors.black, "")
        end
end

function color_print(bg, text_color, text)
    term.setBackgroundColor(bg)
    term.setTextColor(text_color)
    x,y = term.getCursorPos()
    if #text>18 then print("                 ") end
    write("                 ")
    term.setCursorPos(x,y)
    print(text)
    reset_color()
end

function reset_color()
    term.setBackgroundColor(colors.black)
    term.setTextColor(colors.white)
end

function getTableSize(t)
    local count = 0
    for _, __ in pairs(t) do
        count = count + 1
    end
    return count
end

rednet.open("top")
while true do
    term.setCursorPos(1,1)
    reset_color()
    term.clear()
    update_order_effect()
    write_effects()
    local id = -1
    while id ~= server do
        id, message = rednet.receive()
    end
    order = message
end
