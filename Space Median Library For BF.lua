--[[
     ███╗   ███╗██╗███╗   ██╗██╗  ██╗███████╗
     ████╗ ████║██║████╗  ██║██║  ██║╚══███╔╝
     ██╔████╔██║██║██╔██╗ ██║███████║  ███╔╝ 
     ██║╚██╔╝██║██║██║╚██╗██║██╔══██║ ███╔╝  
     ██║ ╚═╝ ██║██║██║ ╚████║██║  ██║███████╗
     ╚═╝     ╚═╝╚═╝╚═╝  ╚═══╝╚═╝  ╚═╝╚══════╝
               Chan Bo May De ❤️
]]--

local ImageLoader = {}
local HttpGet = game.HttpGet or game.HttpGetAsync
local DEFAULT_FOLDER = "MinhZ Hub Bloz Kids"

function ImageLoader.Load(url, fileName, folder)
    folder = folder or DEFAULT_FOLDER
    local path = folder .. "/" .. fileName
    if makefolder and not isfolder(folder) then pcall(makefolder, folder) end
    if not isfile(path) then
        local success, data = pcall(function() return HttpGet(game, url) end)
        if success and data and writefile then pcall(writefile, path, data) end
    end
    if getcustomasset and isfile(path) then return getcustomasset(path) end
    return "" 
end

local DiscordIcon = ImageLoader.Load("https://hanaminikata.com/image/1339580821497053184/DiscordIcon.webp", "DiscordIcon.webp")
local SpaceMedianLogo = ImageLoader.Load("https://hanaminikata.com/image/1339580821497053184/SpaceMedian.webp", "SpaceMedian.webp")
local MinhZLogo = ImageLoader.Load("https://minhz-hub.vercel.app/MinhZ.jpg", "MinhZ.jpg")

local Library = {}
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

Library.ToggleKey = Enum.KeyCode.RightControl

local Theme = {
    MainBg = Color3.fromRGB(12, 12, 12),
    ElementBg = Color3.fromRGB(24, 10, 18), 
    ElementHover = Color3.fromRGB(38, 15, 28),
    FlatBg = Color3.fromRGB(20, 20, 20),
    TextWhite = Color3.fromRGB(255, 255, 255),
    TextGrey = Color3.fromRGB(180, 160, 170), 
}

Library.ChromaCallbacks = {}

RunService.RenderStepped:Connect(function()
    local hue = tick() % 5 / 5 
    local chromaColor = Color3.fromHSV(hue, 1, 1)
    for i = #Library.ChromaCallbacks, 1, -1 do
        local callback = Library.ChromaCallbacks[i]
        local success, err = pcall(callback, chromaColor)
        if not success or err == "REMOVE" then
            table.remove(Library.ChromaCallbacks, i)
        end
    end
end)

function Library:CreateWindow(options)
    local options = options or {}
    local Title = options.Title or "MinhZ Hub UI Library V2"
    local SubTitle = options.SubTitle or "Bloz Kids Edition"
    local ToggleIconId = options.ToggleIcon or MinhZLogo
    local DiscordLink = options.DiscordLink or "https://discord.gg/q2DzqWgpTC"
    
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "Space_Median_Library"
    ScreenGui.Parent = game:GetService("CoreGui")
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    local MainFrame = Instance.new("Frame")
    MainFrame.Size = UDim2.new(0, 620, 0, 420) 
    MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    MainFrame.BackgroundColor3 = Theme.MainBg
    MainFrame.BorderSizePixel = 0
    MainFrame.Active = true
    MainFrame.Draggable = false 
    MainFrame.ClipsDescendants = true 
    MainFrame.Parent = ScreenGui
    Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)
    
    local MainScale = Instance.new("UIScale", MainFrame)
    MainScale.Scale = 1

    local dragging, dragInput, dragStart, startPos
    MainFrame.InputBegan:Connect(function(input, gpe)
        if gpe then return end
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = MainFrame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    MainFrame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)

    local ToggleBtn = Instance.new("ImageButton")
    ToggleBtn.Size = UDim2.new(0, 50, 0, 50)
    ToggleBtn.AnchorPoint = Vector2.new(0.5, 0.5)
    ToggleBtn.Position = UDim2.new(0.1, 0, 0.2, 0)
    ToggleBtn.BackgroundColor3 = Theme.MainBg
    ToggleBtn.BorderSizePixel = 0
    ToggleBtn.AutoButtonColor = false
    ToggleBtn.Visible = false
    ToggleBtn.Parent = ScreenGui
    Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(0, 10)

    local ToggleScale = Instance.new("UIScale", ToggleBtn)
    ToggleScale.Scale = 0

    local ToggleStroke = Instance.new("UIStroke", ToggleBtn)
    ToggleStroke.Thickness = 2
    table.insert(Library.ChromaCallbacks, function(color) ToggleStroke.Color = color end)

    local ToggleImg = Instance.new("ImageLabel", ToggleBtn)
    ToggleImg.Size = UDim2.new(1, -6, 1, -6)
    ToggleImg.Position = UDim2.new(0, 3, 0, 3)
    ToggleImg.BackgroundTransparency = 1
    ToggleImg.Image = ToggleIconId
    Instance.new("UICorner", ToggleImg).CornerRadius = UDim.new(0, 8)

    local tDragging, tDragInput, tDragStart, tStartPos, isDraggingToggle
    ToggleBtn.InputBegan:Connect(function(input, gpe)
        if gpe then return end
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            tDragging, isDraggingToggle = true, false
            tDragStart, tStartPos = input.Position, ToggleBtn.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then tDragging = false end
            end)
        end
    end)
    ToggleBtn.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then tDragInput = input end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == tDragInput and tDragging then
            local delta = input.Position - tDragStart
            if delta.Magnitude > 5 then isDraggingToggle = true end
            ToggleBtn.Position = UDim2.new(tStartPos.X.Scale, tStartPos.X.Offset + delta.X, tStartPos.Y.Scale, tStartPos.Y.Offset + delta.Y)
        end
    end)

    local uiVisible = true
    function Library:ToggleUI()
        uiVisible = not uiVisible
        if uiVisible then
            ToggleBtn.Visible = false
            MainFrame.Visible = true
            TweenService:Create(MainScale, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Scale = 1}):Play()
        else
            local tweenOut = TweenService:Create(MainScale, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), {Scale = 0})
            tweenOut:Play()
            tweenOut.Completed:Connect(function()
                MainFrame.Visible = false
                ToggleBtn.Visible = true
                TweenService:Create(ToggleScale, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Scale = 1}):Play()
            end)
        end
    end

    ToggleBtn.MouseButton1Click:Connect(function()
        if not isDraggingToggle then Library:ToggleUI() end
    end)

    UserInputService.InputBegan:Connect(function(input, gpe)
        if not gpe and input.KeyCode == Library.ToggleKey then
            Library:ToggleUI()
        end
    end)

    local TopBar = Instance.new("Frame")
    TopBar.Size = UDim2.new(1, 0, 0, 65) 
    TopBar.BackgroundTransparency = 1
    TopBar.Parent = MainFrame

    local TopTitle = Instance.new("TextLabel")
    TopTitle.Text = Title
    TopTitle.Font = Enum.Font.GothamBlack 
    TopTitle.TextSize = 24 
    TopTitle.Size = UDim2.new(1, -150, 0, 20)
    TopTitle.Position = UDim2.new(0, 18, 0, 15) 
    TopTitle.BackgroundTransparency = 1
    TopTitle.TextXAlignment = Enum.TextXAlignment.Left
    TopTitle.Parent = TopBar
    table.insert(Library.ChromaCallbacks, function(color) TopTitle.TextColor3 = color end) 

    local TopSubTitle = Instance.new("TextLabel")
    TopSubTitle.Text = SubTitle
    TopSubTitle.TextColor3 = Theme.TextGrey
    TopSubTitle.Font = Enum.Font.GothamMedium
    TopSubTitle.TextSize = 14 
    TopSubTitle.Size = UDim2.new(1, -150, 0, 15)
    TopSubTitle.Position = UDim2.new(0, 18, 0, 40)
    TopSubTitle.BackgroundTransparency = 1
    TopSubTitle.TextXAlignment = Enum.TextXAlignment.Left
    TopSubTitle.Parent = TopBar

    local BackBtnFrame = Instance.new("Frame")
    BackBtnFrame.Size = UDim2.new(0, 32, 0, 32)
    BackBtnFrame.Position = UDim2.new(0, 15, 0, 15)
    BackBtnFrame.BackgroundColor3 = Theme.MainBg
    BackBtnFrame.Visible = false
    BackBtnFrame.Parent = TopBar
    Instance.new("UICorner", BackBtnFrame).CornerRadius = UDim.new(0, 6)
    
    local BackStroke = Instance.new("UIStroke", BackBtnFrame)
    BackStroke.Thickness = 1.2
    table.insert(Library.ChromaCallbacks, function(color) BackStroke.Color = color end)

    local BackIcon = Instance.new("TextButton")
    BackIcon.Size = UDim2.new(1, 0, 1, 0)
    BackIcon.BackgroundTransparency = 1
    BackIcon.Text = "←"
    BackIcon.TextSize = 22
    BackIcon.Font = Enum.Font.GothamBold
    BackIcon.Parent = BackBtnFrame
    table.insert(Library.ChromaCallbacks, function(color) BackIcon.TextColor3 = color end)

    local CloseBtn = Instance.new("TextButton", TopBar)
    CloseBtn.Size = UDim2.new(0, 24, 0, 24)
    CloseBtn.Position = UDim2.new(1, -38, 0.5, -12)
    CloseBtn.BackgroundColor3 = Color3.fromRGB(240, 60, 60)
    CloseBtn.Text = "X"
    CloseBtn.TextColor3 = Theme.TextWhite
    CloseBtn.Font = Enum.Font.GothamBold
    CloseBtn.TextSize = 13
    Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 6)
    CloseBtn.MouseButton1Click:Connect(function() Library:ToggleUI() end)

    local DiscordBtn = Instance.new("ImageButton", TopBar)
    DiscordBtn.Size = UDim2.new(0, 24, 0, 24)
    DiscordBtn.Position = UDim2.new(1, -72, 0.5, -12)
    DiscordBtn.BackgroundTransparency = 1
    DiscordBtn.Image = DiscordIcon
    
    DiscordBtn.MouseEnter:Connect(function() TweenService:Create(DiscordBtn, TweenInfo.new(0.2), {Size = UDim2.new(0, 28, 0, 28)}):Play() end)
    DiscordBtn.MouseLeave:Connect(function() TweenService:Create(DiscordBtn, TweenInfo.new(0.2), {Size = UDim2.new(0, 24, 0, 24)}):Play() end)
    DiscordBtn.MouseButton1Click:Connect(function()
        setclipboard(DiscordLink)
        if Window.CreateNoti then
            Window:CreateNoti({ Title = "System", Text = "Copied Discord Link To Clipboard!", Duration = 3 })
        end
    end)

    local HomeContainer = Instance.new("ScrollingFrame")
    HomeContainer.Size = UDim2.new(1, -30, 1, -75) 
    HomeContainer.Position = UDim2.new(0, 15, 0, 75)
    HomeContainer.BackgroundTransparency = 1
    HomeContainer.ScrollBarThickness = 0 
    HomeContainer.VerticalScrollBarInset = Enum.ScrollBarInset.None
    HomeContainer.CanvasSize = UDim2.new(0, 0, 0, 0) 
    HomeContainer.AutomaticCanvasSize = Enum.AutomaticSize.Y
    HomeContainer.Parent = MainFrame

    local HomeListLayout = Instance.new("UIListLayout")
    HomeListLayout.Padding = UDim.new(0, 12)
    HomeListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    HomeListLayout.Parent = HomeContainer

    local TabGridFrame = Instance.new("Frame")
    TabGridFrame.Size = UDim2.new(1, 0, 0, 0)
    TabGridFrame.BackgroundTransparency = 1
    TabGridFrame.AutomaticSize = Enum.AutomaticSize.Y
    TabGridFrame.Parent = HomeContainer
    TabGridFrame.LayoutOrder = 2 

    local GridLayout = Instance.new("UIGridLayout")
    GridLayout.CellSize = UDim2.new(0.5, -6, 0, 70) 
    GridLayout.CellPadding = UDim2.new(0, 12, 0, 12)
    GridLayout.SortOrder = Enum.SortOrder.LayoutOrder
    GridLayout.Parent = TabGridFrame

    local CreditGridFrame = Instance.new("Frame")
    CreditGridFrame.Size = UDim2.new(1, 0, 0, 0)
    CreditGridFrame.BackgroundTransparency = 1
    CreditGridFrame.AutomaticSize = Enum.AutomaticSize.Y
    CreditGridFrame.Parent = HomeContainer
    CreditGridFrame.LayoutOrder = 1 

    local CreditGridLayout = Instance.new("UIGridLayout")
    CreditGridLayout.CellSize = UDim2.new(0.5, -6, 0, 70) 
    CreditGridLayout.CellPadding = UDim2.new(0, 12, 0, 12)
    CreditGridLayout.SortOrder = Enum.SortOrder.LayoutOrder
    CreditGridLayout.Parent = CreditGridFrame

    local Window = {}
    local ActiveTabContainer = nil

    local NotiContainer = Instance.new("Frame")
    NotiContainer.Size = UDim2.new(0, 300, 1, -100) 
    NotiContainer.Position = UDim2.new(1, -310, 0, 0) 
    NotiContainer.BackgroundTransparency = 1
    NotiContainer.Parent = ScreenGui

    local NotiLayout = Instance.new("UIListLayout")
    NotiLayout.SortOrder = Enum.SortOrder.LayoutOrder
    NotiLayout.Padding = UDim.new(0, 10)
    NotiLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
    NotiLayout.Parent = NotiContainer

    function Window:CreateNoti(cfg)
        local nTitle = cfg.Title or "Notification"
        local nText = cfg.Text or "Message"
        local duration = cfg.Duration or 3

        local NotiWrapper = Instance.new("Frame")
        NotiWrapper.Size = UDim2.new(1, 0, 0, 70)
        NotiWrapper.BackgroundTransparency = 1
        NotiWrapper.Parent = NotiContainer

        local NotiFrame = Instance.new("Frame")
        NotiFrame.Size = UDim2.new(1, 0, 1, 0)
        NotiFrame.BackgroundColor3 = Theme.ElementBg
        NotiFrame.Position = UDim2.new(1, 350, 0, 0) 
        NotiFrame.Parent = NotiWrapper
        Instance.new("UICorner", NotiFrame).CornerRadius = UDim.new(0, 8)

        local NotiStroke = Instance.new("UIStroke", NotiFrame)
        NotiStroke.Thickness = 1.5
        table.insert(Library.ChromaCallbacks, function(color)
            if not NotiStroke.Parent then return "REMOVE" end
            NotiStroke.Color = color 
        end)

        local LblTitle = Instance.new("TextLabel", NotiFrame)
        LblTitle.Size = UDim2.new(1, -20, 0, 20)
        LblTitle.Position = UDim2.new(0, 12, 0, 10)
        LblTitle.BackgroundTransparency = 1
        LblTitle.Text = nTitle
        LblTitle.Font = Enum.Font.GothamBlack
        LblTitle.TextSize = 15
        LblTitle.TextXAlignment = Enum.TextXAlignment.Left
        table.insert(Library.ChromaCallbacks, function(color)
            if not LblTitle.Parent then return "REMOVE" end
            LblTitle.TextColor3 = color 
        end)

        local LblDesc = Instance.new("TextLabel", NotiFrame)
        LblDesc.Size = UDim2.new(1, -20, 0, 30)
        LblDesc.Position = UDim2.new(0, 12, 0, 32)
        LblDesc.BackgroundTransparency = 1
        LblDesc.Text = nText
        LblDesc.TextColor3 = Color3.fromRGB(240, 240, 240) 
        LblDesc.Font = Enum.Font.GothamMedium
        LblDesc.TextSize = 13
        LblDesc.TextWrapped = true
        LblDesc.TextXAlignment = Enum.TextXAlignment.Left
        LblDesc.TextYAlignment = Enum.TextYAlignment.Top

        TweenService:Create(NotiFrame, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Position = UDim2.new(0, 0, 0, 0)}):Play()

        task.delay(duration, function()
            local tweenOut = TweenService:Create(NotiFrame, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.In), {Position = UDim2.new(1, 350, 0, 0)})
            tweenOut:Play()
            tweenOut.Completed:Connect(function() NotiWrapper:Destroy() end)
        end)
    end

    local function CreateFakeStroke(parentFrame, cornerRadius)
        parentFrame.BackgroundTransparency = 1
        local StrokeBg = Instance.new("Frame")
        StrokeBg.Size = UDim2.new(1, 0, 1, 0)
        StrokeBg.BorderSizePixel = 0
        StrokeBg.Parent = parentFrame
        Instance.new("UICorner", StrokeBg).CornerRadius = cornerRadius
        table.insert(Library.ChromaCallbacks, function(color) StrokeBg.BackgroundColor3 = color end)

        local InnerBg = Instance.new("Frame")
        InnerBg.Size = UDim2.new(1, -2, 1, -2)
        InnerBg.Position = UDim2.new(0, 1, 0, 1)
        InnerBg.BackgroundColor3 = Theme.ElementBg
        InnerBg.BorderSizePixel = 0
        InnerBg.Parent = StrokeBg
        Instance.new("UICorner", InnerBg).CornerRadius = UDim.new(0, cornerRadius.Offset - 1)
        return StrokeBg, InnerBg
    end

    BackIcon.MouseButton1Click:Connect(function()
        if ActiveTabContainer then 
            TweenService:Create(ActiveTabContainer, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2.new(1.5, 0, 0, 75)}):Play()
            task.delay(0.3, function() ActiveTabContainer.Visible = false end)
        end
        HomeContainer.Position = UDim2.new(-1, 0, 0, 75) 
        HomeContainer.Visible = true
        TweenService:Create(HomeContainer, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2.new(0, 15, 0, 75)}):Play()
        BackBtnFrame.Visible = false
        TopTitle.Text = Title
        TopSubTitle.Text = SubTitle
        TweenService:Create(TopTitle, TweenInfo.new(0.2), {Position = UDim2.new(0, 18, 0, 15)}):Play()
        TweenService:Create(TopSubTitle, TweenInfo.new(0.2), {Position = UDim2.new(0, 18, 0, 40)}):Play()
    end)

    function Window:AddWelcomeBanner(options)
        local options = options or {}
        local HubName = options.HubName or "MinhZ Hub"
        local DescText = options.Desc or "Blox Fruits | Join For Support And Update 😘"
        local localPlayer = Players.LocalPlayer
        local pName = localPlayer and localPlayer.Name or "Player"
        local pUserId = localPlayer and localPlayer.UserId or 1

        local Banner = Instance.new("Frame")
        Banner.Size = UDim2.new(1, 0, 0, 80) 
        Banner.Parent = HomeContainer
        Banner.LayoutOrder = 0 
        
        local _, InnerBg = CreateFakeStroke(Banner, UDim.new(0, 10))

        local AvatarCircle = Instance.new("Frame", InnerBg)
        AvatarCircle.Size = UDim2.new(0, 50, 0, 50) 
        AvatarCircle.Position = UDim2.new(0, 15, 0.5, -25)
        AvatarCircle.BackgroundColor3 = Color3.fromRGB(20, 10, 15)
        Instance.new("UICorner", AvatarCircle).CornerRadius = UDim.new(1, 0)
        
        local AvStroke = Instance.new("UIStroke", AvatarCircle)
        AvStroke.Thickness = 1.5
        table.insert(Library.ChromaCallbacks, function(color) AvStroke.Color = color end) 

        local AvatarImg = Instance.new("ImageLabel", AvatarCircle)
        AvatarImg.Size = UDim2.new(1, 0, 1, 0)
        AvatarImg.BackgroundTransparency = 1
        AvatarImg.Image = "rbxthumb://type=AvatarHeadShot&id=" .. pUserId .. "&w=150&h=150"
        Instance.new("UICorner", AvatarImg).CornerRadius = UDim.new(1, 0)

        local TextOffset = 80 
        local TxtWelcome = Instance.new("TextLabel", InnerBg)
        TxtWelcome.Size = UDim2.new(1, -TextOffset - 15, 0, 20)
        TxtWelcome.Position = UDim2.new(0, TextOffset, 0, 12)
        TxtWelcome.BackgroundTransparency = 1
        TxtWelcome.RichText = true
        TxtWelcome.Font = Enum.Font.GothamBlack
        TxtWelcome.TextSize = 16 
        TxtWelcome.TextXAlignment = Enum.TextXAlignment.Left

        table.insert(Library.ChromaCallbacks, function(color)
            local r, g, b = math.floor(color.R*255), math.floor(color.G*255), math.floor(color.B*255)
            TxtWelcome.Text = "<font color='#ffffff'>Welcome to " .. HubName .. ", </font><font color='rgb("..r..","..g..","..b..")'>" .. pName .. "!</font>"
        end)

        local TxtUser = Instance.new("TextLabel", InnerBg)
        TxtUser.Size = UDim2.new(1, -TextOffset - 15, 0, 15)
        TxtUser.Position = UDim2.new(0, TextOffset, 0, 35)
        TxtUser.BackgroundTransparency = 1
        TxtUser.Text = "@" .. pName
        TxtUser.TextColor3 = Theme.TextGrey
        TxtUser.Font = Enum.Font.GothamMedium
        TxtUser.TextSize = 13
        TxtUser.TextXAlignment = Enum.TextXAlignment.Left

        local TxtDesc = Instance.new("TextLabel", InnerBg)
        TxtDesc.Size = UDim2.new(1, -TextOffset - 15, 0, 15)
        TxtDesc.Position = UDim2.new(0, TextOffset, 0, 52)
        TxtDesc.BackgroundTransparency = 1
        TxtDesc.Text = DescText
        TxtDesc.TextColor3 = Color3.fromRGB(150, 130, 140)
        TxtDesc.Font = Enum.Font.Gotham
        TxtDesc.TextSize = 11
        TxtDesc.TextXAlignment = Enum.TextXAlignment.Left
    end

    function Window:AddCreditCard(options)
        local options = options or {}
        local Title = options.Title or "Created By"
        local SubTitle = options.SubTitle or "Developer"
        local IconImage = options.Icon 
        
        local Card = Instance.new("TextButton")
        Card.AutoButtonColor = false
        Card.Text = ""
        Card.Parent = CreditGridFrame
        
        local _, InnerBg = CreateFakeStroke(Card, UDim.new(0, 10))

        local IconCircle = Instance.new("Frame", InnerBg)
        IconCircle.Size = UDim2.new(0, 48, 0, 48)
        IconCircle.Position = UDim2.new(0, 15, 0.5, -24)
        IconCircle.BackgroundColor3 = Color3.fromRGB(20, 10, 15)
        IconCircle.BackgroundTransparency = IconImage and 1 or 0 
        Instance.new("UICorner", IconCircle).CornerRadius = UDim.new(1, 0)

        local IconImg = Instance.new("ImageLabel", IconCircle)
        IconImg.Size = UDim2.new(1, 0, 1, 0)
        IconImg.BackgroundTransparency = 1
        Instance.new("UICorner", IconImg).CornerRadius = UDim.new(1, 0)

        if IconImage then
            if string.find(IconImage, "http") then
                local safeName = Title:gsub("%W", "") .. "_icon.png"
                IconImg.Image = ImageLoader.Load(IconImage, safeName) or ""
            else
                IconImg.Image = IconImage
            end
            IconImg.ImageColor3 = Color3.fromRGB(255, 255, 255) 
        else
            IconImg.Image = "rbxassetid://10492192070"
            IconImg.ImageColor3 = Color3.fromRGB(100, 90, 100)
        end

        local LabelTitle = Instance.new("TextLabel", InnerBg)
        LabelTitle.Size = UDim2.new(1, -80, 0, 20)
        LabelTitle.Position = UDim2.new(0, 75, 0, 14)
        LabelTitle.BackgroundTransparency = 1
        LabelTitle.Text = Title
        LabelTitle.Font = Enum.Font.GothamBlack
        LabelTitle.TextSize = 15 
        LabelTitle.TextXAlignment = Enum.TextXAlignment.Left
        table.insert(Library.ChromaCallbacks, function(color) LabelTitle.TextColor3 = color end)

        local LabelSub = Instance.new("TextLabel", InnerBg)
        LabelSub.Size = UDim2.new(1, -80, 0, 15)
        LabelSub.Position = UDim2.new(0, 75, 0, 38)
        LabelSub.BackgroundTransparency = 1
        LabelSub.Text = SubTitle
        LabelSub.TextColor3 = Theme.TextWhite
        LabelSub.Font = Enum.Font.GothamMedium
        LabelSub.TextSize = 13
        LabelSub.TextXAlignment = Enum.TextXAlignment.Left

        Card.MouseEnter:Connect(function() TweenService:Create(InnerBg, TweenInfo.new(0.2), {BackgroundColor3 = Theme.ElementHover}):Play() end)
        Card.MouseLeave:Connect(function() TweenService:Create(InnerBg, TweenInfo.new(0.2), {BackgroundColor3 = Theme.ElementBg}):Play() end)
        Card.MouseButton1Click:Connect(function() setclipboard(SubTitle) end)
    end

    function Window:MakeTab(options)
        local options = options or {}
        local TabTitle = options.Title or "Tab"
        local TabSub = options.SubTitle or "Category"
        local IconId = options.Icon or "rbxassetid://7733655511"

        local TabCard = Instance.new("TextButton")
        TabCard.AutoButtonColor = false
        TabCard.Text = ""
        TabCard.Parent = TabGridFrame
        
        local _, InnerBg = CreateFakeStroke(TabCard, UDim.new(0, 10))

        local IconCircle = Instance.new("Frame", InnerBg)
        IconCircle.Size = UDim2.new(0, 42, 0, 42)
        IconCircle.Position = UDim2.new(0, 15, 0.5, -21)
        IconCircle.BackgroundColor3 = Color3.fromRGB(20, 10, 15)
        Instance.new("UICorner", IconCircle).CornerRadius = UDim.new(1, 0)

        local IconImg = Instance.new("ImageLabel", IconCircle)
        IconImg.Size = UDim2.new(0, 32, 0, 32)
        IconImg.Position = UDim2.new(0.5, -16, 0.5, -16)
        IconImg.BackgroundTransparency = 1
        IconImg.Image = IconId
        table.insert(Library.ChromaCallbacks, function(color) IconImg.ImageColor3 = color end)

        local LabelTitle = Instance.new("TextLabel", InnerBg)
        LabelTitle.Size = UDim2.new(1, -75, 0, 20)
        LabelTitle.Position = UDim2.new(0, 72, 0, 14)
        LabelTitle.BackgroundTransparency = 1
        LabelTitle.Text = TabTitle
        LabelTitle.Font = Enum.Font.GothamBlack
        LabelTitle.TextSize = 16 
        LabelTitle.TextXAlignment = Enum.TextXAlignment.Left
        table.insert(Library.ChromaCallbacks, function(color) LabelTitle.TextColor3 = color end)

        local LabelSub = Instance.new("TextLabel", InnerBg)
        LabelSub.Size = UDim2.new(1, -75, 0, 15)
        LabelSub.Position = UDim2.new(0, 72, 0, 38)
        LabelSub.BackgroundTransparency = 1
        LabelSub.Text = TabSub
        LabelSub.TextColor3 = Theme.TextWhite 
        LabelSub.Font = Enum.Font.GothamMedium
        LabelSub.TextSize = 13
        LabelSub.TextXAlignment = Enum.TextXAlignment.Left

        TabCard.MouseEnter:Connect(function() TweenService:Create(InnerBg, TweenInfo.new(0.2), {BackgroundColor3 = Theme.ElementHover}):Play() end)
        TabCard.MouseLeave:Connect(function() TweenService:Create(InnerBg, TweenInfo.new(0.2), {BackgroundColor3 = Theme.ElementBg}):Play() end)

        local TabContainer = Instance.new("ScrollingFrame")
        TabContainer.Size = UDim2.new(1, -30, 1, -75) 
        TabContainer.Position = UDim2.new(1.5, 0, 0, 75) 
        TabContainer.BackgroundTransparency = 1
        TabContainer.ScrollBarThickness = 0 
        TabContainer.VerticalScrollBarInset = Enum.ScrollBarInset.None 
        TabContainer.CanvasSize = UDim2.new(0, 0, 0, 0) 
        TabContainer.AutomaticCanvasSize = Enum.AutomaticSize.Y
        TabContainer.Visible = false
        TabContainer.Parent = MainFrame

        local TabListLayout = Instance.new("UIListLayout")
        TabListLayout.Padding = UDim.new(0, 8)
        TabListLayout.SortOrder = Enum.SortOrder.LayoutOrder
        TabListLayout.Parent = TabContainer

        TabCard.MouseButton1Click:Connect(function()
            TweenService:Create(HomeContainer, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2.new(-1, 0, 0, 75)}):Play()
            task.delay(0.3, function() HomeContainer.Visible = false end)
            
            TabContainer.Position = UDim2.new(1.5, 0, 0, 75) 
            TabContainer.Visible = true
            TweenService:Create(TabContainer, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2.new(0, 15, 0, 75)}):Play()
            
            BackBtnFrame.Visible = true
            ActiveTabContainer = TabContainer
            TopTitle.Text = TabTitle
            TopSubTitle.Text = TabSub
            
            TweenService:Create(TopTitle, TweenInfo.new(0.2), {Position = UDim2.new(0, 60, 0, 15)}):Play()
            TweenService:Create(TopSubTitle, TweenInfo.new(0.2), {Position = UDim2.new(0, 60, 0, 40)}):Play()
        end)

        local TabElements = {}
        
        function TabElements:AddInfoLabel(cfg)
            local title = cfg.Title or "Label"
            local val = cfg.Value or "Value"
            
            local InfoFrame = Instance.new("Frame", TabContainer)
            InfoFrame.Size = UDim2.new(1, 0, 0, 35)
            InfoFrame.BackgroundTransparency = 1
            
            local LblTitle = Instance.new("TextLabel", InfoFrame)
            LblTitle.Size = UDim2.new(0.5, 0, 1, 0)
            LblTitle.Position = UDim2.new(0, 10, 0, 0)
            LblTitle.BackgroundTransparency = 1
            LblTitle.Text = title
            LblTitle.TextColor3 = Theme.TextGrey
            LblTitle.Font = Enum.Font.GothamMedium
            LblTitle.TextSize = 14
            LblTitle.TextXAlignment = Enum.TextXAlignment.Left

            local LblVal = Instance.new("TextLabel", InfoFrame)
            LblVal.Size = UDim2.new(0.5, -10, 1, 0)
            LblVal.Position = UDim2.new(0.5, 0, 0, 0)
            LblVal.BackgroundTransparency = 1
            LblVal.Text = val
            LblVal.TextColor3 = Theme.TextWhite
            LblVal.Font = Enum.Font.GothamMedium
            LblVal.TextSize = 14
            LblVal.TextXAlignment = Enum.TextXAlignment.Right
            
            return {
                SetDesc = function(self, newText)
                    if LblVal then LblVal.Text = newText end
                end
            }
        end

        function TabElements:AddSection(text)
            local Section = Instance.new("Frame", TabContainer)
            Section.Size = UDim2.new(1, 0, 0, 30)
            Section.BackgroundTransparency = 1
            local Dot = Instance.new("Frame", Section)
            Dot.Size = UDim2.new(0, 6, 0, 6)
            Dot.Position = UDim2.new(0, 5, 0.5, -3)
            table.insert(Library.ChromaCallbacks, function(color) Dot.BackgroundColor3 = color end)
            Instance.new("UICorner", Dot).CornerRadius = UDim.new(1, 0)
            
            local Label = Instance.new("TextLabel", Section)
            Label.Size = UDim2.new(1, -20, 1, 0)
            Label.Position = UDim2.new(0, 20, 0, 0)
            Label.BackgroundTransparency = 1
            Label.Text = text
            Label.TextColor3 = Theme.TextWhite
            Label.Font = Enum.Font.GothamBlack
            Label.TextSize = 15
            Label.TextXAlignment = Enum.TextXAlignment.Left
        end

        function TabElements:CreateBox(cfg)
            local title = cfg.Title or "TextBox"
            local placeholder = cfg.Placeholder or "Type Here..."
            local default = cfg.Default or ""
            local callback = cfg.Callback or function() end

            local BoxFrame = Instance.new("Frame", TabContainer)
            BoxFrame.Size = UDim2.new(1, 0, 0, 50)
            BoxFrame.BackgroundColor3 = Theme.FlatBg
            Instance.new("UICorner", BoxFrame).CornerRadius = UDim.new(0, 6)

            local LblTitle = Instance.new("TextLabel", BoxFrame)
            LblTitle.Size = UDim2.new(0.5, 0, 1, 0)
            LblTitle.Position = UDim2.new(0, 15, 0, 0)
            LblTitle.BackgroundTransparency = 1
            LblTitle.Text = title
            LblTitle.TextColor3 = Theme.TextWhite
            LblTitle.Font = Enum.Font.GothamBold
            LblTitle.TextSize = 14
            LblTitle.TextXAlignment = Enum.TextXAlignment.Left

            local InputBg = Instance.new("Frame", BoxFrame)
            InputBg.Size = UDim2.new(0.4, 0, 0, 32)
            InputBg.Position = UDim2.new(0.55, 0, 0.5, -16)
            InputBg.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
            Instance.new("UICorner", InputBg).CornerRadius = UDim.new(0, 5)

            local InputStroke = Instance.new("UIStroke", InputBg)
            InputStroke.Thickness = 1.2
            InputStroke.Color = Color3.fromRGB(50, 50, 50)

            local TextBox = Instance.new("TextBox", InputBg)
            TextBox.Size = UDim2.new(1, -20, 1, 0)
            TextBox.Position = UDim2.new(0, 10, 0, 0)
            TextBox.BackgroundTransparency = 1
            TextBox.Text = default
            TextBox.PlaceholderText = placeholder
            TextBox.TextColor3 = Theme.TextWhite
            TextBox.Font = Enum.Font.GothamMedium
            TextBox.TextSize = 13
            TextBox.TextXAlignment = Enum.TextXAlignment.Left

            local isFocused = false
            TextBox.Focused:Connect(function() isFocused = true end)

            TextBox.FocusLost:Connect(function()
                isFocused = false
                TweenService:Create(InputStroke, TweenInfo.new(0.2), {Color = Color3.fromRGB(50, 50, 50)}):Play()
                pcall(callback, TextBox.Text)
            end)

            table.insert(Library.ChromaCallbacks, function(color)
                if not TextBox.Parent then return "REMOVE" end
                if isFocused then InputStroke.Color = color end
            end)
        end

        function TabElements:CreateBind(cfg)
            local title = cfg.Title or "Keybind"
            local default = cfg.Default or Enum.KeyCode.E
            local callback = cfg.Callback or function() end

            local currentKey = default
            local isBinding = false

            local BindFrame = Instance.new("Frame", TabContainer)
            BindFrame.Size = UDim2.new(1, 0, 0, 50)
            BindFrame.BackgroundColor3 = Theme.FlatBg
            Instance.new("UICorner", BindFrame).CornerRadius = UDim.new(0, 6)

            local LblTitle = Instance.new("TextLabel", BindFrame)
            LblTitle.Size = UDim2.new(0.5, 0, 1, 0)
            LblTitle.Position = UDim2.new(0, 15, 0, 0)
            LblTitle.BackgroundTransparency = 1
            LblTitle.Text = title
            LblTitle.TextColor3 = Theme.TextWhite
            LblTitle.Font = Enum.Font.GothamBold
            LblTitle.TextSize = 14
            LblTitle.TextXAlignment = Enum.TextXAlignment.Left

            local BindBtn = Instance.new("TextButton", BindFrame)
            BindBtn.Size = UDim2.new(0, 100, 0, 30)
            BindBtn.Position = UDim2.new(1, -115, 0.5, -15)
            BindBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
            BindBtn.Text = currentKey.Name
            BindBtn.TextColor3 = Theme.TextWhite
            BindBtn.Font = Enum.Font.GothamBlack
            BindBtn.TextSize = 13
            Instance.new("UICorner", BindBtn).CornerRadius = UDim.new(0, 5)
            
            local BindStroke = Instance.new("UIStroke", BindBtn)
            BindStroke.Thickness = 1.2
            BindStroke.Color = Color3.fromRGB(50, 50, 50)

            table.insert(Library.ChromaCallbacks, function(color)
                if not BindBtn.Parent then return "REMOVE" end
                if isBinding then BindStroke.Color = color end
            end)

            BindBtn.MouseButton1Click:Connect(function()
                isBinding = true
                BindBtn.Text = "..."
            end)

            UserInputService.InputBegan:Connect(function(input, gpe)
                if isBinding and input.UserInputType == Enum.UserInputType.Keyboard then
                    local key = input.KeyCode
                    if key == Enum.KeyCode.Escape or key == Enum.KeyCode.Backspace then
                        currentKey = Enum.KeyCode.Unknown
                        BindBtn.Text = "None"
                    else
                        currentKey = key
                        BindBtn.Text = key.Name
                    end
                    isBinding = false
                    TweenService:Create(BindStroke, TweenInfo.new(0.2), {Color = Color3.fromRGB(50, 50, 50)}):Play()
                    pcall(callback, currentKey)
                elseif not gpe and input.KeyCode == currentKey and currentKey ~= Enum.KeyCode.Unknown then
                    pcall(callback, currentKey)
                end
            end)
        end

        function TabElements:AddToggle(cfg)
            local default = cfg.Default or false
            local callback = cfg.Callback or function() end
            
            local ToggleFrame = Instance.new("TextButton", TabContainer)
            ToggleFrame.Size = UDim2.new(1, 0, 0, 50)
            ToggleFrame.BackgroundColor3 = Theme.FlatBg 
            ToggleFrame.AutoButtonColor = false
            ToggleFrame.Text = ""
            Instance.new("UICorner", ToggleFrame).CornerRadius = UDim.new(0, 6)
            
            local LblTitle = Instance.new("TextLabel", ToggleFrame)
            LblTitle.Size = UDim2.new(1, -60, 0, 20)
            LblTitle.Position = UDim2.new(0, 15, 0, 8)
            LblTitle.BackgroundTransparency = 1
            LblTitle.Text = cfg.Title or "Toggle"
            LblTitle.TextColor3 = Theme.TextWhite
            LblTitle.Font = Enum.Font.GothamBold
            LblTitle.TextSize = 14
            LblTitle.TextXAlignment = Enum.TextXAlignment.Left
            
            local LblSub = Instance.new("TextLabel", ToggleFrame)
            LblSub.Size = UDim2.new(1, -60, 0, 15)
            LblSub.Position = UDim2.new(0, 15, 0, 28)
            LblSub.BackgroundTransparency = 1
            LblSub.Text = cfg.SubTitle or ""
            LblSub.TextColor3 = Theme.TextGrey
            LblSub.Font = Enum.Font.GothamMedium
            LblSub.TextSize = 12
            LblSub.TextXAlignment = Enum.TextXAlignment.Left
            
            local Box = Instance.new("Frame", ToggleFrame)
            Box.Size = UDim2.new(0, 22, 0, 22)
            Box.Position = UDim2.new(1, -35, 0.5, -11)
            Box.BackgroundColor3 = Color3.fromRGB(45, 25, 35)
            Instance.new("UICorner", Box).CornerRadius = UDim.new(0, 5)
            local Icon = Instance.new("TextLabel", Box)
            Icon.Size = UDim2.new(1, 0, 1, 0)
            Icon.BackgroundTransparency = 1
            Icon.Text = "✓"
            Icon.TextColor3 = Color3.fromRGB(255, 255, 255)
            Icon.TextSize = 15
            Icon.Font = Enum.Font.GothamBlack
            Icon.TextTransparency = default and 0 or 1
            
            local state = default
            table.insert(Library.ChromaCallbacks, function(color)
                if not Box.Parent then return "REMOVE" end
                if state then Box.BackgroundColor3 = color end
            end)

            ToggleFrame.MouseButton1Click:Connect(function()
                state = not state
                TweenService:Create(Icon, TweenInfo.new(0.1), {TextTransparency = state and 0 or 1}):Play()
                if not state then
                    Box.BackgroundColor3 = Color3.fromRGB(45, 25, 35)
                end
                pcall(callback, state)
            end)
        end

        function TabElements:AddButton(cfg)
            local callback = cfg.Callback or function() end

            local ButtonFrame = Instance.new("Frame", TabContainer)
            ButtonFrame.Size = UDim2.new(1, 0, 0, 50)
            ButtonFrame.BackgroundColor3 = Theme.FlatBg
            Instance.new("UICorner", ButtonFrame).CornerRadius = UDim.new(0, 6)

            local LblTitle = Instance.new("TextLabel", ButtonFrame)
            LblTitle.Size = UDim2.new(1, -100, 0, 20)
            LblTitle.Position = UDim2.new(0, 15, 0, 8)
            LblTitle.BackgroundTransparency = 1
            LblTitle.Text = cfg.Title or "Button"
            LblTitle.TextColor3 = Theme.TextWhite
            LblTitle.Font = Enum.Font.GothamBold
            LblTitle.TextSize = 14
            LblTitle.TextXAlignment = Enum.TextXAlignment.Left

            local LblSub = Instance.new("TextLabel", ButtonFrame)
            LblSub.Size = UDim2.new(1, -100, 0, 15)
            LblSub.Position = UDim2.new(0, 15, 0, 28)
            LblSub.BackgroundTransparency = 1
            LblSub.Text = cfg.SubTitle or ""
            LblSub.TextColor3 = Theme.TextGrey
            LblSub.Font = Enum.Font.GothamMedium
            LblSub.TextSize = 12
            LblSub.TextXAlignment = Enum.TextXAlignment.Left

            local ClickBtn = Instance.new("TextButton", ButtonFrame)
            ClickBtn.Size = UDim2.new(0, 65, 0, 26)
            ClickBtn.Position = UDim2.new(1, -80, 0.5, -13)
            ClickBtn.Text = "Click"
            ClickBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            ClickBtn.Font = Enum.Font.GothamBlack
            ClickBtn.TextSize = 12
            Instance.new("UICorner", ClickBtn).CornerRadius = UDim.new(0, 5)
            table.insert(Library.ChromaCallbacks, function(color) 
                if not ClickBtn.Parent then return "REMOVE" end
                ClickBtn.BackgroundColor3 = color 
            end)

            ClickBtn.MouseButton1Click:Connect(function() 
                TweenService:Create(ClickBtn, TweenInfo.new(0.1), {Size = UDim2.new(0, 60, 0, 22)}):Play()
                task.wait(0.1)
                TweenService:Create(ClickBtn, TweenInfo.new(0.1), {Size = UDim2.new(0, 65, 0, 26)}):Play()
                pcall(callback) 
            end)
        end

        function TabElements:AddSlider(cfg)
            local min = cfg.Min or 0
            local max = cfg.Max or 100
            local default = cfg.Default or 50
            local callback = cfg.Callback or function() end

            local SliderFrame = Instance.new("Frame", TabContainer)
            SliderFrame.Size = UDim2.new(1, 0, 0, 55)
            SliderFrame.BackgroundColor3 = Theme.FlatBg
            Instance.new("UICorner", SliderFrame).CornerRadius = UDim.new(0, 6)

            local LblTitle = Instance.new("TextLabel", SliderFrame)
            LblTitle.Size = UDim2.new(1, -70, 0, 20)
            LblTitle.Position = UDim2.new(0, 15, 0, 8)
            LblTitle.BackgroundTransparency = 1
            LblTitle.Text = cfg.Title or "Slider"
            LblTitle.TextColor3 = Theme.TextWhite
            LblTitle.Font = Enum.Font.GothamBold
            LblTitle.TextSize = 14
            LblTitle.TextXAlignment = Enum.TextXAlignment.Left

            local ValueLabel = Instance.new("TextLabel", SliderFrame)
            ValueLabel.Size = UDim2.new(0, 50, 0, 20)
            ValueLabel.Position = UDim2.new(1, -65, 0, 8)
            ValueLabel.BackgroundTransparency = 1
            ValueLabel.Text = tostring(default)
            ValueLabel.TextColor3 = Theme.TextWhite
            ValueLabel.Font = Enum.Font.GothamMedium
            ValueLabel.TextSize = 13
            ValueLabel.TextXAlignment = Enum.TextXAlignment.Right

            local SliderBg = Instance.new("Frame", SliderFrame)
            SliderBg.Size = UDim2.new(1, -30, 0, 6) 
            SliderBg.Position = UDim2.new(0, 15, 0, 38)
            SliderBg.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
            Instance.new("UICorner", SliderBg).CornerRadius = UDim.new(1, 0)

            local SliderFill = Instance.new("Frame", SliderBg)
            local fillPercent = (default - min) / (max - min)
            SliderFill.Size = UDim2.new(fillPercent, 0, 1, 0)
            table.insert(Library.ChromaCallbacks, function(color) 
                if not SliderFill.Parent then return "REMOVE" end
                SliderFill.BackgroundColor3 = color 
            end)
            Instance.new("UICorner", SliderFill).CornerRadius = UDim.new(1, 0)

            local Thumb = Instance.new("Frame", SliderFill)
            Thumb.Size = UDim2.new(0, 3, 0, 16)
            Thumb.Position = UDim2.new(1, -1, 0.5, -8)
            Thumb.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Instance.new("UICorner", Thumb).CornerRadius = UDim.new(1, 0)

            local SliderBtn = Instance.new("TextButton", SliderBg)
            SliderBtn.Size = UDim2.new(1, 0, 1, 20)
            SliderBtn.Position = UDim2.new(0, 0, 0, -10)
            SliderBtn.BackgroundTransparency = 1
            SliderBtn.Text = ""

            local dragging = false
            SliderBtn.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = true end
            end)
            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = false end
            end)
            UserInputService.InputChanged:Connect(function(input)
                if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                    local mPos = UserInputService:GetMouseLocation().X
                    local sPos = SliderBg.AbsolutePosition.X
                    local sSize = SliderBg.AbsoluteSize.X
                    local pct = math.clamp((mPos - sPos) / sSize, 0, 1)
                    local val = math.floor(min + ((max - min) * pct))
                    
                    ValueLabel.Text = tostring(val)
                    TweenService:Create(SliderFill, TweenInfo.new(0.05), {Size = UDim2.new(pct, 0, 1, 0)}):Play()
                    pcall(callback, val)
                end
            end)
        end

        function TabElements:AddDropdown(cfg)
            local title = cfg.Title or "Dropdown"
            local options = cfg.Options or {}
            local default = cfg.Default or ""
            local callback = cfg.Callback or function() end

            local CurrentValue = default == "" and "Select Option" or default

            local TriggerBtn = Instance.new("TextButton", TabContainer)
            TriggerBtn.Size = UDim2.new(1, 0, 0, 50)
            TriggerBtn.BackgroundColor3 = Theme.FlatBg
            TriggerBtn.AutoButtonColor = false
            TriggerBtn.Text = ""
            Instance.new("UICorner", TriggerBtn).CornerRadius = UDim.new(0, 6)

            local LblTitle = Instance.new("TextLabel", TriggerBtn)
            LblTitle.Size = UDim2.new(1, -60, 0, 20)
            LblTitle.Position = UDim2.new(0, 15, 0, 8)
            LblTitle.BackgroundTransparency = 1
            LblTitle.Text = title
            LblTitle.TextColor3 = Theme.TextWhite
            LblTitle.Font = Enum.Font.GothamBold
            LblTitle.TextSize = 14
            LblTitle.TextXAlignment = Enum.TextXAlignment.Left

            local LblVal = Instance.new("TextLabel", TriggerBtn)
            LblVal.Size = UDim2.new(1, -60, 0, 15)
            LblVal.Position = UDim2.new(0, 15, 0, 28)
            LblVal.BackgroundTransparency = 1
            LblVal.Text = CurrentValue
            LblVal.TextColor3 = Theme.TextGrey
            LblVal.Font = Enum.Font.GothamMedium
            LblVal.TextSize = 12
            LblVal.TextXAlignment = Enum.TextXAlignment.Left

            local DropIcon = Instance.new("ImageLabel", TriggerBtn)
            DropIcon.Size = UDim2.new(0, 22, 0, 22)
            DropIcon.Position = UDim2.new(1, -35, 0.5, -11)
            DropIcon.BackgroundTransparency = 1
            DropIcon.Image = "rbxassetid://11419713314" 
            DropIcon.ImageColor3 = Theme.TextGrey

            local Blocker = Instance.new("TextButton", MainFrame)
            Blocker.Size = UDim2.new(1, 0, 1, 0)
            Blocker.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
            Blocker.BackgroundTransparency = 0.4
            Blocker.Text = ""
            Blocker.ZIndex = 50
            Blocker.Visible = false

            local Popup = Instance.new("Frame", Blocker)
            Popup.Size = UDim2.new(0.9, 0, 0.8, 0)
            Popup.Position = UDim2.new(0.5, 0, -0.5, 0)
            Popup.AnchorPoint = Vector2.new(0.5, 0.5)
            Popup.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
            Popup.ZIndex = 51
            Instance.new("UICorner", Popup).CornerRadius = UDim.new(0, 8)
            
            local PopStroke = Instance.new("UIStroke", Popup)
            PopStroke.Color = Color3.fromRGB(35, 35, 35)
            PopStroke.Thickness = 1.2

            local PopTitle = Instance.new("TextLabel", Popup)
            PopTitle.Size = UDim2.new(1, -30, 0, 20)
            PopTitle.Position = UDim2.new(0, 15, 0, 15)
            PopTitle.BackgroundTransparency = 1
            PopTitle.Text = title
            PopTitle.Font = Enum.Font.GothamBold
            PopTitle.TextSize = 15
            PopTitle.TextXAlignment = Enum.TextXAlignment.Left
            PopTitle.ZIndex = 52
            table.insert(Library.ChromaCallbacks, function(color) 
                if not PopTitle.Parent then return "REMOVE" end
                PopTitle.TextColor3 = color 
            end)

            local PopSub = Instance.new("TextLabel", Popup)
            PopSub.Size = UDim2.new(1, -30, 0, 15)
            PopSub.Position = UDim2.new(0, 15, 0, 35)
            PopSub.BackgroundTransparency = 1
            PopSub.Text = CurrentValue
            PopSub.TextColor3 = Theme.TextGrey
            PopSub.Font = Enum.Font.GothamMedium
            PopSub.TextSize = 12
            PopSub.TextXAlignment = Enum.TextXAlignment.Left
            PopSub.ZIndex = 52

            local SearchBoxBg = Instance.new("Frame", Popup)
            SearchBoxBg.Size = UDim2.new(1, -30, 0, 35)
            SearchBoxBg.Position = UDim2.new(0, 15, 0, 60)
            SearchBoxBg.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
            SearchBoxBg.ZIndex = 52
            Instance.new("UICorner", SearchBoxBg).CornerRadius = UDim.new(0, 6)

            local SearchBox = Instance.new("TextBox", SearchBoxBg)
            SearchBox.Size = UDim2.new(1, -20, 1, 0)
            SearchBox.Position = UDim2.new(0, 10, 0, 0)
            SearchBox.BackgroundTransparency = 1
            SearchBox.Text = ""
            SearchBox.PlaceholderText = "Search"
            SearchBox.TextColor3 = Theme.TextWhite
            SearchBox.Font = Enum.Font.GothamMedium
            SearchBox.TextSize = 13
            SearchBox.TextXAlignment = Enum.TextXAlignment.Left
            SearchBox.ZIndex = 53

            local ScrollOpts = Instance.new("ScrollingFrame", Popup)
            ScrollOpts.Size = UDim2.new(1, -30, 1, -115)
            ScrollOpts.Position = UDim2.new(0, 15, 0, 105)
            ScrollOpts.BackgroundTransparency = 1
            ScrollOpts.ScrollBarThickness = 2
            ScrollOpts.ScrollBarImageColor3 = Color3.fromRGB(50, 50, 50)
            ScrollOpts.AutomaticCanvasSize = Enum.AutomaticSize.Y
            ScrollOpts.ZIndex = 52

            local OptLayout = Instance.new("UIListLayout", ScrollOpts)
            OptLayout.Padding = UDim.new(0, 5)

            local OptButtons = {}

            local function ClosePopup()
                local tween = TweenService:Create(Popup, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {Position = UDim2.new(0.5, 0, -0.5, 0)})
                tween:Play()
                task.wait(0.3)
                Blocker.Visible = false
            end
            
            local function LoadOptions(filter)
                for _, btn in pairs(OptButtons) do btn.Visible = false end
                
                for _, opt in ipairs(options) do
                    if filter == "" or string.find(string.lower(opt), string.lower(filter)) then
                        if not OptButtons[opt] then
                            local btn = Instance.new("TextButton", ScrollOpts)
                            btn.Size = UDim2.new(1, 0, 0, 30)
                            btn.BackgroundTransparency = 1
                            btn.Text = "  " .. opt 
                            btn.Font = Enum.Font.GothamMedium
                            btn.TextSize = 13
                            btn.TextXAlignment = Enum.TextXAlignment.Left
                            btn.ZIndex = 53
                            
                            btn.MouseButton1Click:Connect(function()
                                CurrentValue = opt
                                LblVal.Text = opt
                                PopSub.Text = opt
                                ClosePopup()
                                pcall(callback, opt)
                            end)
                            
                            OptButtons[opt] = btn
                            
                            table.insert(Library.ChromaCallbacks, function(color)
                                if not btn.Parent then return "REMOVE" end
                                if CurrentValue == opt then
                                    btn.TextColor3 = color
                                else
                                    btn.TextColor3 = Theme.TextWhite
                                end
                            end)
                        end
                        OptButtons[opt].Visible = true
                    end
                end
            end

            LoadOptions("")

            SearchBox.Changed:Connect(function(prop)
                if prop == "Text" then LoadOptions(SearchBox.Text) end
            end)

            TriggerBtn.MouseButton1Click:Connect(function()
                Blocker.Visible = true
                SearchBox.Text = ""
                LoadOptions("")
                Popup.Position = UDim2.new(0.5, 0, -0.5, 0)
                TweenService:Create(Popup, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Position = UDim2.new(0.5, 0, 0.5, 0)}):Play()
            end)

            Blocker.MouseButton1Click:Connect(function() 
                ClosePopup()
            end)

            return {
                Refresh = function(newOpts)
                    options = newOpts
                    for _, btn in pairs(OptButtons) do btn:Destroy() end
                    OptButtons = {}
                    LoadOptions(SearchBox.Text)
                end
            }
        end

        return TabElements
    end

    return Window
end

local xRedzWrapper = {}

function xRedzWrapper:MakeWindow(options)
    local options = options or {}
    
    local SM_Window = Library:CreateWindow({ 
        Title = options.Title or "MinhZ Hub UI Library V2", 
        SubTitle = options.SubTitle or "Bloz Kids Edition",
        DiscordLink = "https://discord.gg/q2DzqWgpTC"
    })

    local Adapter = {}

    function Adapter:MakeTab(opt)
        local opt = opt or {}
        local smTab = SM_Window:MakeTab({
            Title = opt.Title or opt.Name or "Tab",
            SubTitle = "",
            Icon = opt.Icon or "rbxassetid://7733655511"
        })
        
        local TabWrapper = {}
        
        local function GetLangDesc(data)
            if type(data) ~= "table" then return "" end
            
            local currentLang = _G.Language or "Tiếng Việt"
            
            if currentLang == "Português (Brasil)" and data.DescriptionBR then
                return data.DescriptionBR
            elseif currentLang == "Tiếng Việt" and data.DescriptionVI then
                return data.DescriptionVI
            end
            
            return data.Description or data.SubTitle or ""
        end
        
        function TabWrapper:AddSection(data)
            local text = type(data) == "table" and (data[1] or data.Name or data.Title) or data
            smTab:AddSection(text)
        end
        
        function TabWrapper:AddButton(data)
            local data = data or {}
            smTab:AddButton({
                Title = data.Name or data.Title or "Button",
                SubTitle = GetLangDesc(data),
                Callback = data.Callback or function() end
            })
        end
        
        function TabWrapper:AddToggle(data)
            local data = data or {}
            local def = data.Default or false
            smTab:AddToggle({
                Title = data.Name or data.Title or "Toggle",
                SubTitle = GetLangDesc(data),
                Default = def,
                Callback = data.Callback or function() end
            })
            
            if data.Callback then
                task.spawn(function() pcall(data.Callback, def) end)
            end
        end
        
        function TabWrapper:AddDropdown(data)
            local data = data or {}
            local def = data.Default or ""
            local dropdownObj = smTab:AddDropdown({
                Title = data.Name or data.Title or "Dropdown",
                SubTitle = GetLangDesc(data),
                Options = data.Options or {},
                Default = def,
                Callback = data.Callback or function() end
            })
            
            if data.Callback and def ~= "" then
                task.spawn(function() pcall(data.Callback, def) end)
            end
            
            return {
                Refresh = function(self, newOptions)
                    if dropdownObj and dropdownObj.Refresh then
                        dropdownObj.Refresh(newOptions)
                    end
                end
            }
        end
        
        function TabWrapper:AddTextBox(data)
            local data = data or {}
            smTab:CreateBox({
                Title = data.Name or data.Title or "TextBox",
                Placeholder = data.Placeholder or data.PlaceHolder or "Type here...",
                Default = data.Default or "",
                Callback = data.Callback or function() end
            })
        end
        
        function TabWrapper:AddParagraph(data)
            local data = data or {}
            local titleText = data.Title or data.Name or "Status"
            local initialVal = data.Content or data.Desc or data.Description or "..."
            local infoObj = smTab:AddInfoLabel({ Title = titleText, Value = initialVal })
            return { SetDesc = function(self, text) if infoObj and infoObj.SetDesc then infoObj:SetDesc(text) end end }
        end
        
        function TabWrapper:AddDiscordInvite(data)
            local data = data or {}
            smTab:AddButton({
                Title = "Join Server Discord",
                SubTitle = GetLangDesc(data),
                Callback = function() setclipboard(data.Invite or "https://discord.gg/q2DzqWgpTC") end
            })
        end
        
        return TabWrapper
    end
