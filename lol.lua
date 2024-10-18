local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")

-- Variables
local aimEnabled = true -- Set to true by default
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

-- Function to aim at the closest player's head
local function aimAtPlayerHead()
    if aimEnabled then
        local head = getClosestPlayerHead()
        if head then
            -- Aim at the head by adjusting the camera's CFrame
            local headPosition = head.Position
            local currentPosition = LocalPlayer.Character.Head.Position

            -- Create a new CFrame aiming towards the head
            local aimDirection = CFrame.new(currentPosition, headPosition)
            LocalPlayer.Character.HumanoidRootPart.CFrame = aimDirection
        end
    end
end

-- Run the aim function every frame
RunService.RenderStepped:Connect(aimAtPlayerHead)
