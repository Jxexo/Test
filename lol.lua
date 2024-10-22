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
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Head") then
            -- Create a highlight if it doesn't exist
            local highlight = player.Character:FindFirstChild("Highlight")
            if not highlight then
                highlight = Instance.new("Highlight")
                highlight.Parent = player.Character
                highlight.FillColor = Color3.fromRGB(1, 0, 0) -- Red color
                highlight.OutlineColor = Color3.fromRGB(1, 0, 0) -- Red outline color
                highlight.FillTransparency = 0.5 -- Optional: make it semi-transparent
            end

            -- Set visibility of the highlight based on the aimbot toggle
            highlight.Enabled = aimbotActive
        end
    end

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
            -- Check if the closest player is visible
            local targetHeadPosition = closestPlayer.Character.Head.Position
            local camera = Workspace.CurrentCamera
            local ray = Ray.new(camera.CFrame.Position, (targetHeadPosition - camera.CFrame.Position).unit * (targetHeadPosition - camera.CFrame.Position).magnitude)

            -- Check if the ray hits any part before reaching the target head
            local hit, hitPosition = Workspace:FindPartOnRay(ray, LocalPlayer.Character)

            if not hit then
                -- Adjust camera CFrame to aim at the target if not obstructed
                camera.CFrame = CFrame.new(camera.CFrame.Position, targetHeadPosition)
            end
        end
    end
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
