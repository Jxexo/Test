local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UIS = game:GetService("UserInputService")

-- Variables for UI size and position
local isOpen = true
local selectedPlayer = nil

-- Create the GUI
local ScreenGui = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local PlayerList = Instance.new("TextLabel")
local MessageBox = Instance.new("TextBox")
local SendButton = Instance.new("TextButton")
local ToggleButton = Instance.new("TextButton")

ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
Frame.Parent = ScreenGui
Frame.Size = UDim2.new(0, 300, 0, 300)
Frame.Position = UDim2.new(0.5, -150, 0.5, -150)
Frame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Frame.Active = true
Frame.Draggable = true -- Make the UI draggable

PlayerList.Parent = Frame
PlayerList.Size = UDim2.new(1, 0, 0, 100)
PlayerList.Position = UDim2.new(0, 0, 0, 0)
PlayerList.Text = "Select a player to imitate:"
PlayerList.TextScaled = true

MessageBox.Parent = Frame
MessageBox.Size = UDim2.new(1, 0, 0, 50)
MessageBox.Position = UDim2.new(0, 0, 0.4, 0)
MessageBox.PlaceholderText = "Type your message here"

SendButton.Parent = Frame
SendButton.Size = UDim2.new(1, 0, 0, 50)
SendButton.Position = UDim2.new(0, 0, 0.7, 0)
SendButton.Text = "Send Message"
SendButton.TextScaled = true

-- Toggle Button for opening and closing the UI
ToggleButton.Parent = ScreenGui
ToggleButton.Size = UDim2.new(0, 100, 0, 30)
ToggleButton.Position = UDim2.new(0, 10, 0, 10)
ToggleButton.Text = "Close UI"
ToggleButton.TextScaled = true
ToggleButton.BackgroundColor3 = Color3.fromRGB(0, 200, 0)

-- Function to toggle the UI
local function toggleUI()
    isOpen = not isOpen
    if isOpen then
        Frame.Visible = true
        ToggleButton.Text = "Close UI"
    else
        Frame.Visible = false
        ToggleButton.Text = "Open UI"
    end
end

ToggleButton.MouseButton1Click:Connect(toggleUI)

-- Function to simulate a chat message
local function fakeChatMessage(targetPlayerName, message)
    local chatMessage = string.format("%s: %s", targetPlayerName, message)
    game.ReplicatedStorage.DefaultChatSystemChat:FindFirstChild("Chat")
        :Chat(LocalPlayer.Character.Head, chatMessage)
end

-- Send message when button is clicked
SendButton.MouseButton1Click:Connect(function()
    local message = MessageBox.Text
    if selectedPlayer and message and message ~= "" then
        fakeChatMessage(selectedPlayer, message)
    else
        print("No player selected or message is empty!")
    end
end)

-- Update player list with clickable buttons
local function updatePlayerList()
    -- Clear existing list
    for _, child in pairs(PlayerList:GetChildren()) do
        if child:IsA("TextButton") then
            child:Destroy()
        end
    end

    -- Add player buttons
    for i, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            local PlayerButton = Instance.new("TextButton")
            PlayerButton.Parent = PlayerList
            PlayerButton.Size = UDim2.new(1, 0, 0, 25)
            PlayerButton.Position = UDim2.new(0, 0, 0, 25 * i)
            PlayerButton.Text = player.Name
            PlayerButton.TextScaled = true
            PlayerButton.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
            
            -- When a player is selected, highlight the selected player
            PlayerButton.MouseButton1Click:Connect(function()
                selectedPlayer = player.Name
                for _, sibling in ipairs(PlayerList:GetChildren()) do
                    if sibling:IsA("TextButton") then
                        sibling.BackgroundColor3 = Color3.fromRGB(200, 200, 200) -- Reset all other buttons
                    end
                end
                PlayerButton.BackgroundColor3 = Color3.fromRGB(150, 150, 150) -- Highlight the selected button
                print("Selected player: " .. selectedPlayer)
            end)
        end
    end
end

-- Connect player added and removed events
Players.PlayerAdded:Connect(updatePlayerList)
Players.PlayerRemoving:Connect(updatePlayerList)

-- Update player list initially
updatePlayerList()
