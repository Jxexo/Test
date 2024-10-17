local webhookURL = "https://discord.com/api/webhooks/1294551378886397972/LiaShmLPS1dmb_0NKnnldLwpnWoDBJw04UQkTn5FyQ5pDE_zTJMk0BWrnBGoKx49sNYH"
local foundEggCapsules = {}

local function sendToDiscord(message)
    local data = {
        content = message
    }

    local jsonData = game:GetService("HttpService"):JSONEncode(data)

    -- Send the POST request to the webhook
    local request = http_request or request or HttpPost or syn.request
    request({
        Url = webhookURL,
        Method = "POST",
        Headers = {
            ["Content-Type"] = "application/json"
        },
        Body = jsonData
    })
end

local function gatherEggCapsuleInfo(instance)
    local info = "Found Egg Capsule:\n"
    info = info .. "Name: " .. instance.Name .. "\n"
    info = info .. "Class: " .. instance.ClassName .. "\n"
    info = info .. "Position: " .. tostring(instance.Position) .. "\n"
    info = info .. "Parent: " .. (instance.Parent and instance.Parent.Name or "None") .. "\n"
    info = info .. "Properties:\n"

    for property, value in pairs(instance:GetAttributes()) do
        info = info .. string.format(" - %s: %s\n", property, tostring(value))
    end

    info = info .. "\nChildren:\n"
    for _, child in ipairs(instance:GetChildren()) do
        info = info .. " - " .. child.Name .. " (Class: " .. child.ClassName .. ")\n"
    end

    return info
end

local function continuouslyLookForEggCapsules()
    while true do
        wait(1) -- Adjust the wait time as needed
        for _, instance in pairs(workspace:GetDescendants()) do
            if instance.Name == "1- Egg Capsule" and not foundEggCapsules[instance] then
                foundEggCapsules[instance] = true
                local message = gatherEggCapsuleInfo(instance)
                sendToDiscord(message)
            end
        end
    end
end

-- Start the gathering process
continuouslyLookForEggCapsules()
