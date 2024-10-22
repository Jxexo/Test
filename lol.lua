local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- Create UI
local ScreenGui = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local ToggleButton = Instance.new("TextButton")
local aimbotActive = false

ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
Frame.Parent = ScreenGui
Frame.Size = UDim2.new(0, 200, 0, 100)
Frame.Position = UDim2.new(0.5, -100, 0.5, -50)
Frame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Frame.Active = true
Frame.Draggable = true -- Make the UI draggable

ToggleButton.Parent = Frame
ToggleButton.Size = UDim2.new(1, 0, 1, 0)
ToggleButton.Text = "Toggle Aimbot"
ToggleButton.BackgroundColor3 = Color3.fromRGB(0, 200, 0)

-- Function to find the closest player
local function getClosestPlayer()
    local closestPlayer = nil
    local closestDistance = math.huge

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Head") then
            local distance = (LocalPlayer.Character.HumanoidRootPart.Position - player.Character.Head.Position).magnitude
            if distance < closestDistance then
                closestDistance = distance
                closestPlayer = player
            end
        end
    end

    return closestPlayer
end

-- Function to aim at the closest player's head
local function aimAtPlayer()
    while aimbotActive do
        local closestPlayer = getClosestPlayer()
        if closestPlayer and closestPlayer.Character and closestPlayer.Character:FindFirstChild("Head") then
            local headPos = closestPlayer.Character.Head.Position
            local camera = workspace.CurrentCamera
            local direction = (headPos - camera.CFrame.Position).unit
            camera.CFrame = CFrame.new(camera.CFrame.Position, camera.CFrame.Position + direction)
        end
        RunService.RenderStepped:Wait() -- Wait until the next frame
    end
end

-- Toggle aimbot on button click
ToggleButton.MouseButton1Click:Connect(function()
    aimbotActive = not aimbotActive
    if aimbotActive then
        ToggleButton.Text = "Aimbot On"
        aimAtPlayer() -- Start aiming
    else
        ToggleButton.Text = "Toggle Aimbot"
    end
end)

-- Clean up when the UI is closed
ScreenGui.AncestryChanged:Connect(function(_, parent)
    if not parent then
        aimbotActive = false
    end
end)
