local webhookURL = "https://discord.com/api/webhooks/1294551378886397972/LiaShmLPS1dmb_0NKnnldLwpnWoDBJw04UQkTn5FyQ5pDE_zTJMk0BWrnBGoKx49sNYH"
local classNames = {}

local function sendToDiscord(className)
    local data = {
        content = "Found Class Name: " .. className
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

local function continuouslyGatherClassNames()
    while true do
        wait(1) -- Adjust the wait time as needed
        for _, instance in pairs(workspace:GetDescendants()) do
            if not table.find(classNames, instance.ClassName) then
                table.insert(classNames, instance.ClassName)
                sendToDiscord(instance.ClassName)
            end
        end
    end
end

-- Start the gathering process
continuouslyGatherClassNames()
