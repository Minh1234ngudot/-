local InconUI = {}
local TS = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")
local RS = game:GetService("RunService")
local Players = game:GetService("Players")
local TSvc = game:GetService("TextService")
local LP = Players.LocalPlayer
local InconFont = Font.new("rbxasset://fonts/families/Inconsolata.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)

function InconUI:CreateWindow(Options)
    Options = Options or {}
    local TitleText = Options.Name or "Incon UI Hub"
    local BindKey = Options.ToggleKey or Enum.KeyCode.RightControl
    local KeyName = (BindKey == Enum.KeyCode.RightControl) and "RCtrl" or BindKey.Name
    local Window = { CurrentPage = nil, Pages = {}, TabIndex = 0 }
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
    MainFrame.BorderSizePixel = 1
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
    TopLabel.Text = string.format("            %s  |  %s Toggle", TitleText, KeyName)
    TopLabel.FontFace = InconFont
    TopLabel.TextSize = 12
    TopLabel.TextColor3 = Color3.fromRGB(181, 181, 181)
    TopLabel.TextXAlignment = Enum.TextXAlignment.Left
    TopLabel.BackgroundTransparency = 1
    TopLabel.Size = UDim2.new(1, -10, 1, 0)
    TopLabel.Position = UDim2.new(0, 4, 0, 0)
    TopLabel.ZIndex = 6
    TopLabel.Parent = TopBar

    local dragToggle = nil
    local dragSpeed = 0.25
    local dragStart = nil
    local startPos = nil

    local function updateInput(input)
        local delta = input.Position - dragStart
        local position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        TS:Create(MainFrame, TweenInfo.new(dragSpeed), {Position = position}):Play()
    end

    TopBar.InputBegan:Connect(function(input)
        if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then 
            dragToggle = true
            dragStart = input.Position
            startPos = MainFrame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragToggle = false
                end
            end)
        end
    end)

    UIS.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            if dragToggle then
                updateInput(input)
            end
        end
    end)

    UIS.InputBegan:Connect(function(input, gp)
        if not gp and input.KeyCode == BindKey then
            MainFrame.Visible = not MainFrame.Visible
        end
    end)

    local SideBarMask = Instance.new("Frame")
    SideBarMask.Name = "SideBarMask"
    SideBarMask.Size = UDim2.new(0, 110, 1, 2)
    SideBarMask.Position = UDim2.new(0, -111, 0, -1)
    SideBarMask.BorderSizePixel = 0
    SideBarMask.BackgroundTransparency = 1
    SideBarMask.ClipsDescendants = true
    SideBarMask.ZIndex = 12
    SideBarMask.Parent = MainFrame

    local SideBar = Instance.new("Frame")
    SideBar.Name = "Sidebar"
    SideBar.Size = UDim2.new(1, 0, 1, 0)
    SideBar.Position = UDim2.new(0, 0, 0, 0)
    SideBar.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
    SideBar.BorderColor3 = Color3.fromRGB(56, 56, 56)
    SideBar.BorderSizePixel = 1
    SideBar.ZIndex = 12
    SideBar.Parent = SideBarMask

    local Divider = Instance.new("Frame")
    Divider.Size = UDim2.new(0, 1, 1, 0)
    Divider.Position = UDim2.new(1, -1, 0, 0)
    Divider.BackgroundColor3 = Color3.fromRGB(56, 56, 56)
    Divider.BorderSizePixel = 0
    Divider.ZIndex = 14
    Divider.Parent = SideBar

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

    local RainbowLoop
    RainbowLoop = RS.RenderStepped:Connect(function()
        if not Title.Parent then RainbowLoop:Disconnect() return end
        local hue = os.clock() % 4 / 4
        local c = Color3.fromHSV(hue, 1, 1)
        local hex = string.format("#%02X%02X%02X", c.R*255, c.G*255, c.B*255)
        Title.Text = 'Welcome <font color="'..hex..'">'..LP.Name..'</font>\nto\n'..TitleText
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
        TabPage.ScrollBarThickness = 0
        TabPage.AutomaticCanvasSize = Enum.AutomaticSize.Y
        TabPage.Visible = false
        TabPage.ZIndex = 5
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

        function Tab:CreateButton(Options)
            local Btn = Instance.new("TextButton")
            Btn.Size = UDim2.new(1, 0, 0, 30)
            Btn.BackgroundColor3 = Color3.fromRGB(26, 26, 26)
            Btn.BorderColor3 = Color3.fromRGB(51, 51, 51)
            Btn.TextColor3 = Color3.fromRGB(201, 201, 201)
            Btn.Text = "   " .. (Options.Name or "Button")
            Btn.TextXAlignment = Enum.TextXAlignment.Left
            Btn.FontFace = InconFont
            Btn.TextSize = 12
            Btn.AutoButtonColor = false
            Btn.ZIndex = 6
            Btn.Parent = TabPage

            Btn.MouseButton1Click:Connect(function()
                if Options.Callback then Options.Callback() end
            end)
        end

        function Tab:CreateLabel(Options)
            local Lbl = Instance.new("TextLabel")
            Lbl.Size = UDim2.new(1, 0, 0, 30)
            Lbl.BackgroundColor3 = Color3.fromRGB(16, 16, 16)
            Lbl.BorderColor3 = Color3.fromRGB(51, 51, 51)
            Lbl.TextColor3 = Color3.fromRGB(255, 255, 255)
            Lbl.Text = "   " .. (Options.Name or "Label")
            Lbl.TextXAlignment = Enum.TextXAlignment.Left
            Lbl.FontFace = InconFont
            Lbl.TextSize = 12
            Lbl.ZIndex = 6
            Lbl.Parent = TabPage
        end

        function Tab:CreateToggle(Options)
            local State = Options.Default or false
            local Btn = Instance.new("TextButton")
            Btn.Size = UDim2.new(1, 0, 0, 30)
            Btn.BackgroundColor3 = Color3.fromRGB(26, 26, 26)
            Btn.BorderColor3 = Color3.fromRGB(51, 51, 51)
            Btn.TextColor3 = Color3.fromRGB(201, 201, 201)
            Btn.Text = "   " .. (Options.Name or "Toggle")
            Btn.TextXAlignment = Enum.TextXAlignment.Left
            Btn.FontFace = InconFont
            Btn.TextSize = 12
            Btn.AutoButtonColor = false
            Btn.ZIndex = 6
            Btn.Parent = TabPage

            local Indicator = Instance.new("Frame")
            Indicator.Size = UDim2.new(0, 14, 0, 14)
            Indicator.Position = UDim2.new(1, -22, 0.5, -7)
            Indicator.BackgroundColor3 = State and Color3.fromRGB(0, 170, 0) or Color3.fromRGB(170, 0, 0)
            Indicator.BorderColor3 = Color3.fromRGB(51, 51, 51)
            Indicator.ZIndex = 7
            Indicator.Parent = Btn
            Instance.new("UICorner", Indicator).CornerRadius = UDim.new(0, 3)

            Btn.MouseButton1Click:Connect(function()
                State = not State
                TS:Create(Indicator, TweenInfo.new(0.2), {BackgroundColor3 = State and Color3.fromRGB(0, 170, 0) or Color3.fromRGB(170, 0, 0)}):Play()
                if Options.Callback then Options.Callback(State) end
            end)
        end

        function Tab:CreateSlider(Options)
            local Min = Options.Min or 0
            local Max = Options.Max or 100
            local Default = Options.Default or Min

            local Btn = Instance.new("TextButton")
            Btn.Size = UDim2.new(1, 0, 0, 40)
            Btn.BackgroundColor3 = Color3.fromRGB(26, 26, 26)
            Btn.BorderColor3 = Color3.fromRGB(51, 51, 51)
            Btn.Text = ""
            Btn.AutoButtonColor = false
            Btn.ZIndex = 6
            Btn.Parent = TabPage

            local Title = Instance.new("TextLabel")
            Title.Size = UDim2.new(1, -20, 0.5, 0)
            Title.Position = UDim2.new(0, 10, 0, 2)
            Title.BackgroundTransparency = 1
            Title.TextColor3 = Color3.fromRGB(201, 201, 201)
            Title.TextXAlignment = Enum.TextXAlignment.Left
            Title.Text = Options.Name .. " : " .. Default
            Title.FontFace = InconFont
            Title.TextSize = 12
            Title.ZIndex = 7
            Title.Parent = Btn

            local SliderBack = Instance.new("Frame")
            SliderBack.Size = UDim2.new(1, -20, 0, 6)
            SliderBack.Position = UDim2.new(0, 10, 0.65, 0)
            SliderBack.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
            SliderBack.BorderColor3 = Color3.fromRGB(51, 51, 51)
            SliderBack.ZIndex = 7
            SliderBack.Parent = Btn
            Instance.new("UICorner", SliderBack).CornerRadius = UDim.new(1, 0)

            local SliderFill = Instance.new("Frame")
            SliderFill.Size = UDim2.new((Default - Min) / (Max - Min), 0, 1, 0)
            SliderFill.BackgroundColor3 = Color3.fromRGB(181, 181, 181)
            SliderFill.BorderSizePixel = 0
            SliderFill.ZIndex = 8
            SliderFill.Parent = SliderBack
            Instance.new("UICorner", SliderFill).CornerRadius = UDim.new(1, 0)

            local dragging = false
            local function update(input)
                local pos = math.clamp((input.Position.X - SliderBack.AbsolutePosition.X) / SliderBack.AbsoluteSize.X, 0, 1)
                local value = math.floor(Min + ((Max - Min) * pos))
                TS:Create(SliderFill, TweenInfo.new(0.05), {Size = UDim2.new(pos, 0, 1, 0)}):Play()
                Title.Text = Options.Name .. " : " .. value
                if Options.Callback then Options.Callback(value) end
            end

            Btn.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    dragging = true
                    update(input)
                end
            end)
            UIS.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    dragging = false
                end
            end)
            UIS.InputChanged:Connect(function(input)
                if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                    update(input)
                end
            end)
        end

        function Tab:CreateDropdown(Options)
            local List = Options.List or {}
            local isOpen = false

            local DropContainer = Instance.new("Frame")
            DropContainer.Size = UDim2.new(1, 0, 0, 30)
            DropContainer.BackgroundColor3 = Color3.fromRGB(26, 26, 26)
            DropContainer.BorderColor3 = Color3.fromRGB(51, 51, 51)
            DropContainer.ClipsDescendants = true
            DropContainer.ZIndex = 6
            DropContainer.Parent = TabPage

            local Btn = Instance.new("TextButton")
            Btn.Size = UDim2.new(1, 0, 0, 30)
            Btn.BackgroundTransparency = 1
            Btn.TextColor3 = Color3.fromRGB(201, 201, 201)
            Btn.Text = "   " .. (Options.Name or "Dropdown")
            Btn.TextXAlignment = Enum.TextXAlignment.Left
            Btn.FontFace = InconFont
            Btn.TextSize = 12
            Btn.AutoButtonColor = false
            Btn.ZIndex = 7
            Btn.Parent = DropContainer

            local Icon = Instance.new("TextLabel")
            Icon.Size = UDim2.new(0, 20, 0, 30)
            Icon.Position = UDim2.new(1, -25, 0, 0)
            Icon.BackgroundTransparency = 1
            Icon.TextColor3 = Color3.fromRGB(151, 151, 151)
            Icon.Text = "V"
            Icon.FontFace = InconFont
            Icon.TextSize = 12
            Icon.ZIndex = 8
            Icon.Parent = Btn

            local DropList = Instance.new("ScrollingFrame")
            DropList.Size = UDim2.new(1, 0, 1, -30)
            DropList.Position = UDim2.new(0, 0, 0, 30)
            DropList.BackgroundTransparency = 1
            DropList.BorderSizePixel = 0
            DropList.ScrollBarThickness = 0
            DropList.CanvasSize = UDim2.new(0, 0, 0, #List * 25)
            DropList.ZIndex = 7
            DropList.Parent = DropContainer

            local ListLayout = Instance.new("UIListLayout", DropList)
            ListLayout.SortOrder = Enum.SortOrder.LayoutOrder

            local function toggleDrop()
                isOpen = not isOpen
                Icon.Text = isOpen and "^" or "V"
                local targetHeight = isOpen and (30 + math.min(#List * 25, 120)) or 30
                TS:Create(DropContainer, TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = UDim2.new(1, 0, 0, targetHeight)}):Play()
            end

            Btn.MouseButton1Click:Connect(toggleDrop)

            for _, v in ipairs(List) do
                local Item = Instance.new("TextButton")
                Item.Size = UDim2.new(1, 0, 0, 25)
                Item.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
                Item.BorderSizePixel = 0
                Item.TextColor3 = Color3.fromRGB(180, 180, 180)
                Item.Text = "      " .. v
                Item.TextXAlignment = Enum.TextXAlignment.Left
                Item.FontFace = InconFont
                Item.TextSize = 11
                Item.AutoButtonColor = false
                Item.ZIndex = 8
                Item.Parent = DropList

                Item.MouseButton1Click:Connect(function()
                    Btn.Text = "   " .. Options.Name .. " : " .. v
                    if Options.Callback then Options.Callback(v) end
                    toggleDrop()
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
            card.ZIndex = 6
            card.Parent = TabPage

            local content = Instance.new("Frame")
            content.Size = UDim2.new(1, 0, 1, 0)
            content.BackgroundTransparency = 1
            content.ZIndex = 7
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
            header.ZIndex = 8
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
                lbl.ZIndex = 8
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
                hint.Text = "▼ Click to expand"
                hint.TextColor3 = COL.hint
                hint.TextSize = 10
                hint.TextXAlignment = Enum.TextXAlignment.Right
                hint.TextTransparency = IS_TOUCH and 0.4 or 1
                hint.ZIndex = 9
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
                    hint.Text = expanded and "▲ Click to collapse" or "▼ Click to expand"
                end

                card.MouseButton1Click:Connect(toggleExpand)
            end
        end

        return Tab
    end

    return Window
end

return InconUI
