local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = game:GetService("Players").LocalPlayer
local WindowVisible = true -- Track window visibility

-- Predefined Positions Table with coordinates for Dock, Sweet Shop, Gift-Making Place, and Church
local Positions = {
    ["Dock"] = Vector3.new(445.53, 40.24, 392.25), -- Coordinates for Dock
    ["Sweet Shop"] = Vector3.new(732.36, 156.41, -934.99), -- Coordinates for Sweet Shop
    ["Gift-Making Place"] = Vector3.new(919.32, 235.89, -1137.43), -- Coordinates for Gift-Making Place
    ["Church"] = Vector3.new(998.83, 231.93, -941.85), -- Coordinates for Church
}

local PositionButtons = {} -- Store buttons for dynamically added positions

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

-- Load positions from file if available
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

-- Function to refresh position buttons
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

-- Manage Positions Tab
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

    -- Load initial positions
    RefreshPositionButtons(ManageSection)
end

-- Notify user that the script has been loaded
Fluent:Notify({
    Title = "Manjiro Script Hub",
    Content = "The script has been loaded and is ready to use!",
    Duration = 8
})
