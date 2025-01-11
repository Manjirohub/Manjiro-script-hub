local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = game:GetService("Players").LocalPlayer
local WindowVisible = true -- Track window visibility

local masterUsername = "yashgamer2233"
local mistressUsername = "Karina_Siwa2"

local gamepassID = 1029112746 -- Replace with your GamePass ID

-- Check if the user owns the GamePass
local function hasGamepass(player)
    return player:HasGamePass(gamepassID)
end

local function showMessage(title, content)
    Fluent:Notify({
        Title = title,
        Content = content,
        Duration = 5
    })
end

-- Verification for master or mistress
if LocalPlayer.Name == masterUsername then
    showMessage("Master has arrived", "Welcome, Yash!")
elseif LocalPlayer.Name == mistressUsername then
    showMessage("Mistress has arrived", "Welcome, Jahnavi!")
else
    if hasGamepass(LocalPlayer) then
        showMessage("GamePass Verified", "You have access to this script!")
    else
        showMessage("Access Denied", "You do not have the necessary GamePass.")
        return
    end
end

-- Continue with the rest of the script (positions, etc.)
local Positions = {
    ["Dock"] = Vector3.new(445.53, 40.24, 392.25),
    ["Sweet Shop"] = Vector3.new(732.36, 156.41, -934.99),
    ["Gift-Making Place"] = Vector3.new(919.32, 235.89, -1137.43),
    ["Church"] = Vector3.new(998.83, 231.93, -941.85),
}

local PositionButtons = {}

local function SavePositionsToFile()
    writefile("ManjiroScriptHub_Positions.txt", game:GetService("HttpService"):JSONEncode(Positions))
end

local function LoadPositionsFromFile()
    if isfile("ManjiroScriptHub_Positions.txt") then
        local data = game:GetService("HttpService"):JSONDecode(readfile("ManjiroScriptHub_Positions.txt"))
        for name, position in pairs(data) do
            Positions[name] = Vector3.new(position.X, position.Y, position.Z)
        end
    end
end

LoadPositionsFromFile()

local Window = Fluent:CreateWindow({
    Title = "Manjiro Script Hub",
    SubTitle = "Save, Load, and Manage Positions with Ease!",
    Theme = "Dark",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = true,
})

local Tabs = {
    ManagePositions = Window:AddTab({ Title = "Manage Positions", Icon = "save" })
}

local function RefreshPositionButtons(section)
    for _, button in ipairs(PositionButtons) do
        button:Destroy()
    end
    PositionButtons = {}

    for name, position in pairs(Positions) do
        local button = section:AddButton({
            Title = "Load: " .. name,
            Callback = function()
                if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(position)
                    Fluent:Notify({
                        Title = "Success",
                        Content = "Position loaded: " .. name,
                        Duration = 5,
                        Image = "check"
                    })
                else
                    Fluent:Notify({
                        Title = "Error",
                        Content = "Character or HumanoidRootPart not found.",
                        Duration = 5,
                        Image = "x"
                    })
                end
            end
        })
        table.insert(PositionButtons, button)
    end
end

do
    local ManageSection = Tabs.ManagePositions:AddSection("Position Management")

    Tabs.ManagePositions:AddInput("PositionName", {
        Title = "Position Name",
        Default = "",
        Placeholder = "Enter a position name...",
        Callback = function(value)
            positionName = value
        end
    })

    Tabs.ManagePositions:AddButton({
        Title = "Save Position",
        Callback = function()
            if not positionName or positionName == "" then
                Fluent:Notify({
                    Title = "Error",
                    Content = "Please enter a valid position name.",
                    Duration = 5,
                    Image = "x"
                })
                return
            end

            local character = LocalPlayer.Character
            if character and character:FindFirstChild("HumanoidRootPart") then
                Positions[positionName] = character.HumanoidRootPart.Position
                SavePositionsToFile()
                Fluent:Notify({
                    Title = "Success",
                    Content = "Position saved: " .. positionName,
                    Duration = 5,
                    Image = "check"
                })
                RefreshPositionButtons(ManageSection)
            else
                Fluent:Notify({
                    Title = "Error",
                    Content = "Character or HumanoidRootPart not found.",
                    Duration = 5,
                    Image = "x"
                })
            end
        end
    })

    RefreshPositionButtons(ManageSection)
end

Fluent:Notify({
    Title = "Manjiro Script Hub",
    Content = "The script has been loaded and is ready to use!",
    Duration = 8
})
