local csvData = {}
local cells = {{'L', -2, 2},
{'E', -2, 1},
{'T', -2, 0},
{'T', -2, -1},
{'E', -2, -2},
{'R', -2, -3},
{'O', -1, 2},
{'G', 0, 2},
{'I', 1, 2},
{'C', 2, 2}}

local function loadCSV(filename)
    if love.filesystem.getInfo(filename) then
        local contents, size = love.filesystem.read(filename)
        for line in contents:gmatch("[^\r\n]+") do
            local row = {}
            for value in line:gmatch("[^,]+") do
                table.insert(row, value)
            end
            table.insert(csvData, row)
        end
    else
        error("File not found: " .. filename)
    end
end

local function gameLoop()
    love.graphics.setFont(Play_buttonFont)
    love.graphics.setColor(White)
    
    -- Make a quit button to return to the main menu
    love.graphics.setColor(Red)
    love.graphics.print("Quit", ScreenWidth * 0.01, ScreenHeight * 0)
    
    love.graphics.setFont(Small_quitFont)
    love.graphics.print("(Press Shift)", ScreenWidth * 0.01, ScreenHeight * 0.1)

    -- Function to return to main menu
    if love.keyboard.isDown("lshift") or love.keyboard.isDown("rshift") then
        GameRunning = false
    end

    -- Draw the cells in the 2d space

end

function love.load()
    love.window.setTitle("Letter Logic")
    love.graphics.setBackgroundColor(0.1, 0.1, 0.1)
    ScreenWidth, ScreenHeight = love.graphics.getDimensions()

    loadCSV("letters.csv")

    TitleFont = love.graphics.newFont("assets/fonts/custom.ttf", 100)
    Play_buttonFont = love.graphics.newFont("assets/fonts/custom.ttf", 50)
    Small_quitFont = love.graphics.newFont("assets/fonts/custom.ttf", 17)

    TitleOne = "Letter"
    TitleTwo = "Logic"
    Play_button = "Press space to Start"

    TitleWidthOne = TitleFont:getWidth(TitleOne)
    TitleWidthTwo = TitleFont:getWidth(TitleTwo)
    TitleWidth_Play = Play_buttonFont:getWidth(Play_button)

    TitleX_letter = (ScreenWidth - TitleWidthOne) / 2
    TitleX_logic = (ScreenWidth - TitleWidthTwo) / 2
    TitleX_Play  = (ScreenWidth - TitleWidth_Play) / 2

    Green = {0, 1, 0}
    Red = {1, 0, 0}
    Blue = {0, 0, 1}
    Pale_Green = {0, 0.6, 0}
    Pale_Red = {0.6, 0, 0}
    Light_black = {0.1, 0.1, 0.1}
    White = {0.8, 0.8, 0.8}

    GameRunning = false

end

function love.update()
    Playbutton_active = false
    Quitbutton_active = false
    MouseX, MouseY = love.mouse.getPosition()

end

function love.draw()
    if GameRunning == false then
        -- Set the font to title font
        love.graphics.setFont(TitleFont)

        -- Display the Title "Letter"
        love.graphics.setColor(Blue)
        love.graphics.print(TitleTwo, TitleX_logic, ScreenHeight * 0.225)

        -- Display the Title "Logic"
        love.graphics.setColor(Red)
        love.graphics.print(TitleOne, TitleX_letter, ScreenHeight * 0.15)

        -- Set the Playbutton font
        love.graphics.setFont(Play_buttonFont)

        -- Display the Play_button
        love.graphics.setColor(Green)
        love.graphics.print(Play_button, TitleX_Play, ScreenHeight * 0.60)
        
        if love.keyboard.isDown("space") then
            GameRunning = true
        end

    elseif GameRunning == true then
        gameLoop()
    end

    -- Set else to light_black
    love.graphics.setColor(Light_black)

end