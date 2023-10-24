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

function loadCSV(filename)
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


local function isPlaybuttonInteract()
    Playbutton_active = false
    Playbutton_released = false
    if mouseX > 340 and mouseX < 460 then
        if mouseY > 380 and mouseY < 418 then
            Playbutton_active = true
        else
            Playbutton_active = false
        end
    end
    return {Playbutton_active}
end

local function quitButtonInteract()
    Quitbutton_active = false
    Quitbutton_released = false
    if mouseX > 0 and mouseX < 100 then
        if mouseY > 0 and mouseY < 100 then
            Quitbutton_active = true
        else
            Quitbutton_active = false
        end
    end
    return {Quitbutton_active}
end

local function gameLoop()
    love.graphics.setFont(play_buttonFont)
    love.graphics.setColor(White)
    

    -- Make a quit button to return to the main menu
    if quitButtonInteract()[1] == false then
        love.graphics.setColor(Red)
    else
        love.graphics.setColor(Pale_Red)
    end
    love.graphics.print("Quit", ScreenWidth * 0.01, ScreenHeight * 0)

    -- Function to return to main menu
    if love.keyboard.isDown("space") then
        GameRunning = false
    end

    -- Draw the cells in the 2d space

end

function love.load()
    love.window.setTitle("Letter Logic")
    love.graphics.setBackgroundColor(0.1, 0.1, 0.1)
    ScreenWidth, ScreenHeight = love.graphics.getDimensions()

    loadCSV("letters.csv")

    titleFont = love.graphics.newFont("assets/fonts/custom.ttf", 100)
    play_buttonFont = love.graphics.newFont("assets/fonts/custom.ttf", 50)

    TitleOne = "Letter"
    TitleTwo = "Logic"
    Play_button = "Press space to Start"

    TitleWidthOne = titleFont:getWidth(TitleOne)
    TitleWidthTwo = titleFont:getWidth(TitleTwo)
    TitleWidth_Play = play_buttonFont:getWidth(Play_button)

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
    mouseX, mouseY = love.mouse.getPosition()

end

function love.draw()
    if GameRunning == false then
        -- Set the font to title font
        love.graphics.setFont(titleFont)

        -- Display the Title "Letter"
        love.graphics.setColor(Blue)
        love.graphics.print(TitleTwo, TitleX_logic, ScreenHeight * 0.225)

        -- Display the Title "Logic"
        love.graphics.setColor(Red)
        love.graphics.print(TitleOne, TitleX_letter, ScreenHeight * 0.15)

        -- Set the Playbutton font
        love.graphics.setFont(play_buttonFont)

        -- Display the Play_button
        if isPlaybuttonInteract()[1] == false then
            love.graphics.setColor(Green)
        elseif isPlaybuttonInteract()[1] == true then
            love.graphics.setColor(Pale_Green)
        end
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