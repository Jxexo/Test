local webhookURL = "https://discord.com/api/webhooks/1294551378886397972/LiaShmLPS1dmb_0NKnnldLwpnWoDBJw04UQkTn5FyQ5pDE_zTJMk0BWrnBGoKx49sNYH"
local foundEggs = {}
local eggCount = 0

local function sendToDiscord(eggName)
    local data = {
        content = "Found Egg: " .. eggName .. " | Total Count: " .. eggCount
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

local function continuouslyLookForEggs()
    while true do
        wait(1) -- Adjust the wait time as needed
        for _, instance in pairs(workspace:GetDescendants()) do
            if string.find(instance.Name:lower(), "egg") and not table.find(foundEggs, instance.Name) then
                table.insert(foundEggs, instance.Name)
                eggCount = eggCount + 1
                sendToDiscord(instance.Name)
            end
        end
    end
end

-- Start the gathering process
continuouslyLookForEggs()
