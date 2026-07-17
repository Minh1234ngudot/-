local InconUI = {Connections={},Flags={},Elements={},CurrentFont=Font.new("rbxasset://fonts/families/Inconsolata.json",Enum.FontWeight.Regular,Enum.FontStyle.Normal),Hubs={}}
local TS=game:GetService("TweenService")
local UIS=game:GetService("UserInputService")
local RS=game:GetService("RunService")
local Players=game:GetService("Players")
local Http=game:GetService("HttpService")
local LP=Players.LocalPlayer
function InconUI:SetFont(FontId)
    if string.find(tostring(FontId),"rbxasset") then self.CurrentFont=Font.new(FontId,Enum.FontWeight.Regular,Enum.FontStyle.Normal)
    else self.CurrentFont=Font.fromId(tonumber(FontId) or 12187365364,Enum.FontWeight.Regular,Enum.FontStyle.Normal) end
end
function InconUI:MakeNotify(Options)
    local Title=Options.Title or "Notification"
    local Content=Options.Content or ""
    local Time=Options.Time or 3
    local ParentUI=nil
    pcall(function() ParentUI=game:GetService("CoreGui") end)
    if type(gethui)=="function" then ParentUI=gethui() end
    if not ParentUI then ParentUI=LP:WaitForChild("PlayerGui") end
    local NotifyUI=ParentUI:FindFirstChild("InconUI_Notify")
    if not NotifyUI then
        local NewNotifyUI=Instance.new("ScreenGui")
        NewNotifyUI.Name="InconUI_Notify"
        NewNotifyUI.ResetOnSpawn=false
        NewNotifyUI.IgnoreGuiInset=true
        NewNotifyUI.ZIndexBehavior=Enum.ZIndexBehavior.Sibling
        local Layout=Instance.new("Frame")
        Layout.Name="Layout"
        Layout.AnchorPoint=Vector2.new(1,1)
        Layout.Size=UDim2.new(0,250,1,-30)
        Layout.Position=UDim2.new(1,-15,1,-15)
        Layout.BackgroundTransparency=1
        Layout.Parent=NewNotifyUI
        local UIL=Instance.new("UIListLayout")
        UIL.SortOrder=Enum.SortOrder.LayoutOrder
        UIL.VerticalAlignment=Enum.VerticalAlignment.Bottom
        UIL.Padding=UDim.new(0,10)
        UIL.Parent=Layout
        NewNotifyUI.Parent=ParentUI
        NotifyUI=ParentUI:FindFirstChild("InconUI_Notify") or NewNotifyUI
        if NotifyUI~=NewNotifyUI then NewNotifyUI:Destroy() end
        table.insert(self.Hubs,NotifyUI)
    end
    local NoteFrame=Instance.new("Frame")
    NoteFrame.Size=UDim2.new(1,0,0,60)
    NoteFrame.BackgroundColor3=Color3.fromRGB(20,20,20)
    NoteFrame.BorderColor3=Color3.fromRGB(56,56,56)
    NoteFrame.Position=UDim2.new(1,50,0,0)
    NoteFrame.BackgroundTransparency=1
    NoteFrame.Parent=NotifyUI.Layout
    local TxtTitle=Instance.new("TextLabel")
    TxtTitle.Size=UDim2.new(1,-20,0,20)
    TxtTitle.Position=UDim2.new(0,10,0,5)
    TxtTitle.BackgroundTransparency=1
    TxtTitle.Text=Title
    TxtTitle.TextColor3=Color3.fromRGB(255,255,255)
    TxtTitle.TextXAlignment=Enum.TextXAlignment.Left
    TxtTitle.FontFace=self.CurrentFont
    TxtTitle.TextSize=13
    TxtTitle.TextTransparency=1
    TxtTitle.Parent=NoteFrame
    local TxtContent=Instance.new("TextLabel")
    TxtContent.Size=UDim2.new(1,-20,0,25)
    TxtContent.Position=UDim2.new(0,10,0,25)
    TxtContent.BackgroundTransparency=1
    TxtContent.Text=Content
    TxtContent.TextColor3=Color3.fromRGB(180,180,180)
    TxtContent.TextXAlignment=Enum.TextXAlignment.Left
    TxtContent.TextYAlignment=Enum.TextYAlignment.Top
    TxtContent.TextWrapped=true
    TxtContent.FontFace=self.CurrentFont
    TxtContent.TextSize=11
    TxtContent.TextTransparency=1
    TxtContent.Parent=NoteFrame
    local TimeBar=Instance.new("Frame")
    TimeBar.Size=UDim2.new(1,0,0,2)
    TimeBar.Position=UDim2.new(0,0,1,-2)
    TimeBar.BackgroundColor3=Color3.fromRGB(255,255,255)
    TimeBar.BorderSizePixel=0
    TimeBar.BackgroundTransparency=1
    TimeBar.Parent=NoteFrame
    TS:Create(NoteFrame,TweenInfo.new(0.3,Enum.EasingStyle.Quart,Enum.EasingDirection.Out),{Position=UDim2.new(0,0,0,0),BackgroundTransparency=0}):Play()
    TS:Create(TxtTitle,TweenInfo.new(0.3),{TextTransparency=0}):Play()
    TS:Create(TxtContent,TweenInfo.new(0.3),{TextTransparency=0}):Play()
    TS:Create(TimeBar,TweenInfo.new(0.3),{BackgroundTransparency=0}):Play()
    TS:Create(TimeBar,TweenInfo.new(Time,Enum.EasingStyle.Linear),{Size=UDim2.new(0,0,0,2)}):Play()
    task.delay(Time,function()
        TS:Create(NoteFrame,TweenInfo.new(0.3,Enum.EasingStyle.Quart,Enum.EasingDirection.In),{Position=UDim2.new(1,50,0,0),BackgroundTransparency=1}):Play()
        TS:Create(TxtTitle,TweenInfo.new(0.3),{TextTransparency=1}):Play()
        TS:Create(TxtContent,TweenInfo.new(0.3),{TextTransparency=1}):Play()
        TS:Create(TimeBar,TweenInfo.new(0.3),{BackgroundTransparency=1}):Play()
        task.delay(0.3,function() NoteFrame:Destroy() end)
    end)
end
function InconUI:CreateWindow(Options)
    Options=Options or {}
    if Options.SupportedExecutors and type(Options.SupportedExecutors)=="table" then
        local currentExec="Unknown"
        pcall(function() currentExec=identifyexecutor() end)
        local isSupported=false
        for _,exec in ipairs(Options.SupportedExecutors) do
            if string.find(string.lower(currentExec),string.lower(tostring(exec))) then
                isSupported=true
                break
            end
        end
        if not isSupported then
            LP:Kick("Your Executor Not Support This Script. Executor Support: "..table.concat(Options.SupportedExecutors,", "))
            task.wait(9e9)
            return nil
        end
    end
    local TitleText=Options.Name or "Incon UI Library"
    local ToggleKeyStr=Options.ToggleUIKeybind or "RightControl"
    local BindKey
    pcall(function() BindKey=Enum.KeyCode[ToggleKeyStr] end)
    BindKey=BindKey or Enum.KeyCode.RightControl
    local ConfigFolder=Options.Folder or "InconConfigs"
    local WelcomeTitle=Options.WelcomeTitle or "Welcome"
    local WelcomeName=Options.WelcomeName or TitleText
    local TopBarText=Options.TopBarText or TitleText
    local Window={CurrentPage=nil,Pages={},TabIndex=0,IsUnlocked=not Options.HasKeySystem,IsMinimized=false}
    local ParentUI=nil
    local success,coreGui=pcall(function() return game:GetService("CoreGui") end)
    if success and coreGui then ParentUI=coreGui end
    if type(gethui)=="function" then ParentUI=gethui() end
    if not ParentUI then ParentUI=LP:WaitForChild("PlayerGui") end
    for _,gui in ipairs(ParentUI:GetChildren()) do
        if gui.Name=="InconUI_Hub" or gui.Name=="InconUI_WM" or gui.Name=="InconUI_CP" then gui:Destroy() end
    end
    local function AddDragLogic(frame,dragHandle)
        dragHandle=dragHandle or frame
        local dragToggle=nil
        local dragSpeed=0.25
        local dragStart=nil
        local startPos=nil
        local function updateInput(input)
            local delta=input.Position-dragStart
            local position=UDim2.new(startPos.X.Scale,startPos.X.Offset+delta.X,startPos.Y.Scale,startPos.Y.Offset+delta.Y)
            TS:Create(frame,TweenInfo.new(dragSpeed),{Position=position}):Play()
        end
        table.insert(InconUI.Connections,dragHandle.InputBegan:Connect(function(input)
            if (input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch) then 
                dragToggle=true
                dragStart=input.Position
                startPos=frame.Position
                local changeCon
                changeCon=input.Changed:Connect(function()
                    if input.UserInputState==Enum.UserInputState.End then
                        dragToggle=false
                        if changeCon then changeCon:Disconnect() end
                    end
                end)
            end
        end))
        table.insert(InconUI.Connections,UIS.InputChanged:Connect(function(input)
            if input.UserInputType==Enum.UserInputType.MouseMovement or input.UserInputType==Enum.UserInputType.Touch then
                if dragToggle then updateInput(input) end
            end
        end))
    end
    function Window:InitFolder()
        if isfolder and makefolder then
            if not isfolder(ConfigFolder) then makefolder(ConfigFolder) end
            if not isfolder(ConfigFolder.."/settings") then makefolder(ConfigFolder.."/settings") end
        end
    end
    Window:InitFolder()
    local KeySavePath=ConfigFolder.."/settings/SavedKey.json"
    local function CheckSavedKey()
        if Options.KeySettings and Options.KeySettings.SaveKey then
            if isfile and isfile(KeySavePath) then
                local s,d=pcall(function() return Http:JSONDecode(readfile(KeySavePath)) end)
                if s and d and d.Key and d.Exp then
                    if d.Exp==0 or os.time()<d.Exp then
                        local reqKey=Options.KeySettings.Key
                        local valid=false
                        if type(reqKey)=="table" then
                            for _,k in ipairs(reqKey) do
                                if d.Key==k then valid=true break end
                            end
                        elseif d.Key==reqKey then valid=true end
                        return valid
                    end
                end
            end
        end
        return false
    end
    if Options.HasKeySystem then
        if CheckSavedKey() then Window.IsUnlocked=true end
    end
    local ScreenGui=Instance.new("ScreenGui")
    ScreenGui.Name="InconUI_Hub"
    ScreenGui.ResetOnSpawn=false
    ScreenGui.IgnoreGuiInset=true
    ScreenGui.ZIndexBehavior=Enum.ZIndexBehavior.Sibling
    ScreenGui.Parent=ParentUI
    table.insert(InconUI.Hubs,ScreenGui)
    local WMGui=Instance.new("ScreenGui")
    WMGui.Name="InconUI_WM"
    WMGui.ResetOnSpawn=false
    WMGui.IgnoreGuiInset=true
    WMGui.ZIndexBehavior=Enum.ZIndexBehavior.Sibling
    WMGui.Parent=ParentUI
    table.insert(InconUI.Hubs,WMGui)
    local CPGui=Instance.new("ScreenGui")
    CPGui.Name="InconUI_CP"
    CPGui.ResetOnSpawn=false
    CPGui.IgnoreGuiInset=true
    CPGui.ZIndexBehavior=Enum.ZIndexBehavior.Sibling
    CPGui.Parent=ParentUI
    table.insert(InconUI.Hubs,CPGui)
    function Window:CreateDialog(DiagOptions)
        local Overlay=Instance.new("TextButton")
        Overlay.Size=UDim2.new(1,0,1,0)
        Overlay.BackgroundColor3=Color3.fromRGB(0,0,0)
        Overlay.BackgroundTransparency=0.5
        Overlay.AutoButtonColor=false
        Overlay.Text=""
        Overlay.ZIndex=200
        Overlay.Parent=ScreenGui
        local Box=Instance.new("Frame")
        Box.Size=UDim2.new(0,300,0,140)
        Box.Position=UDim2.new(0.5,-150,0.5,-70)
        Box.BackgroundColor3=Color3.fromRGB(15,15,15)
        Box.BorderColor3=Color3.fromRGB(56,56,56)
        Box.ZIndex=201
        Box.Parent=Overlay
        local Title=Instance.new("TextLabel")
        Title.Size=UDim2.new(1,0,0,30)
        Title.BackgroundTransparency=1
        Title.Text=DiagOptions.Title or "Confirmation"
        Title.TextColor3=Color3.fromRGB(255,255,255)
        Title.FontFace=InconUI.CurrentFont
        Title.TextSize=14
        Title.ZIndex=202
        Title.Parent=Box
        local Content=Instance.new("TextLabel")
        Content.Size=UDim2.new(1,-20,0,40)
        Content.Position=UDim2.new(0,10,0,40)
        Content.BackgroundTransparency=1
        Content.Text=DiagOptions.Content or "Are You Sure?"
        Content.TextColor3=Color3.fromRGB(200,200,200)
        Content.TextWrapped=true
        Content.FontFace=InconUI.CurrentFont
        Content.TextSize=12
        Content.ZIndex=202
        Content.Parent=Box
        local ConfirmBtn=Instance.new("TextButton")
        ConfirmBtn.Size=UDim2.new(0.5,-15,0,30)
        ConfirmBtn.Position=UDim2.new(0,10,0,100)
        ConfirmBtn.BackgroundColor3=Color3.fromRGB(30,80,30)
        ConfirmBtn.BorderColor3=Color3.fromRGB(56,56,56)
        ConfirmBtn.TextColor3=Color3.fromRGB(255,255,255)
        ConfirmBtn.Text=DiagOptions.ConfirmText or "Yes"
        ConfirmBtn.FontFace=InconUI.CurrentFont
        ConfirmBtn.TextSize=12
        ConfirmBtn.ZIndex=202
        ConfirmBtn.Parent=Box
        local CancelBtn=Instance.new("TextButton")
        CancelBtn.Size=UDim2.new(0.5,-15,0,30)
        CancelBtn.Position=UDim2.new(0.5,5,0,100)
        CancelBtn.BackgroundColor3=Color3.fromRGB(80,30,30)
        CancelBtn.BorderColor3=Color3.fromRGB(56,56,56)
        CancelBtn.TextColor3=Color3.fromRGB(255,255,255)
        CancelBtn.Text=DiagOptions.CancelText or "No"
        CancelBtn.FontFace=InconUI.CurrentFont
        CancelBtn.TextSize=12
        CancelBtn.ZIndex=202
        CancelBtn.Parent=Box
        local function CloseDialog(state)
            TS:Create(Overlay,TweenInfo.new(0.2),{BackgroundTransparency=1}):Play()
            TS:Create(Box,TweenInfo.new(0.2),{BackgroundTransparency=1}):Play()
            Title.TextTransparency=1
            Content.TextTransparency=1
            ConfirmBtn.TextTransparency=1
            ConfirmBtn.BackgroundTransparency=1
            CancelBtn.TextTransparency=1
            CancelBtn.BackgroundTransparency=1
            task.delay(0.2,function() Overlay:Destroy() if DiagOptions.Callback then DiagOptions.Callback(state) end end)
        end
        table.insert(InconUI.Connections,ConfirmBtn.MouseButton1Click:Connect(function() CloseDialog(true) end))
        table.insert(InconUI.Connections,CancelBtn.MouseButton1Click:Connect(function() CloseDialog(false) end))
    end
    local WMFrame=Instance.new("Frame")
    WMFrame.Size=UDim2.new(0,0,0,25)
    WMFrame.Position=UDim2.new(0.5,0,0,10)
    WMFrame.AnchorPoint=Vector2.new(0.5,0)
    WMFrame.BackgroundColor3=Color3.fromRGB(15,15,15)
    WMFrame.BorderColor3=Color3.fromRGB(56,56,56)
    WMFrame.AutomaticSize=Enum.AutomaticSize.X
    WMFrame.Visible=Window.IsUnlocked
    WMFrame.Parent=WMGui
    local WMPad=Instance.new("UIPadding")
    WMPad.PaddingLeft=UDim.new(0,10)
    WMPad.PaddingRight=UDim.new(0,10)
    WMPad.Parent=WMFrame
    local WMTxt=Instance.new("TextLabel")
    WMTxt.Size=UDim2.new(0,0,1,0)
    WMTxt.AutomaticSize=Enum.AutomaticSize.X
    WMTxt.BackgroundTransparency=1
    WMTxt.TextColor3=Color3.fromRGB(220,220,220)
    WMTxt.FontFace=InconUI.CurrentFont
    WMTxt.TextSize=12
    WMTxt.Parent=WMFrame
    local fpsCount=0
    local lastTime=tick()
    local wmCon=RS.RenderStepped:Connect(function()
        fpsCount=fpsCount+1
        if tick()-lastTime>=1 then
            WMTxt.Text=TitleText.." | "..LP.Name.." | "..fpsCount.." FPS"
            fpsCount=0
            lastTime=tick()
        end
    end)
    table.insert(InconUI.Connections,wmCon)
    AddDragLogic(WMFrame,WMFrame)
    local MasterFrame=Instance.new("Frame")
    MasterFrame.Name="MasterFrame"
    MasterFrame.BackgroundTransparency=1
    MasterFrame.Size=UDim2.new(0,450,0,280)
    MasterFrame.Position=UDim2.new(0.5,-225,0.5,-140)
    MasterFrame.ZIndex=1
    MasterFrame.Visible=false
    MasterFrame.Parent=ScreenGui
    local FloatBtn=Instance.new("ImageButton")
    FloatBtn.Size=UDim2.new(0,40,0,40)
    FloatBtn.Position=UDim2.new(0.5,-20,0.1,0)
    FloatBtn.Image="rbxthumb://type=AvatarHeadShot&id="..LP.UserId.."&w=150&h=150"
    FloatBtn.BackgroundColor3=Color3.fromRGB(15,15,15)
    FloatBtn.BorderColor3=Color3.fromRGB(56,56,56)
    FloatBtn.Visible=false
    FloatBtn.Parent=ScreenGui
    Instance.new("UICorner",FloatBtn).CornerRadius=UDim.new(0,8)
    AddDragLogic(FloatBtn,FloatBtn)
    table.insert(InconUI.Connections,FloatBtn.MouseButton1Click:Connect(function()
        FloatBtn.Visible=false
        MasterFrame.Visible=true
        Window.IsMinimized=false
    end))
    local KeyFrame=Instance.new("Frame")
    KeyFrame.Size=UDim2.new(0,350,0,160)
    KeyFrame.Position=UDim2.new(0.5,-175,0.5,-80)
    KeyFrame.BackgroundColor3=Color3.fromRGB(11,11,11)
    KeyFrame.BorderColor3=Color3.fromRGB(56,56,56)
    KeyFrame.BorderSizePixel=1
    KeyFrame.Visible=false
    KeyFrame.Parent=ScreenGui
    local KeyTopBar=Instance.new("Frame")
    KeyTopBar.Size=UDim2.new(1,0,0,22)
    KeyTopBar.BackgroundColor3=Color3.fromRGB(23,23,23)
    KeyTopBar.BorderSizePixel=0
    KeyTopBar.Parent=KeyFrame
    local KeyTitle=Instance.new("TextLabel")
    KeyTitle.Size=UDim2.new(1,0,1,0)
    KeyTitle.Position=UDim2.new(0,0,0,0)
    KeyTitle.BackgroundTransparency=1
    KeyTitle.Text=Options.KeySettings and Options.KeySettings.Title or "Key System"
    KeyTitle.TextColor3=Color3.fromRGB(181,181,181)
    KeyTitle.TextXAlignment=Enum.TextXAlignment.Center
    KeyTitle.FontFace=InconUI.CurrentFont
    KeyTitle.TextSize=12
    KeyTitle.Parent=KeyTopBar
    AddDragLogic(KeyFrame,KeyTopBar)
    local KeyInputContainer=Instance.new("Frame")
    KeyInputContainer.Size=UDim2.new(1,-20,0,40)
    KeyInputContainer.Position=UDim2.new(0,10,0,45)
    KeyInputContainer.BackgroundColor3=Color3.fromRGB(26,26,26)
    KeyInputContainer.BorderColor3=Color3.fromRGB(51,51,51)
    KeyInputContainer.Parent=KeyFrame
    local KeyInput=Instance.new("TextBox")
    KeyInput.Size=UDim2.new(1,-20,1,0)
    KeyInput.Position=UDim2.new(0,10,0,0)
    KeyInput.BackgroundTransparency=1
    KeyInput.TextColor3=Color3.fromRGB(200,200,200)
    KeyInput.PlaceholderText="Enter Key..."
    KeyInput.Text=""
    KeyInput.FontFace=InconUI.CurrentFont
    KeyInput.TextSize=12
    KeyInput.TextXAlignment=Enum.TextXAlignment.Left
    KeyInput.Parent=KeyInputContainer
    local KeySubmit=Instance.new("TextButton")
    KeySubmit.Size=UDim2.new(0.5,-15,0,35)
    KeySubmit.Position=UDim2.new(0,10,0,105)
    KeySubmit.BackgroundColor3=Color3.fromRGB(26,26,26)
    KeySubmit.BorderColor3=Color3.fromRGB(51,51,51)
    KeySubmit.TextColor3=Color3.fromRGB(201,201,201)
    KeySubmit.Text="Submit Key"
    KeySubmit.FontFace=InconUI.CurrentFont
    KeySubmit.TextSize=12
    KeySubmit.Parent=KeyFrame
    local KeyGet=Instance.new("TextButton")
    KeyGet.Size=UDim2.new(0.5,-15,0,35)
    KeyGet.Position=UDim2.new(0.5,5,0,105)
    KeyGet.BackgroundColor3=Color3.fromRGB(26,26,26)
    KeyGet.BorderColor3=Color3.fromRGB(51,51,51)
    KeyGet.TextColor3=Color3.fromRGB(201,201,201)
    KeyGet.Text="Get Key"
    KeyGet.FontFace=InconUI.CurrentFont
    KeyGet.TextSize=12
    KeyGet.Parent=KeyFrame
    table.insert(InconUI.Connections,KeyGet.MouseButton1Click:Connect(function()
        local link=Options.KeySettings and Options.KeySettings.Link or ""
        if setclipboard then setclipboard(link) end
        InconUI:MakeNotify({Title="Key System",Content="Copied Link To Clipboard!",Time=3})
    end))
    table.insert(InconUI.Connections,KeySubmit.MouseButton1Click:Connect(function()
        local valid=false
        local reqKey=Options.KeySettings and Options.KeySettings.Key or ""
        if type(reqKey)=="table" then
            for _,k in ipairs(reqKey) do
                if KeyInput.Text==k then valid=true break end
            end
        elseif KeyInput.Text==reqKey then valid=true end
        if valid then
            if Options.KeySettings and Options.KeySettings.SaveKey and writefile then
                local exp=0
                if Options.KeySettings.MaxTime and Options.KeySettings.MaxTime>0 then exp=os.time()+Options.KeySettings.MaxTime end
                local data=Http:JSONEncode({Key=KeyInput.Text,Exp=exp})
                writefile(KeySavePath,data)
            end
            Window.IsUnlocked=true
            KeyFrame.Visible=false
            MasterFrame.Visible=true
            WMFrame.Visible=true
            InconUI:MakeNotify({Title="Key System",Content="Valid Key Entered!",Time=3})
        else
            InconUI:MakeNotify({Title="Key System",Content="Invalid Key!",Time=3})
        end
    end))
    if Options.HasKeySystem and not Window.IsUnlocked then KeyFrame.Visible=true
    elseif Window.IsUnlocked then MasterFrame.Visible=true end
    local SideBarContainer=Instance.new("Frame")
    SideBarContainer.Name="SideBarContainer"
    SideBarContainer.Size=UDim2.new(0,130,1,0)
    SideBarContainer.Position=UDim2.new(0,-110,0,0)
    SideBarContainer.BackgroundColor3=Color3.fromRGB(10,10,10)
    SideBarContainer.BorderSizePixel=0
    SideBarContainer.ZIndex=1
    SideBarContainer.Parent=MasterFrame
    local S_TopBorder=Instance.new("Frame")
    S_TopBorder.Size=UDim2.new(1,0,0,1)
    S_TopBorder.Position=UDim2.new(0,0,0,-1)
    S_TopBorder.BackgroundColor3=Color3.fromRGB(56,56,56)
    S_TopBorder.BorderSizePixel=0
    S_TopBorder.ZIndex=2
    S_TopBorder.Parent=SideBarContainer
    local S_BotBorder=Instance.new("Frame")
    S_BotBorder.Size=UDim2.new(1,0,0,1)
    S_BotBorder.Position=UDim2.new(0,0,1,0)
    S_BotBorder.BackgroundColor3=Color3.fromRGB(56,56,56)
    S_BotBorder.BorderSizePixel=0
    S_BotBorder.ZIndex=2
    S_BotBorder.Parent=SideBarContainer
    local S_LeftBorder=Instance.new("Frame")
    S_LeftBorder.Size=UDim2.new(0,1,1,0)
    S_LeftBorder.Position=UDim2.new(0,-1,0,0)
    S_LeftBorder.BackgroundColor3=Color3.fromRGB(56,56,56)
    S_LeftBorder.BorderSizePixel=0
    S_LeftBorder.ZIndex=2
    S_LeftBorder.Parent=SideBarContainer
    local SideBarMask=Instance.new("Frame")
    SideBarMask.Name="SideBarMask"
    SideBarMask.Size=UDim2.new(0,110,1,0)
    SideBarMask.Position=UDim2.new(0,0,0,0)
    SideBarMask.BackgroundTransparency=1
    SideBarMask.ClipsDescendants=true
    SideBarMask.ZIndex=3
    SideBarMask.Parent=SideBarContainer
    local MainBg=Instance.new("Frame")
    MainBg.Name="MainBg"
    MainBg.Size=UDim2.new(1,0,1,0)
    MainBg.Position=UDim2.new(0,0,0,0)
    MainBg.BackgroundColor3=Color3.fromRGB(11,11,11)
    MainBg.BorderColor3=Color3.fromRGB(56,56,56)
    MainBg.BorderSizePixel=1
    MainBg.ZIndex=10
    MainBg.Parent=MasterFrame
    local TopBar=Instance.new("Frame")
    TopBar.Name="TopBar"
    TopBar.BackgroundColor3=Color3.fromRGB(23,23,23)
    TopBar.BorderSizePixel=0
    TopBar.Size=UDim2.new(1,0,0,22)
    TopBar.ZIndex=11
    TopBar.Parent=MainBg
    local TopLabel=Instance.new("TextLabel")
    TopLabel.Text=TopBarText
    TopLabel.FontFace=InconUI.CurrentFont
    TopLabel.TextSize=12
    TopLabel.TextColor3=Color3.fromRGB(181,181,181)
    TopLabel.TextXAlignment=Enum.TextXAlignment.Center
    TopLabel.BackgroundTransparency=1
    TopLabel.Size=UDim2.new(1,0,1,0)
    TopLabel.Position=UDim2.new(0,0,0,0)
    TopLabel.ZIndex=12
    TopLabel.Parent=TopBar
    local CloseBtn=Instance.new("TextButton")
    CloseBtn.Size=UDim2.new(0,22,0,22)
    CloseBtn.Position=UDim2.new(1,-22,0,0)
    CloseBtn.BackgroundTransparency=1
    CloseBtn.Text="X"
    CloseBtn.TextColor3=Color3.fromRGB(200,100,100)
    CloseBtn.FontFace=InconUI.CurrentFont
    CloseBtn.TextSize=12
    CloseBtn.ZIndex=12
    CloseBtn.Parent=TopBar
    table.insert(InconUI.Connections,CloseBtn.MouseButton1Click:Connect(function() 
        Window:CreateDialog({
            Title="Close Interface",
            Content="Are You Sure You Want To Destroy The Interface?",
            ConfirmText="Close",
            CancelText="Cancel",
            Callback=function(State) if State then InconUI:Destroy() end end
        })
    end))
    local MinBtn=Instance.new("TextButton")
    MinBtn.Size=UDim2.new(0,22,0,22)
    MinBtn.Position=UDim2.new(1,-44,0,0)
    MinBtn.BackgroundTransparency=1
    MinBtn.Text="-"
    MinBtn.TextColor3=Color3.fromRGB(200,200,200)
    MinBtn.FontFace=InconUI.CurrentFont
    MinBtn.TextSize=14
    MinBtn.ZIndex=12
    MinBtn.Parent=TopBar
    table.insert(InconUI.Connections,MinBtn.MouseButton1Click:Connect(function()
        MasterFrame.Visible=false
        FloatBtn.Visible=true
        Window.IsMinimized=true
    end))
    AddDragLogic(MasterFrame,TopBar)
    table.insert(InconUI.Connections,UIS.InputBegan:Connect(function(input,gp)
        if not Window.IsUnlocked then return end
        if not gp and input.KeyCode==BindKey then
            if MasterFrame.Visible then
                MasterFrame.Visible=false
                FloatBtn.Visible=true
                Window.IsMinimized=true
            elseif FloatBtn.Visible then
                FloatBtn.Visible=false
                MasterFrame.Visible=true
                Window.IsMinimized=false
            else
                MasterFrame.Visible=true
                Window.IsMinimized=false
            end
        end
    end))
    local ToggleBtn=Instance.new("TextButton")
    ToggleBtn.Name="ToggleArrow"
    ToggleBtn.Size=UDim2.new(0,15,0,30)
    ToggleBtn.Position=UDim2.new(0,-15,0.5,-15)
    ToggleBtn.BackgroundTransparency=1
    ToggleBtn.TextColor3=Color3.fromRGB(220,220,220)
    ToggleBtn.Text="<"
    ToggleBtn.FontFace=InconUI.CurrentFont
    ToggleBtn.TextSize=16
    ToggleBtn.ZIndex=13
    ToggleBtn.Parent=MainBg
    local isOpen=true
    table.insert(InconUI.Connections,ToggleBtn.MouseButton1Click:Connect(function()
        isOpen=not isOpen
        ToggleBtn.Text=isOpen and "<" or ">"
        TS:Create(SideBarContainer,TweenInfo.new(0.3,Enum.EasingStyle.Quart,Enum.EasingDirection.Out),{Position=UDim2.new(0,isOpen and 0 or -110,0,0)}):Play()
    end))
    local Logo=Instance.new("ImageLabel")
    Logo.Size=UDim2.new(0,56,0,56)
    Logo.Position=UDim2.new(0.5,-28,0,12)
    Logo.Image="rbxthumb://type=AvatarHeadShot&id="..LP.UserId.."&w=150&h=150"
    Logo.BackgroundTransparency=1
    Logo.ZIndex=4
    Instance.new("UICorner",Logo).CornerRadius=UDim.new(1,0)
    Logo.Parent=SideBarMask
    local Title=Instance.new("TextLabel")
    Title.Size=UDim2.new(1,-10,0,45)
    Title.Position=UDim2.new(0,5,0,75)
    Title.BackgroundTransparency=1
    Title.ZIndex=4
    Title.FontFace=InconUI.CurrentFont
    Title.TextSize=11
    Title.TextColor3=Color3.fromRGB(200,200,200)
    Title.TextWrapped=true
    Title.RichText=true
    Title.Parent=SideBarMask
    local rlCon=RS.RenderStepped:Connect(function()
        if not Title:IsDescendantOf(game) then return end
        if not MasterFrame.Visible then return end
        local hue=os.clock()%4/4
        local c=Color3.fromHSV(hue,1,1)
        local hex=string.format("#%02X%02X%02X",c.R*255,c.G*255,c.B*255)
        Title.Text=string.format('%s\n<font color="%s">%s</font>\nto\n%s',WelcomeTitle,hex,LP.Name,WelcomeName)
    end)
    table.insert(InconUI.Connections,rlCon)
    local TabContainer=Instance.new("ScrollingFrame")
    TabContainer.Size=UDim2.new(1,0,1,-125)
    TabContainer.Position=UDim2.new(0,0,0,125)
    TabContainer.BackgroundTransparency=1
    TabContainer.BorderSizePixel=0
    TabContainer.ScrollBarThickness=0
    TabContainer.CanvasSize=UDim2.new(0,0,0,0)
    TabContainer.AutomaticCanvasSize=Enum.AutomaticSize.Y
    TabContainer.ZIndex=4
    TabContainer.Parent=SideBarMask
    local UIListLayout=Instance.new("UIListLayout",TabContainer)
    UIListLayout.SortOrder=Enum.SortOrder.LayoutOrder
    UIListLayout.Padding=UDim.new(0,5)
    UIListLayout.HorizontalAlignment=Enum.HorizontalAlignment.Center
    local UIPad=Instance.new("UIPadding",TabContainer)
    UIPad.PaddingTop=UDim.new(0,2)
    UIPad.PaddingBottom=UDim.new(0,10)
    local PageMask=Instance.new("Frame")
    PageMask.Name="PageMask"
    PageMask.Size=UDim2.new(1,0,1,-22)
    PageMask.Position=UDim2.new(0,0,0,22)
    PageMask.BackgroundTransparency=1
    PageMask.ClipsDescendants=true
    PageMask.ZIndex=11
    PageMask.Parent=MainBg
    local CPPnl=Instance.new("Frame")
    CPPnl.Size=UDim2.new(0,220,0,240)
    CPPnl.Position=UDim2.new(0.5,-110,0.5,-120)
    CPPnl.BackgroundColor3=Color3.fromRGB(20,20,20)
    CPPnl.BorderColor3=Color3.fromRGB(56,56,56)
    CPPnl.BorderSizePixel=1
    CPPnl.Visible=false
    CPPnl.ZIndex=100
    CPPnl.Parent=CPGui
    local CPTopDrag=Instance.new("TextButton")
    CPTopDrag.Size=UDim2.new(1,-30,0,25)
    CPTopDrag.Position=UDim2.new(0,0,0,2)
    CPTopDrag.BackgroundTransparency=1
    CPTopDrag.Text=""
    CPTopDrag.ZIndex=101
    CPTopDrag.Parent=CPPnl
    AddDragLogic(CPPnl,CPTopDrag)
    local CPAccent=Instance.new("Frame")
    CPAccent.Size=UDim2.new(1,0,0,1)
    CPAccent.BackgroundColor3=Color3.fromRGB(0,120,255)
    CPAccent.BorderSizePixel=0
    CPAccent.ZIndex=101
    CPAccent.Parent=CPPnl
    local CPTitle=Instance.new("TextLabel")
    CPTitle.Size=UDim2.new(1,0,1,0)
    CPTitle.Position=UDim2.new(0,10,0,0)
    CPTitle.BackgroundTransparency=1
    CPTitle.Text="Color Picker"
    CPTitle.TextColor3=Color3.fromRGB(220,220,220)
    CPTitle.TextXAlignment=Enum.TextXAlignment.Left
    CPTitle.FontFace=InconUI.CurrentFont
    CPTitle.TextSize=12
    CPTitle.ZIndex=101
    CPTitle.Parent=CPTopDrag
    local CPClose=Instance.new("TextButton")
    CPClose.Size=UDim2.new(0,25,0,25)
    CPClose.Position=UDim2.new(1,-25,0,2)
    CPClose.BackgroundTransparency=1
    CPClose.Text="X"
    CPClose.TextColor3=Color3.fromRGB(200,100,100)
    CPClose.FontFace=InconUI.CurrentFont
    CPClose.TextSize=12
    CPClose.ZIndex=101
    CPClose.Parent=CPPnl
    table.insert(InconUI.Connections,CPClose.MouseButton1Click:Connect(function() CPPnl.Visible=false end))
    local MapFrame=Instance.new("Frame")
    MapFrame.Size=UDim2.new(0,170,0,170)
    MapFrame.Position=UDim2.new(0,10,0,25)
    MapFrame.BackgroundColor3=Color3.fromRGB(255,0,0)
    MapFrame.BorderSizePixel=0
    MapFrame.ZIndex=101
    MapFrame.Parent=CPPnl
    local MapWhite=Instance.new("Frame")
    MapWhite.Size=UDim2.new(1,0,1,0)
    MapWhite.BackgroundColor3=Color3.fromRGB(255,255,255)
    MapWhite.BorderSizePixel=0
    MapWhite.ZIndex=102
    MapWhite.Parent=MapFrame
    local UIG1=Instance.new("UIGradient",MapWhite)
    UIG1.Transparency=NumberSequence.new{NumberSequenceKeypoint.new(0,0),NumberSequenceKeypoint.new(1,1)}
    local MapBlack=Instance.new("Frame")
    MapBlack.Size=UDim2.new(1,0,1,0)
    MapBlack.BackgroundColor3=Color3.fromRGB(0,0,0)
    MapBlack.BorderSizePixel=0
    MapBlack.ZIndex=103
    MapBlack.Parent=MapFrame
    local UIG2=Instance.new("UIGradient",MapBlack)
    UIG2.Transparency=NumberSequence.new{NumberSequenceKeypoint.new(0,1),NumberSequenceKeypoint.new(1,0)}
    UIG2.Rotation=90
    local MapRing=Instance.new("Frame")
    MapRing.Size=UDim2.new(0,4,0,4)
    MapRing.AnchorPoint=Vector2.new(0.5,0.5)
    MapRing.Position=UDim2.new(1,0,0,0)
    MapRing.BackgroundColor3=Color3.fromRGB(255,255,255)
    MapRing.BorderSizePixel=0
    MapRing.ZIndex=105
    MapRing.Parent=MapFrame
    Instance.new("UICorner",MapRing).CornerRadius=UDim.new(1,0)
    local HueFrame=Instance.new("Frame")
    HueFrame.Size=UDim2.new(0,15,0,170)
    HueFrame.Position=UDim2.new(0,190,0,25)
    HueFrame.BackgroundColor3=Color3.fromRGB(255,255,255)
    HueFrame.BorderSizePixel=0
    HueFrame.ZIndex=101
    HueFrame.Parent=CPPnl
    local HueGrad=Instance.new("UIGradient",HueFrame)
    HueGrad.Rotation=90
    HueGrad.Color=ColorSequence.new{ColorSequenceKeypoint.new(0,Color3.fromRGB(255,0,0)),ColorSequenceKeypoint.new(0.167,Color3.fromRGB(255,255,0)),ColorSequenceKeypoint.new(0.333,Color3.fromRGB(0,255,0)),ColorSequenceKeypoint.new(0.5,Color3.fromRGB(0,255,255)),ColorSequenceKeypoint.new(0.667,Color3.fromRGB(0,0,255)),ColorSequenceKeypoint.new(0.833,Color3.fromRGB(255,0,255)),ColorSequenceKeypoint.new(1,Color3.fromRGB(255,0,0))}
    local HueLine=Instance.new("Frame")
    HueLine.Size=UDim2.new(1,4,0,2)
    HueLine.AnchorPoint=Vector2.new(0.5,0.5)
    HueLine.Position=UDim2.new(0.5,0,0,0)
    HueLine.BackgroundColor3=Color3.fromRGB(255,255,255)
    HueLine.BorderSizePixel=0
    HueLine.ZIndex=105
    HueLine.Parent=HueFrame
    local HexBox=Instance.new("TextBox")
    HexBox.Size=UDim2.new(0,80,0,25)
    HexBox.Position=UDim2.new(0,10,0,205)
    HexBox.BackgroundColor3=Color3.fromRGB(15,15,15)
    HexBox.BorderColor3=Color3.fromRGB(56,56,56)
    HexBox.TextColor3=Color3.fromRGB(220,220,220)
    HexBox.Text="#FFFFFF"
    HexBox.FontFace=InconUI.CurrentFont
    HexBox.TextSize=12
    HexBox.ZIndex=101
    HexBox.Parent=CPPnl
    local RGBBox=Instance.new("TextBox")
    RGBBox.Size=UDim2.new(0,105,0,25)
    RGBBox.Position=UDim2.new(0,100,0,205)
    RGBBox.BackgroundColor3=Color3.fromRGB(15,15,15)
    RGBBox.BorderColor3=Color3.fromRGB(56,56,56)
    RGBBox.TextColor3=Color3.fromRGB(220,220,220)
    RGBBox.Text="255, 255, 255"
    RGBBox.FontFace=InconUI.CurrentFont
    RGBBox.TextSize=12
    RGBBox.ZIndex=101
    RGBBox.Parent=CPPnl
    local CurH,CurS,CurV=0,1,1
    local CPCallback=nil
    local CPFlag=nil
    local function UpdateCPVisuals(NoCallback)
        local hc=Color3.fromHSV(CurH,1,1)
        MapFrame.BackgroundColor3=hc
        local fc=Color3.fromHSV(CurH,CurS,CurV)
        MapRing.Position=UDim2.new(CurS,0,1-CurV,0)
        HueLine.Position=UDim2.new(0.5,0,CurH,0)
        RGBBox.Text=string.format("%d, %d, %d",math.floor(fc.R*255),math.floor(fc.G*255),math.floor(fc.B*255))
        HexBox.Text=string.format("#%02X%02X%02X",math.floor(fc.R*255),math.floor(fc.G*255),math.floor(fc.B*255))
        if not NoCallback then
            if CPFlag then InconUI.Flags[CPFlag]=string.format("%d,%d,%d",math.floor(fc.R*255),math.floor(fc.G*255),math.floor(fc.B*255)) end
            if CPCallback then CPCallback(fc) end
        end
    end
    local draggingMap,draggingHue=false,false
    table.insert(InconUI.Connections,UIS.InputEnded:Connect(function(input)
        if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then
            draggingMap=false
            draggingHue=false
        end
    end))
    table.insert(InconUI.Connections,MapFrame.InputBegan:Connect(function(input)
        if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then
            draggingMap=true
            CurS=math.clamp((input.Position.X-MapFrame.AbsolutePosition.X)/MapFrame.AbsoluteSize.X,0,1)
            CurV=1-math.clamp((input.Position.Y-MapFrame.AbsolutePosition.Y)/MapFrame.AbsoluteSize.Y,0,1)
            UpdateCPVisuals(false)
        end
    end))
    table.insert(InconUI.Connections,HueFrame.InputBegan:Connect(function(input)
        if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then
            draggingHue=true
            CurH=math.clamp((input.Position.Y-HueFrame.AbsolutePosition.Y)/HueFrame.AbsoluteSize.Y,0,1)
            UpdateCPVisuals(false)
        end
    end))
    table.insert(InconUI.Connections,UIS.InputChanged:Connect(function(input)
        if input.UserInputType==Enum.UserInputType.MouseMovement or input.UserInputType==Enum.UserInputType.Touch then
            if draggingMap then
                CurS=math.clamp((input.Position.X-MapFrame.AbsolutePosition.X)/MapFrame.AbsoluteSize.X,0,1)
                CurV=1-math.clamp((input.Position.Y-MapFrame.AbsolutePosition.Y)/MapFrame.AbsoluteSize.Y,0,1)
                UpdateCPVisuals(false)
            elseif draggingHue then
                CurH=math.clamp((input.Position.Y-HueFrame.AbsolutePosition.Y)/HueFrame.AbsoluteSize.Y,0,1)
                UpdateCPVisuals(false)
            end
        end
    end))
    table.insert(InconUI.Connections,RGBBox.FocusLost:Connect(function()
        local sp=string.split(RGBBox.Text:gsub(" ",""),",")
        if #sp==3 then
            local r,g,b=tonumber(sp[1]),tonumber(sp[2]),tonumber(sp[3])
            if r and g and b then
                CurH,CurS,CurV=Color3.fromRGB(math.clamp(r,0,255),math.clamp(g,0,255),math.clamp(b,0,255)):ToHSV()
                UpdateCPVisuals(false)
            end
        end
    end))
    table.insert(InconUI.Connections,HexBox.FocusLost:Connect(function()
        local s,c=pcall(function() return Color3.fromHex(HexBox.Text) end)
        if s and c then
            CurH,CurS,CurV=c:ToHSV()
            UpdateCPVisuals(false)
        end
    end))
    function Window:GetConfigs()
        local list={}
        if listfiles and isfolder and isfolder(ConfigFolder.."/settings") then
            for _,file in ipairs(listfiles(ConfigFolder.."/settings")) do
                if file:sub(-5)==".json" and not file:match("SavedKey%.json$") then
                    local name=file:match("([^/\\]+)%.json$")
                    if name then table.insert(list,name) end
                end
            end
        end
        return list
    end
    function Window:SaveConfig(Name)
        if not writefile then return false end
        Window:InitFolder()
        local data=Http:JSONEncode(InconUI.Flags)
        writefile(ConfigFolder.."/settings/"..Name..".json",data)
        return true
    end
    function Window:LoadConfig(Name)
        if not readfile or not isfile then return false end
        local path=ConfigFolder.."/settings/"..Name..".json"
        if isfile(path) then
            local s,d=pcall(function() return Http:JSONDecode(readfile(path)) end)
            if s and d then
                for flag,value in pairs(d) do
                    if InconUI.Elements[flag] then
                        task.spawn(function() InconUI.Elements[flag].SetValue(value) end)
                    end
                end
                return true
            end
        end
        return false
    end
    function Window:DeleteConfig(Name)
        if not isfile or not delfile then return false end
        local path=ConfigFolder.."/settings/"..Name..".json"
        if isfile(path) then
            delfile(path)
            return true
        end
        return false
    end
    function Window:SetAutoload(Name)
        if not writefile then return end
        Window:InitFolder()
        writefile(ConfigFolder.."/settings/autoload.txt",Name)
    end
    function Window:GetAutoload()
        if readfile and isfile then
            local path=ConfigFolder.."/settings/autoload.txt"
            if isfile(path) then
                local content=readfile(path)
                if content and content~="" then return content end
            end
        end
        return nil
    end
    function Window:ClearAutoload()
        if writefile then
            Window:InitFolder()
            writefile(ConfigFolder.."/settings/autoload.txt","")
        end
    end
    function Window:AutoLoad()
        local currentAuto=Window:GetAutoload()
        if currentAuto then
            if Window:LoadConfig(currentAuto) then
                InconUI:MakeNotify({Title="Config Manager",Content="Auto Loaded Config: "..currentAuto,Time=4})
            end
        end
    end
    function Window:CreateTab(TabName)
        Window.TabIndex=Window.TabIndex+1
        local CurrentIndex=Window.TabIndex
        local Tab={LastWasLocked=false,CurrentLockGroup=nil}
        local TabPage=Instance.new("ScrollingFrame")
        TabPage.Name=TabName
        TabPage.Size=UDim2.new(1,0,1,0)
        TabPage.BackgroundTransparency=1
        TabPage.BorderSizePixel=0
        TabPage.ScrollBarThickness=0
        TabPage.CanvasSize=UDim2.new(0,0,0,0)
        TabPage.AutomaticCanvasSize=Enum.AutomaticSize.Y
        TabPage.Visible=false
        TabPage.ZIndex=12
        TabPage:SetAttribute("TabIndex",CurrentIndex)
        TabPage.Parent=PageMask
        local PageLayout=Instance.new("UIListLayout",TabPage)
        PageLayout.SortOrder=Enum.SortOrder.LayoutOrder
        PageLayout.HorizontalAlignment=Enum.HorizontalAlignment.Center
        PageLayout.Padding=UDim.new(0,5)
        local Pad=Instance.new("UIPadding",TabPage)
        Pad.PaddingTop=UDim.new(0,5)
        Pad.PaddingBottom=UDim.new(0,10)
        Pad.PaddingLeft=UDim.new(0,5)
        Pad.PaddingRight=UDim.new(0,5)
        local TabBtn=Instance.new("TextButton")
        TabBtn.Size=UDim2.new(0.9,0,0,28)
        TabBtn.BackgroundColor3=Color3.fromRGB(25,25,25)
        TabBtn.BorderColor3=Color3.fromRGB(50,50,50)
        TabBtn.TextColor3=Color3.fromRGB(200,200,200)
        TabBtn.Text=TabName
        TabBtn.FontFace=InconUI.CurrentFont
        TabBtn.TextSize=11
        TabBtn.ZIndex=5
        TabBtn.Parent=TabContainer
        table.insert(Window.Pages,TabPage)
        table.insert(InconUI.Connections,TabBtn.MouseButton1Click:Connect(function()
            if Window.CurrentPage==TabPage then return end
            local slideInfo=TweenInfo.new(0.35,Enum.EasingStyle.Quart,Enum.EasingDirection.Out)
            if Window.CurrentPage then
                local oldIndex=Window.CurrentPage:GetAttribute("TabIndex")
                if CurrentIndex>oldIndex then
                    TS:Create(Window.CurrentPage,slideInfo,{Position=UDim2.new(0,0,-1,0)}):Play()
                    TabPage.Position=UDim2.new(0,0,1,0)
                else
                    TS:Create(Window.CurrentPage,slideInfo,{Position=UDim2.new(0,0,1,0)}):Play()
                    TabPage.Position=UDim2.new(0,0,-1,0)
                end
                local TempPage=Window.CurrentPage
                task.delay(0.35,function() if Window.CurrentPage~=TempPage then TempPage.Visible=false end end)
            end
            TabPage.Visible=true
            TS:Create(TabPage,slideInfo,{Position=UDim2.new(0,0,0,0)}):Play()
            Window.CurrentPage=TabPage
        end))
        if #Window.Pages==1 then
            TabPage.Visible=true
            TabPage.Position=UDim2.new(0,0,0,0)
            Window.CurrentPage=TabPage
        end
        function Tab:GetParent(IsLocked,LockTitle)
            if IsLocked then
                if not Tab.LastWasLocked or not Tab.CurrentLockGroup then
                    local GrpContainer=Instance.new("Frame")
                    GrpContainer.Size=UDim2.new(1,0,0,0)
                    GrpContainer.AutomaticSize=Enum.AutomaticSize.Y
                    GrpContainer.BackgroundTransparency=1
                    GrpContainer.ZIndex=13
                    GrpContainer.Parent=TabPage
                    local GrpItems=Instance.new("Frame")
                    GrpItems.Size=UDim2.new(1,0,0,0)
                    GrpItems.AutomaticSize=Enum.AutomaticSize.Y
                    GrpItems.BackgroundTransparency=1
                    GrpItems.ZIndex=13
                    GrpItems.Parent=GrpContainer
                    local L=Instance.new("UIListLayout",GrpItems)
                    L.SortOrder=Enum.SortOrder.LayoutOrder
                    L.Padding=UDim.new(0,5)
                    local Overlay=Instance.new("TextButton")
                    Overlay.Size=UDim2.new(1,0,0,0)
                    Overlay.BackgroundColor3=Color3.fromRGB(15,15,15)
                    Overlay.BackgroundTransparency=0.5
                    Overlay.AutoButtonColor=false
                    Overlay.Text=""
                    Overlay.ZIndex=50
                    Overlay.Parent=GrpContainer
                    local LockTxt=Instance.new("TextLabel")
                    LockTxt.Size=UDim2.new(1,0,1,0)
                    LockTxt.BackgroundTransparency=1
                    LockTxt.Text="🔒 "..(LockTitle or "Requires Premium")
                    LockTxt.TextColor3=Color3.fromRGB(220,220,220)
                    LockTxt.FontFace=InconUI.CurrentFont
                    LockTxt.TextSize=14
                    LockTxt.ZIndex=51
                    LockTxt.Parent=Overlay
                    table.insert(InconUI.Connections,GrpItems:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
                        Overlay.Size=UDim2.new(1,0,0,GrpItems.AbsoluteSize.Y)
                    end))
                    table.insert(InconUI.Connections,Overlay.MouseButton1Click:Connect(function()
                        InconUI:MakeNotify({Title="Locked",Content=LockTitle or "Requires Premium",Time=3})
                    end))
                    Tab.CurrentLockGroup=GrpItems
                    Tab.LastWasLocked=true
                end
                return Tab.CurrentLockGroup
            else
                Tab.LastWasLocked=false
                Tab.CurrentLockGroup=nil
                return TabPage
            end
        end
        function Tab:CreateSection(Name)
            local Target=Tab:GetParent(false)
            local Sec=Instance.new("Frame")
            Sec.Size=UDim2.new(1,0,0,30)
            Sec.BackgroundTransparency=1
            Sec.ZIndex=13
            Sec.Parent=Target
            local Lbl=Instance.new("TextLabel")
            Lbl.Size=UDim2.new(1,-10,1,0)
            Lbl.Position=UDim2.new(0,5,0,0)
            Lbl.BackgroundTransparency=1
            Lbl.Text=Name
            Lbl.TextColor3=Color3.fromRGB(255,255,255)
            Lbl.TextXAlignment=Enum.TextXAlignment.Center
            Lbl.FontFace=InconUI.CurrentFont
            Lbl.TextSize=13
            Lbl.ZIndex=14
            Lbl.Parent=Sec
            local Div=Instance.new("Frame")
            Div.Size=UDim2.new(1,-10,0,1)
            Div.Position=UDim2.new(0,5,1,-2)
            Div.BackgroundColor3=Color3.fromRGB(56,56,56)
            Div.BorderSizePixel=0
            Div.ZIndex=14
            Div.Parent=Sec
        end
        function Tab:CreateButton(ElmOptions)
            local Target=Tab:GetParent(ElmOptions.Locked,ElmOptions.LockedTitle)
            local Btn=Instance.new("TextButton")
            Btn.Size=UDim2.new(1,0,0,30)
            Btn.BackgroundColor3=Color3.fromRGB(26,26,26)
            Btn.BorderColor3=Color3.fromRGB(51,51,51)
            Btn.Text=""
            Btn.AutoButtonColor=false
            Btn.ZIndex=13
            Btn.Parent=Target
            local Title=Instance.new("TextLabel")
            Title.Size=UDim2.new(1,-20,1,0)
            Title.Position=UDim2.new(0,10,0,0)
            Title.BackgroundTransparency=1
            Title.Text=ElmOptions.Locked and ("[LOCKED] "..(ElmOptions.LockedTitle or ElmOptions.Name)) or (ElmOptions.Name or "Button")
            Title.TextColor3=ElmOptions.Locked and Color3.fromRGB(100,100,100) or Color3.fromRGB(201,201,201)
            Title.TextXAlignment=Enum.TextXAlignment.Left
            Title.FontFace=InconUI.CurrentFont
            Title.TextSize=12
            Title.ZIndex=14
            Title.Parent=Btn
            table.insert(InconUI.Connections,Btn.MouseButton1Click:Connect(function()
                if ElmOptions.Callback then ElmOptions.Callback() end
            end))
        end
        function Tab:CreateDualButton(ElmOptions)
            local Target=Tab:GetParent(ElmOptions.Locked,ElmOptions.LockedTitle)
            local Container=Instance.new("Frame")
            Container.Size=UDim2.new(1,0,0,30)
            Container.BackgroundTransparency=1
            Container.ZIndex=13
            Container.Parent=Target
            local Btn1=Instance.new("TextButton")
            Btn1.Size=UDim2.new(0.5,-2,1,0)
            Btn1.BackgroundColor3=Color3.fromRGB(26,26,26)
            Btn1.BorderColor3=Color3.fromRGB(51,51,51)
            Btn1.TextColor3=Color3.fromRGB(201,201,201)
            Btn1.Text=ElmOptions.Name1 or "Button 1"
            Btn1.TextXAlignment=Enum.TextXAlignment.Center
            Btn1.FontFace=InconUI.CurrentFont
            Btn1.TextSize=12
            Btn1.AutoButtonColor=false
            Btn1.ZIndex=14
            Btn1.Parent=Container
            table.insert(InconUI.Connections,Btn1.MouseButton1Click:Connect(function() if ElmOptions.Callback1 then ElmOptions.Callback1() end end))
            local Btn2=Instance.new("TextButton")
            Btn2.Size=UDim2.new(0.5,-3,1,0)
            Btn2.Position=UDim2.new(0.5,3,0,0)
            Btn2.BackgroundColor3=Color3.fromRGB(26,26,26)
            Btn2.BorderColor3=Color3.fromRGB(51,51,51)
            Btn2.TextColor3=Color3.fromRGB(201,201,201)
            Btn2.Text=ElmOptions.Name2 or "Button 2"
            Btn2.TextXAlignment=Enum.TextXAlignment.Center
            Btn2.FontFace=InconUI.CurrentFont
            Btn2.TextSize=12
            Btn2.AutoButtonColor=false
            Btn2.ZIndex=14
            Btn2.Parent=Container
            table.insert(InconUI.Connections,Btn2.MouseButton1Click:Connect(function() if ElmOptions.Callback2 then ElmOptions.Callback2() end end))
        end
        function Tab:CreateLabel(ElmOptions)
            local Target=Tab:GetParent(ElmOptions.Locked,ElmOptions.LockedTitle)
            local Style=ElmOptions.Style or 1
            local LblObj={}
            local Lbl=Instance.new("TextLabel")
            Lbl.Size=UDim2.new(1,0,0,30)
            Lbl.Text=""
            Lbl.ZIndex=13
            Lbl.Parent=Target
            local Title=Instance.new("TextLabel")
            Title.Size=UDim2.new(1,-20,1,0)
            Title.Position=UDim2.new(0,10,0,0)
            Title.BackgroundTransparency=1
            Title.TextXAlignment=Enum.TextXAlignment.Left
            Title.FontFace=InconUI.CurrentFont
            Title.TextSize=12
            Title.ZIndex=14
            Title.Parent=Lbl
            if Style==2 then
                Lbl.BackgroundColor3=Color3.fromRGB(40,20,20)
                Lbl.BorderColor3=Color3.fromRGB(80,40,40)
                Title.TextColor3=Color3.fromRGB(255,100,100)
                Title.Text="[!] "..(ElmOptions.Name or "Warning")
            elseif Style==3 then
                Lbl.BackgroundColor3=Color3.fromRGB(20,40,20)
                Lbl.BorderColor3=Color3.fromRGB(40,80,40)
                Title.TextColor3=Color3.fromRGB(100,255,100)
                Title.Text="[i] "..(ElmOptions.Name or "Information")
            else
                Lbl.BackgroundColor3=Color3.fromRGB(20,20,20)
                Lbl.BorderColor3=Color3.fromRGB(51,51,51)
                Title.TextColor3=Color3.fromRGB(200,200,200)
                Title.Text="[-] "..(ElmOptions.Name or "Label")
            end
            function LblObj:SetText(NewText)
                if Style==2 then Title.Text="[!] "..NewText
                elseif Style==3 then Title.Text="[i] "..NewText
                else Title.Text="[-] "..NewText end
            end
            return LblObj
        end
        function Tab:CreateParagraph(ElmOptions)
            local Target=Tab:GetParent(ElmOptions.Locked,ElmOptions.LockedTitle)
            local ParaObj={}
            local Container=Instance.new("Frame")
            Container.Size=UDim2.new(1,0,0,0)
            Container.AutomaticSize=Enum.AutomaticSize.Y
            Container.BackgroundColor3=Color3.fromRGB(20,20,20)
            Container.BorderColor3=Color3.fromRGB(51,51,51)
            Container.ZIndex=13
            Container.Parent=Target
            local Layout=Instance.new("UIListLayout")
            Layout.SortOrder=Enum.SortOrder.LayoutOrder
            Layout.Padding=UDim.new(0,5)
            Layout.Parent=Container
            local Pad=Instance.new("UIPadding")
            Pad.PaddingTop=UDim.new(0,10)
            Pad.PaddingBottom=UDim.new(0,10)
            Pad.PaddingLeft=UDim.new(0,10)
            Pad.PaddingRight=UDim.new(0,10)
            Pad.Parent=Container
            local Title=Instance.new("TextLabel")
            Title.Size=UDim2.new(1,0,0,15)
            Title.BackgroundTransparency=1
            Title.Text=ElmOptions.Name or "Paragraph Title"
            Title.TextColor3=Color3.fromRGB(255,255,255)
            Title.TextXAlignment=Enum.TextXAlignment.Left
            Title.FontFace=InconUI.CurrentFont
            Title.TextSize=13
            Title.ZIndex=14
            Title.Parent=Container
            local Content=Instance.new("TextLabel")
            Content.Size=UDim2.new(1,0,0,0)
            Content.AutomaticSize=Enum.AutomaticSize.Y
            Content.BackgroundTransparency=1
            Content.Text=ElmOptions.Content or "Paragraph Content"
            Content.TextColor3=Color3.fromRGB(180,180,180)
            Content.TextXAlignment=Enum.TextXAlignment.Left
            Content.TextYAlignment=Enum.TextYAlignment.Top
            Content.TextWrapped=true
            Content.FontFace=InconUI.CurrentFont
            Content.TextSize=11
            Content.ZIndex=14
            Content.Parent=Container
            function ParaObj:SetText(NewTitle,NewContent)
                Title.Text=NewTitle or Title.Text
                Content.Text=NewContent or Content.Text
            end
            return ParaObj
        end
        function Tab:CreateToggle(ElmOptions)
            local Target=Tab:GetParent(ElmOptions.Locked,ElmOptions.LockedTitle)
            local State=ElmOptions.Default or false
            local Indicator
            if ElmOptions.Flag then
                InconUI.Flags[ElmOptions.Flag]=State
                InconUI.Elements[ElmOptions.Flag]={
                    SetValue=function(val)
                        if not Indicator or not Indicator:IsDescendantOf(game) then return end
                        State=val
                        InconUI.Flags[ElmOptions.Flag]=State
                        TS:Create(Indicator,TweenInfo.new(0.2),{BackgroundColor3=State and Color3.fromRGB(0,170,0) or Color3.fromRGB(170,0,0)}):Play()
                        if ElmOptions.Callback then ElmOptions.Callback(State) end
                    end
                }
            end
            local Btn=Instance.new("TextButton")
            Btn.Size=UDim2.new(1,0,0,30)
            Btn.BackgroundColor3=Color3.fromRGB(26,26,26)
            Btn.BorderColor3=Color3.fromRGB(51,51,51)
            Btn.Text=""
            Btn.AutoButtonColor=false
            Btn.ZIndex=13
            Btn.Parent=Target
            local Title=Instance.new("TextLabel")
            Title.Size=UDim2.new(1,-40,1,0)
            Title.Position=UDim2.new(0,10,0,0)
            Title.BackgroundTransparency=1
            Title.Text=ElmOptions.Name or "Toggle"
            Title.TextColor3=Color3.fromRGB(201,201,201)
            Title.TextXAlignment=Enum.TextXAlignment.Left
            Title.FontFace=InconUI.CurrentFont
            Title.TextSize=12
            Title.ZIndex=14
            Title.Parent=Btn
            Indicator=Instance.new("Frame")
            Indicator.Size=UDim2.new(0,14,0,14)
            Indicator.Position=UDim2.new(1,-22,0.5,-7)
            Indicator.BackgroundColor3=State and Color3.fromRGB(0,170,0) or Color3.fromRGB(170,0,0)
            Indicator.BorderColor3=Color3.fromRGB(51,51,51)
            Indicator.ZIndex=14
            Indicator.Parent=Btn
            Instance.new("UICorner",Indicator).CornerRadius=UDim.new(0,3)
            table.insert(InconUI.Connections,Btn.MouseButton1Click:Connect(function()
                State=not State
                if ElmOptions.Flag then InconUI.Flags[ElmOptions.Flag]=State end
                TS:Create(Indicator,TweenInfo.new(0.2),{BackgroundColor3=State and Color3.fromRGB(0,170,0) or Color3.fromRGB(170,0,0)}):Play()
                if ElmOptions.Callback then ElmOptions.Callback(State) end
            end))
        end
        function Tab:CreateSlider(ElmOptions)
            local Target=Tab:GetParent(ElmOptions.Locked,ElmOptions.LockedTitle)
            local Min=ElmOptions.Min or 0
            local Max=ElmOptions.Max or 100
            local Default=ElmOptions.Default or Min
            local CurrentValue=Default
            local SliderFill,ValueBox
            local Btn=Instance.new("TextButton")
            Btn.Size=UDim2.new(1,0,0,40)
            Btn.BackgroundColor3=Color3.fromRGB(26,26,26)
            Btn.BorderColor3=Color3.fromRGB(51,51,51)
            Btn.Text=""
            Btn.AutoButtonColor=false
            Btn.ZIndex=13
            Btn.Parent=Target
            local TopRow=Instance.new("Frame")
            TopRow.Size=UDim2.new(1,-20,0.5,0)
            TopRow.Position=UDim2.new(0,10,0,2)
            TopRow.BackgroundTransparency=1
            TopRow.ZIndex=14
            TopRow.Parent=Btn
            local RowLayout=Instance.new("UIListLayout")
            RowLayout.FillDirection=Enum.FillDirection.Horizontal
            RowLayout.SortOrder=Enum.SortOrder.LayoutOrder
            RowLayout.Padding=UDim.new(0,5)
            RowLayout.VerticalAlignment=Enum.VerticalAlignment.Center
            RowLayout.Parent=TopRow
            local Title=Instance.new("TextLabel")
            Title.Size=UDim2.new(0,0,1,0)
            Title.AutomaticSize=Enum.AutomaticSize.X
            Title.BackgroundTransparency=1
            Title.TextColor3=Color3.fromRGB(201,201,201)
            Title.TextXAlignment=Enum.TextXAlignment.Left
            Title.Text=ElmOptions.Name.." :"
            Title.FontFace=InconUI.CurrentFont
            Title.TextSize=12
            Title.ZIndex=14
            Title.Parent=TopRow
            local ValWrap=Instance.new("Frame")
            ValWrap.Size=UDim2.new(0,35,0,20)
            ValWrap.BackgroundTransparency=1
            ValWrap.ZIndex=14
            ValWrap.Parent=TopRow
            ValueBox=Instance.new("TextBox")
            ValueBox.Size=UDim2.new(1,0,0,16)
            ValueBox.AnchorPoint=Vector2.new(0,0.5)
            ValueBox.Position=UDim2.new(0,0,0.5,2)
            ValueBox.BackgroundColor3=Color3.fromRGB(15,15,15)
            ValueBox.BorderSizePixel=0
            ValueBox.TextColor3=Color3.fromRGB(201,201,201)
            ValueBox.Text=tostring(Default)
            ValueBox.FontFace=InconUI.CurrentFont
            ValueBox.TextSize=11
            ValueBox.ZIndex=15
            ValueBox.Parent=ValWrap
            Instance.new("UICorner",ValueBox).CornerRadius=UDim.new(0,3)
            local SliderBack=Instance.new("Frame")
            SliderBack.Size=UDim2.new(1,-20,0,6)
            SliderBack.Position=UDim2.new(0,10,0.65,0)
            SliderBack.BackgroundColor3=Color3.fromRGB(15,15,15)
            SliderBack.BorderColor3=Color3.fromRGB(51,51,51)
            SliderBack.ZIndex=14
            SliderBack.Parent=Btn
            Instance.new("UICorner",SliderBack).CornerRadius=UDim.new(1,0)
            SliderFill=Instance.new("Frame")
            SliderFill.Size=UDim2.new((Default-Min)/(Max-Min),0,1,0)
            SliderFill.BackgroundColor3=Color3.fromRGB(181,181,181)
            SliderFill.BorderSizePixel=0
            SliderFill.ZIndex=15
            SliderFill.Parent=SliderBack
            Instance.new("UICorner",SliderFill).CornerRadius=UDim.new(1,0)
            if ElmOptions.Flag then
                InconUI.Flags[ElmOptions.Flag]=Default
                InconUI.Elements[ElmOptions.Flag]={
                    SetValue=function(val)
                        if not SliderFill or not SliderFill:IsDescendantOf(game) then return end
                        local num=math.clamp(tonumber(val) or Min,Min,Max)
                        CurrentValue=num
                        InconUI.Flags[ElmOptions.Flag]=num
                        local pos=(num-Min)/(Max-Min)
                        TS:Create(SliderFill,TweenInfo.new(0.2),{Size=UDim2.new(pos,0,1,0)}):Play()
                        ValueBox.Text=tostring(num)
                        if ElmOptions.Callback then ElmOptions.Callback(num) end
                    end
                }
            end
            local dragging=false
            local function update(input)
                local pos=math.clamp((input.Position.X-SliderBack.AbsolutePosition.X)/SliderBack.AbsoluteSize.X,0,1)
                local value=math.floor(Min+((Max-Min)*pos))
                CurrentValue=value
                if ElmOptions.Flag then InconUI.Flags[ElmOptions.Flag]=value end
                TS:Create(SliderFill,TweenInfo.new(0.05),{Size=UDim2.new(pos,0,1,0)}):Play()
                ValueBox.Text=tostring(value)
                if ElmOptions.Callback then ElmOptions.Callback(value) end
            end
            table.insert(InconUI.Connections,Btn.InputBegan:Connect(function(input)
                if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then
                    dragging=true
                    update(input)
                end
            end))
            table.insert(InconUI.Connections,UIS.InputEnded:Connect(function(input)
                if not Btn:IsDescendantOf(game) then return end
                if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then
                    dragging=false
                end
            end))
            table.insert(InconUI.Connections,UIS.InputChanged:Connect(function(input)
                if not Btn:IsDescendantOf(game) then return end
                if dragging and (input.UserInputType==Enum.UserInputType.MouseMovement or input.UserInputType==Enum.UserInputType.Touch) then
                    update(input)
                end
            end))
            table.insert(InconUI.Connections,ValueBox.FocusLost:Connect(function()
                local num=tonumber(ValueBox.Text)
                if num then
                    num=math.clamp(math.floor(num),Min,Max)
                    CurrentValue=num
                    if ElmOptions.Flag then InconUI.Flags[ElmOptions.Flag]=num end
                    local pos=(num-Min)/(Max-Min)
                    TS:Create(SliderFill,TweenInfo.new(0.2),{Size=UDim2.new(pos,0,1,0)}):Play()
                    ValueBox.Text=tostring(num)
                    if ElmOptions.Callback then ElmOptions.Callback(num) end
                else
                    ValueBox.Text=tostring(CurrentValue)
                end
            end))
        end
        function Tab:CreateColorPicker(ElmOptions)
            local Target=Tab:GetParent(ElmOptions.Locked,ElmOptions.LockedTitle)
            local ColorVal=ElmOptions.Default or Color3.fromRGB(255,255,255)
            local Container=Instance.new("Frame")
            Container.Size=UDim2.new(1,0,0,30)
            Container.BackgroundColor3=Color3.fromRGB(26,26,26)
            Container.BorderColor3=Color3.fromRGB(51,51,51)
            Container.ZIndex=13
            Container.Parent=Target
            local Btn=Instance.new("TextButton")
            Btn.Size=UDim2.new(1,0,0,30)
            Btn.BackgroundTransparency=1
            Btn.Text=""
            Btn.AutoButtonColor=false
            Btn.ZIndex=14
            Btn.Parent=Container
            local Title=Instance.new("TextLabel")
            Title.Size=UDim2.new(1,-40,1,0)
            Title.Position=UDim2.new(0,10,0,0)
            Title.BackgroundTransparency=1
            Title.Text=ElmOptions.Name or "Color Picker"
            Title.TextColor3=Color3.fromRGB(201,201,201)
            Title.TextXAlignment=Enum.TextXAlignment.Left
            Title.FontFace=InconUI.CurrentFont
            Title.TextSize=12
            Title.ZIndex=15
            Title.Parent=Btn
            local DisplayColor=Instance.new("Frame")
            DisplayColor.Size=UDim2.new(0,20,0,20)
            DisplayColor.Position=UDim2.new(1,-25,0.5,-10)
            DisplayColor.BackgroundColor3=ColorVal
            DisplayColor.BorderColor3=Color3.fromRGB(51,51,51)
            DisplayColor.ZIndex=15
            DisplayColor.Parent=Btn
            Instance.new("UICorner",DisplayColor).CornerRadius=UDim.new(0,4)
            if ElmOptions.Flag then
                InconUI.Flags[ElmOptions.Flag]=string.format("%d,%d,%d",math.floor(ColorVal.R*255),math.floor(ColorVal.G*255),math.floor(ColorVal.B*255))
                InconUI.Elements[ElmOptions.Flag]={
                    SetValue=function(val)
                        local sp=string.split(val,",")
                        if #sp==3 then
                            local r,g,b=tonumber(sp[1]),tonumber(sp[2]),tonumber(sp[3])
                            if r and g and b then
                                ColorVal=Color3.fromRGB(math.clamp(r,0,255),math.clamp(g,0,255),math.clamp(b,0,255))
                                DisplayColor.BackgroundColor3=ColorVal
                                InconUI.Flags[ElmOptions.Flag]=val
                                if CPFlag==ElmOptions.Flag then
                                    CurH,CurS,CurV=ColorVal:ToHSV()
                                    UpdateCPVisuals(true)
                                end
                                if ElmOptions.Callback then ElmOptions.Callback(ColorVal) end
                            end
                        end
                    end
                }
            end
            table.insert(InconUI.Connections,Btn.MouseButton1Click:Connect(function()
                CPTitle.Text=ElmOptions.Name or "Color Picker"
                CurH,CurS,CurV=ColorVal:ToHSV()
                CPFlag=ElmOptions.Flag
                CPCallback=function(newCol)
                    ColorVal=newCol
                    DisplayColor.BackgroundColor3=ColorVal
                    if ElmOptions.Flag then
                        InconUI.Flags[ElmOptions.Flag]=string.format("%d,%d,%d",math.floor(ColorVal.R*255),math.floor(ColorVal.G*255),math.floor(ColorVal.B*255))
                    end
                    if ElmOptions.Callback then ElmOptions.Callback(ColorVal) end
                end
                UpdateCPVisuals(true)
                CPPnl.Visible=true
            end))
        end
        function Tab:CreateTextbox(ElmOptions)
            local Target=Tab:GetParent(ElmOptions.Locked,ElmOptions.LockedTitle)
            local BoxObj={}
            local BoxContainer=Instance.new("Frame")
            BoxContainer.Size=UDim2.new(1,0,0,30)
            BoxContainer.BackgroundColor3=Color3.fromRGB(26,26,26)
            BoxContainer.BorderColor3=Color3.fromRGB(51,51,51)
            BoxContainer.ZIndex=13
            BoxContainer.Parent=Target
            local Lbl=Instance.new("TextLabel")
            Lbl.Size=UDim2.new(0.5,0,1,0)
            Lbl.Position=UDim2.new(0,10,0,0)
            Lbl.BackgroundTransparency=1
            Lbl.Text=ElmOptions.Name or "Textbox"
            Lbl.TextColor3=Color3.fromRGB(201,201,201)
            Lbl.TextXAlignment=Enum.TextXAlignment.Left
            Lbl.FontFace=InconUI.CurrentFont
            Lbl.TextSize=12
            Lbl.ZIndex=14
            Lbl.Parent=BoxContainer
            local TxtBox=Instance.new("TextBox")
            TxtBox.AnchorPoint=Vector2.new(1,0.5)
            TxtBox.Size=UDim2.new(0.4,0,0,20)
            TxtBox.Position=UDim2.new(1,-10,0.5,0)
            TxtBox.BackgroundColor3=Color3.fromRGB(15,15,15)
            TxtBox.BorderColor3=Color3.fromRGB(51,51,51)
            TxtBox.TextColor3=Color3.fromRGB(255,255,255)
            TxtBox.PlaceholderText=ElmOptions.Placeholder or ""
            TxtBox.Text=""
            TxtBox.FontFace=InconUI.CurrentFont
            TxtBox.TextSize=11
            TxtBox.ZIndex=14
            TxtBox.Parent=BoxContainer
            Instance.new("UICorner",TxtBox).CornerRadius=UDim.new(0,3)
            if ElmOptions.Flag then
                InconUI.Flags[ElmOptions.Flag]=""
                InconUI.Elements[ElmOptions.Flag]={
                    SetValue=function(val)
                        if not TxtBox or not TxtBox:IsDescendantOf(game) then return end
                        TxtBox.Text=tostring(val)
                        InconUI.Flags[ElmOptions.Flag]=TxtBox.Text
                        if ElmOptions.Callback then ElmOptions.Callback(TxtBox.Text) end
                    end
                }
            end
            table.insert(InconUI.Connections,TxtBox.FocusLost:Connect(function()
                if ElmOptions.Flag then InconUI.Flags[ElmOptions.Flag]=TxtBox.Text end
                if ElmOptions.Callback then ElmOptions.Callback(TxtBox.Text) end
            end))
            function BoxObj:SetText(val)
                if TxtBox and TxtBox:IsDescendantOf(game) then TxtBox.Text=tostring(val) end
            end
            function BoxObj:GetText()
                if TxtBox and TxtBox:IsDescendantOf(game) then return TxtBox.Text end
                return ""
            end
            return BoxObj
        end
        function Tab:CreateKeybind(ElmOptions)
            local Target=Tab:GetParent(ElmOptions.Locked,ElmOptions.LockedTitle)
            local Key=ElmOptions.Default or Enum.KeyCode.E
            local Waiting=false
            local BindBtn
            local BindContainer=Instance.new("Frame")
            BindContainer.Size=UDim2.new(1,0,0,30)
            BindContainer.BackgroundColor3=Color3.fromRGB(26,26,26)
            BindContainer.BorderColor3=Color3.fromRGB(51,51,51)
            BindContainer.ZIndex=13
            BindContainer.Parent=Target
            local Lbl=Instance.new("TextLabel")
            Lbl.Size=UDim2.new(0.5,0,1,0)
            Lbl.Position=UDim2.new(0,10,0,0)
            Lbl.BackgroundTransparency=1
            Lbl.Text=ElmOptions.Name or "Keybind"
            Lbl.TextColor3=Color3.fromRGB(201,201,201)
            Lbl.TextXAlignment=Enum.TextXAlignment.Left
            Lbl.FontFace=InconUI.CurrentFont
            Lbl.TextSize=12
            Lbl.ZIndex=14
            Lbl.Parent=BindContainer
            BindBtn=Instance.new("TextButton")
            BindBtn.AnchorPoint=Vector2.new(1,0.5)
            BindBtn.Size=UDim2.new(0,60,0,20)
            BindBtn.Position=UDim2.new(1,-10,0.5,0)
            BindBtn.BackgroundColor3=Color3.fromRGB(15,15,15)
            BindBtn.BorderColor3=Color3.fromRGB(51,51,51)
            BindBtn.TextColor3=Color3.fromRGB(255,255,255)
            BindBtn.Text=Key.Name
            BindBtn.FontFace=InconUI.CurrentFont
            BindBtn.TextSize=11
            BindBtn.AutoButtonColor=false
            BindBtn.ZIndex=14
            BindBtn.Parent=BindContainer
            Instance.new("UICorner",BindBtn).CornerRadius=UDim.new(0,3)
            if ElmOptions.Flag then
                InconUI.Flags[ElmOptions.Flag]=Key.Name
                InconUI.Elements[ElmOptions.Flag]={
                    SetValue=function(val)
                        if not BindBtn or not BindBtn:IsDescendantOf(game) then return end
                        local s,e=pcall(function() return Enum.KeyCode[val] end)
                        if s and e then
                            Key=e
                            BindBtn.Text=Key.Name
                            InconUI.Flags[ElmOptions.Flag]=Key.Name
                        end
                    end
                }
            end
            local waitToken=0
            table.insert(InconUI.Connections,BindBtn.MouseButton1Click:Connect(function()
                Waiting=true
                BindBtn.Text="..."
                waitToken=waitToken+1
                local myToken=waitToken
                task.delay(5,function()
                    if Waiting and waitToken==myToken then
                        Waiting=false
                        BindBtn.Text=Key.Name
                    end
                end)
            end))
            table.insert(InconUI.Connections,UIS.InputBegan:Connect(function(input,gp)
                if not BindContainer:IsDescendantOf(game) then return end
                if Waiting and input.UserInputType==Enum.UserInputType.Keyboard then
                    Key=input.KeyCode
                    BindBtn.Text=Key.Name
                    if ElmOptions.Flag then InconUI.Flags[ElmOptions.Flag]=Key.Name end
                    Waiting=false
                elseif not gp and input.KeyCode==Key and not Waiting then
                    if ElmOptions.Callback then ElmOptions.Callback() end
                end
            end))
        end
        function Tab:CreateDropdown(ElmOptions)
            local Target=Tab:GetParent(ElmOptions.Locked,ElmOptions.LockedTitle)
            local List=ElmOptions.List or {}
            local isOpen=false
            local DropObj={}
            local Btn,DropContainer,DropList,Title
            DropContainer=Instance.new("Frame")
            DropContainer.Size=UDim2.new(1,0,0,30)
            DropContainer.BackgroundColor3=Color3.fromRGB(26,26,26)
            DropContainer.BorderColor3=Color3.fromRGB(51,51,51)
            DropContainer.ClipsDescendants=true
            DropContainer.ZIndex=13
            DropContainer.Parent=Target
            Btn=Instance.new("TextButton")
            Btn.Size=UDim2.new(1,0,0,30)
            Btn.BackgroundTransparency=1
            Btn.Text=""
            Btn.AutoButtonColor=false
            Btn.ZIndex=14
            Btn.Parent=DropContainer
            Title=Instance.new("TextLabel")
            Title.Size=UDim2.new(1,-30,1,0)
            Title.Position=UDim2.new(0,10,0,0)
            Title.BackgroundTransparency=1
            Title.Text=ElmOptions.Name.." : None"
            Title.TextColor3=Color3.fromRGB(201,201,201)
            Title.TextXAlignment=Enum.TextXAlignment.Left
            Title.FontFace=InconUI.CurrentFont
            Title.TextSize=12
            Title.ZIndex=15
            Title.Parent=Btn
            local Icon=Instance.new("TextLabel")
            Icon.Size=UDim2.new(0,20,0,30)
            Icon.Position=UDim2.new(1,-25,0,0)
            Icon.BackgroundTransparency=1
            Icon.TextColor3=Color3.fromRGB(151,151,151)
            Icon.Text="V"
            Icon.FontFace=InconUI.CurrentFont
            Icon.TextSize=12
            Icon.ZIndex=15
            Icon.Parent=Btn
            DropList=Instance.new("ScrollingFrame")
            DropList.Size=UDim2.new(1,0,1,-30)
            DropList.Position=UDim2.new(0,0,0,30)
            DropList.BackgroundTransparency=1
            DropList.BorderSizePixel=0
            DropList.ScrollBarThickness=0
            DropList.ZIndex=14
            DropList.Parent=DropContainer
            local ListLayout=Instance.new("UIListLayout",DropList)
            ListLayout.SortOrder=Enum.SortOrder.LayoutOrder
            if ElmOptions.Flag then
                InconUI.Flags[ElmOptions.Flag]=""
                InconUI.Elements[ElmOptions.Flag]={
                    SetValue=function(val)
                        if not Title or not Title:IsDescendantOf(game) then return end
                        Title.Text=ElmOptions.Name.." : "..tostring(val)
                        InconUI.Flags[ElmOptions.Flag]=tostring(val)
                        if ElmOptions.Callback then ElmOptions.Callback(val) end
                    end
                }
            end
            local function toggleDrop()
                isOpen=not isOpen
                Icon.Text=isOpen and "^" or "V"
                local targetHeight=isOpen and (30+math.min(#List*25,120)) or 30
                TS:Create(DropContainer,TweenInfo.new(0.2,Enum.EasingStyle.Quart,Enum.EasingDirection.Out),{Size=UDim2.new(1,0,0,targetHeight)}):Play()
            end
            table.insert(InconUI.Connections,Btn.MouseButton1Click:Connect(toggleDrop))
            function DropObj:Refresh(newList)
                List=newList
                for _,child in ipairs(DropList:GetChildren()) do
                    if child:IsA("TextButton") then child:Destroy() end
                end
                DropList.CanvasSize=UDim2.new(0,0,0,#List*25)
                if isOpen then
                    local targetHeight=30+math.min(#List*25,120)
                    TS:Create(DropContainer,TweenInfo.new(0.2,Enum.EasingStyle.Quart,Enum.EasingDirection.Out),{Size=UDim2.new(1,0,0,targetHeight)}):Play()
                end
                for _,v in ipairs(List) do
                    local Item=Instance.new("TextButton")
                    Item.Size=UDim2.new(1,0,0,25)
                    Item.BackgroundColor3=Color3.fromRGB(20,20,20)
                    Item.BorderSizePixel=0
                    Item.Text=""
                    Item.AutoButtonColor=false
                    Item.ZIndex=15
                    Item.Parent=DropList
                    local ItemLbl=Instance.new("TextLabel")
                    ItemLbl.Size=UDim2.new(1,-20,1,0)
                    ItemLbl.Position=UDim2.new(0,20,0,0)
                    ItemLbl.BackgroundTransparency=1
                    ItemLbl.Text=v
                    ItemLbl.TextColor3=Color3.fromRGB(180,180,180)
                    ItemLbl.TextXAlignment=Enum.TextXAlignment.Left
                    ItemLbl.FontFace=InconUI.CurrentFont
                    ItemLbl.TextSize=11
                    ItemLbl.ZIndex=16
                    ItemLbl.Parent=Item
                    table.insert(InconUI.Connections,Item.MouseButton1Click:Connect(function()
                        Title.Text=ElmOptions.Name.." : "..v
                        if ElmOptions.Flag then InconUI.Flags[ElmOptions.Flag]=v end
                        if ElmOptions.Callback then ElmOptions.Callback(v) end
                        toggleDrop()
                    end))
                end
            end
            function DropObj:SetTitle(newTitle)
                if Title and Title:IsDescendantOf(game) then
                    Title.Text=ElmOptions.Name.." : "..tostring(newTitle)
                end
            end
            DropObj:Refresh(List)
            return DropObj
        end
        function Tab:CreateMultiDropdown(ElmOptions)
            local Target=Tab:GetParent(ElmOptions.Locked,ElmOptions.LockedTitle)
            local List=ElmOptions.List or {}
            local Selected=ElmOptions.Default or {}
            local isOpen=false
            local DropContainer=Instance.new("Frame")
            DropContainer.Size=UDim2.new(1,0,0,30)
            DropContainer.BackgroundColor3=Color3.fromRGB(26,26,26)
            DropContainer.BorderColor3=Color3.fromRGB(51,51,51)
            DropContainer.ClipsDescendants=true
            DropContainer.ZIndex=13
            DropContainer.Parent=Target
            local Btn=Instance.new("TextButton")
            Btn.Size=UDim2.new(1,-25,0,30)
            Btn.BackgroundTransparency=1
            Btn.Text=""
            Btn.AutoButtonColor=false
            Btn.ZIndex=14
            Btn.Parent=DropContainer
            local Title=Instance.new("TextLabel")
            Title.Size=UDim2.new(1,-30,1,0)
            Title.Position=UDim2.new(0,10,0,0)
            Title.BackgroundTransparency=1
            Title.TextColor3=Color3.fromRGB(201,201,201)
            Title.TextXAlignment=Enum.TextXAlignment.Left
            Title.TextTruncate=Enum.TextTruncate.AtEnd
            Title.FontFace=InconUI.CurrentFont
            Title.TextSize=12
            Title.ZIndex=15
            Title.Parent=Btn
            local function updateText()
                if #Selected==0 then Title.Text=ElmOptions.Name.." : None"
                else Title.Text=ElmOptions.Name.." : "..table.concat(Selected,", ") end
            end
            updateText()
            local IconBtn=Instance.new("TextButton")
            IconBtn.Size=UDim2.new(0,25,0,30)
            IconBtn.Position=UDim2.new(1,-25,0,0)
            IconBtn.BackgroundTransparency=1
            IconBtn.Text=""
            IconBtn.ZIndex=15
            IconBtn.Parent=DropContainer
            local Icon=Instance.new("TextLabel")
            Icon.Size=UDim2.new(1,0,1,0)
            Icon.BackgroundTransparency=1
            Icon.TextColor3=Color3.fromRGB(151,151,151)
            Icon.Text="V"
            Icon.FontFace=InconUI.CurrentFont
            Icon.TextSize=12
            Icon.ZIndex=15
            Icon.Parent=IconBtn
            local DropList=Instance.new("ScrollingFrame")
            DropList.Size=UDim2.new(1,0,1,-30)
            DropList.Position=UDim2.new(0,0,0,30)
            DropList.BackgroundTransparency=1
            DropList.BorderSizePixel=0
            DropList.ScrollBarThickness=0
            DropList.CanvasSize=UDim2.new(0,0,0,#List*25)
            DropList.ZIndex=14
            DropList.Parent=DropContainer
            local ListLayout=Instance.new("UIListLayout",DropList)
            ListLayout.SortOrder=Enum.SortOrder.LayoutOrder
            if ElmOptions.Flag then
                InconUI.Flags[ElmOptions.Flag]=Selected
                InconUI.Elements[ElmOptions.Flag]={
                    SetValue=function(val)
                        if not DropList or not DropList:IsDescendantOf(game) then return end
                        if type(val)=="table" then
                            Selected=val
                            InconUI.Flags[ElmOptions.Flag]=Selected
                            updateText()
                            for _,child in ipairs(DropList:GetChildren()) do
                                if child:IsA("TextButton") then
                                    local ItemLbl=child:FindFirstChild("TextLabel")
                                    if ItemLbl then
                                        if table.find(Selected,ItemLbl.Text) then ItemLbl.TextColor3=Color3.fromRGB(100,255,100)
                                        else ItemLbl.TextColor3=Color3.fromRGB(180,180,180) end
                                    end
                                end
                            end
                            if ElmOptions.Callback then ElmOptions.Callback(Selected) end
                        end
                    end
                }
            end
            local function toggleDrop()
                isOpen=not isOpen
                Icon.Text=isOpen and "^" or "V"
                local targetHeight=isOpen and (30+math.min(#List*25,120)) or 30
                TS:Create(DropContainer,TweenInfo.new(0.2,Enum.EasingStyle.Quart,Enum.EasingDirection.Out),{Size=UDim2.new(1,0,0,targetHeight)}):Play()
            end
            table.insert(InconUI.Connections,Btn.MouseButton1Click:Connect(toggleDrop))
            table.insert(InconUI.Connections,IconBtn.MouseButton1Click:Connect(toggleDrop))
            for _,v in ipairs(List) do
                local isSel=table.find(Selected,v)~=nil
                local Item=Instance.new("TextButton")
                Item.Size=UDim2.new(1,0,0,25)
                Item.BackgroundColor3=Color3.fromRGB(20,20,20)
                Item.BorderSizePixel=0
                Item.Text=""
                Item.AutoButtonColor=false
                Item.ZIndex=15
                Item.Parent=DropList
                local ItemLbl=Instance.new("TextLabel")
                ItemLbl.Size=UDim2.new(1,-20,1,0)
                ItemLbl.Position=UDim2.new(0,20,0,0)
                ItemLbl.BackgroundTransparency=1
                ItemLbl.Text=v
                ItemLbl.TextColor3=isSel and Color3.fromRGB(100,255,100) or Color3.fromRGB(180,180,180)
                ItemLbl.TextXAlignment=Enum.TextXAlignment.Left
                ItemLbl.FontFace=InconUI.CurrentFont
                ItemLbl.TextSize=11
                ItemLbl.ZIndex=16
                ItemLbl.Parent=Item
                table.insert(InconUI.Connections,Item.MouseButton1Click:Connect(function()
                    local idx=table.find(Selected,v)
                    if idx then
                        table.remove(Selected,idx)
                        ItemLbl.TextColor3=Color3.fromRGB(180,180,180)
                    else
                        table.insert(Selected,v)
                        ItemLbl.TextColor3=Color3.fromRGB(100,255,100)
                    end
                    updateText()
                    if ElmOptions.Flag then InconUI.Flags[ElmOptions.Flag]=Selected end
                    if ElmOptions.Callback then ElmOptions.Callback(Selected) end
                end))
            end
        end
        function Tab:CreateUpdateLog(entry)
            local COL={
                card=Color3.fromRGB(25,25,25),
                stroke=Color3.fromRGB(50,50,50),
                ver=Color3.fromRGB(220,220,220),
                add=Color3.fromRGB(100,255,100),
                change=Color3.fromRGB(255,210,90),
                remove=Color3.fromRGB(255,90,90),
                text=Color3.fromRGB(200,200,200),
                hint=Color3.fromRGB(120,180,255),
            }
            local KIND_COL={["+"]=COL.add,["~"]=COL.change,["-"]=COL.remove}
            local HEADER_H=18
            local LINE_H=16
            local LINE_GAP=3
            local PAD_V=6
            local HINT_H=14
            local IS_TOUCH=UIS.TouchEnabled and not UIS.MouseEnabled
            local function measureText(text,availW)
                local dummy=Instance.new("TextLabel")
                dummy.Text=text
                dummy.FontFace=InconUI.CurrentFont
                dummy.TextSize=11
                dummy.TextWrapped=true
                dummy.Size=UDim2.new(0,availW,0,9999)
                dummy.BackgroundTransparency=1
                dummy.TextTransparency=1
                dummy.Parent=TabPage
                local bounds=dummy.TextBounds
                dummy:Destroy()
                return bounds
            end
            local function cardHeight(sumLines,n,canExpand)
                local h=PAD_V+HEADER_H+LINE_GAP+sumLines+math.max(0,n-1)*LINE_GAP+PAD_V
                if canExpand then h=h+HINT_H end
                return h
            end
            local n=#entry.changes
            local canExpand=entry.expandable==true
            local collapsedH=cardHeight(n*LINE_H,n,canExpand)
            local card=Instance.new("TextButton")
            card.Size=UDim2.new(1,-6,0,collapsedH)
            card.BackgroundColor3=COL.card
            card.BorderSizePixel=1
            card.BorderColor3=COL.stroke
            card.AutoButtonColor=false
            card.Text=""
            card.Active=canExpand
            card.Selectable=canExpand
            card.ClipsDescendants=true
            card.ZIndex=13
            card.Parent=TabPage
            local content=Instance.new("Frame")
            content.Size=UDim2.new(1,0,1,0)
            content.BackgroundTransparency=1
            content.ZIndex=14
            content.Parent=card
            local cpad=Instance.new("UIPadding")
            cpad.PaddingTop=UDim.new(0,PAD_V)
            cpad.PaddingBottom=UDim.new(0,PAD_V)
            cpad.PaddingLeft=UDim.new(0,8)
            cpad.PaddingRight=UDim.new(0,8)
            cpad.Parent=content
            local clist=Instance.new("UIListLayout")
            clist.Padding=UDim.new(0,LINE_GAP)
            clist.SortOrder=Enum.SortOrder.LayoutOrder
            clist.Parent=content
            local header=Instance.new("TextLabel")
            header.BackgroundTransparency=1
            header.Size=UDim2.new(1,0,0,HEADER_H)
            header.FontFace=InconUI.CurrentFont
            header.RichText=true
            header.Text=string.format('<b>%s</b>  <font color="rgb(120,120,120)">%s</font>',entry.ver,entry.date)
            header.TextColor3=COL.ver
            header.TextSize=13
            header.TextXAlignment=Enum.TextXAlignment.Left
            header.LayoutOrder=0
            header.ZIndex=15
            header.Parent=content
            local lines={}
            for i,ch in ipairs(entry.changes) do
                local kind,desc=ch[1],ch[2]
                local lbl=Instance.new("TextLabel")
                lbl.BackgroundTransparency=1
                lbl.Size=UDim2.new(1,0,0,LINE_H)
                lbl.FontFace=InconUI.CurrentFont
                lbl.Text=string.format("[%s] %s",kind,desc)
                lbl.TextColor3=KIND_COL[kind] or COL.text
                lbl.TextSize=11
                lbl.TextXAlignment=Enum.TextXAlignment.Left
                lbl.TextYAlignment=Enum.TextYAlignment.Top
                lbl.TextTruncate=Enum.TextTruncate.AtEnd
                lbl.LayoutOrder=i
                lbl.ZIndex=15
                lbl.Parent=content
                lines[i]=lbl
            end
            if canExpand then
                local hint=Instance.new("TextLabel")
                hint.AnchorPoint=Vector2.new(1,1)
                hint.Position=UDim2.new(1,-8,1,-5)
                hint.Size=UDim2.new(0,150,0,HINT_H)
                hint.BackgroundTransparency=1
                hint.FontFace=InconUI.CurrentFont
                hint.Text="▼ Click To Expand"
                hint.TextColor3=COL.hint
                hint.TextSize=10
                hint.TextXAlignment=Enum.TextXAlignment.Right
                hint.TextTransparency=IS_TOUCH and 0.4 or 1
                hint.ZIndex=16
                hint.Parent=card
                local expanded=false
                local fadeIn=TweenInfo.new(0.15,Enum.EasingStyle.Quad,Enum.EasingDirection.Out)
                if not IS_TOUCH then
                    table.insert(InconUI.Connections,card.MouseEnter:Connect(function() TS:Create(hint,fadeIn,{TextTransparency=0}):Play() end))
                    table.insert(InconUI.Connections,card.MouseLeave:Connect(function() TS:Create(hint,fadeIn,{TextTransparency=1}):Play() end))
                end
                local function toggleExpand()
                    expanded=not expanded
                    local availW=math.max(50,card.AbsoluteSize.X-16)
                    local sumLines=0
                    for _,lbl in ipairs(lines) do
                        if expanded then
                            lbl.TextTruncate=Enum.TextTruncate.None
                            lbl.TextWrapped=true
                            local b=measureText(lbl.Text,availW)
                            local h=math.max(LINE_H,math.ceil(b.Y)+2)
                            lbl.Size=UDim2.new(1,0,0,h)
                            sumLines=sumLines+h
                        else
                            lbl.TextWrapped=false
                            lbl.TextTruncate=Enum.TextTruncate.AtEnd
                            lbl.Size=UDim2.new(1,0,0,LINE_H)
                            sumLines=sumLines+LINE_H
                        end
                    end
                    local goal=UDim2.new(1,-6,0,cardHeight(sumLines,#lines,true))
                    TS:Create(card,TweenInfo.new(0.25,Enum.EasingStyle.Quart,Enum.EasingDirection.Out),{Size=goal}):Play()
                    hint.Text=expanded and "▲ Click To Collapse" or "▼ Click To Expand"
                end
                table.insert(InconUI.Connections,card.MouseButton1Click:Connect(toggleExpand))
            end
        end
        return Tab
    end
    function Window:BuildSaveManager(TargetTab)
        TargetTab:CreateSection("Configuration")
        local ConfigBox=TargetTab:CreateTextbox({Name="Config Name",Placeholder="Enter Name..."})
        local ConfigList=TargetTab:CreateDropdown({
            Name="Config List",
            List=Window:GetConfigs(),
            Callback=function(val) ConfigBox:SetText(val) end
        })
        TargetTab:CreateDualButton({
            Name1="Create Config",
            Callback1=function()
                local ConfigName=ConfigBox:GetText()
                if ConfigName=="" then InconUI:MakeNotify({Title="Config Error",Content="Please Enter A Config Name!",Time=3}) return end
                Window:SaveConfig(ConfigName)
                ConfigList:Refresh(Window:GetConfigs())
                InconUI:MakeNotify({Title="Config Manager",Content="Created Config "..ConfigName,Time=3})
            end,
            Name2="Load Config",
            Callback2=function()
                local ConfigName=ConfigBox:GetText()
                if ConfigName=="" then InconUI:MakeNotify({Title="Config Error",Content="Please Select Or Enter A Config!",Time=3}) return end
                if Window:LoadConfig(ConfigName) then InconUI:MakeNotify({Title="Config Manager",Content="Loaded Config "..ConfigName,Time=3})
                else InconUI:MakeNotify({Title="Config Error",Content="Config Not Found!",Time=3}) end
            end
        })
        TargetTab:CreateDualButton({
            Name1="Overwrite Config",
            Callback1=function()
                local ConfigName=ConfigBox:GetText()
                if ConfigName=="" then InconUI:MakeNotify({Title="Config Error",Content="Please Select Or Enter A Config!",Time=3}) return end
                Window:CreateDialog({
                    Title="Overwrite Config",
                    Content="Are You Sure You Want To Overwrite "..ConfigName.."?",
                    ConfirmText="Overwrite",
                    CancelText="Cancel",
                    Callback=function(State)
                        if State then
                            Window:SaveConfig(ConfigName)
                            InconUI:MakeNotify({Title="Config Manager",Content="Overwrote Config "..ConfigName,Time=3})
                        end
                    end
                })
            end,
            Name2="Delete Config",
            Callback2=function()
                local ConfigName=ConfigBox:GetText()
                if ConfigName=="" then InconUI:MakeNotify({Title="Config Error",Content="Please Select Or Enter A Config!",Time=3}) return end
                Window:CreateDialog({
                    Title="Delete Config",
                    Content="Are You Sure You Want To Delete "..ConfigName.."?",
                    ConfirmText="Delete",
                    CancelText="Cancel",
                    Callback=function(State)
                        if State then
                            if Window:DeleteConfig(ConfigName) then
                                ConfigList:Refresh(Window:GetConfigs())
                                ConfigList:SetTitle("None")
                                ConfigBox:SetText("")
                                InconUI:MakeNotify({Title="Config Manager",Content="Deleted Config "..ConfigName,Time=3})
                                local currentAuto=Window:GetAutoload()
                                if currentAuto==ConfigName then Window:ClearAutoload() end
                            else
                                InconUI:MakeNotify({Title="Config Error",Content="Config Not Found!",Time=3})
                            end
                        end
                    end
                })
            end
        })
        TargetTab:CreateButton({
            Name="Refresh List",
            Callback=function()
                ConfigList:Refresh(Window:GetConfigs())
                InconUI:MakeNotify({Title="Config Manager",Content="List Refreshed!",Time=3})
            end
        })
        local autoLbl=TargetTab:CreateLabel({Name="Current Autoload: None"})
        TargetTab:CreateDualButton({
            Name1="Set As Autoload",
            Callback1=function()
                local ConfigName=ConfigBox:GetText()
                if ConfigName=="" then InconUI:MakeNotify({Title="Config Error",Content="Please Select Or Enter A Config!",Time=3}) return end
                Window:SetAutoload(ConfigName)
                autoLbl:SetText("Current Autoload: "..ConfigName)
                InconUI:MakeNotify({Title="Config Manager",Content="Set "..ConfigName.." To Autoload",Time=3})
            end,
            Name2="Clear Autoload",
            Callback2=function()
                local currentAuto=Window:GetAutoload()
                if not currentAuto or currentAuto=="" then InconUI:MakeNotify({Title="Config Error",Content="No Autoload Config To Clear!",Time=3}) return end
                Window:CreateDialog({
                    Title="Clear Autoload",
                    Content="Are You Sure You Want To Clear The Autoload Config?",
                    ConfirmText="Clear",
                    CancelText="Cancel",
                    Callback=function(State)
                        if State then
                            Window:ClearAutoload()
                            autoLbl:SetText("Current Autoload: None")
                            InconUI:MakeNotify({Title="Config Manager",Content="Cleared Autoload Config",Time=3})
                        end
                    end
                })
            end
        })
        local currentAuto=Window:GetAutoload()
        if currentAuto and currentAuto~="" then autoLbl:SetText("Current Autoload: "..currentAuto) end
    end
    return Window
end
function InconUI:Destroy()
    for _,con in ipairs(self.Connections) do pcall(function() con:Disconnect() end) end
    self.Connections={}
    self.Flags={}
    self.Elements={}
    for _,hub in ipairs(self.Hubs) do if hub and hub.Parent then hub:Destroy() end end
    self.Hubs={}
end
return InconUI
