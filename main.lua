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
local intialLetter = 0
local cells = {}

-- Initialising the parameters for the undo key
undokeyPressed = 0
undokeyReleased = 0
undokeyisDown = 0

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

-- Function to detect the input of the player
local function playerInput()
    local input = '#'
    for _,key in ipairs(csvData) do
        local aV = string.byte(key[1])
        if love.keyboard.isDown(string.char(aV + 32)) == true then
            input = key[1]
        end
    end
    return input
end

-- Function to check if the block already has a cell present
local function occupiedBlock(playerCursorX, playerCursorY)
    blockOccupied = 0
    for _, value in ipairs(cells) do
        if value[2] == playerCursorX and value[3] == playerCursorY then
            blockOccupied = 1
        end
    end
    return blockOccupied
end

-- Function to check if the position of the input is near a existing cell
local function nearCell(playerCursorX, playerCursorY)
    local nearCellExist = 0
    for _, cell in ipairs(cells) do
        if playerCursorX == cell[2] then
            if (playerCursorY-1) == cell[3] or (playerCursorY+1) == cell[3] then
                nearCellExist = 1
                break
            end
        elseif playerCursorY == cell[3] then
            if (playerCursorX-1) == cell[2] or (playerCursorX+1) == cell[2] then
                nearCellExist = 1
                break
            end
        end
    end
    return nearCellExist
end

-- Functtion to display the input on the screen
local function displayInput(input)
    
    -- Setting the font and color
    love.graphics.setColor(White)
    love.graphics.setFont(Play_buttonFont)

    -- Initialising the position of the player cell
    local playerCursorX = (-offset_x + 350) / 100
    local playerCursorY = ((offset_y - 400) / 100)

    -- Displaying the initial elements of the word lETTER and LOGIC
    if intialLetter == 0 then
        table.insert(cells, {'L', -2, 2})
        table.insert(cells, {'E', -2, 1})
        table.insert(cells, {'T', -2, 0})
        table.insert(cells, {'T', -2, -1})
        table.insert(cells, {'E', -2, -2})
        table.insert(cells, {'R', -2, -3})
        table.insert(cells, {'O', -1, 2})
        table.insert(cells, {'G', 0, 2})
        table.insert(cells, {'I', 1, 2})
        table.insert(cells, {'C', 2, 2})
        intialLetter = 1
    end
    
    -- Adding the new input to the cells
    if input == '#' then
        -- If the player is not pressing any key
    elseif occupiedBlock(playerCursorX, playerCursorY) == 1 then
        -- If the player is trying to input on an already occupied block
    elseif nearCell(playerCursorX, playerCursorY) == 0 then
        -- If the player cursor is not near any cell 
    else
        table.insert(cells, {input, playerCursorX, playerCursorY})
    end
end

local function undoPreviousInput()

    -- Displaying the text for Undo button
    love.graphics.setColor(Yellow)
    love.graphics.setFont(Undo_font)
    love.graphics.print("Press TAB to undo", 240, 15)

    -- When the tab key is down
    if love.keyboard.isDown("tab") == true then
        undokeyisDown = 1
    else
        undokeyisDown = 0
    end
    -- To check if the key is pressed
    if undokeyisDown == 1 and undokeyPressed == 0 then
        undokeyPressed = 1
    end
    -- To check if the key is released
    if undokeyisDown == 0 and undokeyPressed == 1 then
        undokeyReleased = 1
    end
    -- To execute the code when the tab key is released
    if undokeyReleased == 1 then
        if cells[#cells][2] == 2 and cells[#cells][3] == 2 then
            -- When the player has no input on the screen
        else
            table.remove(cells)
        undokeyPressed = 0
        undokeyReleased = 0
        end
    end
end

-- Gameloop is the function where the functions related to gameplay exist
local function gameLoop()

    -- Setting the font of the cells
    love.graphics.setFont(Play_buttonFont)
    love.graphics.setColor(White)
    
    -- Implementing the code for grid spawning with letters
    for _, cell in ipairs(cells) do
        local letter = cell[1]
        local x = cell[2]
        local y = cell[3]
        love.graphics.rectangle("line", x * 100 + offset_x, -y * 100 + offset_y, 100, 100)
        love.graphics.print(letter, (x * 100) + offset_x + 32.5, (-y * 100) + offset_y + 12.5)
    end

    -- Drawing a rectangle to display the player cursor
    love.graphics.setColor(White)
    love.graphics.rectangle("line", 350, 400, 100, 100)
    love.graphics.rectangle("line", 350, 400, 100, 100)
    love.graphics.setColor(Blue)
    love.graphics.rectangle("line", 352, 402, 96, 96)
    love.graphics.rectangle("line", 350, 400, 100, 100)
    love.graphics.rectangle("line", 348, 398 , 104, 104)

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

    -- Calling functin to get the player input
    local input = playerInput()

    -- Calling the function to display the player input on the screen
    displayInput(input)

    -- Calling the undo function if player wants to undo previous output
    undoPreviousInput()
end

function love.load()
    love.window.setTitle("Letter Logic")
    love.graphics.setBackgroundColor(0.1, 0.1, 0.1)
    ScreenWidth, ScreenHeight = love.graphics.getDimensions()

    loadCSV("letters.csv")

    TitleFont = love.graphics.newFont("assets/fonts/custom.ttf", 100)
    Play_buttonFont = love.graphics.newFont("assets/fonts/custom.ttf", 50)
    Small_quitFont = love.graphics.newFont("assets/fonts/custom.ttf", 17)
    Undo_font = love.graphics.newFont("assets/fonts/custom.ttf", 30)

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
    Yellow = {0.8, 0.8, 0}

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

    -- Set the background color to light_black
    love.graphics.setColor(Light_black)
end