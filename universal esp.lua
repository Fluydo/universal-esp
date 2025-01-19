local DiscordLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/UI-Libs/main/discord%20lib.txt"))()
local needToCreateButtonToTp = true
local needToCreateDropdownToTp = true
local espColor = Color3.fromRGB(255, 1, 1)

local win = DiscordLib:Window("Alexiss [DEVELOPER TEST]")

local serv = win:Server("DEVELOPER", "")

local main = serv:Channel("Main")

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local function populateDropdown()
    local playerNames = {}

    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            table.insert(playerNames, player.Name)
        end
    end

    if needToCreateDropdownToTp == true then
        needToCreateDropdownToTp = false
        dropTp = main:Dropdown("Tp To A Player", playerNames, function(selectedPlayerName)
            print("Selected player: " .. selectedPlayerName)

            local selectedPlayer = Players:FindFirstChild(selectedPlayerName)

            function clickTp()
                if selectedPlayer and selectedPlayer.Character then
                    local selectedPlayerRootPart = selectedPlayer.Character:FindFirstChild("HumanoidRootPart")
                    if selectedPlayerRootPart then
                        LocalPlayer.Character:SetPrimaryPartCFrame(selectedPlayerRootPart.CFrame)
                    end
                end
            end
        end)
    end

    if needToCreateButtonToTp == true then
        main:Button("Tp to selected player", function()
            clickTp()
        end)
        needToCreateButtonToTp = false
    end
end

populateDropdown()

Players.PlayerAdded:Connect(function(player)
    populateDropdown()
end)

Players.PlayerRemoving:Connect(function(player)
    populateDropdown()
end)

main:Button("Kill Myself", function()
    game.Players.LocalPlayer.Character.Humanoid:TakeDamage(1000)
end)

function createEsp(player)
    if player.Character and not player.Character:FindFirstChild("EspBillboard") then
        if player ~= Players.LocalPlayer then
            local billboard = Instance.new("BillboardGui", player.Character)
            billboard.Name = "EspBillboard"
            billboard.AlwaysOnTop = true
            billboard.Size = UDim2.new(4, 0, 5, 0) -- Adjust size as needed
            billboard.Adornee = player.Character:FindFirstChild("HumanoidRootPart")
            billboard.Enabled = false

            local frame = Instance.new("Frame", billboard)
            frame.Size = UDim2.new(1, 0, 1, 0)
            frame.BackgroundTransparency = 0.5
            frame.BackgroundColor3 = espColor
        end
    end
end

for _, player in pairs(Players:GetPlayers()) do
    createEsp(player)
end

Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function()
        createEsp(player)
        player.Character.EspBillboard.Enabled = true
        player.Character.EspBillboard.Enabled = false
    end)
end)

Players.PlayerRemoving:Connect(function(player)
    if player.Character and player.Character:FindFirstChild("EspBillboard") then
        player.Character.EspBillboard:Destroy()
        player.Character.EspBillboard.Enabled = true
        player.Character.EspBillboard.Enabled = false
    end
end)

main:Toggle("Esp Player", false, function(value)
    for _, player in pairs(Players:GetPlayers()) do
        if player.Character and player.Character:FindFirstChild("EspBillboard") then
            player.Character.EspBillboard.Enabled = value
        end
    end
end)

main:Button("Reload Esp", function()
    for _, player in pairs(Players:GetPlayers()) do
        createEsp(player)
    end
end)

main:Colorpicker("ESP Color", espColor, function(color)
    espColor = color
    for _, player in pairs(Players:GetPlayers()) do
        if player.Character and player.Character:FindFirstChild("EspBillboard") then
            player.Character.EspBillboard.Frame.BackgroundColor3 = espColor
        end
    end
end)
