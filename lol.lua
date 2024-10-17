-- Services
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local Camera = game:GetService("Workspace").CurrentCamera

-- Variables
local aimbotEnabled = false
local closestPlayer = nil

-- Create the GUI
local ScreenGui = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local AimbotToggle = Instance.new("TextButton")
local StopAimbotButton = Instance.new("TextButton")
local CloseButton = Instance.new("TextButton")

ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
Frame.Parent = ScreenGui
Frame.Size = UDim2.new(0, 200, 0, 150)
Frame.Position = UDim2.new(0.5, -100, 0.5, -75)
Frame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Frame.Active = true
Frame.Draggable = true

AimbotToggle.Parent = Frame
AimbotToggle.Size = UDim2.new(1, 0, 0, 50)
AimbotToggle.Position = UDim2.new(0, 0, 0, 0)
AimbotToggle.Text = "Toggle Aimbot: OFF"
AimbotToggle.TextScaled = true
AimbotToggle.BackgroundColor3 = Color3.fromRGB(255, 100, 100)

StopAimbotButton.Parent = Frame
StopAimbotButton.Size = UDim2.new(1, 0, 0, 50)
StopAimbotButton.Position = UDim2.new(0, 0, 0.35, 0)
StopAimbotButton.Text = "Stop Aimbot"
StopAimbotButton.TextScaled = true
StopAimbotButton.BackgroundColor3 = Color3.fromRGB(100, 255, 100)

CloseButton.Parent = Frame
CloseButton.Size = UDim2.new(1, 0, 0, 50)
CloseButton.Position = UDim2.new(0, 0, 0.7, 0)
CloseButton.Text = "Close UI"
CloseButton.TextScaled = true
CloseButton.BackgroundColor3 = Color3.fromRGB(150, 150, 150)

-- Function to find the closest player to aim at
local function findClosestPlayer()
    local shortestDistance = math.huge
    closestPlayer = nil

    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Head") then
            local distance = (player.Character.Head.Position - LocalPlayer.Character.Head.Position).Magnitude
            if distance < shortestDistance then
                shortestDistance = distance
                closestPlayer = player
            end
        end
    end

    return closestPlayer
end

-- Function to enable the aimbot
local function enableAimbot()
    if not LocalPlayer.Character then return end
    LocalPlayer.CameraMode = Enum.CameraMode.LockFirstPerson -- Force first-person mode

    -- Run the aimbot loop
    RunService.RenderStepped:Connect(function()
        if aimbotEnabled and closestPlayer and closestPlayer.Character and closestPlayer.Character:FindFirstChild("Head") then
            local headPosition = closestPlayer.Character.Head.Position
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, headPosition) -- Aim at the player's head
        end
    end)
end

-- Toggle the aimbot when button is clicked
AimbotToggle.MouseButton1Click:Connect(function()
    aimbotEnabled = not aimbotEnabled
    if aimbotEnabled then
        AimbotToggle.Text = "Toggle Aimbot: ON"
        AimbotToggle.BackgroundColor3 = Color3.fromRGB(100, 255, 100)
        findClosestPlayer() -- Find the closest player
        enableAimbot() -- Start aimbot
    else
        AimbotToggle.Text = "Toggle Aimbot: OFF"
        AimbotToggle.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
        LocalPlayer.CameraMode = Enum.CameraMode.Classic -- Reset camera mode
    end
end)

-- Stop the aimbot when button is clicked
StopAimbotButton.MouseButton1Click:Connect(function()
    aimbotEnabled = false
    AimbotToggle.Text = "Toggle Aimbot: OFF"
    AimbotToggle.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
    LocalPlayer.CameraMode = Enum.CameraMode.Classic -- Reset camera mode
end)

-- Close the UI
CloseButton.MouseButton1Click:Connect(function()
    Frame.Visible = false
end)

-- Update closest player every frame
RunService.RenderStepped:Connect(function()
    if aimbotEnabled then
        findClosestPlayer() -- Continuously update the closest player
    end
end)
