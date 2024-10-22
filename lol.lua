local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UIS = game:GetService("UserInputService")

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
game:GetService("RunService").RenderStepped:Connect(function()
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
            LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(closestPlayer.Character.Head.Position + Vector3.new(0, 0.5, 0))
        end
    end
end)

