-- Chat GUI for NPC Commands
-- This creates a simple GUI to execute NPC commands and debug chat functionality

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local TextService = game:GetService("TextService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local mouse = player:GetMouse()

-- Get core GUI
local core
if game:FindFirstChildOfClass("CoreGui") then
    if gethui then
        core = gethui()
    else
        core = game:GetService("CoreGui")
    end
else
    core = Players.LocalPlayer:WaitForChild("PlayerGui")
end

-- Create main GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "NPCChatGUI"
screenGui.Parent = core
screenGui.ResetOnSpawn = false

-- Main Frame
local mainFrame = Instance.new("Frame")
mainFrame.Name = "ChatFrame"
mainFrame.Parent = screenGui
mainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
mainFrame.Size = UDim2.new(0, 350, 0, 450)
mainFrame.Position = UDim2.new(0, 20, 0.5, -225)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 10)
corner.Parent = mainFrame

-- Header
local header = Instance.new("Frame")
header.Name = "Header"
header.Parent = mainFrame
header.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
header.Size = UDim2.new(1, 0, 0, 30)
header.BorderSizePixel = 0

local headerCorner = Instance.new("UICorner")
headerCorner.CornerRadius = UDim.new(0, 10)
headerCorner.Parent = header

local headerTitle = Instance.new("TextLabel")
headerTitle.Parent = header
headerTitle.BackgroundTransparency = 1
headerTitle.Size = UDim2.new(1, -60, 1, 0)
headerTitle.Position = UDim2.new(0, 10, 0, 0)
headerTitle.Text = "NPC Chat Commands"
headerTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
headerTitle.TextSize = 14
headerTitle.TextXAlignment = Enum.TextXAlignment.Left
headerTitle.Font = Enum.Font.SourceSansBold

-- Close Button
local closeButton = Instance.new("TextButton")
closeButton.Parent = header
closeButton.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
closeButton.Size = UDim2.new(0, 20, 0, 20)
closeButton.Position = UDim2.new(1, -25, 0, 5)
closeButton.Text = "X"
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.TextSize = 12
closeButton.Font = Enum.Font.SourceSansBold
closeButton.BorderSizePixel = 0

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 3)
closeCorner.Parent = closeButton

-- Commands ScrollingFrame
local commandsFrame = Instance.new("ScrollingFrame")
commandsFrame.Name = "CommandsFrame"
commandsFrame.Parent = mainFrame
commandsFrame.BackgroundTransparency = 1
commandsFrame.Size = UDim2.new(1, -20, 1, -140)
commandsFrame.Position = UDim2.new(0, 10, 0, 40)
commandsFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
commandsFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
commandsFrame.ScrollBarThickness = 6
commandsFrame.ScrollBarImageColor3 = Color3.fromRGB(80, 80, 80)

local listLayout = Instance.new("UIListLayout")
listLayout.Parent = commandsFrame
listLayout.Padding = UDim.new(0, 5)
listLayout.SortOrder = Enum.SortOrder.LayoutOrder

-- Command Input Section
local inputFrame = Instance.new("Frame")
inputFrame.Name = "InputFrame"
inputFrame.Parent = mainFrame
inputFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
inputFrame.Size = UDim2.new(1, -20, 0, 80)
inputFrame.Position = UDim2.new(0, 10, 1, -90)
inputFrame.BorderSizePixel = 0

local inputCorner = Instance.new("UICorner")
inputCorner.CornerRadius = UDim.new(0, 8)
inputCorner.Parent = inputFrame

local inputLabel = Instance.new("TextLabel")
inputLabel.Parent = inputFrame
inputLabel.BackgroundTransparency = 1
inputLabel.Size = UDim2.new(1, 0, 0, 20)
inputLabel.Position = UDim2.new(0, 10, 0, 5)
inputLabel.Text = "Enter Command:"
inputLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
inputLabel.TextSize = 12
inputLabel.TextXAlignment = Enum.TextXAlignment.Left
inputLabel.Font = Enum.Font.SourceSans

local textBox = Instance.new("TextBox")
textBox.Parent = inputFrame
textBox.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
textBox.Size = UDim2.new(1, -80, 0, 25)
textBox.Position = UDim2.new(0, 10, 0, 25)
textBox.Text = ""
textBox.PlaceholderText = "e.g., :kill npc"
textBox.TextColor3 = Color3.fromRGB(255, 255, 255)
textBox.TextSize = 12
textBox.Font = Enum.Font.SourceSans
textBox.ClearTextOnFocus = false
textBox.BorderSizePixel = 0

local textBoxCorner = Instance.new("UICorner")
textBoxCorner.CornerRadius = UDim.new(0, 5)
textBoxCorner.Parent = textBox

local sendButton = Instance.new("TextButton")
sendButton.Parent = inputFrame
sendButton.BackgroundColor3 = Color3.fromRGB(80, 150, 255)
sendButton.Size = UDim2.new(0, 60, 0, 25)
sendButton.Position = UDim2.new(1, -70, 0, 25)
sendButton.Text = "Send"
sendButton.TextColor3 = Color3.fromRGB(255, 255, 255)
sendButton.TextSize = 12
sendButton.Font = Enum.Font.SourceSansBold
sendButton.BorderSizePixel = 0

local sendCorner = Instance.new("UICorner")
sendCorner.CornerRadius = UDim.new(0, 5)
sendCorner.Parent = sendButton

-- Status Label
local statusLabel = Instance.new("TextLabel")
statusLabel.Parent = inputFrame
statusLabel.BackgroundTransparency = 1
statusLabel.Size = UDim2.new(1, -20, 0, 20)
statusLabel.Position = UDim2.new(0, 10, 0, 55)
statusLabel.Text = "Ready"
statusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
statusLabel.TextSize = 10
statusLabel.TextXAlignment = Enum.TextXAlignment.Left
statusLabel.Font = Enum.Font.SourceSans

-- Available Commands
local commands = {
    {cmd = ":kill npc", desc = "Kill selected NPC"},
    {cmd = ":bring npc", desc = "Bring NPC to you"},
    {cmd = ":goto npc", desc = "Go to NPC"},
    {cmd = ":sit npc", desc = "Make NPC sit/stand"},
    {cmd = ":jump npc", desc = "Make NPC jump"},
    {cmd = ":punish npc", desc = "Send NPC to space/bring back"},
    {cmd = ":freeze npc", desc = "Freeze/unfreeze NPC"},
    {cmd = ":commands", desc = "Show all commands"}
}

-- Create command buttons
for i, commandData in ipairs(commands) do
    local commandButton = Instance.new("TextButton")
    commandButton.Parent = commandsFrame
    commandButton.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
    commandButton.Size = UDim2.new(1, 0, 0, 40)
    commandButton.BorderSizePixel = 0
    commandButton.LayoutOrder = i
    
    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0, 6)
    buttonCorner.Parent = commandButton
    
    local commandText = Instance.new("TextLabel")
    commandText.Parent = commandButton
    commandText.BackgroundTransparency = 1
    commandText.Size = UDim2.new(1, -10, 0.6, 0)
    commandText.Position = UDim2.new(0, 5, 0, 0)
    commandText.Text = commandData.cmd
    commandText.TextColor3 = Color3.fromRGB(100, 200, 255)
    commandText.TextSize = 12
    commandText.TextXAlignment = Enum.TextXAlignment.Left
    commandText.Font = Enum.Font.SourceSansBold
    
    local descText = Instance.new("TextLabel")
    descText.Parent = commandButton
    descText.BackgroundTransparency = 1
    descText.Size = UDim2.new(1, -10, 0.4, 0)
    descText.Position = UDim2.new(0, 5, 0.6, 0)
    descText.Text = commandData.desc
    descText.TextColor3 = Color3.fromRGB(180, 180, 180)
    descText.TextSize = 10
    descText.TextXAlignment = Enum.TextXAlignment.Left
    descText.Font = Enum.Font.SourceSans
    
    -- Button click
    commandButton.MouseButton1Click:Connect(function()
        textBox.Text = commandData.cmd
        executeCommand(commandData.cmd)
    end)
    
    -- Hover effect
    commandButton.MouseEnter:Connect(function()
        TweenService:Create(commandButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(70, 70, 70)}):Play()
    end)
    
    commandButton.MouseLeave:Connect(function()
        TweenService:Create(commandButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(55, 55, 55)}):Play()
    end)
end

-- Functions
function updateStatus(text, color)
    statusLabel.Text = text
    statusLabel.TextColor3 = color or Color3.fromRGB(100, 255, 100)
end

function executeCommand(command)
    updateStatus("Executing: " .. command, Color3.fromRGB(255, 255, 100))

    -- Safely try to call a global chat handler
    if _G.onChatted then
        _G.onChatted(command)
    elseif typeof(onChatted) == "function" then
        onChatted(command)
    end

    -- Show feedback
    task.wait(0.5)
    updateStatus("Command sent!", Color3.fromRGB(100, 255, 100))

    task.wait(2)
    updateStatus("Ready", Color3.fromRGB(100, 255, 100))
end

-- Event connections
sendButton.MouseButton1Click:Connect(function()
    if textBox.Text ~= "" then
        executeCommand(textBox.Text)
        textBox.Text = ""
    end
end)

textBox.FocusLost:Connect(function(enterPressed)
    if enterPressed and textBox.Text ~= "" then
        executeCommand(textBox.Text)
        textBox.Text = ""
    end
end)

closeButton.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)

-- Toggle GUI with key (F9)
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.F9 then
        mainFrame.Visible = not mainFrame.Visible
    end
end)

-- Add some debugging
print("Chat GUI loaded! Press F9 to toggle, or click commands to execute them.")
print("If commands don't work, there might be an issue with the main NPC script.")

-- Try to expose the execute function globally for debugging
_G.ExecuteNPCCommand = executeCommand

return screenGui
