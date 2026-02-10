-- Credit aabbaaii13/14, Modified This Script By MinhZ
local screengui = Instance.new("ScreenGui", game:GetService("CoreGui"))
local frame3 = Instance.new("Frame", screengui)
local frame2 = Instance.new("Frame", frame3)
local frame = Instance.new("Frame", frame2)
local uilistlayout = Instance.new("UIListLayout", frame2)
local textlabel = Instance.new("TextLabel", frame)
local uicorner = Instance.new("UICorner", frame)
screengui.ResetOnSpawn = false
screengui.ScreenInsets = "TopbarSafeInsets"

frame3.Size = UDim2.new(1, 0, 1, -2)
frame3.Position = UDim2.new(0, 0, 0, 0)
frame3.BackgroundTransparency = 1

frame2.Size = UDim2.new(1, -24, 1, 0)
frame2.Position = UDim2.new(0, 12, 0, 0)
frame2.BackgroundTransparency = 1

uilistlayout.Padding = UDim.new(0, 12)
uilistlayout.FillDirection = Enum.FillDirection.Horizontal
uilistlayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
uilistlayout.SortOrder = Enum.SortOrder.LayoutOrder
uilistlayout.VerticalAlignment = Enum.VerticalAlignment.Bottom

frame.Size = UDim2.new(0, 44, 0, 44)
frame.Position = UDim2.new(0.85, 0, 0, 0)
frame.BackgroundColor3 = Color3.new(0, 0, 0)
frame.BackgroundTransparency = 0.1

textlabel.Size = UDim2.new(1, 0, 1, 0)
textlabel.BackgroundTransparency = 1
textlabel.TextColor3 = Color3.new(1, 1, 1)
textlabel.Text = "FPS: 0"
textlabel.TextSize = 12
textlabel.Font = Enum.Font.GothamBold

uicorner.CornerRadius = UDim.new(1, 0)

local n = 0
local o = 0

game:GetService("RunService").RenderStepped:Connect(function(q)
    n += 1
    o += q
    if o >= 1 then
        local r = n / o
        textlabel.Text = string.format("FPS: %.0f", r)
        n = 0
        o = 0
    end
end)
