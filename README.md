<div align="center">

# 🌌 Incon UI Library

[![Lua](https://img.shields.io/badge/Language-Lua-blue.svg?style=for-the-badge&logo=lua)](https://www.lua.org/)
[![Roblox](https://img.shields.io/badge/Game-Roblox-red.svg?style=for-the-badge&logo=roblox)](https://www.roblox.com/)
[![Status](https://img.shields.io/badge/Status-Active-success.svg?style=for-the-badge)]()
[![License](https://img.shields.io/badge/License-MIT-green.svg?style=for-the-badge)]()

<img src="https://readme-typing-svg.herokuapp.com?font=Inconsolata&weight=600&size=24&pause=1000&color=00FF99&center=true&vCenter=true&width=435&lines=Premium+Roblox+UI+Library;Built-In+Save+Manager;Zero+Sub-Pixel+Tearing;Highly+Optimized" alt="Typing SVG" />

A modern, highly optimized, and bug-free Roblox UI Library designed for exploit scripts. Featuring a clean dark theme, smooth tweens, built-in config saving, and **0% sub-pixel rendering issues**.

</div>

---

### 🚀 Booting The Library

Load the UI Library using the raw GitHub URL.

```lua
local InconUI = loadstring(game:HttpGet("[https://github.com/Minh1234ngudot/-/raw/refs/heads/main/Incon_UI.luau](https://github.com/Minh1234ngudot/-/raw/refs/heads/main/Incon_UI.luau)"))()

```

### 🪟 Creating A Window

Initialize your main hub interface. You can set the title, toggle key, and the folder name where configurations will be saved.

```lua
local Window = InconUI:CreateWindow({
    Name = "Incon Premium Hub",
    ToggleKey = Enum.KeyCode.RightControl,
    Folder = "InconConfigs"
})

```

### 📑 Creating A Tab

Create tabs to organize your features.

```lua
local MainTab = Window:CreateTab("Main Settings")

```

### 📌 Creating A Section

Divide your tab into neat sections.

```lua
MainTab:CreateSection("Player Settings")

```

### 🔘 Creating A Button

Execute a function when clicked.

```lua
MainTab:CreateButton({
    Name = "Kill All",
    Callback = function()
        print("Kill All Executed!")
    end
})

```

### 🎚️ Creating A Toggle

A switch to turn features on or off. Use `Flag` to save its state in the Config Manager.

```lua
MainTab:CreateToggle({
    Name = "Auto Farm",
    Flag = "AutoFarm_Toggle",
    Default = false,
    Callback = function(State)
        print("Auto Farm: ", State)
    end
})

```

### ➖ Creating A Slider

Adjust numerical values smoothly. Includes a manual text input feature.

```lua
MainTab:CreateSlider({
    Name = "Walk Speed",
    Flag = "WS_Slider",
    Min = 16,
    Max = 250,
    Default = 16,
    Callback = function(Value)
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = Value
    end
})

```

### 📝 Creating A Textbox

Input text directly into the UI. Retrieves values live.

```lua
MainTab:CreateTextbox({
    Name = "Target Name",
    Flag = "Target_Textbox",
    Placeholder = "Enter Name Here...",
    Callback = function(Text)
        print("Targetting: ", Text)
    end
})

```

### ⌨️ Creating A Keybind

Assign a quick hotkey. Users can click to rebind it dynamically.

```lua
MainTab:CreateKeybind({
    Name = "Invisible Key",
    Flag = "Invis_Keybind",
    Default = Enum.KeyCode.T,
    Callback = function()
        print("Invisible Activated!")
    end
})

```

### 🔽 Creating A Dropdown

Select a single option from a list.

```lua
MainTab:CreateDropdown({
    Name = "Aimbot Mode",
    Flag = "Aimbot_Dropdown",
    List = {"Legit", "Rage", "Blatant"},
    Callback = function(Value)
        print("Mode Switched To: ", Value)
    end
})

```

### ✔️ Creating A Multi-Dropdown

Select multiple options at once. Returns a table of selected items.

```lua
MainTab:CreateMultiDropdown({
    Name = "Auto Weapons",
    Flag = "Weapons_MultiDrop",
    List = {"Sword", "Gun M4A1", "Bow", "Magic Staff"},
    Default = {"Sword"},
    Callback = function(SelectedItems)
        print("Equipped: ", table.concat(SelectedItems, ", "))
    end
})

```

### 🔔 Using Notifications

Trigger a smooth pop-up notification at the bottom right.

```lua
InconUI:MakeNotify({
    Title = "Skill Activated",
    Content = "You Are Now Invisible!",
    Time = 3
})

```

### 📜 Creating Update Logs

Show off your recent updates in a sleek, expandable card.

```lua
MainTab:CreateUpdateLog({
    ver = "v3.1.0",
    date = "14/07/2026",
    expandable = true,
    changes = {
        {"+", "Added Robust Error Handling For Config Manager."},
        {"+", "Textboxes Now Retrieve Values Live."},
        {"~", "Capitalized First Letters Across All UI Prompts."},
        {"-", "Fixed 100% Sub-Pixel Rendering UI Tear Bugs."}
    }
})

```

### ⚙️ Building The Config Manager

Automatically generate a fully functional Configuration interface (Save, Load, Overwrite, Delete, AutoLoad).

```lua
local ConfigTab = Window:CreateTab("Settings")

Window:BuildSaveManager(ConfigTab)
Window:AutoLoad()

```

### 🗑️ Destroying The Interface

Safely remove the UI and disconnect all events to prevent memory leaks.

```lua
Window:Destroy()
