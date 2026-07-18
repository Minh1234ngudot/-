<div align="center">

# 🌌 Incon Premium UI Library

[![Lua](https://img.shields.io/badge/Language-Lua-blue.svg?style=for-the-badge&logo=lua)](https://www.lua.org/)
[![Roblox](https://img.shields.io/badge/Game-Roblox-red.svg?style=for-the-badge&logo=roblox)](https://www.roblox.com/)
[![Status](https://img.shields.io/badge/Status-Active-success.svg?style=for-the-badge)]()
[![License](https://img.shields.io/badge/License-MIT-green.svg?style=for-the-badge)]()

<img src="https://readme-typing-svg.herokuapp.com?font=Inconsolata&weight=600&size=24&pause=1000&color=00FF99&center=true&vCenter=true&width=435&lines=Premium+Roblox+UI+Library;Built-In+Save+Manager;Secure+Dialog+Modals;Highly+Optimized" alt="Typing SVG" />

A Modern, Highly Optimized, And Bug-Free Roblox UI Library Designed For Exploit Scripts. Featuring A Clean Dark Theme, Fully Dynamic Texts, Secure Dialog Modals, Draggable Elements, And An Advanced Key System.

</div>

---

### 🚀 Booting The Library & Setting Fonts

Load The UI Library Using The Raw GitHub URL And Set Your Custom Font.

```lua
local InconUI = loadstring(game:HttpGet("https://github.com/Minh1234ngudot/-/raw/refs/heads/main/Incon_UI.luau"))()

InconUI:SetFont("rbxassetid://12187365364")

```

### 🪟 Creating A Window (With Key System & Executor Check)

Initialize Your Main Hub Interface. The TopBar And Welcome Text Will Automatically Format Based On Your `Name` Property. You Can Also Restrict Execution To Specific App Environments And Enable The Secure Auto-Saving Key System.

```lua
local Window = InconUI:CreateWindow({
    Name = "MinhZ Hub Test",
    ToggleUIKeybind = "M",
    Folder = "MinhZConfigs",
    SupportedExecutors = {"Krampus", "Wave", "Delta", "Solara", "Hydrogen", "Arceus", "Codex", "MacSploit"},
    HasKeySystem = true,
    KeySettings = {
        Title = "MinhZ Premium Key System",
        Key = {"MinhZ123", "AdminKey"},
        Link = "https://discord.gg/yourlink",
        SaveKey = true,
        MaxTime = 86400
    }
})

```

### 📑 Creating Tabs & Sections

Create Tabs To Organize Your Features And Divide Them Into Neat Sections.

```lua
local MainTab = Window:CreateTab("Main Settings")

MainTab:CreateSection("VIP Features")

```

### 🔒 Premium Locked Logic

Add `Locked = true` And `LockedTitle` To Any Element To Lock It. Consecutive Locked Elements Will Automatically Group Into A Beautiful Overlay.

```lua
MainTab:CreateButton({
    Name = "Premium Fly",
    Locked = true,
    LockedTitle = "Requires VIP Pass",
    Callback = function() 
    end
})

```

### ⚠️ Informational Elements (Paragraphs & Styled Labels)

Create Multi-Line Paragraphs That Update Dynamically And Colored Labels For Better UX. Styles: `1 = Basic`, `2 = Warning (Red)`, `3 = Information (Green)`.

```lua
local InfoPara = MainTab:CreateParagraph({
    Name = "Auto Farm Status",
    Content = "Target: None\nGold: 0\nState: Idle"
})

InfoPara:SetText("Auto Farm Status", "Target: Bandits\nGold: 15,000\nState: Attacking")

MainTab:CreateLabel({
    Name = "Warning: Do Not Teleport Too Fast!",
    Style = 2
})

MainTab:CreateLabel({
    Name = "Information: Script Loaded Successfully",
    Style = 3
})

```

### 🔘 Creating Standard Elements

Execute Functions, Toggle States, And Adjust Numerical Values Smoothly.

```lua
MainTab:CreateToggle({
    Name = "God Mode",
    Flag = "GodMode_Toggle",
    Default = false,
    Callback = function(State) 
    end
})

MainTab:CreateSlider({
    Name = "Walk Speed",
    Flag = "WS_Slider",
    Min = 16,
    Max = 250,
    Default = 16,
    Callback = function(Value)
    end
})

```

### 🎨 Creating A Color Picker

A Highly Advanced Draggable Color Picker Popup With Live Hex And RGB Inputs. Safe Clamping For All Values.

```lua
MainTab:CreateColorPicker({
    Name = "ESP Color",
    Flag = "ESP_Color",
    Default = Color3.fromRGB(0, 255, 150),
    Callback = function(Value)
    end
})

```

### 📝 Creating Textboxes & Keybinds

Input Text Directly Or Assign Quick Hotkeys.

```lua
MainTab:CreateTextbox({
    Name = "Target Name",
    Flag = "Target_Textbox",
    Placeholder = "Enter Name Here...",
    Callback = function(Text)
    end
})

MainTab:CreateKeybind({
    Name = "Invisible Key",
    Flag = "Invis_Keybind",
    Default = Enum.KeyCode.T,
    Callback = function()
    end
})

```

### 🔽 Creating Dropdowns

Select Single Or Multiple Options Flawlessly.

```lua
MainTab:CreateDropdown({
    Name = "Aimbot Mode",
    Flag = "Aimbot_Dropdown",
    List = {"Legit", "Rage", "Blatant"},
    Callback = function(Value)
    end
})

MainTab:CreateMultiDropdown({
    Name = "Auto Weapons",
    Flag = "Weapons_MultiDrop",
    List = {"Sword", "Gun M4A1", "Bow", "Magic Staff"},
    Default = {"Sword"},
    Callback = function(SelectedItems)
    end
})

```

### 💬 Using Confirmation Dialogs

Trigger A Secure Confirmation Popup For Crucial Actions To Prevent Accidental Clicks.

```lua
MainTab:CreateButton({
    Name = "Delete Something",
    Callback = function()
        Window:CreateDialog({
            Title = "Warning",
            Content = "Are You Sure You Want To Proceed?",
            ConfirmText = "Yes",
            CancelText = "No",
            Callback = function(State)
                if State then
                    print("Action Confirmed!")
                end
            end
        })
    end
})

```

### 🔔 Using Notifications

Trigger A Smooth Pop-Up Notification At The Bottom Right.

```lua
InconUI:MakeNotify({
    Title = "Skill Activated",
    Content = "You Are Now Invisible!",
    Time = 3
})

```

### 📜 Creating Update Logs

Show Off Your Recent Updates In A Sleek, Expandable Card.

```lua
MainTab:CreateUpdateLog({
    ver = "v19.0.0 (DYNAMIC TEXT REWORK)",
    date = "18/07/2026",
    expandable = true,
    changes = {
        {"+", "TopBar And Welcome Messages Inherently Scale Entirely By 'Name' Key."},
        {"+", "Added Dialog Modal Popup For Secure Interactions."},
        {"+", "Implemented Paragraph Object With Dynamic SetText."},
        {"+", "Introduced 3 Style Labels (Basic, Warning, Information)."}
    }
})

```

### ⚙️ Building The Config Manager

Automatically Generate A Fully Functional Configuration Interface (Save, Load, Overwrite, Delete, AutoLoad). Overwriting, Deleting And Clearing Autoload Configs Features Built-In Dialog Protection.

```lua
local ConfigTab = Window:CreateTab("Settings")

Window:BuildSaveManager(ConfigTab)
Window:AutoLoad()

```

### 🗑️ Destroying The Interface

Safely Remove The UI, Floating Buttons, Watermarks, And Disconnect All Event Connections To Prevent Memory Leaks.

```lua
MainTab:CreateButton({
    Name = "Destroy UI",
    Callback = function()
        InconUI:Destroy()
    end
})
```

```
