local Players = game:GetService("Players")

local TAG_NAME = "ScriptOwnerTag"
local TARGET_USERNAMES = { "Theo_TheoBenzo", "Theo_TheoBenzo", "ITS_MEBRU123", "please_flyflywjcy" } -- Add more here
local CHECK_INTERVAL = 2

local TargetLookup = {}
for _, name in pairs(TARGET_USERNAMES) do
    TargetLookup[name] = true
end

local function createTag(player)
    if player.Character and player.Character:FindFirstChild("Head") then
        if player.Character.Head:FindFirstChild(TAG_NAME) then return end

        local billboard = Instance.new("BillboardGui")
        billboard.Name = TAG_NAME
        billboard.Size = UDim2.new(0, 100, 0, 40)
        billboard.StudsOffset = Vector3.new(0, 2.5, 0)
        billboard.Adornee = player.Character.Head
        billboard.AlwaysOnTop = true
        billboard.Parent = player.Character.Head

        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, 0, 1, 0)
        label.BackgroundTransparency = 1
        label.Text = "SCRIPT OWNER"
        label.TextColor3 = Color3.new(1, 1, 1)
        label.TextStrokeTransparency = 0
        label.TextScaled = true
        label.Font = Enum.Font.Sarpanch
        label.Parent = billboard
local G = Color3.fromRGB(10, 10, 10)
local A = Color3.fromRGB(100,100,100)
local W = Color3.fromRGB(255, 255, 255)
local H = ColorSequence.new{
    ColorSequenceKeypoint.new(0, A),
    ColorSequenceKeypoint.new(0.500, G),
    ColorSequenceKeypoint.new(1, W)
}
local Rq300 = Instance.new("UIGradient")
local Text200 = Instance.new("UIStroke")
Text200.Thickness = 1.25
Text200.Color = Color3.fromRGB(255,255,255)
Text200.Parent = label
Text200.LineJoinMode = Enum.LineJoinMode.Miter
Rq300.Parent = Text200
Rq300.Color = H
Rq300.Name = "Test3"
Rq300.Enabled = true 
Rq300.Rotation = 85
Rq300.Offset = Vector2.new(-2,0)
    end
end

task.spawn(function()
    while true do
        for _, player in pairs(Players:GetPlayers()) do
            if TargetLookup[player.Name] then
                createTag(player)
            end
        end
        task.wait(CHECK_INTERVAL)
    end
end)

Players.PlayerAdded:Connect(function(player)
    if TargetLookup[player.Name] then
        player.CharacterAdded:Connect(function()
            task.wait(1)
            createTag(player)
        end)
    end
end)
