local grid = {}
local nextGrid = {}
local elaspedTime = 0
local hue = 0
local elaspedTime = 0
local color_cycle_speed = 0.03

function make2dArray(rows, cols)
    local arr = {}
    local y, x
    for y = 1, rows do
        arr[y] = {}
        for x = 1, cols do
            arr[y][x] = 0
        end
    end
    return arr
end

function HSV(h, s, v)
    if s <= 0 then return v,v,v end
    h = h*6
    local c = v*s
    local x = (1-math.abs((h%2)-1))*c
    local m,r,g,b = (v-c), 0, 0, 0
    if h < 1 then
        r, g, b = c, x, 0
    elseif h < 2 then
        r, g, b = x, c, 0
    elseif h < 3 then
        r, g, b = 0, c, x
    elseif h < 4 then
        r, g, b = 0, x, c
    elseif h < 5 then
        r, g, b = x, 0, c
    else
        r, g, b = c, 0, x
    end
    return r+m, g+m, b+m
end

function love.mousepressed(x, y, button)
    if button == 1 then -- "Versions prior to 0.10.0 use the MouseConstant 'l'"
        xf = math.floor(y/w)
        yf = math.floor(x/w)
        if xf > 0 and xf <= cols and yf > 0 and yf <= rows then
            if (love.math.random() < 0.75) then
                grid[yf][xf] = hue
            end
        end
    end
 end
    
function love.load()
    height = love.graphics.getHeight()
    width = love.graphics.getWidth()
    w = 3
    rows = height / w - 1
    cols = width / w - 1
    grid = make2dArray(rows, cols)
    nextGrid = make2dArray(rows, cols)
end

function updateState()
    local nextGrid = make2dArray(rows, cols)
    local y, x
    for y = 1, #grid do
        for x = 1, #grid[y] do
            state = grid[y][x]
            if state ~= 0 then
                local random_lr = love.math.random() < 0.5
                if y < rows and grid[y+1][x] == 0 then
                    nextGrid[y+1][x] = grid[y][x]
                elseif y < rows and x > 1 and grid[y+1][x-1] == 0 and random_lr then
                    nextGrid[y+1][x-1] = grid[y][x]
                elseif y < rows and x < cols and grid[y+1][x+1] == 0 and not random_lr then
                    nextGrid[y+1][x+1] = grid[y][x]
                else
                    nextGrid[y][x] = grid[y][x]
                end
            end
        end
    end

    for y = 1, #nextGrid do
        for x = 1, #nextGrid[y] do
            grid[y][x] = nextGrid[y][x]
        end
    end
end


function love.update(dt)
    if love.mouse.isDown(1) then
        for i = -2,2 do
            xf = math.floor(love.mouse.getX() / w) + i
            yf = math.floor(love.mouse.getY() / w) + i
            if xf > 0 and xf <= cols and yf > 0 and yf <= rows then
                grid[yf][xf] = hue
            end
        end
    end
    updateState()
    if love.mouse.isDown(1) then
        elaspedTime = elaspedTime + dt
        if elaspedTime > 0.5 then
            hue = hue + color_cycle_speed
            if hue > 1 then
                hue = 0
            end
            elaspedTime = 0
        end
    end
end



function love.draw() 
    love.graphics.setBackgroundColor(0, 0, 0, 1)
    for y = 1, #grid do
        for x = 1, #grid[y] do
            if grid[y][x] ~= 0 then
                love.graphics.setColor(HSV(grid[y][x], 1, 1))
                love.graphics.rectangle("fill",x * w, y * w, w, w)
            end
        end
    end    
end