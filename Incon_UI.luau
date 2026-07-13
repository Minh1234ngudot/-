local InconUI = {}
local TS = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")
local RS = game:GetService("RunService")
local Players = game:GetService("Players")
local LP = Players.LocalPlayer
local MinhZFont = Font.new("rbxasset://fonts/families/Inconsolata.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)

function InconUI:CreateWindow(Options)
    Options = Options or {}
    local TitleText = Options.Name or "Incon UI Hub"
    local BindKey = Options.ToggleKey or Enum.KeyCode.RightControl
    local KeyName = (BindKey == Enum.KeyCode.RightControl) and "RCtrl" or BindKey.Name
    local Window = {CurrentPage = nil, Pages = {}, TabIndex = 0}
    local ParentUI = nil
    local success, coreGui = pcall(function() return game:GetService("CoreGui") end)
    if success and coreGui then ParentUI = coreGui end
    if type(gethui) == "function" then ParentUI = gethui() end
    if not ParentUI then ParentUI = LP:WaitForChild("PlayerGui") end
    for _, gui in ipairs(ParentUI:GetChildren()) do
        if gui.Name == "InconUI_Hub" then gui:Destroy() end
    end
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "InconUI_Hub"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.Parent = ParentUI
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.BackgroundColor3 = Color3.fromRGB(11, 11, 11)
    MainFrame.BorderColor3 = Color3.fromRGB(56, 56, 56)
    MainFrame.Size = UDim2.new(0, 360, 0, 240)
    MainFrame.Position = UDim2.new(0.5, -180, 0.5, -120)
    MainFrame.ClipsDescendants = false
    MainFrame.ZIndex = 4
    MainFrame.Parent = ScreenGui
    local TopBar = Instance.new("Frame")
    TopBar.Name = "TopBar"
    TopBar.BackgroundColor3 = Color3.fromRGB(23, 23, 23)
    TopBar.BorderSizePixel = 0
    TopBar.Size = UDim2.new(1, 0, 0, 22)
    TopBar.ZIndex = 5
    TopBar.Parent = MainFrame
    local TopLabel = Instance.new("TextLabel")
    TopLabel.Text = string.format("           %s  |  %s Toggle", TitleText, KeyName)
    TopLabel.FontFace = MinhZFont
    TopLabel.TextSize = 12
    TopLabel.TextColor3 = Color3.fromRGB(181, 181, 181)
    TopLabel.TextXAlignment = Enum.TextXAlignment.Left
    TopLabel.BackgroundTransparency = 1
    TopLabel.Size = UDim2.new(1, -10, 1, 0)
    TopLabel.Position = UDim2.new(0, 4, 0, 0)
    TopLabel.ZIndex = 6
    TopLabel.Parent = TopBar
    local dragging, dragStart, startPos
    TopBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = MainFrame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    UIS.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement and dragging then
            local delta = input.Position - dragStart
            TS:Create(MainFrame, TweenInfo.new(0.25), {Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)}):Play()
        end
    end)
    UIS.InputBegan:Connect(function(input, gp)
        if not gp and input.KeyCode == BindKey then
            MainFrame.Visible = not MainFrame.Visible
        end
    end)
    local SideBarMask = Instance.new("Frame")
    SideBarMask.Name = "SideBarMask"
    SideBarMask.Size = UDim2.new(0, 110, 1, 0) 
    SideBarMask.Position = UDim2.new(0, -110, 0, 0) 
    SideBarMask.BorderSizePixel = 0
    SideBarMask.BackgroundTransparency = 1
    SideBarMask.ClipsDescendants = true 
    SideBarMask.ZIndex = 12
    SideBarMask.Parent = MainFrame
    local SideBar = Instance.new("Frame")
    SideBar.Name = "InconUI_Sidebar"
    SideBar.Size = UDim2.new(1, 0, 1, 0)
    SideBar.Position = UDim2.new(0, 0, 0, 0)
    SideBar.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
    SideBar.BorderColor3 = Color3.fromRGB(55, 55, 55)
    SideBar.BorderSizePixel = 1
    SideBar.ZIndex = 12
    SideBar.Parent = SideBarMask
    local ToggleBtn = Instance.new("TextButton")
    ToggleBtn.Name = "ToggleArrow"
    ToggleBtn.Size = UDim2.new(0, 15, 0, 30)
    ToggleBtn.Position = UDim2.new(0, -15, 0.5, -15)
    ToggleBtn.BackgroundTransparency = 1
    ToggleBtn.TextColor3 = Color3.fromRGB(220, 220, 220)
    ToggleBtn.Text = "<"
    ToggleBtn.Font = Enum.Font.Code
    ToggleBtn.TextSize = 16
    ToggleBtn.ZIndex = 13
    ToggleBtn.Parent = MainFrame
    local isOpen = true
    ToggleBtn.MouseButton1Click:Connect(function()
        isOpen = not isOpen
        ToggleBtn.Text = isOpen and "<" or ">"
        TS:Create(SideBar, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2.new(0, isOpen and 0 or 110, 0, 0)}):Play()
    end)
    local Logo = Instance.new("ImageLabel")
    Logo.Size = UDim2.new(0, 56, 0, 56)
    Logo.Position = UDim2.new(0.5, -28, 0, 12)
    Logo.Image = "rbxthumb://type=AvatarHeadShot&id="..LP.UserId.."&w=150&h=150"
    Logo.BackgroundTransparency = 1
    Logo.ZIndex = 13
    Instance.new("UICorner", Logo).CornerRadius = UDim.new(1, 0)
    Logo.Parent = SideBar
    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, -10, 0, 45)
    Title.Position = UDim2.new(0, 5, 0, 75)
    Title.BackgroundTransparency = 1
    Title.ZIndex = 13
    Title.Font = Enum.Font.Code
    Title.TextSize = 11
    Title.TextColor3 = Color3.fromRGB(200, 200, 200)
    Title.TextWrapped = true
    Title.RichText = true
    Title.Parent = SideBar
    RS.RenderStepped:Connect(function()
        local hue = tick() % 4 / 4
        local c = Color3.fromHSV(hue, 1, 1)
        local hex = string.format("#%02X%02X%02X", c.R*255, c.G*255, c.B*255)
        Title.Text = 'Welcome\n<font color="'..hex..'">'..LP.Name..'</font>\nto\n'..TitleText
    end)
    local TabContainer = Instance.new("ScrollingFrame")
    TabContainer.Size = UDim2.new(1, 0, 1, -125)
    TabContainer.Position = UDim2.new(0, 0, 0, 125)
    TabContainer.BackgroundTransparency = 1
    TabContainer.BorderSizePixel = 0
    TabContainer.ScrollBarThickness = 0
    TabContainer.AutomaticCanvasSize = Enum.AutomaticSize.Y
    TabContainer.ZIndex = 13
    TabContainer.Parent = SideBar
    local UIListLayout = Instance.new("UIListLayout", TabContainer)
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout.Padding = UDim.new(0, 5)
    UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    local UIPad = Instance.new("UIPadding", TabContainer)
    UIPad.PaddingTop = UDim.new(0, 2)
    UIPad.PaddingBottom = UDim.new(0, 10)
    local PageMask = Instance.new("Frame")
    PageMask.Name = "PageMask"
    PageMask.Size = UDim2.new(1, 0, 1, -22)
    PageMask.Position = UDim2.new(0, 0, 0, 22)
    PageMask.BackgroundTransparency = 1
    PageMask.ClipsDescendants = true
    PageMask.ZIndex = 4
    PageMask.Parent = MainFrame

    function Window:CreateTab(TabName)
        Window.TabIndex = Window.TabIndex + 1
        local CurrentIndex = Window.TabIndex
        local Tab = {}
        local TabPage = Instance.new("ScrollingFrame")
        TabPage.Name = TabName
        TabPage.Size = UDim2.new(1, 0, 1, 0)
        TabPage.BackgroundTransparency = 1
        TabPage.BorderSizePixel = 0
        TabPage.ScrollBarThickness = 3
        TabPage.ScrollBarImageColor3 = Color3.fromRGB(71, 71, 71)
        TabPage.CanvasSize = UDim2.new(0, 0, 0, 0)
        TabPage.AutomaticCanvasSize = Enum.AutomaticSize.Y
        TabPage.Visible = false
        TabPage.ZIndex = 5
        TabPage:SetAttribute("TabIndex", CurrentIndex)
        TabPage.Parent = PageMask
        local Grid = Instance.new("UIGridLayout", TabPage)
        Grid.HorizontalAlignment = Enum.HorizontalAlignment.Center
        Grid.CellSize = UDim2.new(0, 113, 0, 30)
        Grid.CellPadding = UDim2.new(0, 3, 0, 3)
        local Pad = Instance.new("UIPadding", TabPage)
        Pad.PaddingTop = UDim.new(0, 4)
        Pad.PaddingBottom = UDim.new(0, 4)
        local TabBtn = Instance.new("TextButton")
        TabBtn.Size = UDim2.new(0.9, 0, 0, 28)
        TabBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
        TabBtn.BorderColor3 = Color3.fromRGB(50, 50, 50)
        TabBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
        TabBtn.Text = TabName
        TabBtn.Font = Enum.Font.Code
        TabBtn.TextSize = 11
        TabBtn.ZIndex = 14
        TabBtn.Parent = TabContainer
        table.insert(Window.Pages, TabPage)
        TabBtn.MouseButton1Click:Connect(function()
            if Window.CurrentPage == TabPage then return end
            local slideInfo = TweenInfo.new(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
            if Window.CurrentPage then
                local oldIndex = Window.CurrentPage:GetAttribute("TabIndex")
                if CurrentIndex > oldIndex then
                    TS:Create(Window.CurrentPage, slideInfo, {Position = UDim2.new(0, 0, -1, 0)}):Play()
                    TabPage.Position = UDim2.new(0, 0, 1, 0)
                else
                    TS:Create(Window.CurrentPage, slideInfo, {Position = UDim2.new(0, 0, 1, 0)}):Play()
                    TabPage.Position = UDim2.new(0, 0, -1, 0)
                end
                local TempPage = Window.CurrentPage
                task.delay(0.35, function() 
                    if Window.CurrentPage ~= TempPage then TempPage.Visible = false end
                end)
            end
            TabPage.Visible = true
            TS:Create(TabPage, slideInfo, {Position = UDim2.new(0, 0, 0, 0)}):Play()
            Window.CurrentPage = TabPage
        end)
        if #Window.Pages == 1 then
            TabPage.Visible = true
            TabPage.Position = UDim2.new(0, 0, 0, 0)
            Window.CurrentPage = TabPage
        end
        function Tab:CreateButton(Options)
            local Btn = Instance.new("TextButton")
            Btn.Size = UDim2.new(0, 113, 0, 30)
            Btn.BackgroundColor3 = Color3.fromRGB(26, 26, 26)
            Btn.BorderColor3 = Color3.fromRGB(51, 51, 51)
            Btn.TextColor3 = Color3.fromRGB(201, 201, 201)
            Btn.Text = Options.Name or "Button"
            Btn.FontFace = MinhZFont
            Btn.TextSize = 11
            Btn.AutoButtonColor = false
            Btn.ZIndex = 6
            Btn.Parent = TabPage
            Btn.MouseButton1Click:Connect(function()
                if Options.Callback then Options.Callback() end
            end)
        end
        return Tab
    end
    return Window
end

return InconUI
