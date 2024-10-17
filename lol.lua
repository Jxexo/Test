local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UIS = game:GetService("UserInputService")
local Camera = game.Workspace.CurrentCamera

-- Variables for UI size, position, and aimbot
local isOpen = true
local aimbotEnabled = false
local selectedPlayer = nil
local closestPlayer = nil

-- Create the GUI
local ScreenGui = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local ToggleAimbotButton = Instance.new("TextButton")
local ToggleButton = Instance.new("TextButton")
local AimbotStatusLabel = Instance.new("TextLabel")

ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
Frame.Parent = ScreenGui
Frame.Size = UDim2.new(0, 300, 0, 150)
Frame.Position = UDim2.new(0.5, -150, 0.5, -75)
Frame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Frame.Active = true
Frame.Draggable = true -- Make the UI draggable

-- Aimbot Toggle Button
ToggleAimbotButton.Parent = Frame
ToggleAimbotButton.Size = UDim2.new(1, 0, 0, 50)
ToggleAimbotButton.Position = UDim2.new(0, 0, 0.2, 0)
ToggleAimbotButton.Text = "Toggle Aimbot"
ToggleAimbotButton.TextScaled = true

-- Aimbot Status Label
AimbotStatusLabel.Parent = Frame
AimbotStatusLabel.Size = UDim2.new(1, 0, 0, 50)
AimbotStatusLabel.Position = UDim2.new(0, 0, 0.6, 0)
AimbotStatusLabel.Text = "Aimbot: OFF"
AimbotStatusLabel.TextScaled = true
AimbotStatusLabel.TextColor3 = Color3.fromRGB(255, 0, 0)

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

-- Aimbot functionality
local function getClosestPlayer()
    local closestDistance = math.huge
    local closestPlayer = nil
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Head") then
            local head = player.Character.Head
            local screenPoint, onScreen = Camera:WorldToViewportPoint(head.Position)
            if onScreen then
                local mousePos = UIS:GetMouseLocation()
                local distance = (Vector2.new(screenPoint.X, screenPoint.Y) - mousePos).Magnitude
                if distance < closestDistance then
                    closestDistance = distance
                    closestPlayer = player
                end
            end
        end
    end
    return closestPlayer
end

-- Toggle aimbot functionality
ToggleAimbotButton.MouseButton1Click:Connect(function()
    aimbotEnabled = not aimbotEnabled
    if aimbotEnabled then
        AimbotStatusLabel.Text = "Aimbot: ON"
        AimbotStatusLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
    else
        AimbotStatusLabel.Text = "Aimbot: OFF"
        AimbotStatusLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
    end
end)

-- Aimbot loop
game:GetService("RunService").RenderStepped:Connect(function()
    if aimbotEnabled then
        closestPlayer = getClosestPlayer()
        if closestPlayer and closestPlayer.Character and closestPlayer.Character:FindFirstChild("Head") then
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, closestPlayer.Character.Head.Position)
        end
    end
end)
