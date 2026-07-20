<div align="center">

# 🌌 Incon Premium UI Library

[![Lua](https://img.shields.io/badge/Language-Lua-blue.svg?style=for-the-badge&logo=lua)](https://www.lua.org/)
[![Roblox](https://img.shields.io/badge/Game-Roblox-red.svg?style=for-the-badge&logo=roblox)](https://www.roblox.com/)
[![Status](https://img.shields.io/badge/Status-Active-success.svg?style=for-the-badge)]()
[![License](https://img.shields.io/badge/License-MIT-green.svg?style=for-the-badge)]()

<img src="https://readme-typing-svg.herokuapp.com?font=Inconsolata&weight=600&size=24&pause=1000&color=00FF99&center=true&vCenter=true&width=435&lines=Premium+Roblox+UI+Library;Built-In+Save+Manager;Secure+Dialog+Modals;Discord+Integration" alt="Typing SVG" />

A Modern, Highly Optimized, And Bug-Free Roblox UI Library Designed For Exploit Scripts. Featuring A Clean Dark Theme, Fully Dynamic Texts, User Profile Cards, Draggable Elements, And Direct Discord Integrations.

</div>

---

### 🚀 Booting The Library & Setting Fonts

Load the UI library using the raw GitHub URL and set your custom font before creating the window.

```lua
-- Fetch the library source code
local InconUI = loadstring(game:HttpGet("https://github.com/Minh1234ngudot/-/raw/refs/heads/main/Incon_UI.luau"))()

-- Set a custom font using a Roblox Asset ID (Default is Inconsolata)
InconUI:SetFont("rbxassetid://12187365364")

```

### 🪟 Creating A Window (With Key System, Float Logo & Executor Check)

Initialize your main hub interface. The TopBar and Welcome text will automatically format based on your `Name` property. You can fully customize the floating toggle icon, restrict execution to specific app environments, and enable the secure key system.

```lua
local Window = InconUI:CreateWindow({
    Name = "MinhZ Hub Premium", -- The main title of your hub
    ToggleUIKeybind = "M", -- The key to open/close the UI
    Folder = "MinhZConfigs", -- The folder name where configs and keys will be saved
    FloatImage = "rbxassetid://123456789", -- Optional: Replaces the default user avatar on the floating button
    
    -- Optional: Kick users if they are not using these specific executors
    SupportedExecutors = {"Krampus", "Wave", "Delta", "Solara", "Hydrogen", "Arceus", "Codex", "MacSploit"},
    
    HasKeySystem = true, -- Set to false if you don't want a key system
    KeySettings = {
        Title = "MinhZ Premium Key System", -- Title displayed on the key system screen
        Key = {"MinhZ123", "AdminKey"}, -- Accepts a single string or a table of valid keys
        Link = "https://example.com/getkey", -- The link copied when the user clicks 'Get Key'
        SaveKey = true, -- Automatically saves the valid key to the user's workspace
        MaxTime = 86400 -- Expiration time for the saved key in seconds (86400 = 24 hours)
    }
})

```

### 📑 Creating Tabs & Sections

Create tabs to organize your features and divide them into neat sections.

```lua
-- Creates a new tab on the left sidebar
local MainTab = Window:CreateTab("Main Settings")

-- Creates a visual separator and title within the tab
MainTab:CreateSection("Profile & Community")

```

### 👤 Creating A User Profile Card (Info Card)

Display user information or welcome messages using the exclusive profile layout element. It fully supports Rich Text styling.

```lua
local ProfileCard = MainTab:CreateInfoCard({
    -- Automatically grabs the user's actual Roblox display name and makes it pink
    Title = "Welcome to MinhZ Hub, <font color='#ff00ff'>" .. game.Players.LocalPlayer.Name .. "</font>!",
    SubTitle = "@" .. game.Players.LocalPlayer.Name,
    Description = "Universal Hub | Join Discord For Support And Update",
    -- Automatically grabs the user's Roblox avatar headshot
    Icon = "rbxthumb://type=AvatarHeadShot&id=" .. game.Players.LocalPlayer.UserId .. "&w=150&h=150"
})

-- You can dynamically update the description later in your script
ProfileCard:SetDescription("Status: AFK Farming")

```

### 🎧 Embedding Discord Invites

Create a professional Discord embed card inside the hub complete with a large scaled banner, server icon, server name, description, and a fully functional 'Join' copy link button.

```lua
MainTab:CreateDiscord({
    ServerName = "🤫 MinhZ Community",
    Description = "Script Free, Fast Update, Fast Support, People Friendly.",
    Invite = "https://discord.gg/YourInviteHere", -- Link copied when the user clicks 'Join'
    Banner = "rbxassetid://123456789", -- The large background image ID
    Icon = "rbxassetid://123456789" -- The small server icon ID
})

```

### 🔒 Premium Locked Logic

Add `Locked = true` and `LockedTitle` to any element to lock it. Consecutive locked elements will automatically group into a beautiful overlay, preventing interactions.

```lua
MainTab:CreateButton({
    Name = "Premium Fly",
    Locked = true, -- Enables the lock overlay
    LockedTitle = "Requires VIP Pass", -- The text displayed on the lock overlay
    Callback = function() 
        -- This code will never run unless the element is unlocked
    end
})

```

### ⚠️ Informational Elements (Paragraphs & Styled Labels)

Create multi-line paragraphs that can update dynamically, and colored labels for better UX.
Label Styles: `1 = Basic (Grey)`, `2 = Warning (Red)`, `3 = Information (Green)`.

```lua
-- Create a multi-line paragraph
local InfoPara = MainTab:CreateParagraph({
    Name = "Auto Farm Status",
    Content = "Target: None\nGold: 0\nState: Idle"
})

-- Update the paragraph dynamically in your auto-farm loop
InfoPara:SetText("Auto Farm Status", "Target: Bandits\nGold: 15,000\nState: Attacking")

-- Create styled labels
MainTab:CreateLabel({
    Name = "Warning: Do Not Teleport Too Fast!",
    Style = 2 -- Red Warning Style
})

MainTab:CreateLabel({
    Name = "Information: Script Loaded Successfully",
    Style = 3 -- Green Information Style
})

```

### 🔘 Creating Standard Elements

Execute functions, toggle states, and adjust numerical values smoothly.

```lua
-- Create a standard button
MainTab:CreateButton({
    Name = "Teleport To Safezone",
    Callback = function()
        print("Teleporting...")
    end
})

-- Create a dual button (two buttons on one line)
MainTab:CreateDualButton({
    Name1 = "Option A",
    Callback1 = function() print("A") end,
    Name2 = "Option B",
    Callback2 = function() print("B") end
})

-- Create a toggle switch
MainTab:CreateToggle({
    Name = "God Mode",
    Flag = "GodMode_Toggle", -- The flag identifier used for saving/loading configs
    Default = false, -- Default state when the UI loads
    Callback = function(State) 
        print("God Mode is now: ", State)
    end
})

-- Create a smooth slider
MainTab:CreateSlider({
    Name = "Walk Speed",
    Flag = "WS_Slider",
    Min = 16,
    Max = 250,
    Default = 16,
    Callback = function(Value)
        print("Speed set to: ", Value)
    end
})

```

### 🎨 Creating A Color Picker

A highly advanced draggable color picker popup with live Hex and RGB inputs. Safe clamping is applied for all values.

```lua
MainTab:CreateColorPicker({
    Name = "ESP Color",
    Flag = "ESP_Color",
    Default = Color3.fromRGB(0, 255, 150),
    Callback = function(Value)
        print("Color changed to: ", Value)
    end
})

```

### 📝 Creating Textboxes & Keybinds

Input text directly or assign quick hotkeys for specific actions.

```lua
-- Create a text input box
MainTab:CreateTextbox({
    Name = "Target Name",
    Flag = "Target_Textbox",
    Placeholder = "Enter Name Here...",
    Callback = function(Text)
        print("Targetting: ", Text)
    end
})

-- Create a keybind listener
MainTab:CreateKeybind({
    Name = "Trigger Skill Auto",
    Flag = "Skill_Keybind",
    Default = Enum.KeyCode.Q, -- Default key
    Callback = function()
        print("Keybind pressed!")
    end
})

```

### 🔽 Creating Dropdowns

Select single or multiple options flawlessly.

```lua
-- Standard Dropdown (Single Selection)
MainTab:CreateDropdown({
    Name = "Aimbot Mode",
    Flag = "Aimbot_Dropdown",
    List = {"Legit", "Rage", "Blatant"},
    Callback = function(Value)
        print("Selected mode: ", Value)
    end
})

-- Multi-Dropdown (Multiple Selections)
MainTab:CreateMultiDropdown({
    Name = "Auto Weapons",
    Flag = "Weapons_MultiDrop",
    List = {"Sword", "Gun M4A1", "Bow", "Magic Staff"},
    Default = {"Sword"}, -- Pre-selected options
    Callback = function(SelectedItems)
        -- SelectedItems is a table containing all chosen strings
        print("Equipped Weapons: ", table.concat(SelectedItems, ", "))
    end
})

```

### 💬 Using Confirmation Dialogs

Trigger a secure confirmation popup for crucial actions to prevent accidental clicks. It blurs the background and forces a Yes/No decision.

```lua
MainTab:CreateButton({
    Name = "Delete Save Data",
    Callback = function()
        Window:CreateDialog({
            Title = "Warning",
            Content = "Are You Sure You Want To Proceed?",
            ConfirmText = "Yes",
            CancelText = "No",
            Callback = function(State)
                if State then
                    -- This runs if the user clicks 'Yes'
                    print("Action Confirmed! Data Deleted.")
                end
            end
        })
    end
})

```

### 🔔 Using Notifications

Trigger a smooth pop-up notification at the bottom right of the screen.

```lua
InconUI:MakeNotify({
    Title = "Skill Activated",
    Content = "You Are Now Invisible!",
    Time = 3 -- Duration in seconds before the notification disappears
})

```

### 📜 Creating Update Logs

Show off your recent script updates in a sleek, expandable card.

```lua
MainTab:CreateUpdateLog({
    ver = "v23.0.0 (THE REFINEMENT UPDATE)",
    date = "20/07/2026",
    expandable = true, -- Allows the user to click to show/hide the changes
    changes = {
        {"+", "Info Card Now Fully Automated Rainbow Username Binding."}, -- Green text
        {"~", "Adjusted UI Elements To Perfectly Match Developer Specifications."}, -- Yellow text
        {"-", "Totally Annihilated ProgressBar As Dictated By Supreme Law."} -- Red text
    }
})

```

### ⚙️ Building The Config Manager

Automatically generate a fully functional configuration interface (Save, Load, Overwrite, Delete, AutoLoad). Overwriting, Deleting and Clearing Autoload Configs features built-in dialog protection.

```lua
-- Create a dedicated tab for settings
local ConfigTab = Window:CreateTab("Settings")

-- Pass the tab into the BuildSaveManager function
Window:BuildSaveManager(ConfigTab)

-- Automatically loads the config if the user set one to AutoLoad previously
Window:AutoLoad()

```

### 🗑️ Destroying The Interface

Safely remove the UI, floating buttons, notifications, and disconnect all event connections to prevent memory leaks in the executor.

```lua
MainTab:CreateButton({
    Name = "Destroy UI",
    Callback = function()
        -- Ask for confirmation before destroying
        Window:CreateDialog({
            Title = "Destroy UI",
            Content = "Are You Sure You Want To Destroy This Interface?",
            ConfirmText = "Destroy",
            CancelText = "Cancel",
            Callback = function(State)
                if State then
                    -- Execute the destroy function
                    InconUI:Destroy()
                end
            end
        })
    end
})
