-- Setting the offset of the player from the screen
local offset_x, offset_y
local csvData = {}

-- Intilialising the parameters for the movement keys
-- Parameters for the W key
upPressed = 0
upReleased = 0
upkeyisDown = 0

-- Parameters for the A key
leftPressed = 0
leftReleased = 0
leftkeyisDown = 0

-- Parameters for the S key
downPressed = 0
downReleased = 0
downkeyisDown = 0

-- Parameters for the D key
rightPressed = 0
rightReleased = 0
rightkeyisDown = 0

-- Intial cells
local cells = {{'L', -2, -3},
{'E', -2, -2},
{'T', -2, -1},
{'T', -2, 0},
{'E', -2, 1},
{'R', -2, 2},
{'O', -1, -3},
{'G', 0, -3},
{'I', 1, -3},
{'C', 2, -3}}

-- Loading the CSV data from the letters.csv file
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

-- Function for the precise movement of the player on the screen
local function movementKeys()

    -- When 'UP' key is down
    if love.keyboard.isDown("up") == true then
        upkeyisDown = 1
    else
        upkeyisDown = 0
    end
    -- To check if key is pressed
    if upkeyisDown == 1 and upPressed == 0 then
        upPressed = 1
    end
    -- To check if the pressed key is released
    if upkeyisDown == 0 and upPressed == 1 then
        upReleased = 1
    end
    -- To execute the code when key is released
    if upReleased == 1 then
        offset_y = offset_y + 100
        upReleased = 0
        upPressed = 0
    end

    -- When 'LEFT' key is down
    if love.keyboard.isDown("left") == true then
        leftkeyisDown = 1
    else
        leftkeyisDown = 0
    end
    -- To check if the key is pressed
    if leftkeyisDown == 1 and leftPressed == 0 then
        leftPressed = 1
    end
    -- To check if the key is released
    if leftkeyisDown == 0 and leftPressed == 1 then
        leftReleased = 1
    end
    -- To execute the code when key is released
    if leftReleased == 1 then
        offset_x = offset_x + 100
        leftReleased = 0
        leftPressed = 0
    end

    -- When 'DOWN' is down
    if love.keyboard.isDown("down") == true then
        downkeyisDown = 1
    else
        downkeyisDown = 0
    end
    -- To check if the key is pressed
    if downkeyisDown == 1 and downPressed == 0 then
        downPressed = 1
    end
    -- To check if the key is released
    if downkeyisDown == 0 and downPressed == 1 then
        downReleased = 1
    end
    -- To execute the code when the key is released
    if downReleased == 1 then
        offset_y = offset_y - 100
        downReleased = 0
        downPressed = 0
    end

    -- When the 'RIGHT' is down
    if love.keyboard.isDown("right") == true then   
        rightkeyisDown = 1
    else
        rightkeyisDown = 0
    end
    -- To check if the key is pressed
    if rightkeyisDown == 1 and rightPressed == 0 then
        rightPressed = 1
    end
    -- To check if the key is released
    if rightkeyisDown == 0 and rightPressed == 1 then
        rightReleased = 1
    end
    -- To execute the code when the key is released
    if rightReleased == 1 then
        offset_x = offset_x - 100
        rightReleased = 0
        rightPressed = 0
    end
end

-- Gameloop is the function where the functions related to gameplay exist
local function gameLoop()
    love.graphics.setFont(Play_buttonFont)
    love.graphics.setColor(White)
    
    -- Implementing the code for grid spawning with letters
    for _, cell in ipairs(cells) do
        local letter = cell[1]
        local x = cell[2]
        local y = cell[3]
        love.graphics.rectangle("line", x * 100 + offset_x, y * 100 + offset_y, 100, 100)
        love.graphics.print(letter, (x * 100) + offset_x + 32.5, (y * 100) + offset_y + 12.5)
    end

    -- Drawing a rectangle to display the player cursor
    love.graphics.setColor(White)
    love.graphics.rectangle("line", 350, 300, 100, 100)
    love.graphics.setColor(Blue)
    love.graphics.rectangle("line", 352, 302, 96, 96)
    love.graphics.rectangle("line", 350, 300, 100, 100)
    love.graphics.rectangle("line", 348, 298 , 104, 104)

    -- Make a quit button to return to the main menu
    love.graphics.setColor(Red)
    love.graphics.print("Back", ScreenWidth * 0.01, ScreenHeight * 0)
    
    love.graphics.setFont(Small_quitFont)
    love.graphics.print("(Press Shift)", ScreenWidth * 0.01, ScreenHeight * 0.1)

    -- Function to return to main menu
    if love.keyboard.isDown("lshift") or love.keyboard.isDown("rshift") then
        GameRunning = false
    end

    -- Calling function for the movement
    movementKeys()
    
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

    offset_x = 350
    offset_y = 400

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
        
        -- Running the gameloop when the play button is pressed
        if love.keyboard.isDown("space") then
            GameRunning = true
        end

    elseif GameRunning == true then
        gameLoop()
    end

    -- Set else to light_black
    love.graphics.setColor(Light_black)

end