local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Create the GUI
local ScreenGui = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local PlayerList = Instance.new("TextLabel")
local MessageBox = Instance.new("TextBox")
local SendButton = Instance.new("TextButton")

ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
Frame.Parent = ScreenGui
Frame.Size = UDim2.new(0, 300, 0, 200)
Frame.Position = UDim2.new(0.5, -150, 0.5, -100)
Frame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)

PlayerList.Parent = Frame
PlayerList.Size = UDim2.new(1, 0, 0, 50)
PlayerList.Text = "Select a player to imitate:"
PlayerList.TextScaled = true

MessageBox.Parent = Frame
MessageBox.Size = UDim2.new(1, 0, 0, 50)
MessageBox.Position = UDim2.new(0, 0, 0.25, 0)
MessageBox.PlaceholderText = "Type your message here"

SendButton.Parent = Frame
SendButton.Size = UDim2.new(1, 0, 0, 50)
SendButton.Position = UDim2.new(0, 0, 0.5, 0)
SendButton.Text = "Send Message"
SendButton.TextScaled = true

-- Function to send a fake message
local function fakeChatMessage(targetPlayerName, message)
    -- Simulate sending a message
    local chatMessage = string.format("%s: %s", targetPlayerName, message)
    game.ReplicatedStorage.DefaultChatSystemChat:FindFirstChild("Chat") -- Access the chat system
        :Chat(LocalPlayer.Character.Head, chatMessage) -- Simulate the chat message
end

-- Send message when button is clicked
SendButton.MouseButton1Click:Connect(function()
    local selectedPlayer = PlayerList.Text
    local message = MessageBox.Text
    if selectedPlayer and selectedPlayer ~= "" and message and message ~= "" then
        fakeChatMessage(selectedPlayer, message)
    else
        print("No player selected or message is empty!")
    end
end)

-- Update player list in the GUI
local function updatePlayerList()
    local playerNames = {}
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            table.insert(playerNames, player.Name)
        end
    end
    PlayerList.Text = "Select a player to imitate:\n" .. table.concat(playerNames, "\n") or "No players available"
end

-- Connect player added and removed events
Players.PlayerAdded:Connect(updatePlayerList)
Players.PlayerRemoving:Connect(updatePlayerList)

-- Update player list initially
updatePlayerList()
