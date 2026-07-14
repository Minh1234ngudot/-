local InconUI = {}
local TS = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")
local RS = game:GetService("RunService")
local Players = game:GetService("Players")
local TSvc = game:GetService("TextService")
local Http = game:GetService("HttpService")
local LP = Players.LocalPlayer
local InconFont = Font.new("rbxasset://fonts/families/Inconsolata.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)

function InconUI:MakeNotify(Options)
    local Title = Options.Title or "Notification"
    local Content = Options.Content or ""
    local Time = Options.Time or 3

    local ParentUI = nil
    pcall(function() ParentUI = game:GetService("CoreGui") end)
    if type(gethui) == "function" then ParentUI = gethui() end
    if not ParentUI then ParentUI = LP:WaitForChild("PlayerGui") end

    local NotifyUI = ParentUI:FindFirstChild("InconUI_Notify")
    if not NotifyUI then
        local NewNotifyUI = Instance.new("ScreenGui")
        NewNotifyUI.Name = "InconUI_Notify"
        NewNotifyUI.ResetOnSpawn = false
        NewNotifyUI.IgnoreGuiInset = true
        NewNotifyUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        local Layout = Instance.new("Frame")
        Layout.Name = "Layout"
        Layout.AnchorPoint = Vector2.new(1, 1)
        Layout.Size = UDim2.new(0, 250, 1, -30)
        Layout.Position = UDim2.new(1, -15, 1, -15)
        Layout.BackgroundTransparency = 1
        Layout.Parent = NewNotifyUI
        local UIL = Instance.new("UIListLayout")
        UIL.SortOrder = Enum.SortOrder.LayoutOrder
        UIL.VerticalAlignment = Enum.VerticalAlignment.Bottom
        UIL.Padding = UDim.new(0, 10)
        UIL.Parent = Layout
        NewNotifyUI.Parent = ParentUI
        NotifyUI = ParentUI:FindFirstChild("InconUI_Notify") or NewNotifyUI
        if NotifyUI ~= NewNotifyUI then
            NewNotifyUI:Destroy()
        end
    end

    local NoteFrame = Instance.new("Frame")
    NoteFrame.Size = UDim2.new(1, 0, 0, 60)
    NoteFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    NoteFrame.BorderColor3 = Color3.fromRGB(56, 56, 56)
    NoteFrame.Position = UDim2.new(1, 50, 0, 0)
    NoteFrame.BackgroundTransparency = 1
    NoteFrame.Parent = NotifyUI.Layout

    local TxtTitle = Instance.new("TextLabel")
    TxtTitle.Size = UDim2.new(1, -20, 0, 20)
    TxtTitle.Position = UDim2.new(0, 10, 0, 5)
    TxtTitle.BackgroundTransparency = 1
    TxtTitle.Text = Title
    TxtTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    TxtTitle.TextXAlignment = Enum.TextXAlignment.Left
    TxtTitle.FontFace = InconFont
    TxtTitle.TextSize = 13
    TxtTitle.TextTransparency = 1
    TxtTitle.Parent = NoteFrame

    local TxtContent = Instance.new("TextLabel")
    TxtContent.Size = UDim2.new(1, -20, 0, 25)
    TxtContent.Position = UDim2.new(0, 10, 0, 25)
    TxtContent.BackgroundTransparency = 1
    TxtContent.Text = Content
    TxtContent.TextColor3 = Color3.fromRGB(180, 180, 180)
    TxtContent.TextXAlignment = Enum.TextXAlignment.Left
    TxtContent.TextYAlignment = Enum.TextYAlignment.Top
    TxtContent.TextWrapped = true
    TxtContent.FontFace = InconFont
    TxtContent.TextSize = 11
    TxtContent.TextTransparency = 1
    TxtContent.Parent = NoteFrame

    local TimeBar = Instance.new("Frame")
    TimeBar.Size = UDim2.new(1, 0, 0, 2)
    TimeBar.Position = UDim2.new(0, 0, 1, -2)
    TimeBar.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    TimeBar.BorderSizePixel = 0
    TimeBar.BackgroundTransparency = 1
    TimeBar.Parent = NoteFrame

    TS:Create(NoteFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2.new(0, 0, 0, 0), BackgroundTransparency = 0}):Play()
    TS:Create(TxtTitle, TweenInfo.new(0.3), {TextTransparency = 0}):Play()
    TS:Create(TxtContent, TweenInfo.new(0.3), {TextTransparency = 0}):Play()
    TS:Create(TimeBar, TweenInfo.new(0.3), {BackgroundTransparency = 0}):Play()

    TS:Create(TimeBar, TweenInfo.new(Time, Enum.EasingStyle.Linear), {Size = UDim2.new(0, 0, 0, 2)}):Play()

    task.delay(Time, function()
        TS:Create(NoteFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {Position = UDim2.new(1, 50, 0, 0), BackgroundTransparency = 1}):Play()
        TS:Create(TxtTitle, TweenInfo.new(0.3), {TextTransparency = 1}):Play()
        TS:Create(TxtContent, TweenInfo.new(0.3), {TextTransparency = 1}):Play()
        TS:Create(TimeBar, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()
        task.delay(0.3, function() NoteFrame:Destroy() end)
    end)
end

function InconUI:CreateWindow(Options)
    Options = Options or {}
    local TitleText = Options.Name or "Incon UI Library"
    local BindKey = Options.ToggleKey or Enum.KeyCode.RightControl
    local KeyName = (BindKey == Enum.KeyCode.RightControl) and "RCtrl" or BindKey.Name
    local ConfigFolder = Options.Folder or "InconConfigs"
    local Window = { CurrentPage = nil, Pages = {}, TabIndex = 0, Connections = {}, Flags = {}, Elements = {} }
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
    ScreenGui.IgnoreGuiInset = true
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.Parent = ParentUI

    local MasterFrame = Instance.new("Frame")
    MasterFrame.Name = "MasterFrame"
    MasterFrame.BackgroundTransparency = 1
    MasterFrame.Size = UDim2.new(0, 360, 0, 240)
    MasterFrame.Position = UDim2.new(0.5, -180, 0.5, -120)
    MasterFrame.ZIndex = 1
    MasterFrame.Parent = ScreenGui

    local SideBarContainer = Instance.new("Frame")
    SideBarContainer.Name = "SideBarContainer"
    SideBarContainer.Size = UDim2.new(0, 130, 1, 0)
    SideBarContainer.Position = UDim2.new(0, -110, 0, 0)
    SideBarContainer.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
    SideBarContainer.BorderSizePixel = 0
    SideBarContainer.ZIndex = 1
    SideBarContainer.Parent = MasterFrame

    local S_TopBorder = Instance.new("Frame")
    S_TopBorder.Size = UDim2.new(1, 0, 0, 1)
    S_TopBorder.Position = UDim2.new(0, 0, 0, -1)
    S_TopBorder.BackgroundColor3 = Color3.fromRGB(56, 56, 56)
    S_TopBorder.BorderSizePixel = 0
    S_TopBorder.ZIndex = 2
    S_TopBorder.Parent = SideBarContainer

    local S_BotBorder = Instance.new("Frame")
    S_BotBorder.Size = UDim2.new(1, 0, 0, 1)
    S_BotBorder.Position = UDim2.new(0, 0, 1, 0)
    S_BotBorder.BackgroundColor3 = Color3.fromRGB(56, 56, 56)
    S_BotBorder.BorderSizePixel = 0
    S_BotBorder.ZIndex = 2
    S_BotBorder.Parent = SideBarContainer

    local S_LeftBorder = Instance.new("Frame")
    S_LeftBorder.Size = UDim2.new(0, 1, 1, 0)
    S_LeftBorder.Position = UDim2.new(0, -1, 0, 0)
    S_LeftBorder.BackgroundColor3 = Color3.fromRGB(56, 56, 56)
    S_LeftBorder.BorderSizePixel = 0
    S_LeftBorder.ZIndex = 2
    S_LeftBorder.Parent = SideBarContainer

    local SideBarMask = Instance.new("Frame")
    SideBarMask.Name = "SideBarMask"
    SideBarMask.Size = UDim2.new(0, 110, 1, 0)
    SideBarMask.Position = UDim2.new(0, 0, 0, 0)
    SideBarMask.BackgroundTransparency = 1
    SideBarMask.ClipsDescendants = true
    SideBarMask.ZIndex = 3
    SideBarMask.Parent = SideBarContainer

    local MainBg = Instance.new("Frame")
    MainBg.Name = "MainBg"
    MainBg.Size = UDim2.new(1, 0, 1, 0)
    MainBg.Position = UDim2.new(0, 0, 0, 0)
    MainBg.BackgroundColor3 = Color3.fromRGB(11, 11, 11)
    MainBg.BorderColor3 = Color3.fromRGB(56, 56, 56)
    MainBg.BorderSizePixel = 1
    MainBg.ZIndex = 10
    MainBg.Parent = MasterFrame

    local TopBar = Instance.new("Frame")
    TopBar.Name = "TopBar"
    TopBar.BackgroundColor3 = Color3.fromRGB(23, 23, 23)
    TopBar.BorderSizePixel = 0
    TopBar.Size = UDim2.new(1, 0, 0, 22)
    TopBar.ZIndex = 11
    TopBar.Parent = MainBg

    local TopLabel = Instance.new("TextLabel")
    TopLabel.Text = string.format("            %s  |  %s Toggle", TitleText, KeyName)
    TopLabel.FontFace = InconFont
    TopLabel.TextSize = 12
    TopLabel.TextColor3 = Color3.fromRGB(181, 181, 181)
    TopLabel.TextXAlignment = Enum.TextXAlignment.Left
    TopLabel.BackgroundTransparency = 1
    TopLabel.Size = UDim2.new(1, -10, 1, 0)
    TopLabel.Position = UDim2.new(0, 4, 0, 0)
    TopLabel.ZIndex = 12
    TopLabel.Parent = TopBar

    local dragToggle = nil
    local dragSpeed = 0.25
    local dragStart = nil
    local startPos = nil

    local function updateInput(input)
        local delta = input.Position - dragStart
        local position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        TS:Create(MasterFrame, TweenInfo.new(dragSpeed), {Position = position}):Play()
    end

    table.insert(Window.Connections, TopBar.InputBegan:Connect(function(input)
        if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then 
            dragToggle = true
            dragStart = input.Position
            startPos = MasterFrame.Position
            local changeCon
            changeCon = input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragToggle = false
                    changeCon:Disconnect()
                end
            end)
        end
    end))

    local dragCon
    dragCon = UIS.InputChanged:Connect(function(input)
        if not MasterFrame:IsDescendantOf(game) then dragCon:Disconnect() return end
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            if dragToggle then
                updateInput(input)
            end
        end
    end)
    table.insert(Window.Connections, dragCon)

    local toggleCon
    toggleCon = UIS.InputBegan:Connect(function(input, gp)
        if not MasterFrame:IsDescendantOf(game) then toggleCon:Disconnect() return end
        if not gp and input.KeyCode == BindKey then
            MasterFrame.Visible = not MasterFrame.Visible
        end
    end)
    table.insert(Window.Connections, toggleCon)

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
    ToggleBtn.Parent = MainBg

    local isOpen = true
    table.insert(Window.Connections, ToggleBtn.MouseButton1Click:Connect(function()
        isOpen = not isOpen
        ToggleBtn.Text = isOpen and "<" or ">"
        TS:Create(SideBarContainer, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2.new(0, isOpen and 0 or -110, 0, 0)}):Play()
    end))

    local Logo = Instance.new("ImageLabel")
    Logo.Size = UDim2.new(0, 56, 0, 56)
    Logo.Position = UDim2.new(0.5, -28, 0, 12)
    Logo.Image = "rbxthumb://type=AvatarHeadShot&id="..LP.UserId.."&w=150&h=150"
    Logo.BackgroundTransparency = 1
    Logo.ZIndex = 4
    Instance.new("UICorner", Logo).CornerRadius = UDim.new(1, 0)
    Logo.Parent = SideBarMask

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, -10, 0, 45)
    Title.Position = UDim2.new(0, 5, 0, 75)
    Title.BackgroundTransparency = 1
    Title.ZIndex = 4
    Title.Font = Enum.Font.Code
    Title.TextSize = 11
    Title.TextColor3 = Color3.fromRGB(200, 200, 200)
    Title.TextWrapped = true
    Title.RichText = true
    Title.Parent = SideBarMask

    local RainbowLoop
    RainbowLoop = RS.RenderStepped:Connect(function()
        if not Title:IsDescendantOf(game) then RainbowLoop:Disconnect() return end
        if not MasterFrame.Visible then return end
        local hue = os.clock() % 4 / 4
        local c = Color3.fromHSV(hue, 1, 1)
        local hex = string.format("#%02X%02X%02X", c.R*255, c.G*255, c.B*255)
        Title.Text = 'Welcome <font color="'..hex..'">'..LP.Name..'</font>\nto\n'..TitleText
    end)
    table.insert(Window.Connections, RainbowLoop)

    local TabContainer = Instance.new("ScrollingFrame")
    TabContainer.Size = UDim2.new(1, 0, 1, -125)
    TabContainer.Position = UDim2.new(0, 0, 0, 125)
    TabContainer.BackgroundTransparency = 1
    TabContainer.BorderSizePixel = 0
    TabContainer.ScrollBarThickness = 0
    TabContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
    TabContainer.AutomaticCanvasSize = Enum.AutomaticSize.Y
    TabContainer.ZIndex = 4
    TabContainer.Parent = SideBarMask

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
    PageMask.ZIndex = 11
    PageMask.Parent = MainBg

    function Window:InitFolder()
        if isfolder and makefolder then
            if not isfolder(ConfigFolder) then makefolder(ConfigFolder) end
            if not isfolder(ConfigFolder .. "/settings") then makefolder(ConfigFolder .. "/settings") end
        end
    end

    function Window:GetConfigs()
        local list = {}
        if listfiles and isfolder and isfolder(ConfigFolder .. "/settings") then
            for _, file in ipairs(listfiles(ConfigFolder .. "/settings")) do
                if file:sub(-5) == ".json" then
                    local name = file:match("([^/\\]+)%.json$")
                    if name then table.insert(list, name) end
                end
            end
        end
        return list
    end

    function Window:SaveConfig(Name)
        if not writefile then return false end
        Window:InitFolder()
        local data = Http:JSONEncode(Window.Flags)
        writefile(ConfigFolder .. "/settings/" .. Name .. ".json", data)
        return true
    end

    function Window:LoadConfig(Name)
        if not readfile or not isfile then return false end
        local path = ConfigFolder .. "/settings/" .. Name .. ".json"
        if isfile(path) then
            local s, d = pcall(function() return Http:JSONDecode(readfile(path)) end)
            if s and d then
                for flag, value in pairs(d) do
                    if Window.Elements[flag] then
                        task.spawn(function() Window.Elements[flag].SetValue(value) end)
                    end
                end
                return true
            end
        end
        return false
    end

    function Window:DeleteConfig(Name)
        if not isfile or not delfile then return false end
        local path = ConfigFolder .. "/settings/" .. Name .. ".json"
        if isfile(path) then
            delfile(path)
            return true
        end
        return false
    end

    function Window:SetAutoload(Name)
        if not writefile then return end
        Window:InitFolder()
        writefile(ConfigFolder .. "/settings/autoload.txt", Name)
    end

    function Window:GetAutoload()
        if readfile and isfile then
            local path = ConfigFolder .. "/settings/autoload.txt"
            if isfile(path) then
                local content = readfile(path)
                if content and content ~= "" then return content end
            end
        end
        return nil
    end

    function Window:ClearAutoload()
        if writefile then
            Window:InitFolder()
            writefile(ConfigFolder .. "/settings/autoload.txt", "")
        end
    end

    function Window:AutoLoad()
        local currentAuto = Window:GetAutoload()
        if currentAuto then
            if Window:LoadConfig(currentAuto) then
                InconUI:MakeNotify({
                    Title = "Config Manager",
                    Content = "Auto Loaded Config: " .. currentAuto,
                    Time = 4
                })
            end
        end
    end

    function Window:CreateTab(TabName)
        Window.TabIndex = Window.TabIndex + 1
        local CurrentIndex = Window.TabIndex
        local Tab = {}
        
        local TabPage = Instance.new("ScrollingFrame")
        TabPage.Name = TabName
        TabPage.Size = UDim2.new(1, 0, 1, 0)
        TabPage.BackgroundTransparency = 1
        TabPage.BorderSizePixel = 0
        TabPage.ScrollBarThickness = 0
        TabPage.CanvasSize = UDim2.new(0, 0, 0, 0)
        TabPage.AutomaticCanvasSize = Enum.AutomaticSize.Y
        TabPage.Visible = false
        TabPage.ZIndex = 12
        TabPage:SetAttribute("TabIndex", CurrentIndex)
        TabPage.Parent = PageMask

        local PageLayout = Instance.new("UIListLayout", TabPage)
        PageLayout.SortOrder = Enum.SortOrder.LayoutOrder
        PageLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
        PageLayout.Padding = UDim.new(0, 5)

        local Pad = Instance.new("UIPadding", TabPage)
        Pad.PaddingTop = UDim.new(0, 5)
        Pad.PaddingBottom = UDim.new(0, 10)
        Pad.PaddingLeft = UDim.new(0, 5)
        Pad.PaddingRight = UDim.new(0, 5)

        local TabBtn = Instance.new("TextButton")
        TabBtn.Size = UDim2.new(0.9, 0, 0, 28)
        TabBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
        TabBtn.BorderColor3 = Color3.fromRGB(50, 50, 50)
        TabBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
        TabBtn.Text = TabName
        TabBtn.Font = Enum.Font.Code
        TabBtn.TextSize = 11
        TabBtn.ZIndex = 5
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
                task.delay(0.35, function() if Window.CurrentPage ~= TempPage then TempPage.Visible = false end end)
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

        function Tab:CreateSection(Name)
            local Sec = Instance.new("Frame")
            Sec.Size = UDim2.new(1, 0, 0, 30)
            Sec.BackgroundTransparency = 1
            Sec.ZIndex = 13
            Sec.Parent = TabPage

            local Lbl = Instance.new("TextLabel")
            Lbl.Size = UDim2.new(1, -10, 1, 0)
            Lbl.Position = UDim2.new(0, 5, 0, 0)
            Lbl.BackgroundTransparency = 1
            Lbl.Text = Name
            Lbl.TextColor3 = Color3.fromRGB(255, 255, 255)
            Lbl.TextXAlignment = Enum.TextXAlignment.Center
            Lbl.FontFace = InconFont
            Lbl.TextSize = 13
            Lbl.ZIndex = 14
            Lbl.Parent = Sec

            local Div = Instance.new("Frame")
            Div.Size = UDim2.new(1, -10, 0, 1)
            Div.Position = UDim2.new(0, 5, 1, -2)
            Div.BackgroundColor3 = Color3.fromRGB(56, 56, 56)
            Div.BorderSizePixel = 0
            Div.ZIndex = 14
            Div.Parent = Sec
        end

        function Tab:CreateButton(Options)
            local Btn = Instance.new("TextButton")
            Btn.Size = UDim2.new(1, 0, 0, 30)
            Btn.BackgroundColor3 = Color3.fromRGB(26, 26, 26)
            Btn.BorderColor3 = Color3.fromRGB(51, 51, 51)
            Btn.TextColor3 = Color3.fromRGB(201, 201, 201)
            Btn.Text = Options.Name or "Button"
            Btn.TextXAlignment = Enum.TextXAlignment.Center
            Btn.FontFace = InconFont
            Btn.TextSize = 12
            Btn.AutoButtonColor = false
            Btn.ZIndex = 13
            Btn.Parent = TabPage

            Btn.MouseButton1Click:Connect(function()
                if Options.Callback then Options.Callback() end
            end)
        end

        function Tab:CreateDualButton(Options)
            local Container = Instance.new("Frame")
            Container.Size = UDim2.new(1, 0, 0, 30)
            Container.BackgroundTransparency = 1
            Container.ZIndex = 13
            Container.Parent = TabPage

            local Btn1 = Instance.new("TextButton")
            Btn1.Size = UDim2.new(0.5, -2, 1, 0)
            Btn1.BackgroundColor3 = Color3.fromRGB(26, 26, 26)
            Btn1.BorderColor3 = Color3.fromRGB(51, 51, 51)
            Btn1.TextColor3 = Color3.fromRGB(201, 201, 201)
            Btn1.Text = Options.Name1 or "Button 1"
            Btn1.TextXAlignment = Enum.TextXAlignment.Center
            Btn1.FontFace = InconFont
            Btn1.TextSize = 12
            Btn1.AutoButtonColor = false
            Btn1.ZIndex = 14
            Btn1.Parent = Container
            Btn1.MouseButton1Click:Connect(function() if Options.Callback1 then Options.Callback1() end end)

            local Btn2 = Instance.new("TextButton")
            Btn2.Size = UDim2.new(0.5, -3, 1, 0)
            Btn2.Position = UDim2.new(0.5, 3, 0, 0)
            Btn2.BackgroundColor3 = Color3.fromRGB(26, 26, 26)
            Btn2.BorderColor3 = Color3.fromRGB(51, 51, 51)
            Btn2.TextColor3 = Color3.fromRGB(201, 201, 201)
            Btn2.Text = Options.Name2 or "Button 2"
            Btn2.TextXAlignment = Enum.TextXAlignment.Center
            Btn2.FontFace = InconFont
            Btn2.TextSize = 12
            Btn2.AutoButtonColor = false
            Btn2.ZIndex = 14
            Btn2.Parent = Container
            Btn2.MouseButton1Click:Connect(function() if Options.Callback2 then Options.Callback2() end end)
        end

        function Tab:CreateLabel(Options)
            local LblObj = {}
            local Lbl = Instance.new("TextLabel")
            Lbl.Size = UDim2.new(1, 0, 0, 30)
            Lbl.BackgroundColor3 = Color3.fromRGB(16, 16, 16)
            Lbl.BorderColor3 = Color3.fromRGB(51, 51, 51)
            Lbl.Text = ""
            Lbl.ZIndex = 13
            Lbl.Parent = TabPage

            local Title = Instance.new("TextLabel")
            Title.Size = UDim2.new(1, -20, 1, 0)
            Title.Position = UDim2.new(0, 10, 0, 0)
            Title.BackgroundTransparency = 1
            Title.Text = Options.Name or "Label"
            Title.TextColor3 = Color3.fromRGB(255, 255, 255)
            Title.TextXAlignment = Enum.TextXAlignment.Left
            Title.FontFace = InconFont
            Title.TextSize = 12
            Title.ZIndex = 14
            Title.Parent = Lbl

            function LblObj:SetText(NewText)
                Title.Text = NewText
            end

            return LblObj
        end

        function Tab:CreateToggle(Options)
            local State = Options.Default or false
            local Indicator

            if Options.Flag then
                Window.Flags[Options.Flag] = State
                Window.Elements[Options.Flag] = {
                    SetValue = function(val)
                        if not Indicator or not Indicator:IsDescendantOf(game) then return end
                        State = val
                        Window.Flags[Options.Flag] = State
                        TS:Create(Indicator, TweenInfo.new(0.2), {BackgroundColor3 = State and Color3.fromRGB(0, 170, 0) or Color3.fromRGB(170, 0, 0)}):Play()
                        if Options.Callback then Options.Callback(State) end
                    end
                }
            end

            local Btn = Instance.new("TextButton")
            Btn.Size = UDim2.new(1, 0, 0, 30)
            Btn.BackgroundColor3 = Color3.fromRGB(26, 26, 26)
            Btn.BorderColor3 = Color3.fromRGB(51, 51, 51)
            Btn.Text = ""
            Btn.AutoButtonColor = false
            Btn.ZIndex = 13
            Btn.Parent = TabPage

            local Title = Instance.new("TextLabel")
            Title.Size = UDim2.new(1, -40, 1, 0)
            Title.Position = UDim2.new(0, 10, 0, 0)
            Title.BackgroundTransparency = 1
            Title.Text = Options.Name or "Toggle"
            Title.TextColor3 = Color3.fromRGB(201, 201, 201)
            Title.TextXAlignment = Enum.TextXAlignment.Left
            Title.FontFace = InconFont
            Title.TextSize = 12
            Title.ZIndex = 14
            Title.Parent = Btn

            Indicator = Instance.new("Frame")
            Indicator.Size = UDim2.new(0, 14, 0, 14)
            Indicator.Position = UDim2.new(1, -22, 0.5, -7)
            Indicator.BackgroundColor3 = State and Color3.fromRGB(0, 170, 0) or Color3.fromRGB(170, 0, 0)
            Indicator.BorderColor3 = Color3.fromRGB(51, 51, 51)
            Indicator.ZIndex = 14
            Indicator.Parent = Btn
            Instance.new("UICorner", Indicator).CornerRadius = UDim.new(0, 3)

            Btn.MouseButton1Click:Connect(function()
                State = not State
                if Options.Flag then Window.Flags[Options.Flag] = State end
                TS:Create(Indicator, TweenInfo.new(0.2), {BackgroundColor3 = State and Color3.fromRGB(0, 170, 0) or Color3.fromRGB(170, 0, 0)}):Play()
                if Options.Callback then Options.Callback(State) end
            end)
        end

        function Tab:CreateSlider(Options)
            local Min = Options.Min or 0
            local Max = Options.Max or 100
            local Default = Options.Default or Min
            local CurrentValue = Default
            local SliderFill, ValueBox

            local Btn = Instance.new("TextButton")
            Btn.Size = UDim2.new(1, 0, 0, 40)
            Btn.BackgroundColor3 = Color3.fromRGB(26, 26, 26)
            Btn.BorderColor3 = Color3.fromRGB(51, 51, 51)
            Btn.Text = ""
            Btn.AutoButtonColor = false
            Btn.ZIndex = 13
            Btn.Parent = TabPage

            local TopRow = Instance.new("Frame")
            TopRow.Size = UDim2.new(1, -20, 0.5, 0)
            TopRow.Position = UDim2.new(0, 10, 0, 2)
            TopRow.BackgroundTransparency = 1
            TopRow.ZIndex = 14
            TopRow.Parent = Btn

            local RowLayout = Instance.new("UIListLayout")
            RowLayout.FillDirection = Enum.FillDirection.Horizontal
            RowLayout.SortOrder = Enum.SortOrder.LayoutOrder
            RowLayout.Padding = UDim.new(0, 5)
            RowLayout.VerticalAlignment = Enum.VerticalAlignment.Center
            RowLayout.Parent = TopRow

            local Title = Instance.new("TextLabel")
            Title.Size = UDim2.new(0, 0, 1, 0)
            Title.AutomaticSize = Enum.AutomaticSize.X
            Title.BackgroundTransparency = 1
            Title.TextColor3 = Color3.fromRGB(201, 201, 201)
            Title.TextXAlignment = Enum.TextXAlignment.Left
            Title.Text = Options.Name .. " :"
            Title.FontFace = InconFont
            Title.TextSize = 12
            Title.ZIndex = 14
            Title.Parent = TopRow

            local ValWrap = Instance.new("Frame")
            ValWrap.Size = UDim2.new(0, 35, 0, 20)
            ValWrap.BackgroundTransparency = 1
            ValWrap.ZIndex = 14
            ValWrap.Parent = TopRow

            ValueBox = Instance.new("TextBox")
            ValueBox.Size = UDim2.new(1, 0, 0, 16)
            ValueBox.AnchorPoint = Vector2.new(0, 0.5)
            ValueBox.Position = UDim2.new(0, 0, 0.5, 2)
            ValueBox.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
            ValueBox.BorderSizePixel = 0
            ValueBox.TextColor3 = Color3.fromRGB(201, 201, 201)
            ValueBox.Text = tostring(Default)
            ValueBox.FontFace = InconFont
            ValueBox.TextSize = 11
            ValueBox.ZIndex = 15
            ValueBox.Parent = ValWrap
            Instance.new("UICorner", ValueBox).CornerRadius = UDim.new(0, 3)

            local SliderBack = Instance.new("Frame")
            SliderBack.Size = UDim2.new(1, -20, 0, 6)
            SliderBack.Position = UDim2.new(0, 10, 0.65, 0)
            SliderBack.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
            SliderBack.BorderColor3 = Color3.fromRGB(51, 51, 51)
            SliderBack.ZIndex = 14
            SliderBack.Parent = Btn
            Instance.new("UICorner", SliderBack).CornerRadius = UDim.new(1, 0)

            SliderFill = Instance.new("Frame")
            SliderFill.Size = UDim2.new((Default - Min) / (Max - Min), 0, 1, 0)
            SliderFill.BackgroundColor3 = Color3.fromRGB(181, 181, 181)
            SliderFill.BorderSizePixel = 0
            SliderFill.ZIndex = 15
            SliderFill.Parent = SliderBack
            Instance.new("UICorner", SliderFill).CornerRadius = UDim.new(1, 0)

            if Options.Flag then
                Window.Flags[Options.Flag] = Default
                Window.Elements[Options.Flag] = {
                    SetValue = function(val)
                        if not SliderFill or not SliderFill:IsDescendantOf(game) then return end
                        local num = math.clamp(tonumber(val) or Min, Min, Max)
                        CurrentValue = num
                        Window.Flags[Options.Flag] = num
                        local pos = (num - Min) / (Max - Min)
                        TS:Create(SliderFill, TweenInfo.new(0.2), {Size = UDim2.new(pos, 0, 1, 0)}):Play()
                        ValueBox.Text = tostring(num)
                        if Options.Callback then Options.Callback(num) end
                    end
                }
            end

            local dragging = false
            local function update(input)
                local pos = math.clamp((input.Position.X - SliderBack.AbsolutePosition.X) / SliderBack.AbsoluteSize.X, 0, 1)
                local value = math.floor(Min + ((Max - Min) * pos))
                CurrentValue = value
                if Options.Flag then Window.Flags[Options.Flag] = value end
                TS:Create(SliderFill, TweenInfo.new(0.05), {Size = UDim2.new(pos, 0, 1, 0)}):Play()
                ValueBox.Text = tostring(value)
                if Options.Callback then Options.Callback(value) end
            end

            Btn.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    dragging = true
                    update(input)
                end
            end)

            local sEndCon
            sEndCon = UIS.InputEnded:Connect(function(input)
                if not Btn:IsDescendantOf(game) then sEndCon:Disconnect() return end
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    dragging = false
                end
            end)

            local sChgCon
            sChgCon = UIS.InputChanged:Connect(function(input)
                if not Btn:IsDescendantOf(game) then sChgCon:Disconnect() return end
                if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                    update(input)
                end
            end)

            ValueBox.FocusLost:Connect(function()
                local num = tonumber(ValueBox.Text)
                if num then
                    num = math.clamp(math.floor(num), Min, Max)
                    CurrentValue = num
                    if Options.Flag then Window.Flags[Options.Flag] = num end
                    local pos = (num - Min) / (Max - Min)
                    TS:Create(SliderFill, TweenInfo.new(0.2), {Size = UDim2.new(pos, 0, 1, 0)}):Play()
                    ValueBox.Text = tostring(num)
                    if Options.Callback then Options.Callback(num) end
                else
                    ValueBox.Text = tostring(CurrentValue)
                end
            end)
        end

        function Tab:CreateTextbox(Options)
            local BoxObj = {}
            local BoxContainer = Instance.new("Frame")
            BoxContainer.Size = UDim2.new(1, 0, 0, 30)
            BoxContainer.BackgroundColor3 = Color3.fromRGB(26, 26, 26)
            BoxContainer.BorderColor3 = Color3.fromRGB(51, 51, 51)
            BoxContainer.ZIndex = 13
            BoxContainer.Parent = TabPage

            local Lbl = Instance.new("TextLabel")
            Lbl.Size = UDim2.new(0.5, 0, 1, 0)
            Lbl.Position = UDim2.new(0, 10, 0, 0)
            Lbl.BackgroundTransparency = 1
            Lbl.Text = Options.Name or "Textbox"
            Lbl.TextColor3 = Color3.fromRGB(201, 201, 201)
            Lbl.TextXAlignment = Enum.TextXAlignment.Left
            Lbl.FontFace = InconFont
            Lbl.TextSize = 12
            Lbl.ZIndex = 14
            Lbl.Parent = BoxContainer

            local TxtBox = Instance.new("TextBox")
            TxtBox.AnchorPoint = Vector2.new(1, 0.5)
            TxtBox.Size = UDim2.new(0.4, 0, 0, 20)
            TxtBox.Position = UDim2.new(1, -10, 0.5, 0)
            TxtBox.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
            TxtBox.BorderColor3 = Color3.fromRGB(51, 51, 51)
            TxtBox.TextColor3 = Color3.fromRGB(255, 255, 255)
            TxtBox.PlaceholderText = Options.Placeholder or ""
            TxtBox.Text = ""
            TxtBox.FontFace = InconFont
            TxtBox.TextSize = 11
            TxtBox.ZIndex = 14
            TxtBox.Parent = BoxContainer
            Instance.new("UICorner", TxtBox).CornerRadius = UDim.new(0, 3)

            if Options.Flag then
                Window.Flags[Options.Flag] = ""
                Window.Elements[Options.Flag] = {
                    SetValue = function(val)
                        if not TxtBox or not TxtBox:IsDescendantOf(game) then return end
                        TxtBox.Text = tostring(val)
                        Window.Flags[Options.Flag] = TxtBox.Text
                        if Options.Callback then Options.Callback(TxtBox.Text) end
                    end
                }
            end

            TxtBox.FocusLost:Connect(function()
                if Options.Flag then Window.Flags[Options.Flag] = TxtBox.Text end
                if Options.Callback then Options.Callback(TxtBox.Text) end
            end)

            function BoxObj:SetText(val)
                if TxtBox and TxtBox:IsDescendantOf(game) then
                    TxtBox.Text = tostring(val)
                end
            end

            function BoxObj:GetText()
                if TxtBox and TxtBox:IsDescendantOf(game) then
                    return TxtBox.Text
                end
                return ""
            end

            return BoxObj
        end

        function Tab:CreateKeybind(Options)
            local Key = Options.Default or Enum.KeyCode.E
            local Waiting = false
            local BindBtn

            local BindContainer = Instance.new("Frame")
            BindContainer.Size = UDim2.new(1, 0, 0, 30)
            BindContainer.BackgroundColor3 = Color3.fromRGB(26, 26, 26)
            BindContainer.BorderColor3 = Color3.fromRGB(51, 51, 51)
            BindContainer.ZIndex = 13
            BindContainer.Parent = TabPage

            local Lbl = Instance.new("TextLabel")
            Lbl.Size = UDim2.new(0.5, 0, 1, 0)
            Lbl.Position = UDim2.new(0, 10, 0, 0)
            Lbl.BackgroundTransparency = 1
            Lbl.Text = Options.Name or "Keybind"
            Lbl.TextColor3 = Color3.fromRGB(201, 201, 201)
            Lbl.TextXAlignment = Enum.TextXAlignment.Left
            Lbl.FontFace = InconFont
            Lbl.TextSize = 12
            Lbl.ZIndex = 14
            Lbl.Parent = BindContainer

            BindBtn = Instance.new("TextButton")
            BindBtn.AnchorPoint = Vector2.new(1, 0.5)
            BindBtn.Size = UDim2.new(0, 60, 0, 20)
            BindBtn.Position = UDim2.new(1, -10, 0.5, 0)
            BindBtn.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
            BindBtn.BorderColor3 = Color3.fromRGB(51, 51, 51)
            BindBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            BindBtn.Text = Key.Name
            BindBtn.FontFace = InconFont
            BindBtn.TextSize = 11
            BindBtn.AutoButtonColor = false
            BindBtn.ZIndex = 14
            BindBtn.Parent = BindContainer
            Instance.new("UICorner", BindBtn).CornerRadius = UDim.new(0, 3)

            if Options.Flag then
                Window.Flags[Options.Flag] = Key.Name
                Window.Elements[Options.Flag] = {
                    SetValue = function(val)
                        if not BindBtn or not BindBtn:IsDescendantOf(game) then return end
                        local s, e = pcall(function() return Enum.KeyCode[val] end)
                        if s and e then
                            Key = e
                            BindBtn.Text = Key.Name
                            Window.Flags[Options.Flag] = Key.Name
                        end
                    end
                }
            end

            local waitToken = 0
            BindBtn.MouseButton1Click:Connect(function()
                Waiting = true
                BindBtn.Text = "..."
                waitToken = waitToken + 1
                local myToken = waitToken
                task.delay(5, function()
                    if Waiting and waitToken == myToken then
                        Waiting = false
                        BindBtn.Text = Key.Name
                    end
                end)
            end)

            local kbCon
            kbCon = UIS.InputBegan:Connect(function(input, gp)
                if not BindContainer:IsDescendantOf(game) then kbCon:Disconnect() return end
                if Waiting and input.UserInputType == Enum.UserInputType.Keyboard then
                    Key = input.KeyCode
                    BindBtn.Text = Key.Name
                    if Options.Flag then Window.Flags[Options.Flag] = Key.Name end
                    Waiting = false
                elseif not gp and input.KeyCode == Key and not Waiting then
                    if Options.Callback then Options.Callback() end
                end
            end)
        end

        function Tab:CreateDropdown(Options)
            local List = Options.List or {}
            local isOpen = false
            local DropObj = {}
            local Btn, DropContainer, DropList, Title

            DropContainer = Instance.new("Frame")
            DropContainer.Size = UDim2.new(1, 0, 0, 30)
            DropContainer.BackgroundColor3 = Color3.fromRGB(26, 26, 26)
            DropContainer.BorderColor3 = Color3.fromRGB(51, 51, 51)
            DropContainer.ClipsDescendants = true
            DropContainer.ZIndex = 13
            DropContainer.Parent = TabPage

            Btn = Instance.new("TextButton")
            Btn.Size = UDim2.new(1, 0, 0, 30)
            Btn.BackgroundTransparency = 1
            Btn.Text = ""
            Btn.AutoButtonColor = false
            Btn.ZIndex = 14
            Btn.Parent = DropContainer

            Title = Instance.new("TextLabel")
            Title.Size = UDim2.new(1, -30, 1, 0)
            Title.Position = UDim2.new(0, 10, 0, 0)
            Title.BackgroundTransparency = 1
            Title.Text = Options.Name .. " : None"
            Title.TextColor3 = Color3.fromRGB(201, 201, 201)
            Title.TextXAlignment = Enum.TextXAlignment.Left
            Title.FontFace = InconFont
            Title.TextSize = 12
            Title.ZIndex = 15
            Title.Parent = Btn

            local Icon = Instance.new("TextLabel")
            Icon.Size = UDim2.new(0, 20, 0, 30)
            Icon.Position = UDim2.new(1, -25, 0, 0)
            Icon.BackgroundTransparency = 1
            Icon.TextColor3 = Color3.fromRGB(151, 151, 151)
            Icon.Text = "V"
            Icon.FontFace = InconFont
            Icon.TextSize = 12
            Icon.ZIndex = 15
            Icon.Parent = Btn

            DropList = Instance.new("ScrollingFrame")
            DropList.Size = UDim2.new(1, 0, 1, -30)
            DropList.Position = UDim2.new(0, 0, 0, 30)
            DropList.BackgroundTransparency = 1
            DropList.BorderSizePixel = 0
            DropList.ScrollBarThickness = 0
            DropList.ZIndex = 14
            DropList.Parent = DropContainer

            local ListLayout = Instance.new("UIListLayout", DropList)
            ListLayout.SortOrder = Enum.SortOrder.LayoutOrder

            if Options.Flag then
                Window.Flags[Options.Flag] = ""
                Window.Elements[Options.Flag] = {
                    SetValue = function(val)
                        if not Title or not Title:IsDescendantOf(game) then return end
                        Title.Text = Options.Name .. " : " .. tostring(val)
                        Window.Flags[Options.Flag] = tostring(val)
                        if Options.Callback then Options.Callback(val) end
                    end
                }
            end

            local function toggleDrop()
                isOpen = not isOpen
                Icon.Text = isOpen and "^" or "V"
                local targetHeight = isOpen and (30 + math.min(#List * 25, 120)) or 30
                TS:Create(DropContainer, TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = UDim2.new(1, 0, 0, targetHeight)}):Play()
            end

            Btn.MouseButton1Click:Connect(toggleDrop)

            function DropObj:Refresh(newList)
                List = newList
                for _, child in ipairs(DropList:GetChildren()) do
                    if child:IsA("TextButton") then child:Destroy() end
                end
                DropList.CanvasSize = UDim2.new(0, 0, 0, #List * 25)
                if isOpen then
                    local targetHeight = 30 + math.min(#List * 25, 120)
                    TS:Create(DropContainer, TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = UDim2.new(1, 0, 0, targetHeight)}):Play()
                end

                for _, v in ipairs(List) do
                    local Item = Instance.new("TextButton")
                    Item.Size = UDim2.new(1, 0, 0, 25)
                    Item.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
                    Item.BorderSizePixel = 0
                    Item.Text = ""
                    Item.AutoButtonColor = false
                    Item.ZIndex = 15
                    Item.Parent = DropList

                    local ItemLbl = Instance.new("TextLabel")
                    ItemLbl.Size = UDim2.new(1, -20, 1, 0)
                    ItemLbl.Position = UDim2.new(0, 20, 0, 0)
                    ItemLbl.BackgroundTransparency = 1
                    ItemLbl.Text = v
                    ItemLbl.TextColor3 = Color3.fromRGB(180, 180, 180)
                    ItemLbl.TextXAlignment = Enum.TextXAlignment.Left
                    ItemLbl.FontFace = InconFont
                    ItemLbl.TextSize = 11
                    ItemLbl.ZIndex = 16
                    ItemLbl.Parent = Item

                    Item.MouseButton1Click:Connect(function()
                        Title.Text = Options.Name .. " : " .. v
                        if Options.Flag then Window.Flags[Options.Flag] = v end
                        if Options.Callback then Options.Callback(v) end
                        toggleDrop()
                    end)
                end
            end

            function DropObj:SetTitle(newTitle)
                if Title and Title:IsDescendantOf(game) then
                    Title.Text = Options.Name .. " : " .. tostring(newTitle)
                end
            end

            DropObj:Refresh(List)
            return DropObj
        end

        function Tab:CreateMultiDropdown(Options)
            local List = Options.List or {}
            local Selected = Options.Default or {}
            local isOpen = false

            local DropContainer = Instance.new("Frame")
            DropContainer.Size = UDim2.new(1, 0, 0, 30)
            DropContainer.BackgroundColor3 = Color3.fromRGB(26, 26, 26)
            DropContainer.BorderColor3 = Color3.fromRGB(51, 51, 51)
            DropContainer.ClipsDescendants = true
            DropContainer.ZIndex = 13
            DropContainer.Parent = TabPage

            local Btn = Instance.new("TextButton")
            Btn.Size = UDim2.new(1, -25, 0, 30)
            Btn.BackgroundTransparency = 1
            Btn.Text = ""
            Btn.AutoButtonColor = false
            Btn.ZIndex = 14
            Btn.Parent = DropContainer

            local Title = Instance.new("TextLabel")
            Title.Size = UDim2.new(1, -30, 1, 0)
            Title.Position = UDim2.new(0, 10, 0, 0)
            Title.BackgroundTransparency = 1
            Title.TextColor3 = Color3.fromRGB(201, 201, 201)
            Title.TextXAlignment = Enum.TextXAlignment.Left
            Title.TextTruncate = Enum.TextTruncate.AtEnd
            Title.FontFace = InconFont
            Title.TextSize = 12
            Title.ZIndex = 15
            Title.Parent = Btn
            
            local function updateText()
                if #Selected == 0 then
                    Title.Text = Options.Name .. " : None"
                else
                    Title.Text = Options.Name .. " : " .. table.concat(Selected, ", ")
                end
            end
            updateText()

            local IconBtn = Instance.new("TextButton")
            IconBtn.Size = UDim2.new(0, 25, 0, 30)
            IconBtn.Position = UDim2.new(1, -25, 0, 0)
            IconBtn.BackgroundTransparency = 1
            IconBtn.Text = ""
            IconBtn.ZIndex = 15
            IconBtn.Parent = DropContainer

            local Icon = Instance.new("TextLabel")
            Icon.Size = UDim2.new(1, 0, 1, 0)
            Icon.BackgroundTransparency = 1
            Icon.TextColor3 = Color3.fromRGB(151, 151, 151)
            Icon.Text = "V"
            Icon.FontFace = InconFont
            Icon.TextSize = 12
            Icon.ZIndex = 15
            Icon.Parent = IconBtn

            local DropList = Instance.new("ScrollingFrame")
            DropList.Size = UDim2.new(1, 0, 1, -30)
            DropList.Position = UDim2.new(0, 0, 0, 30)
            DropList.BackgroundTransparency = 1
            DropList.BorderSizePixel = 0
            DropList.ScrollBarThickness = 0
            DropList.CanvasSize = UDim2.new(0, 0, 0, #List * 25)
            DropList.ZIndex = 14
            DropList.Parent = DropContainer

            local ListLayout = Instance.new("UIListLayout", DropList)
            ListLayout.SortOrder = Enum.SortOrder.LayoutOrder

            if Options.Flag then
                Window.Flags[Options.Flag] = Selected
                Window.Elements[Options.Flag] = {
                    SetValue = function(val)
                        if not DropList or not DropList:IsDescendantOf(game) then return end
                        if type(val) == "table" then
                            Selected = val
                            Window.Flags[Options.Flag] = Selected
                            updateText()
                            for _, child in ipairs(DropList:GetChildren()) do
                                if child:IsA("TextButton") then
                                    local ItemLbl = child:FindFirstChild("TextLabel")
                                    if ItemLbl then
                                        if table.find(Selected, ItemLbl.Text) then
                                            ItemLbl.TextColor3 = Color3.fromRGB(100, 255, 100)
                                        else
                                            ItemLbl.TextColor3 = Color3.fromRGB(180, 180, 180)
                                        end
                                    end
                                end
                            end
                            if Options.Callback then Options.Callback(Selected) end
                        end
                    end
                }
            end

            local function toggleDrop()
                isOpen = not isOpen
                Icon.Text = isOpen and "^" or "V"
                local targetHeight = isOpen and (30 + math.min(#List * 25, 120)) or 30
                TS:Create(DropContainer, TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = UDim2.new(1, 0, 0, targetHeight)}):Play()
            end

            Btn.MouseButton1Click:Connect(toggleDrop)
            IconBtn.MouseButton1Click:Connect(toggleDrop)

            for _, v in ipairs(List) do
                local isSel = table.find(Selected, v) ~= nil
                local Item = Instance.new("TextButton")
                Item.Size = UDim2.new(1, 0, 0, 25)
                Item.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
                Item.BorderSizePixel = 0
                Item.Text = ""
                Item.AutoButtonColor = false
                Item.ZIndex = 15
                Item.Parent = DropList

                local ItemLbl = Instance.new("TextLabel")
                ItemLbl.Size = UDim2.new(1, -20, 1, 0)
                ItemLbl.Position = UDim2.new(0, 20, 0, 0)
                ItemLbl.BackgroundTransparency = 1
                ItemLbl.Text = v
                ItemLbl.TextColor3 = isSel and Color3.fromRGB(100, 255, 100) or Color3.fromRGB(180, 180, 180)
                ItemLbl.TextXAlignment = Enum.TextXAlignment.Left
                ItemLbl.FontFace = InconFont
                ItemLbl.TextSize = 11
                ItemLbl.ZIndex = 16
                ItemLbl.Parent = Item

                Item.MouseButton1Click:Connect(function()
                    local idx = table.find(Selected, v)
                    if idx then
                        table.remove(Selected, idx)
                        ItemLbl.TextColor3 = Color3.fromRGB(180, 180, 180)
                    else
                        table.insert(Selected, v)
                        ItemLbl.TextColor3 = Color3.fromRGB(100, 255, 100)
                    end
                    updateText()
                    if Options.Flag then Window.Flags[Options.Flag] = Selected end
                    if Options.Callback then Options.Callback(Selected) end
                end)
            end
        end

        function Tab:CreateUpdateLog(entry)
            local COL = {
                card   = Color3.fromRGB(25, 25, 25),
                stroke = Color3.fromRGB(50, 50, 50),
                ver    = Color3.fromRGB(220, 220, 220),
                add    = Color3.fromRGB(100, 255, 100),
                change = Color3.fromRGB(255, 210, 90),
                remove = Color3.fromRGB(255, 90, 90),
                text   = Color3.fromRGB(200, 200, 200),
                hint   = Color3.fromRGB(120, 180, 255),
            }
            local KIND_COL = { ["+"] = COL.add, ["~"] = COL.change, ["-"] = COL.remove }
            local HEADER_H = 18
            local LINE_H = 16
            local LINE_GAP = 3
            local PAD_V = 6
            local HINT_H = 14
            local IS_TOUCH = UIS.TouchEnabled and not UIS.MouseEnabled

            local function measureText(text, availW)
                return TSvc:GetTextSize(text, 11, Enum.Font.Code, Vector2.new(availW, math.huge))
            end

            local function cardHeight(sumLines, n, canExpand)
                local h = PAD_V + HEADER_H + LINE_GAP + sumLines + math.max(0, n - 1) * LINE_GAP + PAD_V
                if canExpand then h = h + HINT_H end
                return h
            end

            local n = #entry.changes
            local canExpand = entry.expandable == true
            local collapsedH = cardHeight(n * LINE_H, n, canExpand)

            local card = Instance.new("TextButton")
            card.Size = UDim2.new(1, -6, 0, collapsedH)
            card.BackgroundColor3 = COL.card
            card.BorderSizePixel = 1
            card.BorderColor3 = COL.stroke
            card.AutoButtonColor = false
            card.Text = ""
            card.Active = canExpand
            card.Selectable = canExpand
            card.ClipsDescendants = true
            card.ZIndex = 13
            card.Parent = TabPage

            local content = Instance.new("Frame")
            content.Size = UDim2.new(1, 0, 1, 0)
            content.BackgroundTransparency = 1
            content.ZIndex = 14
            content.Parent = card

            local cpad = Instance.new("UIPadding")
            cpad.PaddingTop = UDim.new(0, PAD_V)
            cpad.PaddingBottom = UDim.new(0, PAD_V)
            cpad.PaddingLeft = UDim.new(0, 8)
            cpad.PaddingRight = UDim.new(0, 8)
            cpad.Parent = content

            local clist = Instance.new("UIListLayout")
            clist.Padding = UDim.new(0, LINE_GAP)
            clist.SortOrder = Enum.SortOrder.LayoutOrder
            clist.Parent = content

            local header = Instance.new("TextLabel")
            header.BackgroundTransparency = 1
            header.Size = UDim2.new(1, 0, 0, HEADER_H)
            header.Font = Enum.Font.Code
            header.RichText = true
            header.Text = string.format('<b>%s</b>  <font color="rgb(120,120,120)">%s</font>', entry.ver, entry.date)
            header.TextColor3 = COL.ver
            header.TextSize = 13
            header.TextXAlignment = Enum.TextXAlignment.Left
            header.LayoutOrder = 0
            header.ZIndex = 15
            header.Parent = content

            local lines = {}
            for i, ch in ipairs(entry.changes) do
                local kind, desc = ch[1], ch[2]
                local lbl = Instance.new("TextLabel")
                lbl.BackgroundTransparency = 1
                lbl.Size = UDim2.new(1, 0, 0, LINE_H)
                lbl.Font = Enum.Font.Code
                lbl.Text = string.format("[%s] %s", kind, desc)
                lbl.TextColor3 = KIND_COL[kind] or COL.text
                lbl.TextSize = 11
                lbl.TextXAlignment = Enum.TextXAlignment.Left
                lbl.TextYAlignment = Enum.TextYAlignment.Top
                lbl.TextTruncate = Enum.TextTruncate.AtEnd
                lbl.LayoutOrder = i
                lbl.ZIndex = 15
                lbl.Parent = content
                lines[i] = lbl
            end

            if canExpand then
                local hint = Instance.new("TextLabel")
                hint.AnchorPoint = Vector2.new(1, 1)
                hint.Position = UDim2.new(1, -8, 1, -5)
                hint.Size = UDim2.new(0, 150, 0, HINT_H)
                hint.BackgroundTransparency = 1
                hint.Font = Enum.Font.Code
                hint.Text = "▼ Click To Expand"
                hint.TextColor3 = COL.hint
                hint.TextSize = 10
                hint.TextXAlignment = Enum.TextXAlignment.Right
                hint.TextTransparency = IS_TOUCH and 0.4 or 1
                hint.ZIndex = 16
                hint.Parent = card

                local expanded = false
                local fadeIn = TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

                if not IS_TOUCH then
                    card.MouseEnter:Connect(function()
                        TS:Create(hint, fadeIn, {TextTransparency = 0}):Play()
                    end)
                    card.MouseLeave:Connect(function()
                        TS:Create(hint, fadeIn, {TextTransparency = 1}):Play()
                    end)
                end

                local function toggleExpand()
                    expanded = not expanded
                    local availW = math.max(50, card.AbsoluteSize.X - 16)
                    local sumLines = 0
                    for _, lbl in ipairs(lines) do
                        if expanded then
                            lbl.TextTruncate = Enum.TextTruncate.None
                            lbl.TextWrapped = true
                            local b = measureText(lbl.Text, availW)
                            local h = math.max(LINE_H, math.ceil(b.Y) + 2)
                            lbl.Size = UDim2.new(1, 0, 0, h)
                            sumLines = sumLines + h
                        else
                            lbl.TextWrapped = false
                            lbl.TextTruncate = Enum.TextTruncate.AtEnd
                            lbl.Size = UDim2.new(1, 0, 0, LINE_H)
                            sumLines = sumLines + LINE_H
                        end
                    end
                    local goal = UDim2.new(1, -6, 0, cardHeight(sumLines, #lines, true))
                    TS:Create(card, TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = goal}):Play()
                    hint.Text = expanded and "▲ Click To Collapse" or "▼ Click To Expand"
                end

                card.MouseButton1Click:Connect(toggleExpand)
            end
        end

        return Tab
    end

    function Window:BuildSaveManager(TargetTab)
        TargetTab:CreateSection("Configuration")
        
        local ConfigBox = TargetTab:CreateTextbox({
            Name = "Config Name",
            Placeholder = "Enter Name..."
        })

        local ConfigList = TargetTab:CreateDropdown({
            Name = "Config List",
            List = Window:GetConfigs(),
            Callback = function(val) 
                ConfigBox:SetText(val)
            end
        })

        TargetTab:CreateDualButton({
            Name1 = "Create Config",
            Callback1 = function()
                local ConfigName = ConfigBox:GetText()
                if ConfigName == "" then
                    InconUI:MakeNotify({Title = "Config Error", Content = "Please Enter A Config Name!", Time = 3})
                    return
                end
                Window:SaveConfig(ConfigName)
                ConfigList:Refresh(Window:GetConfigs())
                InconUI:MakeNotify({Title = "Config Manager", Content = "Created Config " .. ConfigName, Time = 3})
            end,
            Name2 = "Load Config",
            Callback2 = function()
                local ConfigName = ConfigBox:GetText()
                if ConfigName == "" then
                    InconUI:MakeNotify({Title = "Config Error", Content = "Please Select Or Enter A Config!", Time = 3})
                    return
                end
                if Window:LoadConfig(ConfigName) then
                    InconUI:MakeNotify({Title = "Config Manager", Content = "Loaded Config " .. ConfigName, Time = 3})
                else
                    InconUI:MakeNotify({Title = "Config Error", Content = "Config Not Found!", Time = 3})
                end
            end
        })

        TargetTab:CreateDualButton({
            Name1 = "Overwrite Config",
            Callback1 = function()
                local ConfigName = ConfigBox:GetText()
                if ConfigName == "" then
                    InconUI:MakeNotify({Title = "Config Error", Content = "Please Select Or Enter A Config!", Time = 3})
                    return
                end
                Window:SaveConfig(ConfigName)
                InconUI:MakeNotify({Title = "Config Manager", Content = "Overwrote Config " .. ConfigName, Time = 3})
            end,
            Name2 = "Delete Config",
            Callback2 = function()
                local ConfigName = ConfigBox:GetText()
                if ConfigName == "" then
                    InconUI:MakeNotify({Title = "Config Error", Content = "Please Select Or Enter A Config!", Time = 3})
                    return
                end
                if Window:DeleteConfig(ConfigName) then
                    ConfigList:Refresh(Window:GetConfigs())
                    ConfigList:SetTitle("None")
                    ConfigBox:SetText("")
                    InconUI:MakeNotify({Title = "Config Manager", Content = "Deleted Config " .. ConfigName, Time = 3})
                    local currentAuto = Window:GetAutoload()
                    if currentAuto == ConfigName then
                        Window:ClearAutoload()
                    end
                else
                    InconUI:MakeNotify({Title = "Config Error", Content = "Config Not Found!", Time = 3})
                end
            end
        })

        TargetTab:CreateButton({
            Name = "Refresh List",
            Callback = function()
                ConfigList:Refresh(Window:GetConfigs())
                InconUI:MakeNotify({Title = "Config Manager", Content = "List Refreshed!", Time = 3})
            end
        })

        local autoLbl = TargetTab:CreateLabel({Name = "Current Autoload: None"})

        TargetTab:CreateDualButton({
            Name1 = "Set As Autoload",
            Callback1 = function()
                local ConfigName = ConfigBox:GetText()
                if ConfigName == "" then
                    InconUI:MakeNotify({Title = "Config Error", Content = "Please Select Or Enter A Config!", Time = 3})
                    return
                end
                Window:SetAutoload(ConfigName)
                autoLbl:SetText("Current Autoload: " .. ConfigName)
                InconUI:MakeNotify({Title = "Config Manager", Content = "Set " .. ConfigName .. " To Autoload", Time = 3})
            end,
            Name2 = "Clear Autoload",
            Callback2 = function()
                local currentAuto = Window:GetAutoload()
                if not currentAuto or currentAuto == "" then
                    InconUI:MakeNotify({Title = "Config Error", Content = "No Autoload Config To Clear!", Time = 3})
                    return
                end
                Window:ClearAutoload()
                autoLbl:SetText("Current Autoload: None")
                InconUI:MakeNotify({Title = "Config Manager", Content = "Cleared Autoload Config", Time = 3})
            end
        })
        
        local currentAuto = Window:GetAutoload()
        if currentAuto and currentAuto ~= "" then
            autoLbl:SetText("Current Autoload: " .. currentAuto)
        end
    end

    function Window:Destroy()
        for _, con in ipairs(Window.Connections) do
            pcall(function() con:Disconnect() end)
        end
        Window.Connections = {}
        Window.Pages = {}
        Window.CurrentPage = nil
        Window.Flags = {}
        Window.Elements = {}
        if ScreenGui and ScreenGui.Parent then
            ScreenGui:Destroy()
        end
    end

    return Window
end

return InconUI
