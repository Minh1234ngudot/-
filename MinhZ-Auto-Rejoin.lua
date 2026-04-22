--[[
            ╔══════════════════════════════════════════════╗
            ║                                              ║
            ║   ███╗   ███╗██╗███╗   ██╗██╗  ██╗███████╗   ║
            ║   ████╗ ████║██║████╗  ██║██║  ██║╚══███╔╝   ║
            ║   ██╔████╔██║██║██╔██╗ ██║███████║  ███╔╝    ║
            ║   ██║╚██╔╝██║██║██║╚██╗██║██╔══██║ ███╔╝     ║
            ║   ██║ ╚═╝ ██║██║██║ ╚████║██║  ██║███████╗   ║
            ║   ╚═╝     ╚═╝╚═╝╚═╝  ╚═══╝╚═╝  ╚═╝╚══════╝   ║
            ║     MinhZ Hub Auto Rejoin | Made By MinhZ    ║
            ║                                              ║
            ╚══════════════════════════════════════════════╝
                       Note: This Is Make By MinhZ
]]--

local timeToRejoin = tonumber(getgenv().TIME_REJOIN) or 60

local coreGui = game:GetService("CoreGui")
if coreGui:FindFirstChild("MinhZ_RejoinUI") then
    coreGui.MinhZ_RejoinUI:Destroy()
end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "MinhZ_RejoinUI"
screenGui.Parent = coreGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 250, 0, 60)
frame.Position = UDim2.new(0.5, -125, 0, 30)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
frame.BorderSizePixel = 0
frame.Parent = screenGui

local uiCorner = Instance.new("UICorner")
uiCorner.CornerRadius = UDim.new(0, 8)
uiCorner.Parent = frame

local uiStroke = Instance.new("UIStroke")
uiStroke.Color = Color3.fromRGB(255, 255, 255)
uiStroke.Thickness = 1.5
uiStroke.Parent = frame

local textLabel = Instance.new("TextLabel")
textLabel.Size = UDim2.new(1, 0, 1, 0)
textLabel.BackgroundTransparency = 1
textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
textLabel.TextScaled = false
textLabel.TextSize = 24
textLabel.Font = Enum.Font.GothamBold
textLabel.Text = "Auto Rejoin In: " .. timeToRejoin .. "s"
textLabel.Parent = frame

task.spawn(function()
    while timeToRejoin > 0 do
        task.wait(1)
        timeToRejoin = timeToRejoin - 1
        textLabel.Text = "Auto Rejoin In: " .. timeToRejoin .. "s"
    end

    textLabel.Text = "Rejoining Now..."
    textLabel.TextColor3 = Color3.fromRGB(0, 255, 100)
    task.wait(1)

    local teleportService = game:GetService("TeleportService")
    local player = game:GetService("Players").LocalPlayer
    
    teleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, player)
end)



--[[ Usage:

getgenv().TIME_REJOIN = "60" -- 1 Minute (Measured In Seconds)
loadstring(game:HttpGet("https://raw.githubusercontent.com/Minh1234ngudot/-/refs/heads/main/MinhZ-Auto-Rejoin.lua"))()

]]--
