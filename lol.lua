local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

-- UI Variables
local isOpen = true
local aimbotActive = false

-- Create the GUI
local ScreenGui = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local CloseButton = Instance.new("TextButton")
local ToggleButton = Instance.new("TextButton")

ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
Frame.Parent = ScreenGui
Frame.Size = UDim2.new(0, 300, 0, 100)
Frame.Position = UDim2.new(0.5, -150, 0.5, -50)
Frame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Frame.Active = true
Frame.Draggable = true -- Make the UI draggable

CloseButton.Parent = Frame
CloseButton.Size = UDim2.new(0, 100, 0, 50)
CloseButton.Position = UDim2.new(0, 10, 0, 10)
CloseButton.Text = "Close UI"
CloseButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)

ToggleButton.Parent = Frame
ToggleButton.Size = UDim2.new(0, 100, 0, 50)
ToggleButton.Position = UDim2.new(0, 10, 0, 70)
ToggleButton.Text = "Toggle Aimbot"
ToggleButton.BackgroundColor3 = Color3.fromRGB(0, 255, 0)

-- Function to toggle the UI visibility
local function toggleUI()
    isOpen = not isOpen
    Frame.Visible = isOpen
end

CloseButton.MouseButton1Click:Connect(toggleUI)

-- Function to toggle the aimbot
ToggleButton.MouseButton1Click:Connect(function()
    aimbotActive = not aimbotActive
    ToggleButton.Text = aimbotActive and "Aimbot On" or "Aimbot Off"
end)

-- Aimbot logic
RunService.RenderStepped:Connect(function()
    if aimbotActive then
        local closestPlayer = nil
        local closestDistance = math.huge

        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Head") then
                local distance = (player.Character.Head.Position - LocalPlayer.Character.Head.Position).magnitude
                if distance < closestDistance then
                    closestDistance = distance
                    closestPlayer = player
                end
            end
        end

        if closestPlayer then
            -- Aim at the closest player's head
            local targetHeadPosition = closestPlayer.Character.Head.Position
            local camera = Workspace.CurrentCamera
            camera.CFrame = CFrame.new(camera.CFrame.Position, targetHeadPosition)
        end
    end
end)

-- Highlight players
for _, player in ipairs(Players:GetPlayers()) do
    if player ~= LocalPlayer and player.Character then
        local highlight = Instance.new("Highlight")
        highlight.Adornee = player.Character
        highlight.FillColor = Color3.fromRGB(255, 0, 0) -- Red color
        highlight.FillTransparency = 0.5
        highlight.OutlineColor = Color3.fromRGB(255, 0, 0)
        highlight.OutlineTransparency = 0
        highlight.Parent = player.Character
    end
end

-- Update highlights in real-time
Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function(character)
        local highlight = Instance.new("Highlight")
        highlight.Adornee = character
        highlight.FillColor = Color3.fromRGB(255, 0, 0) -- Red color
        highlight.FillTransparency = 0.5
        highlight.OutlineColor = Color3.fromRGB(255, 0, 0)
        highlight.OutlineTransparency = 0
        highlight.Parent = character
    end)
end)

-- Draggable UI Functionality
local function makeDraggable(frame)
    local dragging, dragInput, startPos, startPosMouse
    local function update(input)
        local delta = input.Position - startPosMouse
        frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end

    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            startPos = frame.Position
            startPosMouse = input.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    UIS.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            update(input)
        end
    end)
end

makeDraggable(Frame) -- Call the function to make the Frame draggable
