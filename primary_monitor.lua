scroll = 1
order = {}
target_server = 56

ingredients = {
  [1] = "Milk",
  [2] = "Magma Cream",
  [3] = "Sugar",
  [4] = "Golden Carrot",
  [5] = "Pufferfish",
  [6] = "Spider Eye",
  [7] = "Ghast Tear",
  [8] = "Blaze Powder"
}

wires = {
  [1] = colors.black,
  [2] = colors.green,
  [3] = colors.white,
  [4] = colors.yellow,
  [5] = colors.blue,
  [6] = colors.brown,
  [7] = colors.red,
  [8] = colors.orange
}

ingredient_limits = {
  [1] = 3,
  [2] = 2,
  [3] = 4,
  [4] = 2,
  [5] = 2,
  [6] = 2,
  [7] = 3,
  [8] = 4
}
 
buttons = {
  [2] = function() add_to_order(0) end,
  [3] = function() add_to_order(1) end,
  [4] = function() add_to_order(2) end,
  [5] = function() add_to_order(3) end,
  [6] = function() order = {} end,
  [18] = function() brew() end
}

side_buttons = {
  [2] = function() scroll_up() end,
  [5] = function() scroll_down() end
}

function scroll_up()
  if scroll > 1 then
    scroll = scroll - 1
  end
end
 
function scroll_down()
  if scroll <= #ingredients - 4 then
    scroll = scroll + 1
  end
end
 
function add_to_order(i)
  -- Adds item to order if order is not full and ingredients are available
  local order_len = #order
  if order_len < 8 then
    local num_ingredient = 0
    for key, val in pairs(order) do
      if val == i+scroll then num_ingredient = num_ingredient + 1 end
      if num_ingredient == ingredient_limits[i+scroll] then return end
    end
    order[order_len + 1] = i+scroll
  end
  transmit_order()
end

function brew()
  term.clear()
    term.setCursorPos(1,1)
    color_print(colors.black, colors.white, "Making your")
    color_print(colors.black, colors.white, "coffee...")
    print("")
    color_print(colors.black, colors.white, "Progress:")
    local x,y = term.getCursorPos()
    for i=1,14 do
      color_print(colors.lightGray, colors.white, "")
    end
    term.setCursorPos(x,y)
    for i=1,#order do
      color_print(colors.white, colors.black, "Adding "..ingredients[i])
      add_ingredient(order[i])
    end
    color_print(colors.white, colors.black, "Brewing...")
    rs.setBundledOutput("front", colors.red)
    sleep(1)
    rs.setBundledOutput("front", 0)
    sleep(31)
    rs.setBundledOutput("front", colors.green)
    sleep(1)
    rs.setBundledOutput("front", 0)
    color_print(colors.white, colors.black, "Enjoy!")
    sleep(5)
    order = {}
    scroll = 1
end

function add_ingredient(i)
  rs.setBundledOutput("back", wires[i])
  sleep(1)
  rs.setBundledOutput("back", 0)
  sleep(1)
  rs.setBundledOutput("front", colors.white)
  sleep(1)
  rs.setBundledOutput("front", 0)
end

function write_menu()
  term.setCursorPos(1,1)
  color_print(colors.black, colors.white, "Add Ingredients:")
  print_menu_item(scroll, "^")
  print_menu_item(scroll+1, " ")
  print_menu_item(scroll+2, " ")
  print_menu_item(scroll+3, "v")
  color_print(colors.black, colors.white, "Clear")
  print("")
end

function print_menu_item(i, arrow)
  -- Alternate bg color
  local bg = colors.white
  if i%2~=0 then
    bg = colors.lightGray
  end
  -- Draw back of line and scroll bar
  term.setBackgroundColor(bg)
  write("                ")
  term.setBackgroundColor(colors.gray)
  term.setTextColor(colors.white)
  write(arrow)
  -- Write text for menu item
  reset_cursor()
  term.setBackgroundColor(bg)
  term.setTextColor(colors.black)
  local current = 0
  for j=1,#order do if order[j] == i then current = current + 1 end end
  print(ingredients[i].." x"..(ingredient_limits[i]-current))
end
   
function write_order()
  color_print(colors.black, colors.white, "Your Order:")
  -- Write 8 lines
  for i=1,8 do
    -- Alternate bg color
    bg = colors.lightGray
    if i%2==0 then bg = colors.white end
    -- Write order item or blank line
    if order[i] then color_print(bg, colors.black, i..". "..ingredients[order[i]])
    else color_print(bg, colors.black, "")
    end
  end
end

function transmit_order()
  rednet.open("top")
  rednet.send(target_server, order)
  rednet.close("top")
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

function reset_cursor()
  local x,y = term.getCursorPos()
  term.setCursorPos(1,y)
end

function reset_color()
  term.setBackgroundColor(colors.brown)
  term.setTextColor(colors.black)
end

while true do
  reset_color()
  term.clear()
  write_menu()
  write_order()
  term.setCursorPos(1,17)
  print("")
  color_print(colors.black, colors.white, "   Start Brew   ")
  local event, side, x, y = os.pullEvent("monitor_touch")
  if x<16 and buttons[y] then buttons[y]() 
  elseif side_buttons[y] then side_buttons[y]()
  end
end
