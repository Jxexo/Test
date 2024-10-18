local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local Camera = game.Workspace.CurrentCamera

-- Variables
local aimEnabled = true -- Toggle aim lock
local aimTarget = nil

-- Function to get the closest player's head
local function getClosestPlayerHead()
    local closestPlayer = nil
    local shortestDistance = math.huge
    local closestHead = nil

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local head = player.Character:FindFirstChild("Head")
            if head then
                local distance = (head.Position - LocalPlayer.Character.HumanoidRootPart.Position).magnitude
                if distance < shortestDistance then
                    shortestDistance = distance
                    closestPlayer = player
                    closestHead = head
                end
            end
        end
    end

    return closestHead
end

-- Function to aim camera at the closest player's head
local function aimAtPlayerHead()
    if aimEnabled then
        local head = getClosestPlayerHead()
        if head then
            -- Aim the camera at the closest player's head
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, head.Position)
        end
    end
end

-- Run the aim function every frame
RunService.RenderStepped:Connect(aimAtPlayerHead)
